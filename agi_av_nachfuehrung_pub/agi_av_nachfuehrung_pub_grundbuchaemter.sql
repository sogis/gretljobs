SELECT
    kreis.gem_bfs,
    amt.amtschreiberei, 
    amt.amt, 
    amt.strasse, 
    amt.hausnummer, 
    amt.plz, 
    amt.ortschaft, 
    amt.telefon, 
    amt.web, 
    amt.email
FROM 
    av_grundbuch.grundbuchkreise kreis, 
    av_grundbuch.grundbuchamt amt
WHERE 
    amt.ogc_fid = kreis.grundbuchamt_id
;