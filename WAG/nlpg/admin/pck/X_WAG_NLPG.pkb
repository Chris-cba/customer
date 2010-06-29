CREATE OR REPLACE PACKAGE BODY X_WAG_NLPG AS
--<PACKAGE>
-------------------------------------------------------------------------
         --   PVCS Identifiers :-
         --
         --       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/nlpg/admin/pck/X_WAG_NLPG.pkb-arc   3.0   Jun 29 2010 08:56:14   Ian.Turnbull  $
         --       Module Name      : $Workfile:   X_WAG_NLPG.pkb  $
         --       Date into PVCS   : $Date:   Jun 29 2010 08:56:14  $
         --       Date fetched Out : $Modtime:   Jun 28 2010 16:57:46  $
         --       Version          : $Revision:   3.0  $
         -- created by Aileen Heal for WAG planning app
-------------------------------------------------------------------------
g_body_sccsid   CONSTANT varchar2(200) := '$Revision:   3.0  $';
-- ****************************************************************************
--           Private PROCS/Functions definitions
--
-- ****************************************************************************
procedure debug_print (v_string IN VARCHAR2);
-- if g_debug = 1 then sends string to dbms_output

type lpi_table_type is table of nlpg_lpi%ROWTYPE;

procedure  get_lpi_info ( v_uprn     IN      nlpg_lpi.UPRN%TYPE,
                          v_language IN      nlpg_lpi.language%type,
                          v_lpi_info IN OUT  lpi_table_type );


-- ****************************************************************************
--  global PROCS/FUNCTIONS
-- ****************************************************************************
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
procedure get_coordinates( v_uprn in nlpg_lpi.UPRN%TYPE
  	                       , x_coordinate out number
  	                       , y_coordinate out number
  	                       ) is
   cursor c1(l_uprn nlpg_lpi.UPRN%TYPE) is
   select x_coordinate, y_coordinate
   from nlpg_lpi l, nlpg_blpu b
   where l.uprn = b.uprn
   	and l_uprn = l.uprn;
begin
   open c1(v_uprn);
   fetch c1 into x_coordinate, y_coordinate;
   if c1%notfound then
    close c1;
   	x_coordinate := NULL;
   	y_coordinate := NULL;
   else
   	close c1;
   end if;

end get_coordinates;

function get_g_radius return number as
begin
	return nvl(g_radius,hig.get_user_or_sys_opt('RADIUS'));
end;

function get_g_address_count return number as
begin
	return nvl(g_address_count, 0);
end;

function get_dummy_nlpg_addresses ( v_uprn     IN nlpg_lpi.UPRN%TYPE
                               ) return address_rec_table_type
as

  p_addresses address_rec_table_type;

begin
	 select ndp_uprn, ndp_address
	 	bulk collect into p_addresses
	 from  nlpg_dummy_properties
	 where ndp_uprn = v_uprn
	   and nm3context.get_effective_date between ndp_start_date and nvl(ndp_end_date,nm3context.get_effective_date);

	return p_addresses;
end;

function get_nlpg_addresses ( v_uprn     IN nlpg_lpi.UPRN%TYPE,
                              v_language IN nlpg_lpi.language%type DEFAULT 'ENG' ) return address_rec_table_type
as


  p_addresses address_rec_table_type;
  lpi_info lpi_table_type;

  p_sao varchar2(100);
  p_pao varchar2(100);
  p_address varchar2(1024) := '';
  p_i number;
  p_street varchar2(200);
  x_coordinate number;
  y_coordinate number;

begin

   get_lpi_info( v_uprn, v_language, lpi_info );

   -- check to see we have an address if not and language is not english try english
   if lpi_info.count < 1 and v_language <> 'ENG' then --try english
      get_lpi_info( v_uprn, 'ENG', lpi_info );
   end if;


   for i in 1..lpi_info.count LOOP

    p_street :=  get_street_info(lpi_info(i).usrn, lpi_info(i).language);

    -- get SAO
    p_sao := get_PAO_SAO( lpi_info(i).sao_start_number,
                          lpi_info(i).sao_start_suffix,
                          lpi_info(i).sao_end_number,
                          lpi_info(i).sao_end_suffix,
                          lpi_info(i).sao_text );

    -- get PAO
    p_pao := get_PAO_SAO( lpi_info(i).pao_start_number,
                          lpi_info(i).pao_start_suffix,
                          lpi_info(i).pao_end_number,
                          lpi_info(i).pao_end_suffix,
                          lpi_info(i).pao_text );

    if length(p_sao) > 0 then
       p_address := p_sao || ' ';
    end if;

    if length(p_pao) > 0 then
       p_address := p_address || p_pao || ' ';
    end if;

    p_addresses(i).uprn := v_uprn;
    p_addresses(i).address := p_address || p_street || ', ' || lpi_info(i).postcode;

  end loop;

  debug_print( 'get_nlpg_addresses: ' || lpi_info.count || ' addresses found for UPRN ' || v_uprn);

  return p_addresses;
