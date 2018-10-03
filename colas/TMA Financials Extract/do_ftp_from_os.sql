CREATE OR REPLACE PROCEDURE HIGHWAYS.do_ftp_from_os ( pi_sendfromdir   IN VARCHAR2
										   , pi_filename      IN VARCHAR2
										   , pi_ftptype       IN VARCHAR2)
IS
	--
	l_dirpath        hig_directories.hdir_path%TYPE;
	flist            nm3file.file_list;
	couoffiles       number(9) := 0;
	--
	c_dir_sep    CONSTANT VARCHAR2(200) := hig.get_user_or_sys_opt('DIRREPSTRN');
	CURSOR get_ftp_details IS
		SELECT hfc_ftp_host         ftp_host
			 , hfc_ftp_username     ftp_username
			 , nm3ftp.get_password(hfc_ftp_password) ftp_password
			 , hfc_ftp_out_dir      ftp_out_dir
			 , hfc_ftp_port         ftp_port
		FROM   hig_ftp_connections
			 , hig_ftp_types
		WHERE  hft_type = pi_ftptype
		AND    hft_id = hfc_hft_id;
	--
BEGIN
	-- Grab path of directory we are sending from
	SELECT hdir_path INTO l_dirpath FROM hig_directories WHERE hdir_name = pi_sendfromdir;
	--
	nm3ctx.set_context('NM3FTPPASSWORD','Y');
	--
	FOR z IN get_ftp_details
	LOOP
		--
		hig_process_api.log_it ( pi_message => 'FTP moving files to '||z.ftp_host||':'||z.ftp_port||' ['||z.ftp_out_dir||'] as '||z.ftp_username, pi_summary_flag => 'Y');
		BEGIN
			--
			flist := nm3file.get_wildcard_files_in_dir (l_dirpath,pi_filename);
			--
			IF flist.COUNT > 0 THEN
				--
				FOR i IN 1 .. flist.COUNT
				LOOP
					--
					-- Check if file is not the OS thumbs on Windows
					IF flist(i) != 'Thumbs.db' THEN
						--
						DECLARE
							l_conn  UTL_TCP.connection;
						BEGIN
							l_conn := nm3ftp.login(z.ftp_host, z.ftp_port, z.ftp_username, z.ftp_password);
							nm3ftp.binary(p_conn => l_conn);
							nm3ftp.put(p_conn      => l_conn,
									   p_from_dir  => pi_sendfromdir,
									   p_from_file => flist(i),
									   p_to_file   => z.ftp_out_dir||flist(i));
							--
							hig_process_api.log_it
								( pi_message_type      => 'I'
								, pi_message           => 'FTP transferred ['||flist(i)||'] in ['||z.ftp_out_dir||'] to ['||l_dirpath||']'
								, pi_summary_flag      => 'N');
							-- Close and clear connections
							nm3ftp.logout(l_conn);
							utl_tcp.close_all_connections;
							-- Delete file from local OS
							utl_file.fremove(pi_sendfromdir, flist(i));
							-- Increment transfer counter
							couoffiles := couoffiles + 1;
							--
						EXCEPTION
							WHEN OTHERS THEN
								hig_process_api.log_it
									( pi_message_type      => 'W'
									, pi_message           => 'FTP transfer error ['||flist(i)||'] - '||SQLERRM
									, pi_summary_flag      => 'N');
						END;
						--
					END IF;
				END LOOP;
				--
				hig_process_api.log_it
					( pi_message      => 'FTP transfer finished for '||z.ftp_host||'. Transferred '||couoffiles||' file(s)'
					, pi_summary_flag => 'Y');
				--
			END IF;
			--
		EXCEPTION
			WHEN OTHERS THEN
				hig_process_api.log_it
					( pi_message_type      => 'W'
					, pi_message           => 'FTP transfer error '||SQLERRM);
		END;
	--
	END LOOP;
END do_ftp_from_os;
/

