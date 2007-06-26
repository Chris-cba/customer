CREATE OR REPLACE PACKAGE BODY xtnz_load_inv AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_load_inv.pkb	1.1 03/15/05
--       Module Name      : xtnz_load_inv.pkb
--       Date into SCCS   : 05/03/15 03:46:09
--       Date fetched Out : 07/06/06 14:40:30
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Transit NZ Inventory Load package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xtnz_load_inv.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xtnz_load_inv';
   g_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE;
   c_eff_date                  DATE;
   g_recursive_call BOOLEAN := FALSE;
--
-----------------------------------------------------------------------------
--
PROCEDURE store_and_set_effective_date (p_eff_date DATE);
--
-----------------------------------------------------------------------------
--
PROCEDURE restore_effective_date;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_datum_lref (pi_route_ne_id  IN     nm_elements.ne_id%TYPE
                         ,pi_ne_group     IN     nm_elements.ne_unique%TYPE
                         ,pi_slk          IN     NUMBER
                         ,pi_sub_class    IN     VARCHAR2
                         ,po_datum_ne_id     OUT nm_elements.ne_id%TYPE
                         ,po_datum_offset    OUT NUMBER
                         );
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ambiguous_lref (pi_route_ne_id  IN     nm_elements.ne_id%TYPE
                             ,pi_ne_group     IN     nm_elements.ne_unique%TYPE
                             ,pi_slk          IN     NUMBER
                             ,pi_sub_class    IN     VARCHAR2
                             ,po_datum_ne_id     OUT nm_elements.ne_id%TYPE
                             ,po_datum_offset    OUT NUMBER
                             );
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_rs_au (p_state_hwy VARCHAR2
                   ,p_rs        VARCHAR2
                   ) RETURN nm_admin_units.nau_admin_unit%TYPE IS
BEGIN
   RETURN nm3get.get_ne (pi_ne_unique  => p_state_hwy||'-'||p_rs
                        ,pi_ne_nt_type => 'RSL'
                        ).ne_admin_unit;
END get_rs_au;
--
-----------------------------------------------------------------------------
--
FUNCTION get_la_au (p_la_section_number VARCHAR2
                   ) RETURN nm_admin_units.nau_admin_unit%TYPE IS
BEGIN
   RETURN nm3get.get_iit (pi_iit_primary_key => p_la_section_number
                         ,pi_iit_inv_type    => 'LA'
                         ).iit_admin_unit;
END get_la_au;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_or_validate  (p_rec           xtnz_load_inv_on_route%ROWTYPE
                            ,p_validate_only BOOLEAN
                            ) IS
--
   l_rec_for_recursive xtnz_load_inv_on_route%ROWTYPE := p_rec;
--
   l_begin_ne    nm_elements%ROWTYPE;
   l_end_ne      nm_elements%ROWTYPE;
   l_route_ne_id nm_elements.ne_id%TYPE;
   l_start_ne_id nm_elements.ne_id%TYPE;
   l_start_mp    NUMBER;
   l_end_ne_id   nm_elements.ne_id%TYPE;
   l_end_mp      NUMBER;
--
   l_st_scl      VARCHAR2(4);
   l_end_scl     VARCHAR2(4);
   no_location_for_asset     EXCEPTION;
   failure_in_recursive_call EXCEPTION;
--
BEGIN
--
   SAVEPOINT top_of_validate;
--
--   nm_debug.debug('--------------------------------------------------------');
--   nm_debug.debug('state_hwy              : '||p_Rec.state_hwy              );
--   nm_debug.debug('start_rs               : '||p_Rec.start_rs               );
--   nm_debug.debug('start_mp               : '||p_Rec.start_mp               );
--   nm_debug.debug('start_cwy              : '||p_Rec.start_cwy              );
--   nm_debug.debug('end_rs                 : '||p_Rec.end_rs                 );
--   nm_debug.debug('end_mp                 : '||p_Rec.end_mp                 );
--   nm_debug.debug('end_cwy                : '||p_Rec.end_cwy                );
--   nm_debug.debug('iit_ne_id              : '||p_Rec.iit_ne_id              );
--   nm_debug.debug('iit_inv_type           : '||p_Rec.iit_inv_type           );
--   nm_debug.debug('nm_start_date          : '||p_Rec.nm_start_date          );
--   nm_debug.debug('--------------------------------------------------------');
--
   IF p_rec.state_hwy IS NULL
    THEN
      RAISE no_location_for_asset;
   END IF;
