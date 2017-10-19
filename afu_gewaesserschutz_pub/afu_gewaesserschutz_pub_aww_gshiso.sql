SELECT 
	ogc_fid,
	wkb_geometry,
	kurventyp,
	bearbeiter,
	kote
FROM
	public.aww_gshiso
WHERE
	"archive" = 0