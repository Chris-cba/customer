CREATE OR REPLACE PACKAGE BODY xlbb_pem_invoice
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/barnet/FSWMI103_pem_to_sap/admin/pck/xlbb_pem_invoice.pkb-arc   2.0   Oct 15 2007 08:38:32   smarshall  $
--       Module Name      : $Workfile:   xlbb_pem_invoice.pkb  $
--       Date into PVCS   : $Date:   Oct 15 2007 08:38:32  $
--       Date fetched Out : $Modtime:   Oct 15 2007 07:45:16  $
--       PVCS Version     : $Revision:   2.0  $
--       Based on SCCS version :
--
--
--   Author : ITurnbull
--
--   xlbb_pem_invoice body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   2.0  $"';

  g_package_name CONSTANT varchar2(30) := 'xlbb_pem_invoice';
  
  g_extract_status_code constant docs.doc_status_code%type := 'II'; -- ready to invoice
  g_inv_requested       constant docs.doc_status_code%type := 'IR'; -- invoice raised/sent to sap
  g_inv_sent            constant docs.doc_status_code%type := 'IS'; -- invoice sent to customer
  g_inv_paid            constant docs.doc_status_code%type := 'IP'; -- invoice customer paid
  
  g_extracted constant varchar2(20) := 'EXTRACTED';

  g_input_filename constant varchar2(20) := 'SAP_2_ATL_IVS_';  

  g_interpath constant varchar2(30) := hig.get_user_or_sys_opt('INTERPATH');
  
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
FUNCTION GET_xlbb_bh_id_seq
RETURN NUMBER
IS
  RTRN NUMBER;
BEGIN
  SELECT xlbb_bh_id_seq.NEXTVAL INTO RTRN FROM DUAL;
--  
  RETURN RTRN;
--  
END GET_xlbb_bh_id_seq;  
--
-----------------------------------------------------------------------------
--
FUNCTION GET_xlbb_Ih_id_seq
RETURN NUMBER
IS
  RTRN NUMBER;
BEGIN
  SELECT xlbb_Ih_id_seq.NEXTVAL INTO RTRN FROM DUAL;
--  
  RETURN RTRN;
--  
END GET_xlbb_Ih_id_seq;  
--
-----------------------------------------------------------------------------
--
FUNCTION GET_xlbb_II_id_seq
RETURN NUMBER
IS
  RTRN NUMBER;
BEGIN
  SELECT xlbb_II_iD_seq.NEXTVAL INTO RTRN FROM DUAL;
--  
  RETURN RTRN;
--  
END GET_xlbb_II_id_seq;  
--
-----------------------------------------------------------------------------
--
FUNCTION GET_xlbb_It_id_seq
RETURN NUMBER
IS
  RTRN NUMBER;
BEGIN
  SELECT xlbb_It_iD_seq.NEXTVAL INTO RTRN FROM DUAL;
--  
  RETURN RTRN;
--  
END GET_xlbb_It_id_seq;  
--
-----------------------------------------------------------------------------
--
FUNCTION GET_xlbb_stp_id_seq
RETURN NUMBER
IS
  RTRN NUMBER;
BEGIN
  SELECT xlbb_stp_iD_seq.NEXTVAL INTO RTRN FROM DUAL;
--  
  RETURN RTRN;
--  
END GET_xlbb_stp_id_seq; --
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
function get_xlbb_file_id_seq
return number
is
   rtrn number;
begin
   select xlbb_file_id_seq.nextval
   into rtrn
   from dual;
   
   return rtrn;
end get_xlbb_file_id_seq;   
--
-----------------------------------------------------------------------------
--
function create_file_name 
return varchar2
is
begin 
   return 'ATL_2_SAP_SOC_'||lpad(get_xlbb_file_id_seq,6,'0')||'.txt';
