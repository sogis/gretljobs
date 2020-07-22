/* Erstellt die GK synoptisch aus den Prozessgefahrenkarten.
 * */

WITH

gk_all AS (
    SELECT
        t_id,
        gef_stufe,
        aindex,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_gk_wasser
    WHERE
        publiziert = true
    UNION ALL
    SELECT
        t_id,
        gef_stufe,
        aindex,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_gk_sturz
    WHERE
        publiziert = true
    UNION ALL
    SELECT
        t_id,
        gef_stufe,
        aindex,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_gk_hangmure
    WHERE
        publiziert = true
    UNION ALL
    SELECT
        t_id,
        gef_stufe,
        aindex,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_gk_absenkung_einsturz
    WHERE
        publiziert = true
    UNION ALL
    SELECT
        t_id,
        gef_stufe,
        aindex,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_kont_sackung
    WHERE
        publiziert = true
    UNION ALL
    SELECT
        t_id,
        gef_stufe,
        aindex,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_spontan
    WHERE
        publiziert = true
),

stufe_vorhanden AS (
    SELECT
        t_id,
        gef_stufe,
        aindex,
        geometrie
    FROM
        gk_all
    WHERE
        gef_stufe = 'vorhanden'
),

stufe_groesser_vorhanden AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        gk_all
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
        aindex,
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
        aindex,
        geometrie
    FROM
        gk_all
    WHERE
        gef_stufe = 'gering'
),

stufe_groesser_gering AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        gk_all
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
        aindex,
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
        aindex,
        geometrie
    FROM
        gk_all
    WHERE
        gef_stufe = 'mittel'
),

stufe_groesser_mittel AS (
    SELECT
        t_id,
        gef_stufe,
        geometrie
    FROM
        gk_all
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
        aindex,
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
        aindex,
        geometrie AS geometry
    FROM
        gk_all
    WHERE
        gef_stufe = 'erheblich'
),

gk_syn_gen AS (

SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "vorhanden"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)) AS geometrie,
    'vorhanden' AS gef_stufe,
    aindex
FROM vorhanden_diff
GROUP BY t_id, aindex
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "gering"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)) AS geometrie,
    'gering' AS gef_stufe,
    aindex
FROM gering_diff
GROUP BY t_id, aindex
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "mittel"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)) AS geometrie,
    'mittel' AS gef_stufe,
    aindex
FROM mittel_diff
GROUP BY t_id, aindex

UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "erheblich"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometry))).geom, 0.001)) AS geometrie,
    'erheblich' AS gef_stufe,
    aindex
FROM stufe_erheblich
GROUP BY t_id, aindex
),

gk_syn_gen_parts AS (
SELECT -- nur gültige Geometrien selektieren
    geometrie,
    gef_stufe,
    aindex
FROM gk_syn_gen
WHERE ST_GeometryType(geometrie) = 'ST_Polygon'
)

SELECT -- nur gültige Geometrien selektieren
    uuid_generate_v4() AS t_ili_tid,
    geometrie,
    gef_stufe,
    aindex
FROM gk_syn_gen_parts
WHERE ST_Area(geometrie) > 0.1
;
