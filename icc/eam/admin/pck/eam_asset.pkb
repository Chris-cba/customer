CREATE OR REPLACE PACKAGE BODY eam_asset
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/icc/eam/admin/pck/eam_asset.pkb-arc   1.0   Nov 28 2008 11:01:14   mhuitson  $
--       Module Name      : $Workfile:   eam_asset.pkb  $
--       Date into PVCS   : $Date:   Nov 28 2008 11:01:14  $
--       Date fetched Out : $Modtime:   Sep 24 2007 13:14:46  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   1.0  $';

  g_package_name CONSTANT varchar2(30) := 'eam_asset_metamodel';
  
-- list of select parent assets to restrict children on
  g_parent_asset_tab  parent_asset_tab;

-- type of 
  g_child_asset_type  nm_inv_types_all.nit_inv_type%TYPE;
  
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
PROCEDURE validate_eftg_rec(pi_eftg_rec IN eam_ft_inv_type_groupings_all%ROWTYPE) IS

 l_parent nm_inv_types_all%ROWTYPE;
 l_child  nm_inv_types_all%ROWTYPE; 

BEGIN

 l_parent := nm3get.get_nit_all(pi_nit_inv_type => pi_eftg_rec.eftg_parent_inv_type
                               ,pi_raise_not_found => FALSE);
                                
 l_child  := nm3get.get_nit_all(pi_nit_inv_type => pi_eftg_rec.eftg_inv_type
                               ,pi_raise_not_found => FALSE);


 IF l_parent.nit_category != 'F' THEN
   hig.raise_ner(pi_appl => 'HIG'
               , pi_id => 250
               , pi_supplementary_info => pi_eftg_rec.eftg_parent_inv_type);
 END IF;
 
 IF l_child.nit_category != 'F' THEN
   hig.raise_ner(pi_appl => 'HIG'
               , pi_id => 250
               , pi_supplementary_info => pi_eftg_rec.eftg_inv_type);
 END IF;
 
END validate_eftg_rec;
--
-----------------------------------------------------------------------------
--
FUNCTION get_drill_down_sql (pi_starting_inv_type    IN VARCHAR2
                            ,pi_starting_id          IN NUMBER
                            ,pi_child_inv_type       IN VARCHAR2) RETURN VARCHAR2 IS

                        
 l_sql nm3type.max_varchar2;                        

 l_starting nm_inv_types_all%ROWTYPE;
 l_child  nm_inv_types_all%ROWTYPE;

--
-- this tree walks up the ft relationships
-- starting at bottom level
 
 CURSOR c1 IS
 SELECT *
 FROM   eam_ft_inv_type_groupings eftg
 CONNECT BY PRIOR eftg_parent_inv_type = eftg_inv_type
 START WITH eftg_inv_type = pi_child_inv_type;

 TYPE tab_eftg IS TABLE OF c1%ROWTYPE INDEX BY BINARY_INTEGER;
 
 l_tab_eftg tab_eftg; 

BEGIN

 l_starting := nm3get.get_nit_all(pi_nit_inv_type => pi_starting_inv_type
                            ,pi_raise_not_found => FALSE);
                                
 OPEN c1;
 FETCH c1
 BULK COLLECT INTO l_tab_eftg;
 CLOSE c1;

--
--
-- child_descr is substringed to VARCHAR2(40) to make it the same as nm_inv_items_all.iit_descr%TYPE
--
 l_sql :=        'SELECT '||chr(10);
 l_sql := l_sql ||'      '|| l_tab_eftg(1).eftg_pk_column||' child_id'||chr(10);
 l_sql := l_sql ||'     ,SUBSTR('|| l_tab_eftg(1).eftg_descr_column||',1,40) child_descr'||chr(10);
 l_sql := l_sql ||'     ,'|| nm3flx.string(l_tab_eftg(1).eftg_inv_type)||' child_inv_type'||chr(10); 

-- FROM CLAUSE
-- the starting table for the driving asset type plus all the other tables in the asset hierarchy dowwards
--
 l_sql := l_sql||'FROM dual'||chr(10);
 FOR i IN 1..l_tab_eftg.COUNT LOOP
   l_sql := l_sql||','||l_tab_eftg(i).eftg_table_name||chr(10);           
 END LOOP;           



-- WHERE CLAUSE
-- the starting table restrict on the id passed in
-- plus join to all the other tables on the criteria denoted in eam_ft_inv_type_groupings_all
-- and selected in the driving cursor
--
 l_sql := l_sql || 'WHERE 1=1'||chr(10);

 FOR i IN 1..l_tab_eftg.COUNT-1 LOOP
   l_sql := l_sql||'AND '||l_tab_eftg(i).eftg_table_name||'.'||l_tab_eftg(i).eftg_fk_column||'='||l_tab_eftg(i).eftg_parent_table_name||'.'||l_tab_eftg(i).eftg_parent_pk_col||chr(10);
 END LOOP;           


