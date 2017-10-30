SELECT 
	ogc_fid AS t_id,
	wkb_geometry AS geometrie,
	kurventyp,
	bearbeiter,
	kote
FROM
	public.aww_gshiso
WHERE
	"archive" = 0