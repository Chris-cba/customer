CREATE OR REPLACE PROCEDURE HIGHWAYS.x_colas_financials_extract ( pi_extractdir   IN VARCHAR2
                                                       , pi_higftptype   IN VARCHAR2)
IS
    --
BEGIN
    --
    -- Extract data to directory
    nsg_org_csv;
    --
    tma_phases_csv;
    --
    tma_works_csv;
    --
    tma_streets_csv;
    --
    -- FTP contents of directory
    do_ftp_from_os(pi_extractdir, '*.csv', pi_higftptype);
    --
END x_colas_financials_extract;
/

