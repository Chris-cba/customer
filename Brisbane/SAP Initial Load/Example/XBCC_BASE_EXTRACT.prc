CREATE OR REPLACE procedure BRAMS_OWNER.XBCC_BASE_EXTRACT(p_inv_type IN NM_INV_TYPES.NIT_INV_TYPE%TYPE, p_net_type IN VARCHAR2 DEFAULT 'RDCO')
IS

-- p_inv_type parameter acceps asset codes from nm_inv_types
-- p_net_type accepts corridor codes
-- RDCO
-- VECO
-- KCOR

sqltxt NM3TYPE.MAX_VARCHAR2;
p_table_name VARCHAR2(30);
p_route_Table_name VARCHAR2(30);
p_asset_cat NM_INV_TYPES.NIT_CATEGORY%TYPE;

p_ft_asset_tab_name VARCHAR2(30);

p_count NUMBER;

PROCEDURE locate_on_route(p_ne_id Nm_elements_all.ne_id%TYPE,p_unique nm_elements_all.ne_unique%TYPE)
IS

begin

NM3ROUTE_REF.GET_INV_ON_ROUTE(p_ne_id,p_inv_type);

sqltxt := 'insert into XBCC_V_NM_'||p_inv_type||'_ON_'||p_net_type||'_ROUTE select a.*, '''||p_unique ||''' from  V_NM_'||p_inv_type||'_on_route a';
NM3DBG.PUTLN(sqltxt);
execute immediate sqltxt;

commit;

EXCEPTION WHEN OTHERS THEN

        NM3DBG.PUTLN(p_ne_id||' - '||sqlerrm);

end;



PROCEDURE locate_on_route_FT(p_ne_id Nm_elements_all.ne_id%TYPE,p_unique nm_elements_all.ne_unique%TYPE)
IS

begin

NM3ROUTE_REF.GET_INV_ON_ROUTE(p_ne_id,p_inv_type);

sqltxt := 'insert into XBCC_V_NM_'||p_inv_type||'_ON_'||p_net_type||'_ROUTE select a.*, '''||p_unique ||''' from  V_NM_'||p_inv_type||'_on_route a';
NM3DBG.PUTLN(sqltxt);
--execute immediate sqltxt;

select count(*) 
into p_count
from nm_nw_Temp_Extents;

NM3DBG.PUTLN(p_count);

--commit;

EXCEPTION WHEN OTHERS THEN

        NM3DBG.PUTLN(p_ne_id||' - '||sqlerrm);

end;



begin

NM3DBG.DEBUG_ON;

-- find if this inv_type is a FT asset or not
select nit_category
into p_asset_cat
from nm_inv_Types
where nit_inv_type = p_inv_type;


if p_Asset_cat <> 'F'
THEN


                    -- get temp table name

                    p_table_name := 'XBCC_V_NM_'||p_inv_type||'_ON_'||p_net_type||'_ROUTE';

                    NM3DBG.PUTLN(p_table_name);
                    p_route_Table_name := 'V_NM_'||p_inv_type||'_ON_ROUTE';

                    NM3DBG.PUTLN(p_route_Table_name);

                    NM3DBG.DEBUG_ON;

                    -- create the holding table if it doesn't exist
                    if NM3DDL.DOES_OBJECT_EXIST(p_table_name)
                    THEN
                        sqltxt := 'drop table '|| p_table_name;
                        NM3DBG.PUTLN(sqltxt);
                        execute immediate sqltxt;
                    END IF;


                    sqltxt := 'create table '|| p_table_name || ' as select * from  '||p_route_Table_name||' where 1 = 2';

                    execute immediate sqltxt;

                    sqltxt := 'ALTER TABLE '||p_table_name||' ADD (ne_unique VARCHAR2(30 BYTE))';

                    NM3DBG.PUTLN(sqltxt);

                    execute immediate sqltxt;

                    commit;

                    if p_net_type = 'RDCO'
                    THEN


                    for rec in (select * from v_nm_rdco_rdco_nt)
                                    LOOP
                                    NM3DBG.PUTLN('Processing '||rec.ne_id);
                                    locate_on_route(rec.ne_id,rec.ne_unique);
                                    
                                    END LOOP;

                    ELSIF p_net_type = 'VECO'
                    THEN

                    for rec in (select * from v_nm_veco_veco_nt)
                                    LOOP
                                    NM3DBG.PUTLN('Processing '||rec.ne_id);
                                    locate_on_route(rec.ne_id,rec.ne_unique);
                                    
                                    END LOOP;


                    ELSIF p_net_type = 'KCOR'
                    THEN


                    for rec in (select * from v_nm_kcor_kcor_nt)
                                    LOOP
                                    NM3DBG.PUTLN('Processing '||rec.ne_id);
                                    locate_on_route(rec.ne_id,rec.ne_unique);
                                    
                                    END LOOP;


                    end if;
                    
                    
end if;


-- process FT inventory
-- ********************************************************************************************

if p_Asset_cat = 'F'
THEN
                
    select NM3INV.GET_INV_TYPE_TABLE_NAME(p_inv_type) 
    into p_ft_asset_tab_name
    from dual;
    
       p_table_name := p_ft_asset_tab_name||'_ON_'||p_net_type||'_ROUTE';

       NM3DBG.PUTLN(p_table_name);
       
           
      if NM3DDL.DOES_OBJECT_EXIST(p_table_name)
                    THEN
                        sqltxt := 'drop table '|| p_table_name;
                        NM3DBG.PUTLN(sqltxt);
                        execute immediate sqltxt;
                    END IF;

    
    
    sqltxt := 'create table '||p_ft_asset_tab_name||'_ON_'||p_net_type||'_ROUTE as select * from '||p_ft_asset_tab_name;
    execute immediate sqltxt;
    
                    if p_net_type = 'RDCO'
                    THEN

                    for rec in (select * from v_nm_rdco_rdco_nt)
                                    LOOP
                                    NM3DBG.PUTLN('Processing '||rec.ne_id);
                                    locate_on_route_ft(rec.ne_id,rec.ne_unique);
                                    
                                    END LOOP;

                    ELSIF p_net_type = 'VECO'
                    THEN

                    for rec in (select * from v_nm_veco_veco_nt)
                                    LOOP
                                    NM3DBG.PUTLN('Processing '||rec.ne_id);
                                    locate_on_route_FT(rec.ne_id,rec.ne_unique);
                                    
                                    END LOOP;


                    ELSIF p_net_type = 'KCOR'
                    THEN


                    for rec in (select * from v_nm_kcor_kcor_nt)
                                    LOOP
                                    NM3DBG.PUTLN('Processing '||rec.ne_id);
                                    locate_on_route_FT(rec.ne_id,rec.ne_unique);
                                    
                                    END LOOP;


                    end if;
                    
   
    
END IF;    
    
     

    


end;
/