--
   store_and_set_effective_date (p_rec.nm_start_date);
--
   l_begin_ne       := nm3get.get_ne (pi_ne_unique  => p_rec.state_hwy||'-'||p_rec.start_rs
                                     ,pi_ne_nt_type => 'RSL'
                                     );
--
   IF  (p_rec.start_cwy IS NULL     AND p_rec.end_cwy IS NOT NULL)
    OR (p_rec.start_cwy IS NOT NULL AND p_rec.end_cwy IS NULL)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => 'Either both carriageways must be specified or no carriageway specified'
                    );
   ELSIF p_rec.start_cwy IS NULL
    AND  p_rec.end_cwy   IS NULL
    THEN
      l_st_scl                      := 'I';
      l_end_scl                     := 'I';
      l_rec_for_recursive.start_cwy := 'D';
      l_rec_for_recursive.end_cwy   := 'D';
      g_recursive_call              := TRUE;
   ELSE
      IF p_rec.start_cwy IN ('0','I','B')
       THEN
         l_st_scl := 'I';
      ELSE
         l_st_scl := 'D';
      END IF;
   --
      IF p_rec.end_cwy IN ('0','I','B')
       THEN
         l_end_scl := 'I';
      ELSE
         l_end_scl := 'D';
      END IF;
   END IF;
--
   get_datum_lref (pi_route_ne_id  => l_begin_ne.ne_id
                  ,pi_ne_group     => l_begin_ne.ne_unique
                  ,pi_slk          => p_rec.start_mp
                  ,pi_sub_class    => l_st_scl
                  ,po_datum_ne_id  => l_start_ne_id
                  ,po_datum_offset => l_start_mp
                  );
--
   IF p_rec.end_rs IS NOT NULL
    THEN
      IF p_rec.start_rs = p_rec.end_rs
       THEN
         l_route_ne_id := l_begin_ne.ne_id;
         l_end_ne      := l_begin_ne;
      ELSE
         l_end_ne      := nm3get.get_ne (pi_ne_unique  => p_rec.state_hwy||'-'||p_rec.end_rs
                                        ,pi_ne_nt_type => 'RSL'
                                        );
         l_route_ne_id := nm3net.get_ne_id (p_rec.state_hwy, 'SHL');
   --      hig.raise_ner (pi_appl => nm3type.c_net, pi_id => 28, pi_supplementary_info => 'not doing these yet!');
      END IF;
   --
      get_datum_lref (pi_route_ne_id  => l_end_ne.ne_id
                     ,pi_ne_group     => l_end_ne.ne_unique
                     ,pi_slk          => p_rec.end_mp
                     ,pi_sub_class    => l_end_scl
                     ,po_datum_ne_id  => l_end_ne_id
                     ,po_datum_offset => l_end_mp
                     );
   --
      DECLARE
         l_sqlcode NUMBER;
         l_sqlerrm nm3type.max_varchar2;
         l_excl_scl nm_elements.ne_sub_class%TYPE;
         c_nte_job_id CONSTANT NUMBER := g_nte_job_id;
         l_max_nte_seq_no NUMBER;
      BEGIN
         l_excl_scl := nm3flx.i_t_e(l_st_scl = 'D',l_st_scl, Null);
         nm3wrap.create_temp_ne_from_route
                     (pi_route                   => l_route_ne_id
                     ,pi_start_ne_id             => l_start_ne_id
                     ,pi_start_offset            => l_start_mp
                     ,pi_end_ne_id               => l_end_ne_id
                     ,pi_end_offset              => l_end_mp
                     ,pi_sub_class               => l_st_scl
                     ,pi_restrict_excl_sub_class => l_excl_scl
                     ,pi_homo_check              => TRUE
                     ,po_job_id                  => g_nte_job_id
                     );
--
         IF g_recursive_call
          THEN
--
            SELECT MAX(b.nte_seq_no)
             INTO  l_max_nte_seq_no
             FROM  nm_nw_temp_extents b
            WHERE  b.nte_job_id = c_nte_job_id;
--
            UPDATE nm_nw_temp_extents a
             SET   a.nte_seq_no = a.nte_seq_no + l_max_nte_seq_no
            WHERE  a.nte_job_id = g_nte_job_id;
--
            UPDATE nm_nw_temp_extents
             SET   nte_job_id = g_nte_job_id
            WHERE  nte_job_id = c_nte_job_id;