end create_file_name;
--
-----------------------------------------------------------------------------
--
function ins_bh(pi_bh_rec Xlbb_pem_inv_batch_header%rowtype)
return Xlbb_pem_inv_batch_header%rowtype
is
   L_BH_REC Xlbb_pem_inv_batch_header%rowtype;
   RTRN  Xlbb_pem_inv_batch_header%rowtype;
   
   pragma autonomous_transaction;
begin
   L_BH_REC := PI_BH_REC;
   
   L_BH_REC.BH_ID := GET_xlbb_bh_id_seq;
   L_BH_REC.BH_DATE_CREATED := SYSDATE;
   l_bh_rec.bh_filename := create_file_name;
   l_bh_rec.bh_rec_type := 'B##';
   l_bh_rec.bh_trailer_rec_type := 'T##';
   l_bh_rec.bh_created_by := user;
   
   INSERT INTO  Xlbb_pem_inv_batch_header
   VALUES
   L_BH_REC
   RETURNING   BH_ID
             , bh_date_created
             , bh_num_invoices
             , bh_num_invoice_items
             , bh_filename
             , bh_rec_type
             , bh_trailer_rec_type
   INTO  RTRN.BH_ID
        ,RTRN.bh_date_created
        ,RTRN.bh_num_invoices
        ,RTRN.bh_num_invoice_items
        ,RTRN.bh_filename
        ,RTRN.bh_rec_type
        ,RTRN.bh_trailer_rec_type;
   
   commit;
   
   RETURN RTRN;
   
end ins_bh;
--
-----------------------------------------------------------------------------
--
procedure upd_bh_num_invoices(pi_bh_id Xlbb_pem_inv_batch_header.bh_id%type
                            , pi_bh_num_invoices Xlbb_pem_inv_batch_header.bh_num_invoices%type )
is
   pragma autonomous_transaction;
begin 
   update Xlbb_pem_inv_batch_header
   set bh_num_invoices = pi_bh_num_invoices
   where bh_id = pi_bh_id;
   
   commit;
end upd_bh_num_invoices;
--
-----------------------------------------------------------------------------
--
procedure upd_bh_num_invoice_items(pi_bh_id Xlbb_pem_inv_batch_header.bh_id%type
                                 , pi_bh_num_invoices Xlbb_pem_inv_batch_header.bh_num_invoice_items%type )
is
   pragma autonomous_transaction;
begin 
   update Xlbb_pem_inv_batch_header
   set bh_num_invoice_items  = pi_bh_num_invoices
   where bh_id = pi_bh_id;
   
   commit;
end upd_bh_num_invoice_items;
--
-----------------------------------------------------------------------------
--
procedure upd_Bh_filename(pi_bh_id Xlbb_pem_inv_batch_header.bh_id%type
                        , pi_Bh_filename Xlbb_pem_inv_batch_header.Bh_filename%type )
is
   pragma autonomous_transaction;
begin 
   update Xlbb_pem_inv_batch_header
   set Bh_filename = pi_Bh_filename
   where bh_id = pi_bh_id;
   
   commit;
end upd_Bh_filename;
--
-----------------------------------------------------------------------------
--
function ins_ih(pi_ih_rec Xlbb_pem_inv_invoice_header%rowtype)
return Xlbb_pem_inv_invoice_header%rowtype
is
   L_iH_REC Xlbb_pem_inv_invoice_header%rowtype;
   RTRN  Xlbb_pem_inv_invoice_header%rowtype;
   
   pragma autonomous_transaction;
