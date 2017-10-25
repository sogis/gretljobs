SELECT
	ogc_fid AS t_id,
	wkb_geometry AS geometrie,
	symbol,
	bearbeitun,
	bearbeiter
FROM
	public.aww_gshora
WHERE
	"archive" = 0