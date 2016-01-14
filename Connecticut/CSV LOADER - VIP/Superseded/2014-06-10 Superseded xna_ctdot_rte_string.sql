CREATE OR REPLACE FUNCTION xna_ctdot_rte_string(
	p_road_unique IN VARCHAR2
	, p_route_suffix IN VARCHAR2 DEFAULT NULL
	, p_route_dir IN VARCHAR2 DEFAULT NULL)
RETURN VARCHAR2 IS

t_return		VARCHAR2(30);
t_road_unique		VARCHAR2(20);
t_route_suffix		VARCHAR2(10);
t_route_dir		VARCHAR2(10);
t_route			VARCHAR2(40);

BEGIN
	t_road_unique		:= p_road_unique;
	t_route_suffix		:= p_route_suffix;
	t_route_dir		:= p_route_dir;
	
	IF nvl(t_route_dir,'-x') <> '-x' THEN
		t_route_dir		:= substr(t_route_dir,1,1);
	ELSE
		IF mod(to_number(t_road_unique),2) = 0 THEN
			t_route_dir	:= 'E';
		ELSE
			t_route_dir	:= 'N';
		END IF;
	END IF;

	t_route		:= trim(t_road_unique) || trim(t_route_suffix) || '-' || trim(t_route_dir);

	t_return	:= t_route;

	RETURN t_return;

EXCEPTION WHEN OTHERS THEN
	RETURN NULL;
END;
