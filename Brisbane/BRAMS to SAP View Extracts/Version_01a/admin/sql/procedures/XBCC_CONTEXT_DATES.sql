create or replace procedure XBCC_CONTEXT_DATES ( pname  VARCHAR2, pvalue VARCHAR2) IS
	BEGIN
	  -- Create a session with a previously defined context.
	  DBMS_SESSION.SET_CONTEXT('XBCC_DATES',pname,pvalue);
END XBCC_CONTEXT_DATES;
/

CREATE OR REPLACE CONTEXT XBCC_DATES USING XBCC_CONTEXT_DATES;