begin
   L_iH_REC := PI_iH_REC;
   
   L_iH_REC.iH_ID := GET_xlbb_ih_id_seq;
   

  INSERT INTO xlbb_pem_inv_invoice_header
     VALUES l_ih_rec
  RETURNING ih_id,
            ih_bh_id,
            ih_rec_type,
            ih_order_type,
            ih_sales_org,
            ih_distrib_channel,
            ih_division,
            ih_sales_office,
            ih_sales_group,
            ih_name,
            ih_sold_to_cust,
            ih_ot_cust_name,
            ih_ot_street2,
            ih_ot_street,
            ih_ot_postcode,
            ih_ot_city,
            ih_po_num,
            ih_cust_group,
            ih_services_rend_date,
            ih_billing_date,
            ih_payment_method,
            ih_tax_class,
            ih_ship_to_party,
            ih_bill_to_party,
            ih_payer
       INTO rtrn.ih_id,
            rtrn.ih_bh_id,
            rtrn.ih_rec_type,
            rtrn.ih_order_type,
            rtrn.ih_sales_org,
            rtrn.ih_distrib_channel,
            rtrn.ih_division,
            rtrn.ih_sales_office,
            rtrn.ih_sales_group,
            rtrn.ih_name,
            rtrn.ih_sold_to_cust,
            rtrn.ih_ot_cust_name,
            rtrn.ih_ot_street2,
            rtrn.ih_ot_street,
            rtrn.ih_ot_postcode,
            rtrn.ih_ot_city,
            rtrn.ih_po_num,
            rtrn.ih_cust_group,
            rtrn.ih_services_rend_date,
            rtrn.ih_billing_date,
            rtrn.ih_payment_method,
            rtrn.ih_tax_class,
            rtrn.ih_ship_to_party,
            rtrn.ih_bill_to_party,
            rtrn.ih_payer; 
   commit;
   
   RETURN RTRN;
   
end ins_ih;
--
-----------------------------------------------------------------------------
--
function ins_ii(pi_ii_rec Xlbb_pem_inv_invoice_item%rowtype)
return Xlbb_pem_inv_invoice_item%rowtype
is
   L_ii_REC Xlbb_pem_inv_invoice_item%rowtype;
   RTRN  Xlbb_pem_inv_invoice_item%rowtype;
   
   pragma autonomous_transaction;
begin
   L_ii_REC := PI_ii_REC;
   
   L_ii_REC.ii_ID := GET_xlbb_ii_id_seq;
   

  INSERT INTO xlbb_pem_inv_invoice_item
     VALUES l_ii_rec
  RETURNING ii_id,
            ii_ih_id,
            ii_rec_type,
            ii_mat_code,
            ii_description,
            ii_quantity,
            ii_profit_centre,
            ii_amount,
            ii_service_rend_date,
            ii_po_number
       INTO rtrn.ii_id,
            rtrn.ii_ih_id,
            rtrn.ii_rec_type,
            rtrn.ii_mat_code,
            rtrn.ii_description,
            rtrn.ii_quantity,
            rtrn.ii_profit_centre,
            rtrn.ii_amount,
            rtrn.ii_service_rend_date,
            rtrn.ii_po_number;
   commit;
   
   RETURN RTRN;
   
end ins_ii;
--
-----------------------------------------------------------------------------
--
function ins_it(pi_it_rec xlbb_pem_inv_item_text %rowtype)
return xlbb_pem_inv_item_text%rowtype
is
   L_it_REC xlbb_pem_inv_item_text %rowtype;
   RTRN  xlbb_pem_inv_item_text %rowtype;
   
   pragma autonomous_transaction;
begin
   L_it_REC := PI_it_REC;
   
   L_it_REC.it_ID := GET_xlbb_it_id_seq;
   l_it_rec.it_rec_type := '4##';
   
   

  INSERT INTO xlbb_pem_inv_item_text
     VALUES 
            L_it_REC
  RETURNING it_id, 
            it_ii_id, 
            it_rec_type, 
            it_text 
       INTO rtrn.it_id, 
            rtrn.it_ii_id, 
            rtrn.it_rec_type, 
            rtrn.it_text;
            
   commit;
   
   RETURN RTRN;
   
end ins_it;
--
-----------------------------------------------------------------------------
--
function get_contact_id(pi_doc_id docs.doc_id%type)
return hig_contacts.hct_notes%type
is
   cursor c_contact (c_doc_id doc_enquiry_contacts.dec_doc_id%type)
   is
   select hct.*
   from doc_enquiry_contacts dec
       ,hig_contacts hct
   where dec_doc_id = c_doc_id
     and dec_hct_id = hct_id
     and dec_contact = 'Y';
   
   rtrn hig_contacts%rowtype;