--
-- Finally add in the restiction on the id/asset type passed in
--
 l_sql := l_sql || 'AND '||l_starting.nit_table_name||'.'||l_starting.nit_foreign_pk_column||'='||pi_starting_id;

 RETURN(l_sql);

END get_drill_down_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_child_asset_params(pi_parent_tab IN parent_asset_tab
                                ,pi_child_type IN nm_inv_types_all.nit_inv_type%TYPE) IS
BEGIN
  --
  g_parent_asset_tab := pi_parent_tab;
  g_child_asset_type := pi_child_type;
  --
END set_child_asset_params;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_child_assets(po_child_assets IN OUT child_asset_tab) IS
  --


  TYPE child_rec IS RECORD(child_id        nm_inv_items_all.iit_ne_id%TYPE
                          ,child_descr     nm_inv_items_all.iit_descr%TYPE
                          ,child_inv_type  nm_inv_types_all.nit_inv_type%TYPE);

  TYPE child_tab IS TABLE OF child_rec INDEX BY BINARY_INTEGER;
  
  lt_children child_tab;
  --
  lt_retval child_asset_tab;
  lv_retind PLS_INTEGER:=0;
  --
  PROCEDURE get_children(pi_starting_inv_type IN nm_inv_types_all.nit_inv_type%TYPE
                        ,pi_starting_id       IN NUMBER
                        ,pi_child_type        nm_inv_types_all.nit_inv_type%TYPE) IS

  --
  --
  l_refcur nm3type.ref_cursor;
  
  l_sql    nm3type.max_varchar2;
  
  BEGIN

  l_sql := get_drill_down_sql(pi_starting_inv_type => pi_starting_inv_type
                             ,pi_starting_id       => pi_starting_id
                             ,pi_child_inv_type    => pi_child_type); 

  nm_debug.debug(l_sql);

  OPEN l_refcur FOR l_sql;
  FETCH l_refcur BULK COLLECT INTO lt_children;
  CLOSE l_refcur;                                       

  EXCEPTION
    WHEN others THEN
      RAISE_APPLICATION_ERROR(-20001,l_sql||sqlerrm);

  END get_children;

BEGIN

-- In the calling module you can select one or more parent assets of the same type
-- to drive from
-- these details of the calling asset are stored in g_parent_asset_tab which is set by set_child_asset_params
--
--
-- what is returned back is a concatenation of the parent details (for context info) plus
-- the details of the matching children
--
 
nm_debug.debug_on;
nm_debug.debug('about to look thru the parent asset table which has '||g_parent_asset_tab.count||' record(s)');

  /*
  ||Loop Throug The Parent Assets.
  */
  FOR i IN 1..g_parent_asset_tab.count LOOP
    /*
    ||Fetch The Child Assets.
    */
    
  nm_debug.debug('pi_starting_inv_type='||g_parent_asset_tab(i).inv_type);            
  nm_debug.debug('pi_starting_id='||g_parent_asset_tab(i).item_id);
  nm_debug.debug('pi_child_type='||g_child_asset_type);      
 
    get_children(pi_starting_inv_type => g_parent_asset_tab(i).inv_type
                ,pi_starting_id       => g_parent_asset_tab(i).item_id
                ,pi_child_type        => g_child_asset_type);
    

    FOR j IN 1..lt_children.count LOOP
      /*
      ||Increment The Index For lt_retval.
      */
      lv_retind := lv_retind+1;
      /*
      ||Set The Parent Details.
      */
      lt_retval(lv_retind).parent_inv_type := g_parent_asset_tab(i).inv_type;
      lt_retval(lv_retind).parent_primary  := g_parent_asset_tab(i).primary_key;
      lt_retval(lv_retind).parent_descr    := g_parent_asset_tab(i).descr;
      lt_retval(lv_retind).ne_id           := g_parent_asset_tab(i).road_id;
      lt_retval(lv_retind).x               := g_parent_asset_tab(i).x;
      lt_retval(lv_retind).y               := g_parent_asset_tab(i).y;
      /*
      ||Set The Child Details.
      */
      lt_retval(lv_retind).child_item_id  := lt_children(j).child_id;
      lt_retval(lv_retind).child_primary  := lt_children(j).child_id;      
      lt_retval(lv_retind).child_inv_type := lt_children(j).child_inv_type;
      lt_retval(lv_retind).child_descr    := lt_children(j).child_descr;
      --
    END LOOP;
    --
  END LOOP;
  --
  po_child_assets := lt_retval;
  --
nm_debug.debug_off;
END get_child_assets;


END eam_asset;
/
