SELECT
	gid,
	ogc_fid,
	typ,
	herkunft,
	the_geom_1,
	tunnel,
	the_geom
FROM
	sorkas.avt_oev_netz
WHERE
	"archive" = 0