--
         END IF;
--
      EXCEPTION
         WHEN OTHERS
          THEN
            IF g_recursive_call
             THEN
               RAISE failure_in_recursive_call;
            ELSE
               l_sqlcode := SQLCODE;
               l_sqlerrm := nm3flx.parse_error_message(SQLERRM);
               IF ABS(l_sqlcode) BETWEEN 20000 AND 20999
                THEN
                  l_sqlerrm := l_sqlerrm
                               ||': '||nm3net.get_ne_unique(l_route_ne_id)
                               ||': '||nm3net.get_ne_unique(l_start_ne_id)||'('||l_start_mp||')'
                               ||'=>'||nm3net.get_ne_unique(l_end_ne_id)||'('||l_end_mp||')'
                               ||':CARRIAGEWAY='||l_st_scl;
                  IF l_excl_scl IS NOT NULL
                   THEN
                     l_sqlerrm := l_sqlerrm||':EXCLUSIVE CWY='||l_excl_scl;
                  END IF;
                  RAISE_APPLICATION_ERROR(l_sqlcode,l_sqlerrm);
               ELSE
                  RAISE;
               END IF;
            END IF;
      END;
--
      DELETE FROM nm_nw_temp_extents
      WHERE  nte_begin_mp = nte_end_mp;
--
      DELETE FROM nm_nw_temp_extents
      WHERE  EXISTS (SELECT 1
                      FROM  nm_elements
                     WHERE  ne_id = nte_ne_id_of
                      AND   ne_type = 'D'
                    );
--
      DECLARE
         CURSOR cs_nte (c_job_id NUMBER) IS
         SELECT 1
          FROM  nm_nw_temp_extents
         WHERE  nte_job_id = c_job_id;
         l_dummy PLS_INTEGER;
         l_found BOOLEAN;
      BEGIN
         OPEN  cs_nte (g_nte_job_id);
         FETCH cs_nte INTO l_dummy;
         l_found := cs_nte%FOUND;
         CLOSE cs_nte;
         IF NOT l_found
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_net
                          ,pi_id                 => 86
                          ,pi_supplementary_info => p_rec.state_hwy||':'||p_rec.start_rs||'('||p_rec.start_mp||')->'||p_rec.end_rs||'('||p_rec.end_mp||')'
                          );
         END IF;
      END;
--
   ELSE
--
      g_recursive_call := FALSE;
      INSERT INTO nm_nw_temp_extents
             (nte_job_id
             ,nte_ne_id_of
             ,nte_begin_mp
             ,nte_end_mp
             ,nte_cardinality
             ,nte_seq_no
             ,nte_route_ne_id
             )
      VALUES (nm3net.get_next_nte_id   -- nte_job_id
             ,l_start_ne_id            -- nte_ne_id_of
             ,l_start_mp               -- nte_begin_mp
             ,NVL(l_end_mp,l_start_mp) -- nte_end_mp
             ,1                        -- nte_cardinality
             ,1                        -- nte_seq_no
             ,l_begin_ne.ne_id         -- nte_route_ne_id
             )
      RETURNING nte_job_id INTO g_nte_job_id;
--
   END IF;
--
   IF g_recursive_call
    THEN
      load_or_validate  (p_rec           => l_rec_for_recursive
                        ,p_validate_only => p_validate_only
                        );
      g_recursive_call := FALSE;
   END IF;
--
   IF p_validate_only
    THEN
      ROLLBACK TO top_of_validate;
      restore_effective_date;
   END IF;
--
EXCEPTION
--
  WHEN failure_in_recursive_call
   THEN
     g_recursive_call := FALSE;
   WHEN no_location_for_asset
    THEN -- asset has no location, just let it slide
      restore_effective_date;
   WHEN others
    THEN
      restore_effective_date;
      RAISE;
--
END load_or_validate;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_inv_on_route (p_rec xtnz_load_inv_on_route%ROWTYPE) IS
   l_rec_iit    nm_inv_items%ROWTYPE;
BEGIN
--
   nm_debug.proc_start (g_package_name, 'load_inv_on_route');
--
   g_recursive_call := FALSE;
   g_nte_job_id     := Null;
   load_or_validate (p_rec, FALSE);
--
   l_rec_iit  := nm3get.get_iit (pi_iit_ne_id => p_rec.iit_ne_id);
