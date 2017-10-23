SELECT
	ogc_fid,
	wkb_geometry,
	didook,
	haltestell,
	gemeinde,
	point_x,
	point_y
FROM 
	public.avt_oev_haltestellen_ausserkantonal
WHERE
	"archive" = 0;