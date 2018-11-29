WITH documents AS (
    SELECT DISTINCT 
        titel, 
        publiziertAb, 
        bemerkung,
        richtplankarte_ueberlagernde_linie.t_id AS ueberlagernder_linie_id,
        dateipfad AS dokumente
    FROM 
        arp_richtplan.richtplankarte_ueberlagernde_linie_dokument
        LEFT JOIN arp_richtplan.richtplankarte_dokument
            ON richtplankarte_dokument.t_id = richtplankarte_ueberlagernde_linie_dokument.dokument
        RIGHT JOIN arp_richtplan.richtplankarte_ueberlagernde_linie
            ON richtplankarte_ueberlagernde_linie_dokument.ueberlagernde_linie = richtplankarte_ueberlagernde_linie.t_id
    WHERE
        (titel, publiziertab, bemerkung, dateipfad) IS NOT NULL
    
), documents_json AS (
    SELECT 
        array_to_json(array_agg(row_to_json(documents)))::text AS dokumente, 
        ueberlagernder_linie_id
    FROM 
        documents
    GROUP BY 
        ueberlagernder_linie_id
)

SELECT
    richtplankarte_ueberlagernde_linie.t_ili_tid,
    richtplankarte_ueberlagernde_linie.objektname,
    richtplankarte_ueberlagernde_linie.abstimmungskategorie,
    richtplankarte_ueberlagernde_linie.bedeutung,
    richtplankarte_ueberlagernde_linie.planungsstand,
    documents_json.dokumente,
    richtplankarte_ueberlagernde_linie.status,
    richtplankarte_ueberlagernde_linie.objektnummer,
    richtplankarte_ueberlagernde_linie.objekttyp,
    richtplankarte_ueberlagernde_linie.geometrie
FROM
    arp_richtplan.richtplankarte_ueberlagernde_linie
    LEFT JOIN documents_json
            ON richtplankarte_ueberlagernde_linie.t_id = documents_json.ueberlagernder_linie_id

UNION ALL

/*Bahnlinien bestehend - Richtplankarte*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    NULL AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    NULL AS dokumente,
    'bestehend' AS status,
    NULL AS objektnummer,
    'Bahnlinie.Schiene' AS objekttyp,
    /*Unterscheidung Schiene und Tunnel fehlt noch -> benötigt ergänzendes Attribut unter public.avt_oev_netz und Nachführung der Daten*/
    (ST_Dump(wkb_geometry)).geom AS geometrie
FROM
    public.avt_oev_netz
WHERE
    typ IN (2,3)
    AND
    "archive" = 0