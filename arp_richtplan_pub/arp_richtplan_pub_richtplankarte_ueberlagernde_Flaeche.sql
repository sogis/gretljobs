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
        parents || rechtsvorschrften_hinweisweiteredokumente.hinweis,
        rechtsvorschrften_hinweisweiteredokumente.hinweis AS last_ursprung,
        x."depth" + 1
    FROM
        x
        INNER JOIN arp_npl.rechtsvorschrften_hinweisweiteredokumente
            ON (last_ursprung = rechtsvorschrften_hinweisweiteredokumente.ursprung)
    WHERE 
        rechtsvorschrften_hinweisweiteredokumente.hinweis IS NOT NULL

), doc_doc_references_all AS (
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
                max(sq."depth")
            FROM
                x AS sq 
            WHERE
                sq.ursprung = x.ursprung
                )
), 
doc_doc_references AS (
    SELECT 
        ursprung,
        a_parents AS dok_dok_referenzen
    FROM
        (
            SELECT DISTINCT ON (a_parents)
                doc_doc_references_all_a.ursprung,
                doc_doc_references_all_a.parents AS a_parents,
                doc_doc_references_all_b.parents AS b_parents
            FROM
                doc_doc_references_all AS doc_doc_references_all_a
                LEFT JOIN doc_doc_references_all AS doc_doc_references_all_b
                    ON 
                        doc_doc_references_all_a.parents <@ doc_doc_references_all_b.parents
                        AND
                        doc_doc_references_all_a.parents != doc_doc_references_all_b.parents
        ) AS subquery
    WHERE
        b_parents IS NULL
), 
json_documents_all AS (
    SELECT
        t_id, 
        row_to_json(subquery)::text AS json_dokument -- Text-Repräsentation des JSON-Objektes. 
    FROM
        (
            SELECT
                t_id,
                titel,
                abkuerzung,
                publiziertab,
                bemerkungen,
                ('https://geo.so.ch/docs/ch.so.arp.zonenplaene/Zonenplaene_pdf/'||"textimweb")::text AS textimweb_absolut
            FROM
                arp_npl.rechtsvorschrften_dokument
        ) AS subquery
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
        ) AS subquery
        LEFT JOIN json_documents_all
            ON subquery.dokument_t_id = json_documents_all.t_id
),
typ_ueberlagernd_flaeche_dokument_ref AS(
    SELECT DISTINCT ON(typ_ueberlagernd_flaeche, dok_referenz)
        typ_ueberlagernd_flaeche,
        dokument,
        dok_referenz
    FROM
        (
            SELECT DISTINCT
                typ_ueberlagernd_flaeche_dokument.typ_ueberlagernd_flaeche,
                dokument,
                unnest(dok_dok_referenzen) AS dok_referenz
            FROM
                arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche_dokument AS typ_ueberlagernd_flaeche_dokument
                LEFT JOIN doc_doc_references
                    ON typ_ueberlagernd_flaeche_dokument.dokument = doc_doc_references.ursprung

            UNION

            SELECT
                typ_ueberlagernd_flaeche,
                dokument,
                dokument AS dok_referenz
            FROM
                arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche_dokument
        ) AS subquery
),
typ_ueberlagernd_flaeche_json_dokument AS (
    SELECT
        typ_ueberlagernd_flaeche,
        dokument,
        dok_referenz,
        t_id,
        json_dokument
    FROM
        typ_ueberlagernd_flaeche_dokument_ref
        LEFT JOIN json_documents_all
            ON json_documents_all.t_id = typ_ueberlagernd_flaeche_dokument_ref.dok_referenz
),
typ_ueberlagernd_flaeche_json_dokument_agg AS (
    SELECT
        typ_ueberlagernd_flaeche_t_id,
        '[' || dokumente::varchar || ']' as dokumente
    FROM
        (
            SELECT
                typ_ueberlagernd_flaeche AS typ_ueberlagernd_flaeche_t_id,
                string_agg(json_dokument, ',') AS dokumente
            FROM
                typ_ueberlagernd_flaeche_json_dokument
            GROUP BY
                typ_ueberlagernd_flaeche
        ) as subquery
),
ueberlagernd_flaeche_geometrie_typ AS (
    SELECT
        nutzungsplanung_ueberlagernd_flaeche.t_id,
        nutzungsplanung_ueberlagernd_flaeche.geometrie,
        nutzungsplanung_typ_ueberlagernd_flaeche.t_id AS typ_t_id,
        nutzungsplanung_typ_ueberlagernd_flaeche.typ_kt AS typ_typ_kt
    FROM
        arp_npl.nutzungsplanung_ueberlagernd_flaeche
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche
            ON nutzungsplanung_ueberlagernd_flaeche.typ_ueberlagernd_flaeche = nutzungsplanung_typ_ueberlagernd_flaeche.t_id
),
npl_wald AS (
    SELECT
        geometrie
    FROM
        arp_npl.nutzungsplanung_grundnutzung
        LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung 
            ON nutzungsplanung_grundnutzung.typ_grundnutzung = nutzungsplanung_typ_grundnutzung.t_id
    WHERE
        nutzungsplanung_typ_grundnutzung.typ_kt = 'N440_Wald'
),
juraschutzzone_ueberlagert_wald AS (
    SELECT
        ueberlagernd_flaeche_geometrie_typ.t_id,
        ST_Intersects(ueberlagernd_flaeche_geometrie_typ.geometrie, npl_wald.geometrie) AS ueberlagerungstyp
    FROM
        npl_wald,
        ueberlagernd_flaeche_geometrie_typ
),
npl_landwirtschaft AS (
    SELECT
        geometrie
    FROM
        arp_npl.nutzungsplanung_grundnutzung
        LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung 
            ON nutzungsplanung_grundnutzung.typ_grundnutzung = nutzungsplanung_typ_grundnutzung.t_id
    WHERE
        nutzungsplanung_typ_grundnutzung.typ_kt = 'N210_Landwirtschaftszone'
),
juraschutzzone_ueberlagert_landwirtschaft AS (
    SELECT
        ueberlagernd_flaeche_geometrie_typ.t_id,
        ST_Intersects(ueberlagernd_flaeche_geometrie_typ.geometrie, npl_landwirtschaft.geometrie) AS ueberlagerungstyp
    FROM
        npl_landwirtschaft,
        ueberlagernd_flaeche_geometrie_typ
),
documents_richtplan AS (
    SELECT DISTINCT 
        titel, 
        publiziertAb, 
        bemerkung,
        richtplankarte_ueberlagernde_flaeche.t_id AS ueberlagernde_flaeche_id,
        dateipfad AS dokumente
    FROM 
        arp_richtplan.richtplankarte_ueberlagernde_flaeche_dokument
        LEFT JOIN arp_richtplan.richtplankarte_dokument
            ON richtplankarte_dokument.t_id = richtplankarte_ueberlagernde_flaeche_dokument.dokument
        RIGHT JOIN arp_richtplan.richtplankarte_ueberlagernde_flaeche
            ON richtplankarte_ueberlagernde_flaeche_dokument.ueberlagernde_flaeche = richtplankarte_ueberlagernde_flaeche.t_id
    WHERE
        (titel, publiziertab, bemerkung, dateipfad) IS NOT NULL
),
documents_json_richtplan AS (
    SELECT 
        array_to_json(array_agg(row_to_json(documents_richtplan)))::text AS dokumente, 
        ueberlagernde_flaeche_id
    FROM 
        documents_richtplan
    GROUP BY 
        ueberlagernde_flaeche_id
),
documents_naturreservate AS (
    SELECT DISTINCT 
        bezeichnung, 
        typ, 
        rechtsstatus, 
        publiziertab, 
        rechtsvorschrift, 
        offiziellenr,
        reservate_reservat_dokument.reservat,
        CASE
            WHEN 
                reservate_dokument.typ = 'RRB' 
                AND 
                position('/opt/sogis_pic/documents/ch.so.arp.naturreservate/rrb/' IN reservate_dokument.dateipfad) != 0 
                AND 
                reservate_dokument.bezeichnung != ''
                AND 
                reservate_dokument.bezeichnung IS NOT NULL
                THEN 'https://geo.so.ch/docs/'
                                || split_part(reservate_dokument.dateipfad, '/documents/', 2)
            WHEN 
                reservate_dokument.typ = 'RRB' 
                AND 
                position('/opt/sogis_pic/documents/ch.so.arp.naturreservate/rrb/' IN reservate_dokument.dateipfad) != 0 
                AND 
                (
                    reservate_dokument.bezeichnung = ''
                    OR 
                    reservate_dokument.bezeichnung IS NULL
                )
                THEN 'https://geo.so.ch/docs/'
                                || split_part(reservate_dokument.dateipfad, '/documents/', 2)
                                
            WHEN 
                reservate_dokument.typ = 'RRB' 
                AND 
                position('opt/sogis_pic/daten_aktuell/arp/Zonenplaene/Zonenplaene_pdf/' IN reservate_dokument.dateipfad) != 0
                AND 
                reservate_dokument.bezeichnung != ''
                AND 
                reservate_dokument.bezeichnung IS NOT NULL
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/'
                                || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)
                                
            WHEN 
                reservate_dokument.typ = 'RRB'
                AND 
                position('opt/sogis_pic/daten_aktuell/arp/Zonenplaene/Zonenplaene_pdf/' IN reservate_dokument.dateipfad) != 0
                AND 
                (
                    reservate_dokument.bezeichnung = ''
                    OR 
                    reservate_dokument.bezeichnung IS NULL
                )
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/'
                                || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)
            WHEN 
                (
                    reservate_dokument.typ = 'Kommunale_Inventare'
                    OR
                    reservate_dokument.typ = 'Bericht'
                    OR
                    reservate_dokument.typ = 'Pflegekonzept'
                )
                AND 
                reservate_dokument.bezeichnung != ''
                AND 
                reservate_dokument.bezeichnung IS NOT NULL
                THEN 'https://geo.so.ch/docs/'
                                || split_part(reservate_dokument.dateipfad, '/documents/', 2)                              
            WHEN 
                (
                    reservate_dokument.typ = 'Kommunale_Inventare'
                    OR
                    reservate_dokument.typ = 'Bericht'
                    OR
                    reservate_dokument.typ = 'Pflegekonzept'
                )
                AND 
                (
                    reservate_dokument.bezeichnung = ''
                    OR 
                    reservate_dokument.bezeichnung IS NULL
                )
                THEN  'https://geo.so.ch/docs/'
                                || split_part(reservate_dokument.dateipfad, '/documents/', 2)
            WHEN 
                (
                    reservate_dokument.typ = 'Sonderbauvorschriften'
                    OR 
                    reservate_dokument.typ = 'Gestaltungsplan'
                )
                AND 
                reservate_dokument.bezeichnung != ''
                AND 
                reservate_dokument.bezeichnung IS NOT NULL
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/'
                                || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)                
            WHEN 
                (
                    reservate_dokument.typ = 'Sonderbauvorschriften'
                    OR 
                    reservate_dokument.typ = 'Gestaltungsplan'
                )
                AND 
                (
                    reservate_dokument.bezeichnung = ''
                    OR 
                    reservate_dokument.bezeichnung IS NULL
                )
                THEN 'https://geo.so.ch/docs/ch.so.arp.zonenplaene/'
                                || split_part(reservate_dokument.dateipfad, '/Zonenplaene/', 2)
            ELSE NULL 
        END AS dokumente
    FROM 
        arp_naturreservate.reservate_reservat_dokument
        LEFT JOIN arp_naturreservate.reservate_dokument
            ON reservate_dokument.t_id = reservate_reservat_dokument.dokument
    
    UNION
    
    SELECT 
        'Objektblatt' AS bezeichnung, 
        'Objektblatt' AS typ, 
        'laufendeAenderung' AS rechtsstatus, 
        NULL AS publiziertab, 
        FALSE AS rechtsvorschrift, 
        NULL AS offiziellenr,
        reservate_reservat.t_id,
        'https://geo.so.ch/api/v1/document/Naturreservate?feature=' || reservate_reservat.t_id
    FROM
        arp_naturreservate.reservate_reservat
        
    UNION
    
    SELECT 
        'Fotos' AS bezeichnung, 
        'Fotos' AS typ, 
        'laufendeAenderung' AS rechtsstatus, 
        NULL AS publiziertab, 
        FALSE AS rechtsvorschrift, 
        NULL AS offiziellenr,
        reservate_reservat.t_id,
        'http://faust.so.ch/suche_start.fau?prj=ARP&dm=FVARP02&rpos=3&ro_zeile_2=' || reservate_reservat.nummer
    FROM
        arp_naturreservate.reservate_reservat
),
documents_json_naturreservate AS (
    SELECT 
        array_to_json(array_agg(row_to_json(documents_naturreservate)))::text AS dokumente, 
        reservat
    FROM 
        documents_naturreservate
    GROUP BY 
        reservat
)

