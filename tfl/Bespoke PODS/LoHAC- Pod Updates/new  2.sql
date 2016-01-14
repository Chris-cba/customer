HIG_AUDITS
work_order_Lines
defects
repairs
imf_net_network_members
	nm_members_all
	imf_net_network_all
		nm_elements_all
		nm_admin_units_all
works_orders



ANALYZE TABLE HIG_AUDITS COMPUTE STATISTICS;
ANALYZE TABLE work_order_Lines COMPUTE STATISTICS;
ANALYZE TABLE defects COMPUTE STATISTICS;
ANALYZE TABLE repairs COMPUTE STATISTICS;
ANALYZE TABLE nm_members_all COMPUTE STATISTICS;
ANALYZE TABLE nm_elements_all COMPUTE STATISTICS;
ANALYZE TABLE nm_admin_units_all COMPUTE STATISTICS;
ANALYZE TABLE works_orders COMPUTE STATISTICS;



create index z_idx_IM_POD_CR_ID_U_SN on IM_POD_CHART_RESULTS(IPCR_POD_ID, IPCR_USERNAME, IPCR_SERIES_NAME);

                     create index zIM_tab_names on im_user_pods(IUP_IP_ID, IUP_IT_ID, IUP_HUS_USERNAME);
                     
                     create index zIM_tabs_tab_names on im_tabs(IT_PAGE_ID);