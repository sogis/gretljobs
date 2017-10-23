SELECT
	ogc_fid,
	ST_Multi(wkb_geometry) AS wkb_geometry,
	typ,
	herkunft
FROM
	public.avt_oev_netz
WHERE
	"archive" = 0