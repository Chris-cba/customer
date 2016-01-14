/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: exor_to_aa_uninstall_sys.sql
	Author: JMM
	UPDATE01:	Original, 2014.01.16, JMM
*/

drop user exor_to_aa CASCADE;

drop tablespace tbs_exor_to_aa
	INCLUDING CONTENTS 
	AND DATAFILES
	CASCADE CONSTRAINTS
;