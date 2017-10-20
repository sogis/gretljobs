SELECT 
	ogc_fid,
	st_multi(wkb_geometry) AS wkb_geometry,
	sz,
	kanton,
	status
FROM
	public.aww_gszoak
WHERE
	"archive" = 0;