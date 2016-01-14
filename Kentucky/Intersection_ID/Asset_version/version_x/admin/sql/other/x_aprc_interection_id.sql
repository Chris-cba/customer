DROP SEQUENCE x_aprc_interection_id;

CREATE SEQUENCE x_aprc_interection_id
  START WITH 0
  MAXVALUE 999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE OR REPLACE PUBLIC SYNONYM x_aprc_interection_id FOR x_aprc_interection_id;