begin 
   open c_contact(pi_doc_id);
   fetch c_contact into rtrn;
   close c_contact;
   
   return rtrn.hct_notes;
   
end get_contact_id;
--
-----------------------------------------------------------------------------
--
function get_sales_office(pi_enq_class docs.doc_dcl_code%type)
return xlbb_z_sales_office.zso_sales_office%type
is
   ref_cur nm3type.ref_cursor;
   rtrn xlbb_z_sales_office.zso_sales_office%type;
begin 
   open ref_cur for 'select zso_sales_office from xlbb_z_sales_office where zso_enq_class = '||nm3flx.string(pi_enq_class);
   fetch ref_cur into  rtrn;
   close ref_cur;
   
   return rtrn;   
end get_sales_office;  
--
-----------------------------------------------------------------------------
--
function get_sales_group(pi_enq_class docs.doc_dcl_code%type)
return xlbb_z_sales_group.zsg_sales_group %type
is
   ref_cur nm3type.ref_cursor;
   rtrn xlbb_z_sales_group.zsg_sales_group %type;
begin 
   open ref_cur for 'select zsg_sales_group  from xlbb_z_sales_group  where zsg_enq_class  = '||nm3flx.string(pi_enq_class);
   fetch ref_cur into  rtrn;
   close ref_cur;
   
   return rtrn;   
end get_sales_group;  
--
-----------------------------------------------------------------------------
--
function get_service_material(pi_enq_class docs.doc_dcl_code%type
                             ,pi_enq_type  docs.doc_compl_type%type)
return xlbb_z_service_material.zsm_service_num  %type
is
   ref_cur nm3type.ref_cursor;
   rtrn xlbb_z_service_material.zsm_service_num  %type;
begin 
   open ref_cur for 'select zsm_service_num   from xlbb_z_service_material   '||
                    ' where zsm_enq_class   = '||nm3flx.string(pi_enq_class) ||
                    '   and zsm_enq_type = '||nm3flx.string(pi_enq_type);
   fetch ref_cur into  rtrn;
   close ref_cur;
   
   return rtrn;   
end get_service_material;
--
-----------------------------------------------------------------------------
--
function get_doc_rec(pi_doc_id docs.doc_id%type)
return docs%rowtype
is
   ref_cur nm3type.ref_cursor;
   rtrn docs%rowtype;
begin 
   open ref_cur for 'select * from docs where doc_id = ' || pi_doc_id;
   fetch ref_cur into rtrn;
   close ref_cur;
   
   return rtrn;
end get_doc_rec;   
--
-----------------------------------------------------------------------------
--
function create_ih_rec(pi_bh_id xlbb_pem_inv_batch_header.bh_id%type
                      ,pi_doc_id docs.doc_id%type
                      )
return xlbb_pem_inv_invoice_header%rowtype
is
   l_ih_rec xlbb_pem_inv_invoice_header%rowtype;
   
   l_doc_rec docs%rowtype;
begin

   l_doc_rec := get_doc_rec(pi_doc_id => pi_doc_id);

   l_ih_rec.ih_id := null ; -- set by ins procedure
   l_ih_rec.ih_bh_id := pi_bh_id;
   l_ih_rec.ih_rec_type := '1##';
   l_ih_rec.ih_order_type  := 'ZINV';
   l_ih_rec.ih_sales_org  := '1000';
   l_ih_rec.ih_distrib_channel := '10';
   l_ih_rec.ih_division := '10';
   l_ih_rec.ih_sales_office := get_sales_office(pi_enq_class => l_doc_rec.doc_dcl_code) ;
   l_ih_rec.ih_sales_group :=  get_sales_group(pi_enq_class => l_doc_rec.doc_dcl_code) ;
   l_ih_rec.ih_name := pi_doc_id;
   l_ih_rec.ih_sold_to_cust := nvl(get_contact_id(pi_doc_id),-1);
   l_ih_rec.ih_ot_cust_name := null;
   l_ih_rec.ih_ot_street2 := null;
   l_ih_rec.ih_ot_street := null;
   l_ih_rec.ih_ot_postcode := null;
   l_ih_rec.ih_ot_city := null;
   l_ih_rec.ih_po_num := 'ATLAS';
   l_ih_rec.ih_cust_group := null;
   l_ih_rec.ih_services_rend_date := null;
   l_ih_rec.ih_billing_date := null;
   l_ih_rec.ih_payment_method := null;
   l_ih_rec.ih_tax_class := null;
   l_ih_rec.ih_ship_to_party := null;
   l_ih_rec.ih_bill_to_party := null;
   l_ih_rec.ih_payer:= null;

   return l_ih_rec;
     
