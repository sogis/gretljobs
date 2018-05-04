SELECT 
    geometer_gemeinde.gem_bfs,
    nfgeometer.vorname, 
    nfgeometer.name,
    btrim(nfgeometer.firma::text) AS firma, 
    btrim(nfgeometer.firma_zusatz::text) AS firma_zusatz, 
    btrim(nfgeometer.strasse::text) AS strasse, 
    btrim(nfgeometer.hausnummer::text) AS hausnr, 
    nfgeometer.plz, 
    btrim(nfgeometer.ortschaft::text) AS ortschaft, 
    btrim(nfgeometer.telefon::text) AS telefon, 
    btrim(nfgeometer.fax::text) AS fax, 
    btrim(nfgeometer.email::text) AS email, 
    btrim(nfgeometer.web::text) AS web
FROM 
    av_nfgeometer.nfgeometer , 
    av_nfgeometer.geometer_gemeinde
WHERE 
    nfgeometer.ogc_fid = geometer_gemeinde.nfgeometer_id
;