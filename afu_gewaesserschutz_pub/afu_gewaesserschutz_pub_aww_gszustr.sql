SELECT
	ogc_fid,
	wkb_geometry,
	"name",
	im_kanton,
	typ
FROM
	public.aww_gszustr
WHERE
	"archive" = 0