end create_ih_rec;                                              
--
-----------------------------------------------------------------------------
--
function create_ii_rec(pi_ih_id xlbb_pem_inv_invoice_header.ih_id%type
                      ,pi_doc_id docs.doc_id%type
                      ,pi_line_total number
                      )
return xlbb_pem_inv_invoice_item%rowtype
is
   l_ii_rec xlbb_pem_inv_invoice_item%rowtype;
   l_doc_rec docs%rowtype;
begin

   l_doc_rec := get_doc_rec(pi_doc_id => pi_doc_id);

   l_ii_rec.ii_id   := null; --- set by insert statement 
   l_ii_rec.ii_ih_id := pi_ih_id;
   l_ii_rec.ii_rec_type := '3##';
   l_ii_rec.ii_mat_code := get_service_material(pi_enq_class =>  l_doc_rec.doc_dcl_code
                                               ,pi_enq_type => l_doc_rec.doc_compl_type);
   l_ii_rec.ii_description := null; --replace(replace(l_doc_rec.doc_descr,chr(10)),chr(13));
   l_ii_rec.ii_quantity := 1;
   l_ii_rec.ii_profit_centre := null; --l_doc_rec.doc_dcl_code;
   l_ii_rec.ii_amount := pi_line_total;
   l_ii_rec.ii_service_rend_date := null;
   l_ii_rec.ii_po_number := null;

   return l_ii_rec;

end create_ii_rec;                        
--
-----------------------------------------------------------------------------
--
procedure write_file_out(pi_bh_id xlbb_pem_inv_batch_header.bh_id%type)
is
   cursor head (c_bh_id xlbb_pem_inv_batch_header.bh_id%type)
   is
   select * 
   from xlbb_pem_inv_batch_header
   where bh_id = c_bh_id;
   
   cursor c_item_head(c_bh_id xlbb_pem_inv_batch_header.bh_id%type)
   is
   select * 
   from xlbb_pem_inv_invoice_header 
   where ih_bh_id = c_bh_id;
   
   cursor c_items(c_ih_id xlbb_pem_inv_invoice_header.ih_id%type)
   is
   select * 
   from xlbb_pem_inv_invoice_item  
   where ii_ih_id = c_ih_id;

   cursor c_text(c_ii_id xlbb_pem_inv_invoice_item.ii_id%type)
   is
   select * 
   from xlbb_pem_inv_item_text    
   where it_ii_id = c_ii_id;
   
   l_bh_rec xlbb_pem_inv_batch_header%rowtype;
   
   lines nm3type.tab_varchar2000;
   line_count number;
   
   FILE_ID utl_file.file_type;
   
   procedure add(pi_text varchar2
                ,pi_pipe boolean DEFAULT true)
   is
   begin 
      
      lines(line_count) := lines(line_count) || pi_text;
      if pi_pipe
       then 
         lines(line_count) := lines(line_count) || '|';
      END IF;
   end add;
   
   procedure inc_count
   is
   begin 
      line_count := line_count + 1;
      lines(line_count) := null;
   end inc_count;
   
