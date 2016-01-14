/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: Create_Roles.sql
	Author: JMM
	UPDATE01:	Original, 2014.12.03, JMM
*/

Insert Into NM_INV_TYPE_ROLES (ITR_INV_TYPE, ITR_HRO_ROLE, ITR_MODE) Values ('RSD', 'HIG_USER', 'NORMAL');
Insert Into NM_INV_TYPE_ROLES (ITR_INV_TYPE, ITR_HRO_ROLE, ITR_MODE) Values ('RSAM', 'HIG_USER', 'NORMAL');
Insert Into NM_INV_TYPE_ROLES (ITR_INV_TYPE, ITR_HRO_ROLE, ITR_MODE) Values ('RSDE', 'HIG_USER', 'NORMAL');
Insert Into NM_INV_TYPE_ROLES (ITR_INV_TYPE, ITR_HRO_ROLE, ITR_MODE) Values ('RSIC', 'HIG_USER', 'NORMAL');
Insert Into NM_INV_TYPE_ROLES (ITR_INV_TYPE, ITR_HRO_ROLE, ITR_MODE) Values ('RSIN', 'HIG_USER', 'NORMAL');
Insert Into NM_INV_TYPE_ROLES (ITR_INV_TYPE, ITR_HRO_ROLE, ITR_MODE) Values ('RSRE', 'HIG_USER', 'NORMAL');


Commit;

