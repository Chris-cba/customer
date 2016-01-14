
delete from HIG_STANDARD_FAVOURITES where HSTF_CHILD =  'MERGE_EX';
delete from HIG_MODULES where HMO_MODULE = 'MERGE_EX';

delete from hig_module_roles WHERE HMR_MODULE = 'MERGE_EX';

drop package XOR_merge_extract;