--
   IF l_rec_iit.iit_inv_type != NVL(p_rec.iit_inv_type,nm3type.c_nvl)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => '"'||l_rec_iit.iit_inv_type||'" != "'||p_rec.iit_inv_type||'"'
                    );
   END IF;
--
   IF g_nte_job_id IS NOT NULL
    THEN
      nm3homo.homo_update (p_temp_ne_id_in  => g_nte_job_id
                          ,p_iit_ne_id      => p_rec.iit_ne_id
                          ,p_effective_date => p_rec.nm_start_date
                          );
   --
      DELETE FROM nm_nw_temp_extents
      WHERE  nte_job_id = g_nte_job_id;
   END IF;
--
   restore_effective_date;
--
   nm_debug.proc_end (g_package_name, 'load_inv_on_route');
--
EXCEPTION
--
   WHEN others
    THEN
      restore_effective_date;
      RAISE;
--
END load_inv_on_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_inv_on_route (p_rec xtnz_load_inv_on_route%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start (g_package_name, 'validate_inv_on_route');
--
   g_recursive_call := FALSE;
   g_nte_job_id     := Null;
   load_or_validate (p_rec, TRUE);
--
   nm_debug.proc_end (g_package_name, 'validate_inv_on_route');
--
END validate_inv_on_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE store_and_set_effective_date (p_eff_date DATE) IS
BEGIN
   c_eff_date := nm3user.get_effective_date;
   nm3user.set_effective_date (p_eff_date);
END store_and_set_effective_date;
--
-----------------------------------------------------------------------------
--
PROCEDURE restore_effective_date IS
BEGIN
   nm3user.set_effective_date (c_eff_date);
END restore_effective_date;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_datum_lref (pi_route_ne_id  IN     nm_elements.ne_id%TYPE
                         ,pi_ne_group     IN     nm_elements.ne_unique%TYPE
                         ,pi_slk          IN     NUMBER
                         ,pi_sub_class    IN     VARCHAR2
                         ,po_datum_ne_id     OUT nm_elements.ne_id%TYPE
                         ,po_datum_offset    OUT NUMBER
                         ) IS
BEGIN
--
   DECLARE
      l_ambig    EXCEPTION;
      PRAGMA EXCEPTION_INIT (l_ambig,-20002);
      l_no_datum EXCEPTION;
      PRAGMA EXCEPTION_INIT (l_no_datum,-20001);
      l_lref  nm_lref;
   BEGIN
      l_lref          := nm3lrs.get_datum_offset(p_parent_lr => nm_lref(pi_route_ne_id,pi_slk));
      po_datum_ne_id  := l_lref.lr_ne_id;
      po_datum_offset := l_lref.lr_offset;
   EXCEPTION
      WHEN l_no_datum
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 85
                       ,pi_supplementary_info => nm3net.get_ne_unique(pi_route_ne_id)||':'||pi_slk
                       );
      WHEN l_ambig
       THEN
         get_ambiguous_lref (pi_route_ne_id  => pi_route_ne_id
                            ,pi_ne_group     => pi_ne_group
                            ,pi_slk          => pi_slk
                            ,pi_sub_class    => pi_sub_class
                            ,po_datum_ne_id  => po_datum_ne_id
                            ,po_datum_offset => po_datum_offset
                            );
   END;
--
END get_datum_lref;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ambiguous_lref (pi_route_ne_id  IN     nm_elements.ne_id%TYPE
                             ,pi_ne_group     IN     nm_elements.ne_unique%TYPE
                             ,pi_slk          IN     NUMBER
                             ,pi_sub_class    IN     VARCHAR2
                             ,po_datum_ne_id     OUT nm_elements.ne_id%TYPE
                             ,po_datum_offset    OUT NUMBER
                             ) IS
--
   l_end_of_section_found BOOLEAN;
   c_sub_class CONSTANT   nm_elements.ne_sub_class%TYPE := nm3flx.i_t_e (pi_sub_class = 'S'
                                                                        ,Null
                                                                        ,pi_sub_class
                                                                        );
--
   l_lref_count           PLS_INTEGER;
--
BEGIN
--
  nm3wrap.get_ambiguous_lrefs (pi_parent_id => pi_route_ne_id
                              ,pi_offset    => pi_slk
                              ,pi_sub_class => c_sub_class
                              );
--
  l_lref_count := nm3wrap.lref_count;
