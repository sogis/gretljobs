WITH 
    firma_zusatz AS (
        SELECT 
            concat(btrim(vorname), ' ', btrim(name)) AS nfgeometer,
            CASE
                WHEN firma_zusatz IS NOT NULL 
                    THEN concat(btrim(firma_zusatz), ', ')
                ELSE ''
            END AS firma_zusatz,
            concat(btrim(firma)) AS firma,
            concat(btrim(strasse), ' ', btrim(hausnummer::text)) AS strasse,
            concat(plz, ' ', btrim(ortschaft)) AS ort,
            concat('Tel.: ', btrim(telefon)) AS tel,
            concat('Fax: ', btrim(fax)) AS fax,
            concat('E-Mail: ', btrim(email)) AS email,
            concat('Web: ', btrim(web)) AS web,
            gem_bfs
        FROM av_nfgeometer.nfgeometer
            RIGHT JOIN av_nfgeometer.geometer_gemeinde
                ON geometer_gemeinde.nfgeometer_id = nfgeometer.ogc_fid
    ),
    
    firma AS (
        SELECT
            nfgeometer,
            firma,
            concat(firma, ', ', firma_zusatz, strasse, ', ', ort) AS adresse,
            concat(tel, ', ', fax, ', ' , email, ', ' , web) AS kontakt,
            strasse,
            ort,
            tel,
            fax,
            email,
            web,
            gem_bfs
        FROM 
            firma_zusatz
    ),
    
    grundbuchkreise_anzahl AS (
        SELECT 
            count(*) AS anz, 
            grundbuchkreise.gem_bfs
        FROM 
            av_grundbuch.grundbuchkreise
        GROUP BY 
            grundbuchkreise.gem_bfs
    ),
    
    gemeinde AS ( 
        SELECT 
            DISTINCT ON (gemeindegrenzen_gemeinde.gem_bfs) 
            gemeindegrenzen_gemeinde.gem_bfs, 
            to_char(gemeindegrenzen_gemeinde.lieferdatum, 'DD.MM.YYYY') AS lieferdatum
        FROM 
            av_avdpool_ng.gemeindegrenzen_gemeinde
        ORDER BY 
            gemeindegrenzen_gemeinde.gem_bfs
    )

SELECT 
    firma.gem_bfs, 
    grundbuchkreise.wkb_geometry AS geometrie, 
    CASE
        WHEN grundbuchkreise_anzahl.anz = 1 
            THEN concat('Gemeinde ', btrim(grundbuchkreise.gemeinde))
        ELSE concat('Gemeinde ', btrim(grundbuchkreise.gemeinde), ' (', btrim(grundbuchkreise.grundbuch),  ')')
    END AS gemeinde, 
    gemeinde.lieferdatum, 
    firma.nfgeometer, 
    firma.adresse AS anschrift,
    firma.kontakt,
    grundbuchkreise.gemeinde AS gemeinde_name, 
    grundbuchkreise.grundbuch AS grundbuch_name, 
    firma.firma, 
    firma.strasse AS strasse_nummer, 
    firma.ort AS plz_ortschaft, 
    firma.tel, 
    firma.fax, 
    firma.email, 
    firma.web
FROM 
    av_grundbuch.grundbuchkreise
    LEFT JOIN grundbuchkreise_anzahl
        ON grundbuchkreise_anzahl.gem_bfs = grundbuchkreise.gem_bfs
    LEFT JOIN gemeinde
        ON gemeinde.gem_bfs = grundbuchkreise.gem_bfs
    LEFT JOIN firma
        ON firma.gem_bfs = gemeinde.gem_bfs
;