end;


-- ****************************************************************************

function get_street_info (v_usrn     IN nlpg_street_descriptor.USRN%TYPE,
                          v_language IN nlpg_street_descriptor.LANGUAGE%TYPE DEFAULT 'ENG' ) return varchar2
as
  p_name       nlpg_street_descriptor.STREET_DESCRIPTOR%TYPE;
  p_locality   nlpg_street_descriptor.LOCALITY_NAME%TYPE;
  p_town       nlpg_street_descriptor.TOWN_NAME%TYPE;
  p_return varchar2(200);

begin

   begin
      select  STREET_DESCRIPTOR, LOCALITY_NAME, TOWN_NAME
         into  p_name, p_locality, p_town
         from  nlpg_street_descriptor
         where usrn = v_usrn
          and   language = v_language;

   EXCEPTION
     when NO_DATA_FOUND then
        BEGIN
           if v_language <> 'ENG' then -- try with english
              BEGIN
                select  STREET_DESCRIPTOR, LOCALITY_NAME, TOWN_NAME
                  into  p_name, p_locality, p_town
                  from  nlpg_street_descriptor
                  where usrn = v_usrn
                  and   language = 'ENG';

              EXCEPTION
                 when others then
                    return null;
              END;
           ELSE  -- language was english so no street must exist
             return null;
           end if;
          EXCEPTION -- unexpected error return null
       when others then
          return null;
     END;
   END;

   p_return := p_name;
   if length(p_locality) > 0 then
       p_return := p_return || ', ' || p_locality;
   end if;

   if length(p_town) > 0 then
      p_return := p_return || ', ' || p_town;
   end if;

   return p_return;

EXCEPTION
   When others then
     return null;
END;
-- ****************************************************************************
-- ****************************************************************************
procedure get_addresses_from_bng( v_easting         in number,
                                 v_northing        in number,
                                 v_search_radius   in number DEFAULT 100,  -- in metres
                                 v_language        in nlpg_lpi.language%type DEFAULT 'ENG' ,
                                 v_address_table in out address_rec_table_type)
as

   TYPE uprn_table_type is table of nlpg_blpu.uprn%type INDEX BY BINARY_INTEGER;
   p_uprn_table uprn_table_type;
   p_i integer;
   p_j integer;
   p_total_num_addresses integer;
   p_all_addresses address_rec_table_type;
   p_uprn_addresses address_rec_table_type;

   p_high_radius number := nvl(v_search_radius,100);
   p_low_radius number := 0;
   p_radius number := nvl(v_search_radius,100);
   p_count number := 0;
   p_best_radius number;
   p_best_count number := 0;
   i number := 0;

   function binary_chop ( pi_low_radius number
   	                    , pi_high_radius number
   	                    ) return number is
   	 l_new_radius number;
   begin
     if pi_low_radius = 0 then
     	 l_new_radius := round(pi_high_radius/2);
     else
       l_new_radius := pi_high_radius - round((pi_high_radius - pi_low_radius)/2);
     end if;
     return l_new_radius;
   end binary_chop;


begin
--	nm_debug.debug_on;
--	nm_debug.debug('nlpg1) get_addresses_from_bng');
loop
 i := i + 1;
/*    select uprn bulk collect
     into p_uprn_table
     from nlpg_blpu
     where X_COORDINATE > v_easting - v_search_radius
     and   X_COORDINATE < v_easting + v_search_radius
     and   Y_COORDINATE > v_northing - v_search_radius
     and   Y_COORDINATE < v_northing + v_search_radius
     and not blpu_class in ('PS', 'UC'); */

   select count(uprn)
   	into p_count
     from nlpg_properties_v
     where X_COORDINATE > v_easting - p_radius
     and   X_COORDINATE < v_easting + p_radius
     and   Y_COORDINATE > v_northing - p_radius
     and   Y_COORDINATE < v_northing + p_radius
     and   logical_status in (1,3,6,8)
     --and   not blpu_class in ('PS', 'UC')
   	;

--  nm_debug.debug('nlpg2) p_count - '||p_count);
--  nm_debug.debug('nlpg3) p_radius - '||p_radius);
   g_radius := p_radius;

   if p_count > 21 and p_radius > 5 then
        p_high_radius := p_radius;
     p_radius := binary_chop(p_low_radius, p_high_radius);
   elsif p_count < 1 and p_radius = nvl(v_search_radius,100) then
     hig.raise_ner(pi_appl => 'PEM'
                  ,pi_id   => 15
                  );

/* --CCH commented out this block as it is still hanging in certain places.
   --if there are less than 10 records returrned, then return all them!!!
   elsif p_count < 10 and p_radius > 5 then
        p_low_radius := p_radius;
        --SM 01072009
        --added the following if statement as if teh initial radius returned less 
        --than 10 properties it was getting stuck in a loop as it tried to do a binary chop.
     if p_low_radius = p_high_radius then
       exit;
     else
       p_radius := binary_chop(p_low_radius, p_high_radius);
     end if;        
        p_radius := binary_chop(p_low_radius, p_high_radius);
*/
   else
