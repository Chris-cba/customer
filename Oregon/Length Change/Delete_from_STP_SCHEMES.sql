delete from STP_SCHEME_JOBS_ALL where SSJ_SS_ID in (select SS_ID from STP_SCHEMES);
delete from STP_SCHEME_LOCATIONS_ALL Where SSL_SS_ID in (Select SS_ID from STP_SCHEMES);

Commit;

delete from STP_SCHEMES;

Commit;