/* Erstellt die GK MGDM Rutschung aus den Prozessgefahrenkarten Hangmure und Rutschung spontan und Rutschung kontinuierlich/Sackung. 
 * */

WITH

gk_rutschung AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_gk_hangmure
    WHERE
        publiziert = true
    UNION ALL
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_kont_sackung
    WHERE
        publiziert = true
    UNION ALL
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_spontan
    WHERE
        publiziert = true
),

stufe_keine AS (
    SELECT
        t_id,
        'keine' AS gef_stufe,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_perimeter_gefahrenkartierung
    WHERE
        gk_hangm = true
    OR  
        gk_ru_spon = true
    OR
        gk_ru_kont = true
),

stufe_groesser_keine AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        gk_rutschung
    WHERE 
        gef_stufe IN ('vorhanden','gering','mittel','erheblich')
),

keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        stufe_keine.t_id AS v_id,
        ST_Union(stufe_groesser_keine.geometrie) AS mpoly_umgebung
    FROM
        stufe_keine
    JOIN
        stufe_groesser_keine
        ON ST_Intersects(stufe_keine.geometrie, stufe_groesser_keine.geometrie)
    GROUP BY
        stufe_keine.t_id
),

keine_diff AS ( -- Gibt alle "vorhanden" Teilpolygone zurück, welche nicht von einer höheren Gefahrenstufe überdeckt werden
    SELECT
        t_id,
        gef_stufe,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        stufe_keine
    LEFT JOIN
        keine_umgebung
        ON stufe_keine.t_id = keine_umgebung.v_id
),

stufe_vorhanden AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        gk_rutschung
    WHERE
        gef_stufe = 'vorhanden'
),

stufe_groesser_vorhanden AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        gk_rutschung
    WHERE 
        gef_stufe IN ('gering', 'mittel', 'erheblich')
),

vorhanden_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        stufe_vorhanden.t_id AS v_id,
        ST_Union(stufe_groesser_vorhanden.geometrie) AS mpoly_umgebung
    FROM
        stufe_vorhanden
    JOIN
        stufe_groesser_vorhanden
        ON ST_Intersects(stufe_vorhanden.geometrie, stufe_groesser_vorhanden.geometrie)
    GROUP BY
        stufe_vorhanden.t_id
),

vorhanden_diff AS ( -- Gibt alle "vorhanden" Teilpolygone zurück, welche nicht von einer höheren Gefahrenstufe überdeckt werden
    SELECT
        t_id,
        gef_stufe,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        stufe_vorhanden
    LEFT JOIN 
        vorhanden_umgebung
        ON stufe_vorhanden.t_id = vorhanden_umgebung.v_id
),

stufe_gering AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        gk_rutschung
    WHERE 
        gef_stufe = 'gering'
),

stufe_groesser_gering AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        gk_rutschung
    WHERE 
        gef_stufe IN ('mittel', 'erheblich')
),

gering_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        stufe_gering.t_id AS v_id,
        ST_Union(stufe_groesser_gering.geometrie) AS mpoly_umgebung
    FROM
        stufe_gering
    JOIN
        stufe_groesser_gering
        ON ST_Intersects(stufe_gering.geometrie, stufe_groesser_gering.geometrie)
    GROUP BY
        stufe_gering.t_id
),

gering_diff AS ( -- Gibt alle "geringen" Teilpolygone zurück, welche nicht von einer höheren Gefahrenstufe überdeckt werden
    SELECT
        t_id,
        gef_stufe,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
            geometrie
        ) AS res_poly
    FROM
        stufe_gering
    LEFT JOIN 
        gering_umgebung
        ON stufe_gering.t_id = gering_umgebung.v_id
),

stufe_mittel AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        gk_rutschung
    WHERE 
        gef_stufe = 'mittel'
),

stufe_groesser_mittel AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        gk_rutschung
    WHERE 
        gef_stufe IN ('erheblich')
),

mittel_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        stufe_mittel.t_id AS v_id,
        ST_Union(stufe_groesser_mittel.geometrie) AS mpoly_umgebung
    FROM
        stufe_mittel
    JOIN
        stufe_groesser_mittel
        ON ST_Intersects(stufe_mittel.geometrie, stufe_groesser_mittel.geometrie)
    GROUP BY
        stufe_mittel.t_id 
),

mittel_diff AS ( -- Gibt alle "mittel" Teilpolygone zurück, welche nicht von einer höheren Gefahrenstufe überdeckt werden
    SELECT
        t_id,
        gef_stufe,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        stufe_mittel
    LEFT JOIN 
        mittel_umgebung
        ON stufe_mittel.t_id = mittel_umgebung.v_id
),

stufe_erheblich AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie AS geometry
    FROM
        gk_rutschung
    WHERE 
        gef_stufe = 'erheblich'
),

gk_mgdm_rutsch AS (

SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "keine"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    --uuid_generate_v4() AS t_ili_tid,
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'Rutschung' AS prozessa,
    'keine' AS gef_stufe,
    null AS bemerkung
FROM keine_diff
GROUP BY t_id
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "vorhanden"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    --uuid_generate_v4() AS t_ili_tid,
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'Rutschung' AS prozessa,
    'vorhanden' AS gef_stufe,
    null AS bemerkung
FROM vorhanden_diff
GROUP BY t_id
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "gering"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    --uuid_generate_v4() AS t_ili_tid,
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'Rutschung' AS prozessa,
    'gering' AS gef_stufe,
    null AS bemerkung
FROM gering_diff
GROUP BY t_id
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "mittel"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    --uuid_generate_v4() AS t_ili_tid,
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'Rutschung' AS prozessa,
    'mittel' AS gef_stufe,
    null AS bemerkung
FROM mittel_diff
GROUP BY t_id
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "erheblich"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    --uuid_generate_v4() AS t_ili_tid,
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometry))).geom, 0.001)))).geom AS geometrie,
    'Rutschung' AS prozessa,
    'erheblich' AS gef_stufe,
    null AS bemerkung
FROM stufe_erheblich
GROUP BY t_id
),

gk_mgdm_rutsch_parts AS (
SELECT -- nur gültige Geometrien selektieren
    geometrie,
    prozessa,
    gef_stufe,
    bemerkung
FROM gk_mgdm_rutsch 
WHERE ST_GeometryType(geometrie) = 'ST_Polygon'
)

SELECT -- nur gültige Geometrien selektieren
    uuid_generate_v4() AS t_ili_tid,
    geometrie,
    prozessa,
    gef_stufe,
    bemerkung
FROM gk_mgdm_rutsch_parts
WHERE ST_Area(geometrie) > 0.1
;
