CREATE OR REPLACE package xhants_def_status as

type defects is table of number
index by binary_integer;

tab_defects defects;

procedure clear_defects;

procedure process_defects;

procedure update_def_status (p_def_id number);


end xhants_def_status;
/

