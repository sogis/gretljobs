SELECT gewisso.ogc_fid, ST_FORCE_2D(gewisso.wkb_geometry) as wkb_geometry, gewisso.dh_gew, gewisso.hauptgnr, 
    gewisso.nebengnr, gewisso.gewissnr, gewisso.abschnitt, gewisso.gnrso, 
    gewisso.meas_unten, gewisso.meas_oben, gewisso.name, gewisso.typ, 
    gewisso.groesse, gewisso.gemeinde, gewisso.gem2, gewisso.qualitaet, 
    gewisso.privat, gewisso.vorf_gewis, gewisso.vorf_neben, gewisso.dh_km, 
    gewisso.strahler, gewisso.groesse * 3 + 10 AS schriftgroesse
FROM gewisso.gewisso
WHERE archive = 0;
