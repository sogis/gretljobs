SELECT
	ogc_fid,
	wkb_geometry,
	haltest_id,
	haltestell,
	nr_tu,
	anzahl_hs,
	didok,
	verkehrsmittel
FROM
	public.avt_oev_haltestellen
WHERE
	"archive" = 0;