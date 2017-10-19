SELECT
	ogc_fid,
	wkb_geometry,
	symbol,
	bearbeitun,
	bearbeiter
FROM
	public.aww_gshora
WHERE
	"archive" = 0