SELECT
	ogc_fid AS t_id,
	wkb_geometry AS geometrie,
	"name",
	im_kanton,
	typ
FROM
	public.aww_gszustr
WHERE
	archive = 0
;