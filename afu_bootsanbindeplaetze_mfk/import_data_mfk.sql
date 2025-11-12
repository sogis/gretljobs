DROP TABLE IF EXISTS data_mfk;

--- Create Table for intersecting objects --- 
CREATE TABLE data_mfk AS 
	SELECT
		*
	FROM
		ST_READ(${mfkPath}, open_options=['EMPTY_STRING_AS_NULL=YES']);