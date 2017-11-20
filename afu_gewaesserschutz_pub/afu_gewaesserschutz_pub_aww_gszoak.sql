SELECT 
	ogc_fid AS t_id,
	ST_Multi(wkb_geometry) AS geometrie,
	sz,
	kanton,
	status
FROM
	public.aww_gszoak
WHERE
	archive = 0
;