begin 
   line_count := 1;
   LINES(LINE_COUNT) := NULL;
   

   open head(pi_bh_id);
   fetch head into l_bh_rec;
   close HEAD;
   
   add(l_bh_rec.BH_rec_type);
   add(l_bh_rec.bh_num_invoices);
   add(l_bh_rec.bh_num_invoice_items, false);
   
   inc_count;
      
   for c_ih_rec in c_item_head(pi_bh_id)
    loop
      add(c_ih_rec.ih_rec_type);
      add(c_ih_rec.ih_order_type);
      add(c_ih_rec.ih_sales_org);
      add(c_ih_rec.ih_distrib_channel);
      add(c_ih_rec.ih_division);
      add(c_ih_rec.ih_sales_office);
      add(c_ih_rec.ih_sales_group);
      add(c_ih_rec.ih_name);
      add(c_ih_rec.ih_sold_to_cust);
      add(c_ih_rec.ih_ot_cust_name);
      add(c_ih_rec.ih_ot_street2);
      add(c_ih_rec.ih_ot_street); 
      add(c_ih_rec.ih_ot_postcode); 
      add(c_ih_rec.ih_ot_city); 
      add(c_ih_rec.ih_po_num); 
      add(c_ih_rec.ih_cust_group); 
      add(c_ih_rec.ih_services_rend_date); 
      add(c_ih_rec.ih_billing_date); 
      add(c_ih_rec.ih_payment_method); 
      add(c_ih_rec.ih_tax_class); 
      add(c_ih_rec.ih_ship_to_party); 
      add(c_ih_rec.ih_bill_to_party); 
      add(c_ih_rec.ih_payer,false);
      inc_count;
      for c_ii_rec in c_items(c_ih_rec.ih_id)
       loop
         add(c_ii_rec.ii_rec_type); 
         add(c_ii_rec.ii_mat_code); 
         add(c_ii_rec.ii_description); 
         add(c_ii_rec.ii_quantity); 
         add(c_ii_rec.ii_profit_centre); 
         add(c_ii_rec.ii_amount); 
         add(c_ii_rec.ii_service_rend_date); 
         add(c_ii_rec.ii_po_number,false);        
         inc_count;
         for c_text_rec in c_text(c_ii_rec.ii_id)
          loop
            add(c_text_rec.it_rec_type);
            add(c_text_rec.it_text, false);
            inc_count;
         end loop;
      end loop;
      
   end loop;

   file_id := nm3file.fopen(location => hig.get_user_or_sys_opt('INTERPATH')
                            ,filename => l_bh_rec.bh_filename 
                            ,open_mode => 'a'
                            );
                
   for I in 1..lines.count -1
    loop
       NM3FILE.put_line(file_id,lines(i));
   end loop;            
   
   -- write the footer line
   nm3file.put_line(file_id,l_bh_rec.bh_trailer_rec_type);
   nm3file.fclose(file_id);

end write_file_out;
--
-----------------------------------------------------------------------------
--
procedure upd_ddc_notes(pi_ddg_id doc_damage_costs.ddc_ddg_id%type
                       ,pi_ddc_id doc_damage_costs.ddc_id%type
                       ,pi_notes doc_damage_costs.ddc_notes%type
                       )
is
   pragma autonomous_transaction;
begin
   update doc_damage_costs
   set ddc_notes = pi_notes
   where ddc_ddg_id = pi_ddg_id
     and ddc_id = pi_ddc_id
     and ddc_notes is null;
     
   commit;
end upd_ddc_notes;                               
--
-----------------------------------------------------------------------------
--
procedure upd_doc_status(pi_doc_id docs.doc_id%type
                        ,pi_new_status docs.doc_status_code%type
                       )
is
   pragma autonomous_transaction;
begin
   update docs
   set doc_status_code = pi_new_status
   where doc_id = pi_doc_id;
     
   commit;
end upd_doc_status;                     
--
-----------------------------------------------------------------------------
--