--   nm_debug.debug('nlpg4) exiting loop with p_redius - '||p_radius||', and p_count - '||p_count);
     exit;     
   end if;

end loop;      
g_address_count := p_count;
g_radius := p_radius;
   

   select unique uprn bulk collect
     into p_uprn_table
     from nlpg_properties_v
     where X_COORDINATE > v_easting - p_radius
     and   X_COORDINATE < v_easting + p_radius
     and   Y_COORDINATE > v_northing - p_radius
     and   Y_COORDINATE < v_northing + p_radius
     and   logical_status in (1,3,6,8)
     --and not blpu_class in ('PS', 'UC');
    order by 1;
--nm_debug.debug('nlpg5) post table update - '||g_radius);
  debug_print( 'get_addresses_from_bng: ' || p_uprn_table.count || ' UPRNs found.');

  p_total_num_addresses := 0;
--  nm_debug.debug('nlpg6) number - '||p_uprn_table.count);

  for p_i in 1..p_uprn_table.count
  loop
     if sign(p_uprn_table(p_i)) = -1 then
       p_uprn_addresses := get_dummy_nlpg_addresses(p_uprn_table(p_i));
--       nm_debug.debug('p_uprn_addresses.count - '||p_uprn_addresses.count);
     else
       p_uprn_addresses := get_nlpg_addresses(p_uprn_table(p_i), v_language );
     end if;
     for p_j in 1..p_uprn_addresses.count
     loop
--        nm_debug.debug('nlpg7) address count('||p_j||'/'||p_i||') - '||p_uprn_addresses(p_j).uprn||' = '||p_uprn_addresses(p_j).address);
        p_total_num_addresses := p_total_num_addresses + 1;
        debug_print( 'get_addresses_from_bng: address(' || p_total_num_addresses  || ').uprn;' || p_uprn_addresses(p_j).uprn);
        debug_print( 'get_addresses_from_bng: address(' || p_total_num_addresses  || ').address;' || p_uprn_addresses(p_j).address);
        p_all_addresses(p_total_num_addresses).uprn := p_uprn_addresses(p_j).uprn;
        p_all_addresses(p_total_num_addresses).address := p_uprn_addresses(p_j).address;
     end loop;
  end loop;

  debug_print( 'get_addresses_from_bng: ' || p_total_num_addresses || ' UPRNs found.');
  v_address_table := p_all_addresses;
  nm_debug.debug_off;
  --v_search_radius := p_radius;
  --return p_all_addresses;

end;

-- ****************************************************************************

function get_PAO_SAO( v_start_number IN number,
                      v_start_suffix IN varchar2,
                      v_end_number   IN number,
                      v_end_suffix   IN varchar2,
                      v_text         In varchar2 ) return varchar2
as
v_return varchar2( 100);
begin

   -- text
    if v_text is not null then
       v_return := v_text || ', ';
    end if;

  -- start number
    if  v_start_number is not null then
       v_return := v_return || v_start_number;

       if  v_start_suffix is not null then
          v_return := v_return || v_start_suffix;
       end if;

      --End number
      if v_end_number is not null then
        v_return := v_return || '-' || v_end_number;
        if v_end_suffix is not null then
          v_return := v_return || v_end_suffix;
        end if;
      end if;

    end if;

    return v_return;

end;
-- ****************************************************************************
--           Private PROCS/Functions
-- ****************************************************************************
procedure debug_print (v_string IN VARCHAR2)
as
begin

  if g_debug = 1 then
     dbms_output.put_line( v_string );
  end if;
end;


-- ****************************************************************************

procedure  get_lpi_info ( v_uprn     IN      nlpg_lpi.UPRN%TYPE,
                          v_language IN      nlpg_lpi.language%type,
                          v_lpi_info IN OUT  lpi_table_type )
as
begin

-- Logical status values
-- 1: Approved / Preferred LPI
-- 3: Alternative LPI
-- 5: Candidate LPI
-- 6: Provisional LPI
-- 7: Rejected External LPI
-- 8: Historical LPI
-- 9: Rejected Internal LPI

   select * bulk collect into v_lpi_info
       from nlpg_lpi
       where uprn = v_uprn
       and logical_status in (1,3)
       and language = v_language;

   if v_lpi_info.count < 1 then
   -- try provisional
      select * bulk collect into v_lpi_info
          from nlpg_lpi
          where uprn = v_uprn
          and logical_status in (6)
          and language = v_language;
   end if;

   if v_lpi_info.count < 1 then
   -- try historic
      select * bulk collect into v_lpi_info
          from nlpg_lpi
          where uprn = v_uprn
          and logical_status in (8)
          and language = v_language;
   end if;

end;

-- ****************************************************************************

END X_WAG_NLPG; 
/

