SELECT 
	aww_gsab.ogc_fid, 
	aww_gsab.wkb_geometry, 
	aww_gsab.erf_datum, 
    aww_gsab.zone, 
    aww_gsab.erfasser, 
    aww_gsab.symbol
FROM 
	aww_gsab
WHERE 
	aww_gsab.archive = 0;