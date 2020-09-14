/* Erstellt den Teilprozess kontinuierliche Rutschung für die IK synoptisch MGDM aus dem Layer IK Rutsch_kont_Sackung. 
 * */

WITH

int_rutsch_kont AS (
    SELECT
        t_id,
        int_stufe,
        'Rutsch_kont, Sackung' AS bez_kanton,
        '' AS wkp,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_ik_rutsch_kont_sackung
),


int_rutsch_kont_keine AS ( -- wird für alle Jährlichkeiten aus dem ganzen Perimeter generiert, da oft nicht vorhanden
    SELECT
        t_id,
        '' AS int_stufe,
        'Rutsch_kont, Sackung' AS bez_kanton,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_perimeter_gefahrenkartierung
    WHERE
        ik_ru_kont = true
),

int_rutsch_kont_gt_keine AS ( -- keine Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_kont
    WHERE
        int_stufe IN ('schwach', 'mittel', 'stark')
),

int_rutsch_kont_keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_kont_keine.t_id AS v_id,
        ST_Union(int_rutsch_kont_gt_keine.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_kont_keine
    JOIN
        int_rutsch_kont_gt_keine
        ON ST_Intersects(int_rutsch_kont_keine.geometrie, int_rutsch_kont_gt_keine.geometrie)
    GROUP BY
        int_rutsch_kont_keine.t_id
),

int_rutsch_kont_keine_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_kont_keine
    LEFT JOIN 
        int_rutsch_kont_keine_umgebung
        ON int_rutsch_kont_keine.t_id = int_rutsch_kont_keine_umgebung.v_id
),

int_rutsch_kont_schwach AS ( -- schwache Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_kont
    WHERE
        int_stufe IN ('schwach')
),

int_rutsch_kont_gt_schwach AS (
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_rutsch_kont
    WHERE
        int_stufe IN ('mittel', 'stark')
),

int_rutsch_kont_schwach_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_kont_schwach.t_id AS v_id,
        ST_Union(int_rutsch_kont_gt_schwach.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_kont_schwach
    JOIN
        int_rutsch_kont_gt_schwach
        ON ST_Intersects(int_rutsch_kont_schwach.geometrie, int_rutsch_kont_gt_schwach.geometrie)
    GROUP BY
        int_rutsch_kont_schwach.t_id
),

int_rutsch_kont_schwach_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_kont_schwach
    LEFT JOIN
        int_rutsch_kont_schwach_umgebung
        ON int_rutsch_kont_schwach.t_id = int_rutsch_kont_schwach_umgebung.v_id
),

int_rutsch_kont_mittel AS ( -- mittlere Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_kont
    WHERE
        int_stufe IN ('mittel')
),

int_rutsch_kont_gt_mittel AS (
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_rutsch_kont
    WHERE
        int_stufe IN ('stark')
),

int_rutsch_kont_mittel_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_kont_mittel.t_id AS v_id,
        ST_Union(int_rutsch_kont_gt_mittel.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_kont_mittel
    JOIN
        int_rutsch_kont_gt_mittel
        ON ST_Intersects(int_rutsch_kont_mittel.geometrie, int_rutsch_kont_gt_mittel.geometrie)
    GROUP BY
        int_rutsch_kont_mittel.t_id
),

int_rutsch_kont_mittel_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_kont_mittel
    LEFT JOIN 
        int_rutsch_kont_mittel_umgebung
        ON int_rutsch_kont_mittel.t_id = int_rutsch_kont_mittel_umgebung.v_id
),

int_rutsch_kont_stark AS ( -- starke Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_kont
    WHERE 
        int_stufe = 'stark'
),

ik_syn_mgdm AS (

SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "keine"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'keine' AS int_stufe,
    '' AS wkp,
    'permanente_Rutschung' AS teilproz,
    bez_kanton,
    '' AS bemerkung
FROM int_rutsch_kont_keine_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "schwach"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'schwach' AS int_stufe,
    '' AS wkp,
    'permanente_Rutschung' AS teilproz,
    bez_kanton,
    '' AS bemerkung
FROM int_rutsch_kont_schwach_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "mittel"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'mittel' AS int_stufe,
    '' AS wkp,
    'permanente_Rutschung' AS teilproz,
    bez_kanton,
    '' AS bemerkung
FROM int_rutsch_kont_mittel_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "stark"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometrie))).geom, 0.001)))).geom AS geometrie,
    'stark' AS int_stufe,
    '' AS wkp,
    'permanente_Rutschung' AS teilproz,
    bez_kanton,
    '' AS bemerkung
FROM int_rutsch_kont_stark
GROUP BY bez_kanton
),

ik_syn_mgdm_parts AS (
SELECT -- nur gültige Geometrien selektieren
    geometrie,
    int_stufe,
    wkp,
    teilproz,
    bez_kanton,
    bemerkung
FROM ik_syn_mgdm
WHERE ST_GeometryType(geometrie) = 'ST_Polygon'
)

SELECT -- nur gültige Geometrien selektieren
    uuid_generate_v4() AS t_ili_tid,
    geometrie,
    int_stufe,
    wkp,
    teilproz,
    bez_kanton,
    bemerkung
FROM ik_syn_mgdm_parts
WHERE ST_Area(geometrie) > 0.1
;