function create_extract_file 
return varchar2
is
   cursor c_extract 
   is
   select distinct doc_id
   from docs
       ,doc_damage
       ,doc_damage_costs
   where doc_id = ddg_doc_id
     and ddg_id = ddc_ddg_id
     and doc_status_code = g_extract_status_code
     and ddc_notes is null;
     
   cursor c_line_total(c_doc_id docs.doc_id%type)
   is   
   SELECT   ddg_id, SUM (ddc_cost) total_damage_cost
     FROM doc_damage, doc_damage_costs
    WHERE ddg_id = ddc_ddg_id
      AND ddg_doc_id = c_doc_id
      AND ddc_notes IS NULL
   GROUP BY ddg_id;
   
   cursor c_text(c_ddg_id doc_damage.ddg_id%type)
   is
   select * 
   from doc_damage_costs
   where ddc_ddg_id = c_ddg_id; 
     
   l_bh_rec xlbb_pem_inv_batch_header%rowtype;
   l_ih_rec xlbb_pem_inv_invoice_header%rowtype;
   l_ii_rec xlbb_pem_inv_invoice_item%rowtype;
   l_it_rec xlbb_pem_inv_item_text%rowtype;
   
   L_INV_CNT NUMBER;
   L_ITEM_CNT NUMBER;
   
   PROCEDURE INC_INV_CNT
   IS
   BEGIN 
      L_INV_CNT := L_INV_CNT + 1;
   END INC_INV_CNT;
   
   PROCEDURE INC_ITEM_CNT
   IS
   BEGIN 
      L_ITEM_CNT := L_ITEM_CNT + 1;
   END INC_ITEM_CNT;   
     
begin
   L_INV_CNT := 0;
   L_ITEM_CNT := 0;


   l_bh_rec := ins_bh(pi_bh_rec => l_bh_rec);
   
   
   for c_extract_rec in c_extract 
    loop   
       l_ih_rec  := create_ih_rec(pi_bh_id => l_bh_rec.bh_id
                                 ,pi_doc_id => c_extract_rec.doc_id);
                                 
       l_ih_rec  := ins_ih(pi_ih_rec => l_ih_rec);
       INC_INV_CNT;
       for c_total_rec in c_line_total(c_extract_rec.doc_id)
        loop
           l_ii_rec := create_ii_rec(pi_ih_id => l_ih_rec.ih_id
                                    ,pi_doc_id => c_extract_rec.doc_id
                                    ,pi_line_total => c_total_rec.total_damage_cost
                                    );
           l_ii_rec := ins_ii(pi_ii_rec => l_ii_rec);
           INC_ITEM_CNT;
           
           for text_rec in c_text(c_total_rec.ddg_id)
            loop
              l_it_rec.it_ii_id := l_ii_rec.ii_id;
              l_it_rec.it_text  := text_rec.ddC_type || ' '  || to_char(text_rec.ddc_cost,'99999.00') ; -- doc_damage_costs
              l_it_rec := ins_it(pi_it_rec => l_it_rec);
              
              upd_ddc_notes(pi_ddg_id => c_total_rec.ddg_id
                           ,pi_ddc_id => text_rec.ddc_id
                           ,pi_notes  => g_extracted);
           end loop;
       end loop;                       
       upd_doc_status(pi_doc_id => c_extract_rec.doc_id
                     ,pi_new_status => g_inv_requested
                     );                        
   end loop;
   
   upd_bh_num_invoices(PI_BH_ID => l_bh_rec.bh_id, PI_BH_NUM_INVOICES => L_INV_CNT );
   upd_bh_num_invoice_items(PI_BH_ID => l_bh_rec.bh_id, PI_BH_NUM_INVOICES => L_ITEM_CNT);
   
   write_file_out(pi_bh_id => l_bh_rec.bh_id);
   
   return l_bh_rec.bh_filename;
   
end create_extract_file;
--
-----------------------------------------------------------------------------
--
function get_list_of_files 
return nm3file.file_list
is
   cursor c_filenames
   is
   select stp_filename
   from xlbb_sap_to_pem;

   
   l_filelist nm3file.file_list;
   l_processed_files nm3file.file_list;
   l_files_to_process nm3file.file_list;
   
   l_cnt number;
