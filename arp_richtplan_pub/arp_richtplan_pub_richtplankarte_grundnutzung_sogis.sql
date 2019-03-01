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
        geometrie
    FROM
        grundnutzung_geometrie_typ
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
rest AS (
    SELECT
        t_id,
        geometrie
    FROM
        grundnutzung_geometrie_typ
    WHERE
        typ_typ_kt IN (
            'N210_Landwirtschaftszone',
            'N220_Spezielle_Landwirtschaftszone',
            'N230_Rebbauzone',
            'N290_weitere_Landwirtschaftszonen',
            'N440_Wald'
         )
),
verkehr AS (
    SELECT
        t_id,
        geometrie
    FROM
        grundnutzung_geometrie_typ
    WHERE
        typ_typ_kt IN ('N180_Verkehrszone_Strasse',
        'N181_Verkehrszone_Bahnareal',
        'N182_Verkehrszone_Flugplatzareal',
        'N189_weitere_Verkehrszonen',
        'N420_Verkehrsflaeche_Strasse',
        'N421_Verkehrsflaeche_Bahnareal',
        'N422_Verkehrsflaeche_Flugplatzareal',
        'N429_weitere_Verkehrsflaechen')
),
wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze AS (
    SELECT
        wohnen_arbeit.t_id AS t_id_wohnen_arbeit,
        verkehr.t_id AS t_id_verkehr,
        ST_Length(ST_CollectionExtract(ST_Intersection(wohnen_arbeit.geometrie, verkehr.geometrie), 2)) AS laenge,
        verkehr.geometrie
    FROM
        wohnen_arbeit,
        verkehr
    WHERE 
        ST_Touches(wohnen_arbeit.geometrie, verkehr.geometrie)
        OR
        ST_Intersects(wohnen_arbeit.geometrie, verkehr.geometrie)
),
wohnen_arbeiten_verkehr_max_laenge AS (
    SELECT
        t_id_verkehr,
        max(laenge) AS laenge
    FROM
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze
    WHERE
        laenge IS NOT NULL
    GROUP BY
        t_id_verkehr
),
rest_verkehr_laenge_gemeinsame_grenze AS (
    SELECT
        rest.t_id AS t_id_rest,
        verkehr.t_id AS t_id_verkehr,
        ST_Length(ST_CollectionExtract(ST_Intersection(rest.geometrie, verkehr.geometrie), 2)) AS laenge,
        verkehr.geometrie
    FROM
        rest,
        verkehr
    WHERE
        (
            ST_Touches(rest.geometrie, verkehr.geometrie)
            OR
            ST_Intersects(rest.geometrie, verkehr.geometrie)
        )
        AND
        verkehr.t_id NOT IN (SELECT t_id_verkehr FROM wohnen_arbeiten_verkehr_max_laenge)
)
, rest_verkehr_max_laenge AS (
    SELECT
        t_id_verkehr,
        max(laenge) AS laenge
    FROM
        rest_verkehr_laenge_gemeinsame_grenze
    WHERE
        laenge IS NOT NULL
    GROUP BY
        t_id_verkehr
),
zugeordnet AS (
    SELECT
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.t_id_wohnen_arbeit AS t_id_grundnutzung,
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.t_id_verkehr,
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.laenge,
        wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.geometrie
    FROM wohnen_arbeiten_verkehr_max_laenge
        LEFT JOIN wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze
            ON 
                wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.t_id_verkehr = wohnen_arbeiten_verkehr_max_laenge.t_id_verkehr
                AND
                wohnen_arbeiten_verkehr_laenge_gemeinsame_grenze.laenge = wohnen_arbeiten_verkehr_max_laenge.laenge
                
    UNION ALL
    
    SELECT
        rest_verkehr_laenge_gemeinsame_grenze.t_id_rest AS t_id_grundnutzung,
        rest_verkehr_laenge_gemeinsame_grenze.t_id_verkehr,
        rest_verkehr_laenge_gemeinsame_grenze.laenge,
        rest_verkehr_laenge_gemeinsame_grenze.geometrie
    FROM rest_verkehr_max_laenge
        LEFT JOIN rest_verkehr_laenge_gemeinsame_grenze
            ON 
                rest_verkehr_laenge_gemeinsame_grenze.t_id_verkehr = rest_verkehr_max_laenge.t_id_verkehr
                AND
                rest_verkehr_laenge_gemeinsame_grenze.laenge = rest_verkehr_max_laenge.laenge
),
nicht_zugeordnet AS (
    SELECT
        t_id,
        geometrie
    FROM 
        verkehr
    WHERE 
        t_id NOT IN (SELECT t_id_verkehr FROM zugeordnet)
),
zugeordnet_nicht_zugeordnet_laenge_gemeinsame_grenze AS (
    SELECT
        zugeordnet.t_id_grundnutzung AS t_id_zugeordnet,
        nicht_zugeordnet.t_id AS t_id_nicht_zugeordnet,
        ST_Length(ST_CollectionExtract(ST_Intersection(zugeordnet.geometrie, nicht_zugeordnet.geometrie), 2)) AS laenge,
        nicht_zugeordnet.geometrie
    FROM
        zugeordnet,
        nicht_zugeordnet
    WHERE
        (
            ST_Touches(zugeordnet.geometrie, nicht_zugeordnet.geometrie)
            OR
            ST_Intersects(zugeordnet.geometrie, nicht_zugeordnet.geometrie)
        )
        AND
        nicht_zugeordnet.t_id NOT IN (SELECT t_id_verkehr FROM zugeordnet)
)
, zugeordnet_nicht_zugeordnet_max_laenge AS (
    SELECT
        t_id_nicht_zugeordnet,
        max(laenge) AS laenge
    FROM
        zugeordnet_nicht_zugeordnet_laenge_gemeinsame_grenze
    WHERE
        laenge IS NOT NULL
    GROUP BY
        t_id_nicht_zugeordnet
)
, zugewiesene_verkehrsflaechen AS (
    SELECT
        zugeordnet_nicht_zugeordnet_laenge_gemeinsame_grenze.t_id_zugeordnet,
        zugeordnet_nicht_zugeordnet_laenge_gemeinsame_grenze.t_id_nicht_zugeordnet,
        zugeordnet_nicht_zugeordnet_laenge_gemeinsame_grenze.laenge,
        zugeordnet_nicht_zugeordnet_laenge_gemeinsame_grenze.geometrie
    FROM zugeordnet_nicht_zugeordnet_max_laenge
        LEFT JOIN zugeordnet_nicht_zugeordnet_laenge_gemeinsame_grenze
            ON 
                zugeordnet_nicht_zugeordnet_laenge_gemeinsame_grenze.t_id_nicht_zugeordnet = zugeordnet_nicht_zugeordnet_max_laenge.t_id_nicht_zugeordnet
                AND
                zugeordnet_nicht_zugeordnet_laenge_gemeinsame_grenze.laenge = zugeordnet_nicht_zugeordnet_max_laenge.laenge

    UNION ALL

    SELECT
        zugeordnet.t_id_grundnutzung,
        zugeordnet.t_id_verkehr,
        zugeordnet.laenge,
        zugeordnet.geometrie
    FROM
        zugeordnet
), grundnutzung_einzelflaechen AS (
    SELECT
        uuid_generate_v4() AS t_ili_tid,
        'Ausgangslage' AS abstimmungskategorie,
        'Reservezone' AS grundnutzungsart,
        'rechtsgueltig' AS planungsstand,
        ST_SnapToGrid((ST_Dump(wkb_geometry)).geom, 0.001) AS geometrie,
        NULL AS dokumente
    FROM
        digizone.zonenplan
    WHERE
        "archive" = 0
        AND
        zcode = 721
        AND
        gem_bfs NOT IN (
            SELECT
                CAST(datasetname AS integer)
            FROM
                arp_npl.t_ili2db_dataset
        )
    
    UNION ALL
    /*Grundnutzung ohne Verkehrsflaechne*/
    SELECT
        grundnutzung.t_ili_tid,
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
                'N290_weitere_Landwirtschaftszonen')
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
            'N430_Reservezone_Wohnzone_Mischzone_Kernzone_Zentrumszone',
            'N431_Reservezone_Arbeiten',
            'N432_Reservezone_OeBA',
            'N439_Reservezone',
            'N440_Wald')
    
    UNION ALL
    /*Verkehrsflaechen */
    SELECT
        grundnutzung.t_ili_tid,
        'Ausgangslage' AS abstimmungskategorie,
        CASE 
            WHEN grundnutzung.typ_typ_kt = 'N440_Wald'
                THEN 'Wald'
            WHEN grundnutzung.typ_typ_kt IN (
                'N210_Landwirtschaftszone',
                'N220_Spezielle_Landwirtschaftszone',
                'N230_Rebbauzone',
                'N290_weitere_Landwirtschaftszonen')
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
        END AS grundnutzungsart,
        'rechtsgueltig' AS planungsstand,
        zugewiesene_verkehrsflaechen.geometrie,
        dokumente.dokumente
    FROM
        zugewiesene_verkehrsflaechen
        LEFT JOIN grundnutzung_geometrie_typ AS grundnutzung 
            ON grundnutzung.t_id = zugewiesene_verkehrsflaechen.t_id_zugeordnet
        LEFT JOIN typ_grundnutzung_json_dokument_agg AS dokumente
            ON grundnutzung.typ_t_id = dokumente.typ_grundnutzung_t_id
), grundnutzung AS (
SELECT
    abstimmungskategorie,
    grundnutzungsart,
    planungsstand,
    ST_SnapToGrid((ST_Dump(ST_Buffer(ST_Buffer(ST_Union(geometrie),1),-1))).geom, 0.001) AS geometrie,
    dokumente
FROM
    grundnutzung_einzelflaechen
GROUP BY
    abstimmungskategorie,
    grundnutzungsart,
    planungsstand,
    dokumente
)

SELECT
    abstimmungskategorie,
    grundnutzungsart,
    planungsstand,
    geometrie,
    dokumente
FROM
    grundnutzung
WHERE
    planungsstand IN ('rechtsgueltig', 'in_Auflage')
    AND
    geometrie IS NOT NULL
;