--
  IF    l_lref_count = 0
   THEN
     hig.raise_ner (pi_appl               => nm3type.c_net
                   ,pi_id                 => 85
                   ,pi_supplementary_info => pi_ne_group||':'||pi_slk
                   );
  ELSIF l_lref_count > 1
   THEN
     l_end_of_section_found := FALSE;
     FOR i IN 1..l_lref_count
      LOOP
        nm3wrap.lref_get_row (pi_index  => i
                             ,po_ne_id  => po_datum_ne_id
                             ,po_offset => po_datum_offset
                             );
        IF po_datum_offset = nm3net.get_datum_element_length (po_datum_ne_id)
         THEN
           l_end_of_section_found := TRUE;
           EXIT;
        END IF;
     END LOOP;
     IF NOT l_end_of_section_found
      THEN
        hig.raise_ner (pi_appl               => nm3type.c_net
                      ,pi_id                 => 312
                      ,pi_supplementary_info => pi_ne_group||':'||pi_slk
                      );
     END IF;
  ELSE
     nm3wrap.lref_get_row (pi_index  => 1
                          ,po_ne_id  => po_datum_ne_id
                          ,po_offset => po_datum_offset
                          );
  END IF;
--
END get_ambiguous_lref;
--
-----------------------------------------------------------------------------
--
FUNCTION remove_excess_spaces(p_string VARCHAR2) RETURN VARCHAR2 IS
   l_retval       nm3type.max_varchar2;
   l_string       nm3type.max_varchar2 := UPPER(p_string);
   l_substr       VARCHAR2(1);
   l_substr_prior VARCHAR2(1) := ' ';
BEGIN
   FOR i IN 1..NVL(LENGTH(l_string),0)
    LOOP
      l_substr := SUBSTR(l_string,i,1);
      IF ASCII(l_substr) = 38
       THEN
         l_substr := '+';
      END IF;
      IF NOT ASCII(l_substr) IN (10,13,38,39)
       THEN
         IF   l_substr != ' '
          OR (l_substr  = ' ' AND l_substr_prior != ' ')
          THEN
            l_retval := l_retval||l_substr;
         END IF;
         l_substr_prior := l_substr;
      END IF;
   END LOOP;
   RETURN l_retval;
END remove_excess_spaces;
--
-----------------------------------------------------------------------------
--
FUNCTION check_for_hig_contact(p_string VARCHAR2) RETURN VARCHAR2 IS
   l_retval       nm3type.max_varchar2;
   l_rec_hct      hig_contacts%ROWTYPE;
BEGIN
--
   l_retval := remove_excess_spaces(p_string => p_string);
--
   IF l_retval IS NOT NULL
    AND nm3get.get_ial (pi_ial_domain      => 'HIG_CONTACTS'
                       ,pi_ial_value       => SUBSTR(l_retval,1,30)
                       ,pi_raise_not_found => FALSE
                       ).ial_domain IS NULL
    THEN
      -- Not found
      l_rec_hct.hct_id                       := nm3seq.next_hct_id_seq;
      l_rec_hct.hct_org_or_person_flag       := 'O';
      l_rec_hct.hct_vip                      := Null;
      l_rec_hct.hct_title                    := Null;
      l_rec_hct.hct_salutation               := Null;
      l_rec_hct.hct_first_name               := Null;
      l_rec_hct.hct_middle_initial           := Null;
      l_rec_hct.hct_surname                  := Null;
      l_rec_hct.hct_organisation             := l_retval;
      l_rec_hct.hct_home_phone               := Null;
      l_rec_hct.hct_work_phone               := Null;
      l_rec_hct.hct_mobile_phone             := Null;
      l_rec_hct.hct_fax                      := Null;
      l_rec_hct.hct_pager                    := Null;
      l_rec_hct.hct_email                    := Null;
      l_rec_hct.hct_occupation               := Null;
      l_rec_hct.hct_employer                 := Null;
      l_rec_hct.hct_date_of_birth            := Null;
      l_rec_hct.hct_start_date               := Null;
      l_rec_hct.hct_end_date                 := Null;
      l_rec_hct.hct_notes                    := Null;
      nm3ins.ins_hct (l_rec_hct);
   END IF;
   l_retval := SUBSTR(l_retval,1,30);
--
   RETURN l_retval;
--
END check_for_hig_contact;
--
-----------------------------------------------------------------------------
--
END xtnz_load_inv;
/
