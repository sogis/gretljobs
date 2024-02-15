WITH

http_dokument AS (
    SELECT
        concat(
            'https://geo.so.ch/docs/ch.so.afu.wasserversorgung/', 
            split_part(
                dateiname, 
                'ch.so.afu.wasserversorgung\', 
                2
            )
        ) AS url,
        t_id
    FROM 
        afu_wasserversorg_obj_v1.dokument d
),

dokumente_filterbrunnen AS (
    SELECT
        fd.filterbrunnen_r,   
        json_agg(d.url ORDER BY url) AS dokumente
    FROM 
        http_dokument d
    JOIN
        afu_wasserversorg_obj_v1.filterbrunnen__dokument fd  ON d.t_id = fd.dokument_r
    GROUP BY
        filterbrunnen_r
),

dokumente_kontrollschacht AS (
    SELECT
        kontrollschacht_r,   
        json_agg(url ORDER BY url) AS dokumente
    FROM 
        http_dokument d
    JOIN
        afu_wasserversorg_obj_v1.kontrollschacht__dokument kd  ON d.t_id = kd.dokument_r
    GROUP BY
        kontrollschacht_r
),

dokumente_pumpwerk AS (
    SELECT
        pumpwerk_r,   
        json_agg(url ORDER BY url) AS dokumente
    FROM 
        http_dokument d
    JOIN
        afu_wasserversorg_obj_v1.pumpwerk__dokument pd  ON d.t_id = pd.dokument_r
    GROUP BY
        pumpwerk_r
),

dokumente_quelle_gefasst AS (
    SELECT
        quelle_gefasst_r,   
        json_agg(url ORDER BY url) AS dokumente
    FROM 
        http_dokument d
    JOIN
        afu_wasserversorg_obj_v1.quelle_gefasst__dokument qgd  ON d.t_id = qgd.dokument_r
    GROUP BY
        quelle_gefasst_r
),

dokumente_quellwasserbehaelter AS (
    SELECT
        quellwasserbehaelter_r,   
        json_agg(url ORDER BY url) AS dokumente
    FROM 
        http_dokument d
    JOIN
        afu_wasserversorg_obj_v1.quellwasserbehaelter__dokument qd  ON d.t_id = qd.dokument_r
    GROUP BY
        quellwasserbehaelter_r
),

dokumente_reservoir AS (
    SELECT
        reservoir_r,   
        json_agg(url ORDER BY url) AS dokumente
    FROM 
        http_dokument d
    JOIN
        afu_wasserversorg_obj_v1.reservoir__dokument rd  ON d.t_id = rd.dokument_r
    GROUP BY
        reservoir_r
),

dokumente_sammelbrunnstube AS (
    SELECT
        sammelbrunnstube_r,   
        json_agg(url ORDER BY url) AS dokumente
    FROM 
        http_dokument d
    JOIN
        afu_wasserversorg_obj_v1.sammelbrunnstube__dokument sd  ON d.t_id = sd.dokument_r
    GROUP BY
        sammelbrunnstube_r
),

pumpwerk AS (
    SELECT 
        'Pumpwerk' AS trinkwasserobjektart,
        'Pumpwerk' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        dp.dokumente,
        geometrie
    FROM
        afu_wasserversorg_obj_v1.pumpwerk
    LEFT JOIN
        dokumente_pumpwerk dp ON t_id = dp.pumpwerk_r
),

reservoir AS (
    SELECT
        'Reservoir' AS trinkwasserobjektart,
        'Reservoir' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        dr.dokumente,
        geometrie
    FROM
        afu_wasserversorg_obj_v1.reservoir
    LEFT JOIN
        dokumente_reservoir dr ON t_id = dr.reservoir_r
),

sammelbrunnstube AS (
    SELECT
        'Sammelbrunnenstube' AS trinkwasserobjektart,
        'Sammelbrunnenstube' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        ds.dokumente,
        geometrie
    FROM
        afu_wasserversorg_obj_v1.sammelbrunnstube
    LEFT JOIN
        dokumente_sammelbrunnstube ds ON t_id = ds.sammelbrunnstube_r
),

kontrollschacht AS (
    SELECT
        'Kontrollschacht' AS trinkwasserobjektart,
        'Kontrollschacht' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        dk.dokumente,
        geometrie
    FROM
        afu_wasserversorg_obj_v1.kontrollschacht
    LEFT JOIN
        dokumente_kontrollschacht dk ON t_id = dk.kontrollschacht_r
),

quellwasserbehaelter AS (
    SELECT
        'Quellwasserbehaelter' AS trinkwasserobjektart,
        'Quellwasserbehälter' AS objekttyp_anzeige,
        bezeichnung AS objektname,
        objekt_id AS objektnummer,
        beschreibung AS technische_angabe,
        bemerkung,
        dq.dokumente,
        geometrie
    FROM
        afu_wasserversorg_obj_v1.quellwasserbehaelter
    LEFT JOIN
        dokumente_quellwasserbehaelter dq ON t_id = dq.quellwasserbehaelter_r
)

SELECT
    trinkwasserobjektart,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    pumpwerk
    
UNION ALL

SELECT
    trinkwasserobjektart,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    reservoir
    
UNION ALL

SELECT
    trinkwasserobjektart,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    sammelbrunnstube

UNION ALL
    
SELECT
    trinkwasserobjektart,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    kontrollschacht

UNION ALL

SELECT
    trinkwasserobjektart,
    objekttyp_anzeige,
    objektname,
    objektnummer,
    technische_angabe,
    bemerkung,
    dokumente,
    geometrie
FROM
    quellwasserbehaelter
;    