begin 
   -- fetch all the filenames already processed
   open c_filenames;
   fetch c_filenames bulk collect into l_filelist;
   close c_filenames;
   
   -- build a list of files processed indexed by the filename
   l_processed_files.delete;
   for i in 1..l_filelist.count
    loop
       l_processed_files(l_filelist(i)) := l_filelist(i);
   end loop;

   -- get a list of files in directory
   l_filelist.delete;
   l_filelist := nm3file.get_files_in_directory(pi_dir => g_interpath,pi_extension => 'txt');
   
   -- build a list of files that havn't been processed
   l_cnt := 1;
   for i in 1..l_filelist.count 
    loop
      if l_filelist(i) != l_processed_files(l_filelist(i))
       and
         substr(l_filelist(i),1,14) = g_input_filename
       then 
          l_files_to_process(l_cnt) := l_filelist(i);
      end if;
   end loop;
   
   return l_files_to_process;
end get_list_of_files;
--
-----------------------------------------------------------------------------
--
procedure load_files
is
   l_filelist nm3file.file_list;
   
   l_stp_rec xlbb_sap_to_pem%rowtype;
   
   l_file utl_file.file_type;
   
   all_lines nm3type.tab_varchar32767;

   pragma autonomous_transaction;
    
begin
   l_filelist := get_list_of_files;
   
   for i in 1..l_filelist.count
    loop
       l_stp_rec.stp_id := GET_xlbb_stp_id_seq;
       l_stp_rec.stp_loaded_date := sysdate;
       l_stp_rec.stp_loaded_by := user;
       l_stp_rec.stp_filename := l_filelist(i);
       
       nm3file.get_file(location => g_interpath
                       ,filename => l_filelist(i)
                       ,all_lines => all_lines);
       
       for j in 1..all_lines.count
        loop
           l_stp_rec.stp_line_id := j;
           l_stp_rec.stp_line := all_lines(i);
           l_stp_rec.stp_loaded_yn := 'N';
           
           insert into xlbb_sap_to_pem
           values 
              l_stp_rec;
            
       end loop;
       commit;                                              
   end loop;
    
end load_files;
--
-----------------------------------------------------------------------------
--
function get_line_parts(pi_str varchar2)
return nm3type.tab_varchar30
is
 item nm3type.tab_varchar30;
 cnt number;
begin 

  cnt := 1;
  item(cnt) := null;
  for i in 1..length(pi_str)
   loop
     if substr(pi_str,i,1) != '|'
      then 
        item(cnt) := item(cnt) || substr(pi_str,i,1);
     elsif substr(pi_str,i,1) = '|'
      then 
        cnt := cnt + 1;
        item(cnt) := null;
     end if; 
  end loop;

   return item;
end get_line_parts;   
--
-----------------------------------------------------------------------------
--
procedure update_pem_from_sap
is
   cursor c_lines
   is
   select stp_line
   from xlbb_sap_to_pem
   where stp_loaded_YN = 'N';
   
   l_items nm3type.tab_varchar30;
   l_new_status docs.doc_status_code%type;
   
begin 
   load_files;

   for line_rec in c_lines
    loop
      l_ITEMS := GET_LINE_PARTS(LINE_REC.STP_LINE);

      IF upper(l_items(3)) = 'INVOICE REQUESTED'
       then 
         l_new_status := g_inv_requested;
      elsif upper(l_items(3)) = 'INVOICE SENT'
       then 
         l_new_status := g_inv_sent;
      elsif upper(l_items(3)) = 'INVOICE PAID'
       then 
         l_new_status := g_inv_paid;       
      end if;      
      update docs 
      set doc_status_code = l_new_status
       ,doc_reference_code = l_items(2)
      where doc_id = l_items(4);              
   end loop;   
end update_pem_from_sap;
--
-----------------------------------------------------------------------------
--
END xlbb_pem_invoice;
/
