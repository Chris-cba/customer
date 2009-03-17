CREATE OR REPLACE TRIGGER nm_node_points_instead_trg 
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/rta/716658/nm_node_points_instead_trg.trg-arc   1.0   Mar 17 2009 16:21:46   cstrettle  $
--       Module Name      : $Workfile:   nm_node_points_instead_trg.trg  $
--       Date into PVCS   : $Date:   Mar 17 2009 16:21:46  $
--       Date fetched Out : $Modtime:   Mar 17 2009 16:12:16  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--
INSTEAD OF
INSERT OR UPDATE OR DELETE 
ON nm_node_points FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--
   l_rec_no  nm_nodes_all%ROWTYPE;
   l_rec_np  nm_points%ROWTYPE;
--
BEGIN
--
  IF INSERTING 
  THEN
--
  l_rec_np.np_id := nm3net.create_point( pi_np_grid_east  => :NEW.np_grid_east
                                       , pi_np_grid_north => :NEW.np_grid_north);
--
  l_rec_no.no_node_id    := NVL(:NEW.no_node_id,nm3seq.next_no_node_id_seq);        
  l_rec_no.no_node_name  := :NEW.no_node_name;      
  l_rec_no.no_start_date := :NEW.no_start_date;         
  l_rec_no.no_end_date   := :NEW.no_end_date;     
  l_rec_no.no_np_id      :=  l_rec_np.np_id;
  l_rec_no.no_descr      := :NEW.no_descr;  
  l_rec_no.no_node_type  := :NEW.no_node_type;      
  l_rec_no.no_purpose    := :NEW.no_purpose;    
--
  NM3INS.INS_NO_ALL ( l_rec_no );
--
  ELSIF UPDATING
  THEN
  UPDATE nm_nodes_all
     SET no_node_name  = :NEW.no_node_name      
       , no_start_date = :NEW.no_start_date         
       , no_end_date   = :NEW.no_end_date     
       , no_descr      = :NEW.no_descr  
       , no_node_type  = :NEW.no_node_type      
       , no_purpose    = :NEW.no_purpose
   WHERE no_node_id    = :NEW.no_node_id;
--      
  UPDATE nm_points
     SET NP_GRID_EAST   = :NEW.NP_GRID_EAST
       , NP_GRID_NORTH  = :NEW.NP_GRID_NORTH
   WHERE NP_ID          = :NEW.NO_NP_ID;
--       
  ELSIF DELETING
  THEN
    NULL;    
  END IF;
END;
/
