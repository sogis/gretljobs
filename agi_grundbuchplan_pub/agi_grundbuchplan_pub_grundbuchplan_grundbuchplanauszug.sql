WITH 
    firma_zusatz AS (
        SELECT 
            concat(btrim(nfg_vorname), ' ', btrim(nfg_name)) AS nfgeometer,
            CASE
                WHEN firma_zusatz IS NOT NULL 
                    THEN concat(btrim(firma_zusatz), ', ')
                ELSE ''
            END AS firma_zusatz,
            concat(btrim(firma)) AS firma,
            concat(btrim(strasse), ' ', btrim(hausnummer::text)) AS strasse,
            concat(plz, ' ', btrim(ortschaft)) AS ort,
            concat('Tel.: ', btrim(telefon)) AS tel,
            concat('Fax: ', ''::text) AS fax,
            concat('E-Mail: ', btrim(email)) AS email,
            concat('Web: ', btrim(web)) AS web,
            bfsnr AS gem_bfs
        FROM agi_av_gb_admin_einteilung_pub.nachfuehrngskrise_gemeinde as nfg
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
            bfsnr AS gem_bfs
        FROM 
            agi_av_gb_admin_einteilung_pub.grundbuchkreise_grundbuchkreis as gg
        GROUP BY 
            bfsnr
    ),

    gemeinde AS ( 
        SELECT 
            DISTINCT ON (bfs_nr) 
            bfs_nr AS gem_bfs, 
            gemeindename,
--            to_char(importdatum, 'DD.MM.YYYY') AS lieferdatum
-- Korrektur 05.12.2019, sc
            to_char(importdatum::Date, 'DD.MM.YYYY') AS lieferdatum
--            importdatum AS lieferdatum
        FROM 
            agi_mopublic_pub.mopublic_gemeindegrenze
        ORDER BY 
            bfs_nr
    )    
SELECT 
    firma.gem_bfs, 
    grundbuchkreise.perimeter AS geometrie, 
    CASE
        WHEN grundbuchkreise_anzahl.anz = 1 
            THEN concat('Gemeinde ', btrim(gemeinde.gemeindename))
        ELSE concat('Gemeinde ', btrim(gemeinde.gemeindename), ' (', btrim(grundbuchkreise.aname),  ')')
    END AS gemeinde, 
    gemeinde.lieferdatum, 
    firma.nfgeometer, 
    firma.adresse AS anschrift,
    firma.kontakt,
    gemeinde.gemeindename AS gemeinde_name, 
    grundbuchkreise.aname AS grundbuch_name, 
    firma.firma, 
    firma.strasse AS strasse_nummer, 
    firma.ort AS plz_ortschaft, 
    firma.tel, 
    firma.fax, 
    firma.email, 
    firma.web
FROM 
    agi_av_gb_admin_einteilung_pub.grundbuchkreise_grundbuchkreis AS grundbuchkreise
    LEFT JOIN grundbuchkreise_anzahl
        ON grundbuchkreise_anzahl.gem_bfs = grundbuchkreise.bfsnr
    LEFT JOIN gemeinde
        ON gemeinde.gem_bfs = grundbuchkreise.bfsnr
    LEFT JOIN firma
        ON firma.gem_bfs = gemeinde.gem_bfs
;

