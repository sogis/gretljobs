WITH RECURSIVE x(ursprung, hinweis, parents, last_ursprung, depth) AS (
    SELECT
        ursprung,
        hinweis,
        ARRAY[ursprung] AS parents,
        ursprung AS last_ursprung,
        0 AS "depth"
    FROM
        arp_npl.rechtsvorschrften_hinweisweiteredokumente

    UNION ALL

    SELECT
        x.ursprung,
        x.hinweis,
        parents || rechtsvorschrften_hinweisweiteredokumente_1.hinweis,
        rechtsvorschrften_hinweisweiteredokumente_1.hinweis AS last_ursprung,
        x."depth" + 1
    FROM
        x
        INNER JOIN arp_npl.rechtsvorschrften_hinweisweiteredokumente  AS rechtsvorschrften_hinweisweiteredokumente_1
            ON last_ursprung = rechtsvorschrften_hinweisweiteredokumente_1.ursprung
    WHERE 
        rechtsvorschrften_hinweisweiteredokumente_1.hinweis IS NOT NULL
), 
doc_doc_references_all AS (
    SELECT
        ursprung,
        hinweis,
        parents,
        depth
    FROM
        x
    WHERE
        depth = (
            SELECT
                max(subquery."depth")
            FROM
                x AS subquery
            WHERE
                subquery.ursprung = x.ursprung
            )
),
doc_doc_references AS (
    SELECT
        ursprung,
        a_parents AS dok_dok_referenzen
    FROM
        (
            SELECT DISTINCT ON (a_parents)
                a.ursprung,
                a.parents AS a_parents,
                b.parents AS b_parents
            FROM
                doc_doc_references_all AS a
                LEFT JOIN doc_doc_references_all AS b
                    ON a.parents <@ b.parents AND a.parents != b.parents
        ) AS subquery
    WHERE
        b_parents IS NULL
),
json_documents_all AS (
    SELECT
        t_id,
        row_to_json(dokumente)::text AS json_dokument
    FROM
        (
            SELECT
                t_id,
                t_ili_tid,
                CASE
                    WHEN offiziellertitel IS NULL
                        THEN titel
                    ELSE offiziellertitel
                END AS titel,
                publiziertab,
                ('https://geo.so.ch/docs/ch.so.arp.zonenplaene/Zonenplaene_pdf/'||"textimweb")::text AS dateipfad,
                bemerkungen AS bemerkung
            FROM
                arp_npl.rechtsvorschrften_dokument
        ) AS dokumente
),
json_documents_doc_doc_reference AS (
    SELECT
        t_id,
        json_dokument
    FROM
        (
            SELECT
                ursprung AS dokument_t_id
            FROM 
                arp_npl.rechtsvorschrften_hinweisweiteredokumente

            UNION

            SELECT
                hinweis AS dokument_t_id
            FROM 
                arp_npl.rechtsvorschrften_hinweisweiteredokumente
        ) AS dokumente_1
        LEFT JOIN json_documents_all AS dokumente_2
            ON dokumente_1.dokument_t_id = dokumente_2.t_id
),
typ_grundnutzung_dokument_ref AS (
    SELECT DISTINCT ON (typ_grundnutzung, dok_referenz)
        typ_grundnutzung,
        dokument,
        dok_referenz
    FROM
        (
            SELECT DISTINCT
                typ_grundnutzung_dokument.typ_grundnutzung,
                dokument,
                unnest(dok_dok_referenzen) AS dok_referenz
            FROM
                arp_npl.nutzungsplanung_typ_grundnutzung_dokument AS typ_grundnutzung_dokument
                LEFT JOIN doc_doc_references
                    ON typ_grundnutzung_dokument.dokument = doc_doc_references.ursprung

            UNION

            SELECT
                typ_grundnutzung,
                dokument,
                dokument AS dok_referenz
            FROM
                arp_npl.nutzungsplanung_typ_grundnutzung_dokument
        ) AS subquery
),
typ_grundnutzung_json_dokument AS (
    SELECT
        typ_grundnutzung,
        dokument,
        dok_referenz,
        t_id,
        json_dokument
    FROM
        typ_grundnutzung_dokument_ref
        LEFT JOIN json_documents_all
            ON json_documents_all.t_id = typ_grundnutzung_dokument_ref.dok_referenz
),
typ_grundnutzung_json_dokument_agg AS (
    SELECT
        typ_grundnutzung_t_id,
        '[' || dokumente::varchar || ']' as dokumente
    FROM
        (
            SELECT
                typ_grundnutzung AS typ_grundnutzung_t_id,
                string_agg(json_dokument, ',') AS dokumente
            FROM
                typ_grundnutzung_json_dokument
            GROUP BY
                typ_grundnutzung
        ) as subquery
),
grundnutzung_geometrie_typ AS(
    SELECT
        grundnutzung.t_id,
        grundnutzung.t_datasetname::int4 AS bfs_nr,
        grundnutzung.t_ili_tid,
        grundnutzung.name_nummer,
        grundnutzung.rechtsstatus,
        grundnutzung.publiziertab,
        grundnutzung.bemerkungen,
        grundnutzung.erfasser,
        grundnutzung.datum,
        grundnutzung.geometrie,
        typ.t_id AS typ_t_id,
        typ.typ_kt AS typ_typ_kt,
        typ.code_kommunal AS typ_code_kommunal,
        typ.nutzungsziffer AS typ_nutzungsziffer,
        typ.nutzungsziffer_art AS typ_nutzungsziffer_art,
        typ.geschosszahl AS typ_geschosszahl,
        typ.bezeichnung AS typ_bezeichnung,
        typ.abkuerzung AS typ_abkuerzung,
        typ.verbindlichkeit AS typ_verbindlichkeit,
        typ.bemerkungen AS typ_bemerkungen 
    FROM
        arp_npl.nutzungsplanung_grundnutzung AS grundnutzung
        LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung AS typ
            ON grundnutzung.typ_grundnutzung = typ.t_id
),
wohnen_arbeit AS (
    SELECT
        t_id,
        geometrie,
        CASE 
            WHEN grundnutzung.typ_typ_kt IN (
                'N110_Wohnzone_1_G',
                'N111_Wohnzone_2_G',
                'N112_Wohnzone_3_G',
                'N113_Wohnzone_4_G',
                'N114_Wohnzone_5_G',
                'N115_Wohnzone_6_G',
                'N116_Wohnzone_7_G_und_groesser',
                'N117_Zone_fuer_Terrassenhaeuser_Terrassensiedlung',
                'N130_Gewerbezone_mit_Wohnen_Mischzone',
                'N131_Gewerbezone_mit_Wohnen_Mischzone_2_G',
                'N132_Gewerbezone_mit_Wohnen_Mischzone_3_G',
                'N133_Gewerbezone_mit_Wohnen_Mischzone_4_G_und_groesser',
                'N134_Zone_fuer_publikumsintensive_Anlagen',
                'N140_Kernzone',
                'N141_Zentrumszone',
                'N142_Erhaltungszone',
                'N150_Zone_fuer_oeffentliche_Bauten',
                'N151_Zone_fuer_oeffentliche_Anlagen',
                'N160_Gruen_und_Freihaltezone_innerhalb_Bauzone',
                'N161_kommunale_Uferschutzzone_innerhalb_Bauzone',
                'N162_Landwirtschaftliche_Kernzone',
                'N163_Weilerzone',
                'N169_weitere_eingeschraenkte_Bauzonen',
                'N170_Zone_fuer_Freizeit_und_Erholung',
                'N190_Spezialzone')
                    THEN 'Siedlungsgebiet.Wohnen_oeffentliche_Bauten'
            WHEN grundnutzung.typ_typ_kt IN (
                'N120_Gewerbezone_ohne_Wohnen',
                'N121_Industriezone',
                'N122_Arbeitszone')
                    THEN 'Siedlungsgebiet.Industrie_Arbeiten'
        END AS typ,
        dokumente.dokumente
    FROM
        grundnutzung_geometrie_typ AS grundnutzung
        LEFT JOIN typ_grundnutzung_json_dokument_agg AS dokumente
            ON grundnutzung.typ_t_id = dokumente.typ_grundnutzung_t_id
    WHERE
        typ_typ_kt IN ('N110_Wohnzone_1_G',
            'N111_Wohnzone_2_G',
            'N112_Wohnzone_3_G',
            'N113_Wohnzone_4_G',
            'N114_Wohnzone_5_G',
            'N115_Wohnzone_6_G',
            'N116_Wohnzone_7_G_und_groesser',
            'N117_Zone_fuer_Terrassenhaeuser_Terrassensiedlung',
            'N120_Gewerbezone_ohne_Wohnen',
            'N121_Industriezone',
            'N122_Arbeitszone',
            'N130_Gewerbezone_mit_Wohnen_Mischzone',
            'N131_Gewerbezone_mit_Wohnen_Mischzone_2_G',
            'N132_Gewerbezone_mit_Wohnen_Mischzone_3_G',
            'N133_Gewerbezone_mit_Wohnen_Mischzone_4_G_und_groesser',
            'N134_Zone_fuer_publikumsintensive_Anlagen',
            'N140_Kernzone',
            'N141_Zentrumszone',
            'N142_Erhaltungszone',
            'N150_Zone_fuer_oeffentliche_Bauten',
            'N151_Zone_fuer_oeffentliche_Anlagen',
            'N160_Gruen_und_Freihaltezone_innerhalb_Bauzone',
            'N161_kommunale_Uferschutzzone_innerhalb_Bauzone',
            'N162_Landwirtschaftliche_Kernzone',
            'N163_Weilerzone',
            'N169_weitere_eingeschraenkte_Bauzonen',
            'N170_Zone_fuer_Freizeit_und_Erholung',
            'N190_Spezialzone')
),
landwirtschaft_union AS (
    SELECT
        ST_Union(ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(geometrie, 0.001)))) AS geometrie,
        dokumente.dokumente,
        'Landwirtschaftsgebiet' AS typ
    FROM
        grundnutzung_geometrie_typ AS grundnutzung
        LEFT JOIN typ_grundnutzung_json_dokument_agg AS dokumente
            ON grundnutzung.typ_t_id = dokumente.typ_grundnutzung_t_id
    WHERE
        typ_typ_kt IN (
            'N210_Landwirtschaftszone',
            'N220_Spezielle_Landwirtschaftszone',
            'N230_Rebbauzone',
            'N290_weitere_Landwirtschaftszonen'
        )
    GROUP BY
        dokumente.dokumente,
        typ
),
wald_union AS (
    SELECT
        ST_Union(geometrie) AS geometrie,
        dokumente.dokumente,
        'Wald' AS typ
    FROM
        grundnutzung_geometrie_typ AS grundnutzung
        LEFT JOIN typ_grundnutzung_json_dokument_agg AS dokumente
            ON grundnutzung.typ_t_id = dokumente.typ_grundnutzung_t_id
    WHERE
        typ_typ_kt ='N440_Wald'
    GROUP BY
        dokumente.dokumente,
        typ
),
verkehr_ausserhalb AS (
    SELECT
        t_id,
        geometrie
    FROM
        grundnutzung_geometrie_typ
    WHERE
        typ_typ_kt IN (
        'N420_Verkehrsflaeche_Strasse',
        'N421_Verkehrsflaeche_Bahnareal',
        'N422_Verkehrsflaeche_Flugplatzareal',
        'N429_weitere_Verkehrsflaechen')
),
verkehr_innerhalb AS (
    SELECT
        t_id,
        geometrie
    FROM
        grundnutzung_geometrie_typ
    WHERE
        typ_typ_kt IN (
        'N180_Verkehrszone_Strasse',
        'N181_Verkehrszone_Bahnareal',
        'N182_Verkehrszone_Flugplatzareal',
        'N189_weitere_Verkehrszonen')
),
wohnen_arbeiten_verkehr_innerhalb_laenge_gemeinsame_grenze AS (
    SELECT
        wohnen_arbeit.t_id AS t_id_wohnen_arbeit,
        verkehr_innerhalb.t_id AS t_id_verkehr,
        ST_Length(ST_CollectionExtract(ST_Intersection(wohnen_arbeit.geometrie, verkehr_innerhalb.geometrie), 2)) AS laenge,
        verkehr_innerhalb.geometrie,
        wohnen_arbeit.typ,
        wohnen_arbeit.dokumente
    FROM
        wohnen_arbeit,
        verkehr_innerhalb
    WHERE 
        ST_Touches(wohnen_arbeit.geometrie, verkehr_innerhalb.geometrie)
        OR
        ST_Intersects(wohnen_arbeit.geometrie, verkehr_innerhalb.geometrie)
),
wohnen_arbeiten_verkehr_innerhalb_max_laenge AS (
    SELECT
        t_id_verkehr,
        max(laenge) AS laenge
    FROM
        wohnen_arbeiten_verkehr_innerhalb_laenge_gemeinsame_grenze
    WHERE
        laenge IS NOT NULL
    GROUP BY
        t_id_verkehr
),
wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze AS (
    SELECT
        wohnen_arbeit.t_id AS t_id_wohnen_arbeit,
        verkehr_ausserhalb.t_id AS t_id_verkehr,
        ST_Length(ST_CollectionExtract(ST_Intersection(wohnen_arbeit.geometrie, verkehr_ausserhalb.geometrie), 2)) AS laenge,
        verkehr_ausserhalb.geometrie,
        wohnen_arbeit.typ,
        wohnen_arbeit.dokumente
    FROM
        wohnen_arbeit,
        verkehr_ausserhalb
    WHERE 
        ST_Touches(wohnen_arbeit.geometrie, verkehr_ausserhalb.geometrie)
        OR
        ST_Intersects(wohnen_arbeit.geometrie, verkehr_ausserhalb.geometrie)
),
wohnen_arbeiten_verkehr_max_laenge AS (
    SELECT
        t_id_verkehr,
        ST_Perimeter(geometrie) AS umfang,
        max(laenge) AS laenge
    FROM
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze
    WHERE
        laenge IS NOT NULL
    GROUP BY
        t_id_verkehr,
        ST_Perimeter(geometrie)
),
wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze AS (
    SELECT
        verkehr_ausserhalb.t_id AS t_id_verkehr,
        --ST_Length(ST_CollectionExtract(ST_Intersection(ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(wald.geometrie, 0.001))), ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(verkehr_ausserhalb.geometrie, 0.001)))), 2)) AS laenge,
        --ST_Length(ST_CollectionExtract(ST_MakeValid(ST_RemoveRepeatedPoints(ST_SnapToGrid(ST_Intersection(wald.geometrie, verkehr_ausserhalb.geometrie), 0.001))), 2)) AS laenge,
        ST_Length(ST_CollectionExtract(ST_Intersection(wald.geometrie, verkehr_ausserhalb.geometrie), 2)) AS laenge,
        verkehr_ausserhalb.geometrie,
        typ,
        dokumente
    FROM
        wald_union AS wald,
        verkehr_ausserhalb
    WHERE
        (
            ST_Touches(wald.geometrie, verkehr_ausserhalb.geometrie)
            OR
            ST_Intersects(wald.geometrie, verkehr_ausserhalb.geometrie)
        )
        AND
            verkehr_ausserhalb.t_id NOT IN (SELECT t_id_verkehr FROM wohnen_arbeiten_verkehr_max_laenge WHERE laenge/umfang > 0.05)
    
    UNION ALL
    
    SELECT
        verkehr_ausserhalb.t_id AS t_id_verkehr,
        ST_Length(ST_CollectionExtract(ST_Intersection(landwirtschaft.geometrie, verkehr_ausserhalb.geometrie), 2)) AS laenge,
        verkehr_ausserhalb.geometrie,
        typ,
        dokumente
    FROM
        landwirtschaft_union AS landwirtschaft,
        verkehr_ausserhalb
    WHERE
        (
            ST_Touches(landwirtschaft.geometrie, verkehr_ausserhalb.geometrie)
            OR
            ST_Intersects(landwirtschaft.geometrie, verkehr_ausserhalb.geometrie)
        )
        AND
        verkehr_ausserhalb.t_id NOT IN (SELECT t_id_verkehr FROM wohnen_arbeiten_verkehr_max_laenge WHERE laenge/umfang > 0.05)
),
summe_lw_w_pro_verkehrsflaeche AS (
    SELECT
        sum(laenge) AS laenge,
        t_id_verkehr,
        typ,
        dokumente
    FROM
        wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze
    GROUP BY
        t_id_verkehr,
        typ,
        dokumente
),
max_laenge_landwirtschaft_wald_verkehr AS (
    SELECT
        t_id_verkehr,
        max(laenge) AS laenge
    FROM
        summe_lw_w_pro_verkehrsflaeche
    WHERE
        laenge IS NOT NULL
    GROUP BY
        t_id_verkehr
),
zuordnung_grundnutzung AS (
    SELECT
        summe_lw_w_pro_verkehrsflaeche.t_id_verkehr,
        summe_lw_w_pro_verkehrsflaeche.typ,
        wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze.laenge,
        summe_lw_w_pro_verkehrsflaeche.dokumente
    FROM
        max_laenge_landwirtschaft_wald_verkehr
        JOIN summe_lw_w_pro_verkehrsflaeche
            ON 
                max_laenge_landwirtschaft_wald_verkehr.t_id_verkehr = summe_lw_w_pro_verkehrsflaeche.t_id_verkehr
                AND
                max_laenge_landwirtschaft_wald_verkehr.laenge = summe_lw_w_pro_verkehrsflaeche.laenge
        JOIN wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze
            ON 
                wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze.t_id_verkehr = summe_lw_w_pro_verkehrsflaeche.t_id_verkehr
                AND
                wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze.typ = summe_lw_w_pro_verkehrsflaeche.typ
),
zugeordnet AS (
    SELECT
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.t_id_verkehr,
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.laenge,
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.geometrie,
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.dokumente,
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.typ
    FROM wohnen_arbeiten_verkehr_max_laenge
        LEFT JOIN wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze
            ON 
                wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.t_id_verkehr = wohnen_arbeiten_verkehr_max_laenge.t_id_verkehr
                AND
                wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.laenge = wohnen_arbeiten_verkehr_max_laenge.laenge
    WHERE
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.t_id_verkehr NOT IN (SELECT t_id_verkehr FROM wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze)

    UNION ALL
    
    SELECT
        wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze.t_id_verkehr,
        wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze.laenge,
        wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze.geometrie,
        zuordnung_grundnutzung.dokumente,
        zuordnung_grundnutzung.typ
    FROM zuordnung_grundnutzung --rest_verkehr_max_laenge
        LEFT JOIN wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze
            ON 
                wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze.t_id_verkehr = zuordnung_grundnutzung.t_id_verkehr
                AND
                wald_landwirtschaft_verkehr_laenge_gemeinsame_grenze.laenge = zuordnung_grundnutzung.laenge
    UNION ALL
    
    SELECT
        wohnen_arbeiten_verkehr_innerhalb_laenge_gemeinsame_grenze.t_id_verkehr,
        wohnen_arbeiten_verkehr_innerhalb_laenge_gemeinsame_grenze.laenge,
        wohnen_arbeiten_verkehr_innerhalb_laenge_gemeinsame_grenze.geometrie,
        wohnen_arbeiten_verkehr_innerhalb_laenge_gemeinsame_grenze.dokumente,
        wohnen_arbeiten_verkehr_innerhalb_laenge_gemeinsame_grenze.typ
    FROM wohnen_arbeiten_verkehr_innerhalb_max_laenge
        LEFT JOIN wohnen_arbeiten_verkehr_innerhalb_laenge_gemeinsame_grenze
            ON 
                wohnen_arbeiten_verkehr_innerhalb_laenge_gemeinsame_grenze.t_id_verkehr = wohnen_arbeiten_verkehr_innerhalb_max_laenge.t_id_verkehr
                AND
                wohnen_arbeiten_verkehr_innerhalb_laenge_gemeinsame_grenze.laenge = wohnen_arbeiten_verkehr_innerhalb_max_laenge.laenge
),
grundnutzung_einzelflaechen AS (
    SELECT
        'Ausgangslage' AS abstimmungskategorie,
        'Reservezone' AS grundnutzungsart,
        'rechtsgueltig' AS planungsstand,
        (ST_Dump(geometrie)).geom AS geometrie,
        NULL AS dokumente
    FROM
        arp_npl.nutzungsplanung_grundnutzung AS grundnutzung
        LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung AS grundnutzungtyp
            ON grundnutzung.typ_grundnutzung = grundnutzungtyp.t_id
    WHERE
        code_kommunal::int >= 4300 AND code_kommunal::int < 4400
    
    UNION ALL
    
    /*Grundnutzung ohne Verkehrsflaechen*/
    SELECT
        'Ausgangslage' AS abstimmungskategorie,
        CASE
            WHEN grundnutzung.typ_typ_kt IN ('N320_Gewaesser')
                THEN 'Gewaesser'
            WHEN grundnutzung.typ_typ_kt IN ('')
                THEN 'Nationalstrasse'
            WHEN grundnutzung.typ_typ_kt IN ('N440_Wald')
                THEN 'Wald'
            WHEN grundnutzung.typ_typ_kt IN (
                'N210_Landwirtschaftszone',
                'N220_Spezielle_Landwirtschaftszone',
                'N230_Rebbauzone',
                'N290_weitere_Landwirtschaftszonen',
                'N329_weitere_Zonen_fuer_Gewaesser_und_ihre_Ufer')
                    THEN 'Landwirtschaftsgebiet'
            WHEN grundnutzung.typ_typ_kt IN (
                'N110_Wohnzone_1_G',
                'N111_Wohnzone_2_G',
                'N112_Wohnzone_3_G',
                'N113_Wohnzone_4_G',
                'N114_Wohnzone_5_G',
                'N115_Wohnzone_6_G',
                'N116_Wohnzone_7_G_und_groesser',
                'N117_Zone_fuer_Terrassenhaeuser_Terrassensiedlung',
                'N130_Gewerbezone_mit_Wohnen_Mischzone',
                'N131_Gewerbezone_mit_Wohnen_Mischzone_2_G',
                'N132_Gewerbezone_mit_Wohnen_Mischzone_3_G',
                'N133_Gewerbezone_mit_Wohnen_Mischzone_4_G_und_groesser',
                'N134_Zone_fuer_publikumsintensive_Anlagen',
                'N140_Kernzone',
                'N141_Zentrumszone',
                'N142_Erhaltungszone',
                'N150_Zone_fuer_oeffentliche_Bauten',
                'N151_Zone_fuer_oeffentliche_Anlagen',
                'N160_Gruen_und_Freihaltezone_innerhalb_Bauzone',
                'N161_kommunale_Uferschutzzone_innerhalb_Bauzone',
                'N162_Landwirtschaftliche_Kernzone',
                'N163_Weilerzone',
                'N169_weitere_eingeschraenkte_Bauzonen',
                'N170_Zone_fuer_Freizeit_und_Erholung',
                'N190_Spezialzone')
                    THEN 'Siedlungsgebiet.Wohnen_oeffentliche_Bauten'
            WHEN grundnutzung.typ_typ_kt IN (
                'N120_Gewerbezone_ohne_Wohnen',
                'N121_Industriezone',
                'N122_Arbeitszone')
                    THEN 'Siedlungsgebiet.Industrie_Arbeiten'
            WHEN grundnutzung.typ_typ_kt IN (
                'N430_Reservezone_Wohnzone_Mischzone_Kernzone_Zentrumszone',
                'N431_Reservezone_Arbeiten',
                'N432_Reservezone_OeBA',
                'N439_Reservezone')
                    THEN 'Reservezone'
        END AS grundnutzungsart,
        'rechtsgueltig' AS planungsstand,
        grundnutzung.geometrie,
        dokumente.dokumente AS dok_id
    FROM  
        grundnutzung_geometrie_typ AS grundnutzung 
        LEFT JOIN typ_grundnutzung_json_dokument_agg AS dokumente
            ON grundnutzung.typ_t_id = dokumente.typ_grundnutzung_t_id
    WHERE
        grundnutzung.typ_typ_kt IN (
            'N110_Wohnzone_1_G',
            'N111_Wohnzone_2_G',
            'N112_Wohnzone_3_G',
            'N113_Wohnzone_4_G',
            'N114_Wohnzone_5_G',
            'N115_Wohnzone_6_G',
            'N116_Wohnzone_7_G_und_groesser',
            'N117_Zone_fuer_Terrassenhaeuser_Terrassensiedlung',
            'N120_Gewerbezone_ohne_Wohnen',
            'N121_Industriezone',
            'N122_Arbeitszone',
            'N130_Gewerbezone_mit_Wohnen_Mischzone',
            'N131_Gewerbezone_mit_Wohnen_Mischzone_2_G',
            'N132_Gewerbezone_mit_Wohnen_Mischzone_3_G',
            'N133_Gewerbezone_mit_Wohnen_Mischzone_4_G_und_groesser',
            'N134_Zone_fuer_publikumsintensive_Anlagen',
            'N140_Kernzone',
            'N141_Zentrumszone',
            'N142_Erhaltungszone',
            'N150_Zone_fuer_oeffentliche_Bauten',
            'N151_Zone_fuer_oeffentliche_Anlagen',
            'N160_Gruen_und_Freihaltezone_innerhalb_Bauzone',
            'N161_kommunale_Uferschutzzone_innerhalb_Bauzone',
            'N162_Landwirtschaftliche_Kernzone',
            'N163_Weilerzone',
            'N169_weitere_eingeschraenkte_Bauzonen',
            'N170_Zone_fuer_Freizeit_und_Erholung',
            'N190_Spezialzone',
            'N210_Landwirtschaftszone',
            'N220_Spezielle_Landwirtschaftszone',
            'N230_Rebbauzone',
            'N290_weitere_Landwirtschaftszonen',
            'N320_Gewaesser',
            'N329_weitere_Zonen_fuer_Gewaesser_und_ihre_Ufer',
            'N430_Reservezone_Wohnzone_Mischzone_Kernzone_Zentrumszone',
            'N431_Reservezone_Arbeiten',
            'N432_Reservezone_OeBA',
            'N439_Reservezone',
            'N440_Wald')
    
    UNION ALL
    /*Verkehrsflaechen */
    SELECT
        'Ausgangslage' AS abstimmungskategorie,
        typ AS grundnutzungsart,
        'rechtsgueltig' AS planungsstand,
        zugeordnet.geometrie,
        zugeordnet.dokumente
    FROM
        zugeordnet
        
),
grundnutzung_vereinigt AS (
SELECT
    abstimmungskategorie,
    grundnutzungsart,
    planungsstand,
    (ST_Dump(ST_Union(ST_SnapToGrid(geometrie, 0.001)))).geom AS geometrie,
    dokumente
FROM
    grundnutzung_einzelflaechen
GROUP BY
    abstimmungskategorie,
    grundnutzungsart,
    planungsstand,
    dokumente
),
richtplankarte_grundnutzung AS (
SELECT
    abstimmungskategorie,
    grundnutzungsart,
    planungsstand,
    geometrie,
    dokumente
FROM
    grundnutzung_vereinigt
WHERE
    planungsstand IN ('rechtsgueltig', 'in_Auflage')
    AND
    geometrie IS NOT NULL
),
documents AS (
    SELECT DISTINCT
        richtplankarte_dokument.t_id,
        richtplankarte_dokument.t_ili_tid,
        richtplankarte_dokument.titel,
        richtplankarte_dokument.publiziertAb,
        richtplankarte_dokument.bemerkung,
        CASE
            WHEN position('/opt/sogis_pic/documents/ch.so.arp.richtplan/' IN richtplankarte_dokument.dateipfad) != 0
                THEN 'https://geo.so.ch/docs/' || split_part(richtplankarte_dokument.dateipfad, '/documents/', 2)
            WHEN position('opt/sogis_pic/daten_aktuell/arp/Zonenplaene/Zonenplaene_pdf/' IN richtplankarte_dokument.dateipfad) != 0
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/' || split_part(richtplankarte_dokument.dateipfad, '/Zonenplaene/', 2)
            WHEN position('G:\documents\' IN richtplankarte_dokument.dateipfad) != 0    
                THEN replace(richtplankarte_dokument.dateipfad, 'G:\documents\', 'https://geo.so.ch/docs/')
        END AS dokument,
        richtplankarte_grundnutzung.t_id AS grundnutzung_id
    FROM 
        arp_richtplan_v1.richtplankarte_grundnutzung_dokument
        LEFT JOIN arp_richtplan_v1.richtplankarte_dokument
            ON richtplankarte_dokument.t_id = richtplankarte_grundnutzung_dokument.dokument
        RIGHT JOIN arp_richtplan_v1.richtplankarte_grundnutzung
            ON richtplankarte_grundnutzung_dokument.grundnutzung = richtplankarte_grundnutzung.t_id
    WHERE
        (titel, dateipfad) IS NOT NULL
),
documents_json AS (
    SELECT 
        array_to_json(
            array_agg(
                row_to_json((
                    SELECT
                        docs
                    FROM 
                        (
                            SELECT
                                t_id,
                                t_ili_tid,
                                titel,
                                publiziertAb,
                                bemerkung,
                                dokument
                        ) docs
                ))
            )
        ) AS dokumente,
        grundnutzung_id
    FROM 
        documents
    GROUP BY 
        grundnutzung_id
)

SELECT
    richtplankarte_grundnutzung.t_ili_tid,
    richtplankarte_grundnutzung.abstimmungskategorie,
    richtplankarte_grundnutzung.grundnutzungsart,
    richtplankarte_grundnutzung.planungsstand,
    richtplankarte_grundnutzung.geometrie,
    documents_json.dokumente AS dokumente
FROM
    arp_richtplan_v1.richtplankarte_grundnutzung
    LEFT JOIN documents_json
        ON documents_json.grundnutzung_id = richtplankarte_grundnutzung.t_id
WHERE
    richtplankarte_grundnutzung.planungsstand IN ('rechtsgueltig', 'in_Auflage')
;