/* Deponie
 * Windenergie,
 * Naturpark,
 * kantonales_Vorranggeiet,
 * Sondernutzungsgebiet,
 * Witischutzzone,
 * kantonale_Uferschutzzone,
 * Juraschutzzone (alt aus Richtplan),
 * Entwicklungsgebiet_Arbeiten,
 * Siedlungstrennguertel,
 * BLN-Gebiet
 */
SELECT
    richtplankarte_ueberlagernde_flaeche.t_ili_tid,
    richtplankarte_ueberlagernde_flaeche.objektnummer,
    richtplankarte_ueberlagernde_flaeche.objekttyp,
    richtplankarte_ueberlagernde_flaeche.weitere_Informationen,
    richtplankarte_ueberlagernde_flaeche.objektname,
    richtplankarte_ueberlagernde_flaeche.abstimmungskategorie,
    richtplankarte_ueberlagernde_flaeche.bedeutung,
    richtplankarte_ueberlagernde_flaeche.planungsstand,
    richtplankarte_ueberlagernde_flaeche.status,
    richtplankarte_ueberlagernde_flaeche.geometrie,
    documents_json_richtplan.dokumente,
   string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeindenamen
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    arp_richtplan.richtplankarte_ueberlagernde_flaeche
    LEFT JOIN documents_json_richtplan
        ON documents_json_richtplan.ueberlagernde_flaeche_id = richtplankarte_ueberlagernde_flaeche.t_id
