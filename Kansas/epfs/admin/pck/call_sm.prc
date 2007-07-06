procedure  call_non_inter_map( pi_assesment_id number
                              ,pi_county number
                             )
is
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/Kanzas/epfs/admin/pck/call_sm.prc-arc   2.0   Jul 06 2007 14:07:16   Ian Turnbull  $
--       Module Name      : $Workfile:   call_sm.prc  $
--       Date into SCCS   : $Date:   Jul 06 2007 14:07:16  $
--       Date fetched Out : $Modtime:   Jul 06 2007 13:10:32  $
--       SCCS Version     : $Revision:   2.0  $
  l_username varchar2(80) := GET_APPLICATION_PROPERTY(USERNAME);
  l_password varchar2(80) := GET_APPLICATION_PROPERTY(PASSWORD);
  l_instance varchar2(80) := GET_APPLICATION_PROPERTY(CONNECT_STRING);

  l_exe_str varchar2(500);

begin

   l_exe_str := x_kansas_epfs.GET_NONINTER_CMD(pi_username => l_username
                                              ,pi_password => l_password
                                              ,pi_instance => l_instance
                                              ,pi_assessment_id => pi_assessment_id
                                              ,pi_county =>  pi_county
                                              );

	client_host ( l_exe_str );

end call_non_inter_map;     