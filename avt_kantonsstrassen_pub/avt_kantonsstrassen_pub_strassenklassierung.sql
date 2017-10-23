SELECT 
	ogc_fid,
	ST_Multi(wkb_geometry) AS wkb_geometry,
	ck,
	cko_owner,
	pos_code,
	baseid,
	klassierun
FROM
	public.avt_strassenklassierung
WHERE
	"archive" = 0