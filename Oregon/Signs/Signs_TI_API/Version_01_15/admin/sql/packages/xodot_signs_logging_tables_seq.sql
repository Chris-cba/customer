--drop table xsign_except;
--drop table reports.xsign_status;

/* ************************************************************
	Object:		reports.xsign_except, REPORTS.XSIGN_STATUS
	Purpose:	These are the tables used to store issues and logging counts on activity by the Signs Broker.
	Notes:		
	Created:	2015.06.08	J.Mendoza
************************************************************* */

Create table reports.xsign_except (
	SYNC_DATE			date
	,session_id			number
	,TI_USERNAME		varchar2(20)
	,OS_HOST			varchar2(32)
	,OS_USERNAME		varchar2(20)
	,NE_ID				varchar2(10)
	,INSTALLATION_ID	varchar2(10)
	,STATEHWY			varchar2(10)
	,MP					number
	,ERROR_TYPE			varchar2(20)
	,SYNC_ERROR			varchar2(2000)
);


Create table REPORTS.XSIGN_STATUS  (
	SYNC_DATE			date
	,TI_USERNAME		varchar2(20)
	,OS_HOST			varchar2(32)
	,OS_USERNAME		varchar2(20)
	,SFA_CNT			number
	,SFA_EXP			number
	,TI_CNT				number
	,TI_EXCP			number
	,LOV_CNT			number
	,LOV_EXP			number
	,MP100_CNT			number
	,MP100_EXP			number
);