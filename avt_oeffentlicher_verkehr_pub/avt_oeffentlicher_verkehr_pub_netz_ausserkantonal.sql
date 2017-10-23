SELECT 
	ogc_fid,
	wkb_geometry,
	objectid,
	liniennumm,
	verkehrsmi,
	verkehrs_1,
	fplnr
FROM 
	public.avt_oev_netz_ausserkantonal
WHERE
	"archive" = 0;