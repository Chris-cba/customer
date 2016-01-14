create or replace procedure XRMS_CONTEXT_RPT_DATES ( pname  VARCHAR2, pvalue VARCHAR2) IS
	BEGIN
	  -- Create a session with a previously defined context.
	  DBMS_SESSION.SET_CONTEXT('XRMS_DATES',pname,pvalue);
END XRMS_CONTEXT_RPT_DATES;

CREATE OR REPLACE CONTEXT XRMS_DATES USING XRMS_CONTEXT_RPT_DATES;