WHERE
    ST_Intersects(richtplankarte_ueberlagernde_flaeche.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
GROUP BY
    richtplankarte_ueberlagernde_flaeche.t_id,
    documents_json_richtplan.dokumente

UNION ALL

/* Grundwasserschutzzone_areal*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    NULL AS objektnummer,
    'Grundwasserschutzzone_areal' AS objekttyp,
    "zone" AS weitere_Informationen,
    NULL AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    'bestehend' AS status,
    ST_Union(ST_SnapToGrid(wkb_geometry, 0.001)) AS geometrie,
    NULL AS dokumente,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeindenamen
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    public.aww_gszoar
WHERE
    "archive" = 0
    AND
    ST_Intersects(aww_gszoar.wkb_geometry, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
GROUP BY 
    "zone"

UNION ALL

/*kantonales_Naturreservat*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    CAST(reservate_reservat.nummer AS varchar) AS nummer,
    'kantonales_Naturreservat' AS objekttyp,
    NULL AS weitere_Informationen,
    reservate_reservat.reservatsname as objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    'bestehend' AS status,
    ST_Multi(ST_Union(ST_SnapToGrid(reservate_teilgebiet.geometrie, 0.001))) AS geometrie,
    documents_json_naturreservate.dokumente AS dokumente,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeindenamen
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    arp_naturreservate.reservate_reservat
    LEFT JOIN arp_naturreservate.reservate_teilgebiet
        ON reservate_teilgebiet.reservat = reservate_reservat.t_id
    LEFT JOIN documents_json_naturreservate
        ON documents_json_naturreservate.reservat = reservate_reservat.t_id
WHERE 
    ST_Intersects(reservate_teilgebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
GROUP BY 
    reservate_reservat.t_id,
    documents_json_naturreservate.dokumente

UNION ALL

/*Fruchtfolgeflaeche*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    NULL AS objektnummer,
    'Fruchtfolgeflaeche' AS objekttyp,
    NULL AS weitere_Informationen,
    NULL AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    'bestehend' AS status,
    ST_Multi(ST_SnapToGrid(wkb_geometry, 0.001)) AS geometrie,
    NULL AS dokumente,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeindenamen
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    alw_grundlagen.fruchtfolgeflaechen_tab
WHERE
    "archive" = 0
    AND
    ST_Intersects(fruchtfolgeflaechen_tab.wkb_geometry, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
    AND
    ST_Multi(ST_SnapToGrid(wkb_geometry, 0.001)) IS NOT NULL
GROUP BY
    ogc_fid

UNION ALL

/*Abbaustelle*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    akten_nr_t AS objektnummer,
    CASE 
        WHEN mat = 1
            THEN 'Abbaustelle.Kies'
        WHEN mat = 2
            THEN 'Abbaustelle.Kalkstein'
        WHEN mat = 3
            THEN 'Abbaustelle.Ton'
    END AS objekttyp,
    NULL AS weitere_Informationen,
    name AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    'bestehend' AS status,
    ST_Multi(ST_SnapToGrid(wkb_geometry, 0.001)) AS geometrie,
    NULL AS dokumente,
    string_agg(hoheitsgrenzen_gemeindegrenze.gemeindename, ', ') AS gemeindenamen
FROM
    abbaustellen.abbaustellen,
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
WHERE
    ST_DWithin(abbaustellen.wkb_geometry, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    AND
    ST_Intersects(abbaustellen.wkb_geometry, hoheitsgrenzen_gemeindegrenze.geometrie)
    AND
    "archive" = 0
    AND
    mat IN (1, 2, 3)
GROUP BY
    ogc_fid

UNION ALL

/*Juraschutzzone aus NPL*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    NULL AS nummer,
    CASE 
        WHEN juraschutzzone_ueberlagert_wald.ueberlagerungstyp IS TRUE
            THEN 'Juraschutzzone.ueberlagert_Wald'
        WHEN juraschutzzone_ueberlagert_landwirtschaft.ueberlagerungstyp IS TRUE
            THEN 'Juraschutzzone.ueberlagert_Landwirtschaftsgebiet'
    END AS objekttyp,
    NULL AS weitere_Informationen,
    NULL as objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    'bestehend' AS status,
    ST_Multi(ST_SnapToGrid(ueberlagernd_flaeche_geometrie_typ.geometrie, 0.001)) AS geometrie,
    typ_ueberlagernd_flaeche_json_dokument_agg.dokumente AS dokumente,
    string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename) AS gemeindenamen
FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
    ueberlagernd_flaeche_geometrie_typ
    LEFT JOIN typ_ueberlagernd_flaeche_json_dokument_agg
        ON ueberlagernd_flaeche_geometrie_typ.typ_t_id = typ_ueberlagernd_flaeche_json_dokument_agg.typ_ueberlagernd_flaeche_t_id
    LEFT JOIN juraschutzzone_ueberlagert_wald
        ON juraschutzzone_ueberlagert_wald.t_id = ueberlagernd_flaeche_geometrie_typ.t_id
    LEFT JOIN juraschutzzone_ueberlagert_landwirtschaft
        ON juraschutzzone_ueberlagert_landwirtschaft.t_id = ueberlagernd_flaeche_geometrie_typ.t_id
WHERE
    ueberlagernd_flaeche_geometrie_typ.typ_typ_kt = 'N521_Juraschutzzone'
    AND
    ST_Intersects(ueberlagernd_flaeche_geometrie_typ.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
    AND
    (
        juraschutzzone_ueberlagert_wald.ueberlagerungstyp IS TRUE
        OR
        juraschutzzone_ueberlagert_landwirtschaft.ueberlagerungstyp IS TRUE
    )
GROUP BY
    juraschutzzone_ueberlagert_wald.ueberlagerungstyp,
    juraschutzzone_ueberlagert_landwirtschaft.ueberlagerungstyp,
    ueberlagernd_flaeche_geometrie_typ.geometrie,
    typ_ueberlagernd_flaeche_json_dokument_agg.dokumente