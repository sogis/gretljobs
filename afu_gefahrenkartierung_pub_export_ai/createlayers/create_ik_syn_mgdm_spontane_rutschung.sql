/* Erstellt den Teilprozess spontane Rutschung für die IK synoptisch MGDM aus dem Layer IK Rutsch_spontan 
 * */

WITH

int_rutsch_spontan AS (
    SELECT
        t_id,
        int_stufe,
        'Rutsch_spontan' AS bez_kanton,
        wkp,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_ik_rutsch_spontan
),


int_rutsch_spontan_keine AS ( -- wird für alle Jährlichkeiten aus dem ganzen Perimeter generiert, da oft nicht vorhanden
    SELECT
        t_id,
        'keine' AS int_stufe,
        'Rutsch_spontan' AS bez_kanton,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_perimeter_gefahrenkartierung
    WHERE
        ik_ru_spon = true    
),

int_rutsch_spontan_0_bis_30_gt_keine AS ( -- Jaehrlichkeit 0 - 30 Jahre - keine Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_0_bis_30_Jahre'
        AND
        int_stufe IN ('schwach', 'mittel', 'stark')
),

int_rutsch_spontan_0_bis_30_keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_spontan_keine.t_id AS v_id,
        ST_Union(int_rutsch_spontan_0_bis_30_gt_keine.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_spontan_keine
    JOIN
        int_rutsch_spontan_0_bis_30_gt_keine
        ON ST_Intersects(int_rutsch_spontan_keine.geometrie, int_rutsch_spontan_0_bis_30_gt_keine.geometrie)
    GROUP BY
        int_rutsch_spontan_keine.t_id 
),

int_rutsch_spontan_0_bis_30_keine_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_spontan_keine
    LEFT JOIN 
        int_rutsch_spontan_0_bis_30_keine_umgebung
        ON int_rutsch_spontan_keine.t_id = int_rutsch_spontan_0_bis_30_keine_umgebung.v_id
),

int_rutsch_spontan_0_bis_30_schwach AS ( -- schwache Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,        
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_0_bis_30_Jahre'
        AND
        int_stufe IN ('schwach')
),

int_rutsch_spontan_0_bis_30_gt_schwach AS (
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_0_bis_30_Jahre'
        AND
        int_stufe IN ('mittel', 'stark')
),

int_rutsch_spontan_0_bis_30_schwach_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_spontan_0_bis_30_schwach.t_id AS v_id,
        ST_Union(int_rutsch_spontan_0_bis_30_gt_schwach.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_spontan_0_bis_30_schwach
    JOIN
        int_rutsch_spontan_0_bis_30_gt_schwach
        ON ST_Intersects(int_rutsch_spontan_0_bis_30_schwach.geometrie, int_rutsch_spontan_0_bis_30_gt_schwach.geometrie)
    GROUP BY
        int_rutsch_spontan_0_bis_30_schwach.t_id 
),

int_rutsch_spontan_0_bis_30_schwach_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_spontan_0_bis_30_schwach
    LEFT JOIN 
        int_rutsch_spontan_0_bis_30_schwach_umgebung
        ON int_rutsch_spontan_0_bis_30_schwach.t_id = int_rutsch_spontan_0_bis_30_schwach_umgebung.v_id
),

int_rutsch_spontan_0_bis_30_mittel AS ( -- mittlere Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_0_bis_30_Jahre'
        AND
        int_stufe IN ('mittel')
),

int_rutsch_spontan_0_bis_30_gt_mittel AS (
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_0_bis_30_Jahre'
        AND
        int_stufe IN ('stark')
),

int_rutsch_spontan_0_bis_30_mittel_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_spontan_0_bis_30_mittel.t_id AS v_id,
        ST_Union(int_rutsch_spontan_0_bis_30_gt_mittel.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_spontan_0_bis_30_mittel
    JOIN
        int_rutsch_spontan_0_bis_30_gt_mittel
        ON ST_Intersects(int_rutsch_spontan_0_bis_30_mittel.geometrie, int_rutsch_spontan_0_bis_30_gt_mittel.geometrie)
    GROUP BY
        int_rutsch_spontan_0_bis_30_mittel.t_id 
),

int_rutsch_spontan_0_bis_30_mittel_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_spontan_0_bis_30_mittel
    LEFT JOIN 
        int_rutsch_spontan_0_bis_30_mittel_umgebung
        ON int_rutsch_spontan_0_bis_30_mittel.t_id = int_rutsch_spontan_0_bis_30_mittel_umgebung.v_id
),

int_rutsch_spontan_0_bis_30_stark AS ( -- starke Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE 
        wkp = 'von_0_bis_30_Jahre'
        AND    
        int_stufe = 'stark'    
),


int_rutsch_spontan_30_bis_100_gt_keine AS ( -- Jaehrlichkeit 30 - 100 Jahre - keine Intensitaeten
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_30_bis_100_Jahre'
        AND
        int_stufe IN ('schwach', 'mittel', 'stark')
),

int_rutsch_spontan_30_bis_100_keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_spontan_keine.t_id AS v_id,
        ST_Union(int_rutsch_spontan_30_bis_100_gt_keine.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_spontan_keine
    JOIN
        int_rutsch_spontan_30_bis_100_gt_keine
        ON ST_Intersects(int_rutsch_spontan_keine.geometrie, int_rutsch_spontan_30_bis_100_gt_keine.geometrie)
    GROUP BY
        int_rutsch_spontan_keine.t_id 
),

int_rutsch_spontan_30_bis_100_keine_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_spontan_keine
    LEFT JOIN 
        int_rutsch_spontan_30_bis_100_keine_umgebung
        ON int_rutsch_spontan_keine.t_id = int_rutsch_spontan_30_bis_100_keine_umgebung.v_id
),

int_rutsch_spontan_30_bis_100_schwach AS ( -- schwache Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,        
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_30_bis_100_Jahre'
        AND
        int_stufe IN ('schwach')
),

int_rutsch_spontan_30_bis_100_gt_schwach AS (
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_30_bis_100_Jahre'
        AND
        int_stufe IN ('mittel', 'stark')
),

int_rutsch_spontan_30_bis_100_schwach_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_spontan_30_bis_100_schwach.t_id AS v_id,
        ST_Union(int_rutsch_spontan_30_bis_100_gt_schwach.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_spontan_30_bis_100_schwach
    JOIN
        int_rutsch_spontan_30_bis_100_gt_schwach
        ON ST_Intersects(int_rutsch_spontan_30_bis_100_schwach.geometrie, int_rutsch_spontan_30_bis_100_gt_schwach.geometrie)
    GROUP BY
        int_rutsch_spontan_30_bis_100_schwach.t_id 
),

int_rutsch_spontan_30_bis_100_schwach_diff AS ( -- Gibt alle "vorhanden" Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_spontan_30_bis_100_schwach
    LEFT JOIN 
        int_rutsch_spontan_30_bis_100_schwach_umgebung
        ON int_rutsch_spontan_30_bis_100_schwach.t_id = int_rutsch_spontan_30_bis_100_schwach_umgebung.v_id
),

int_rutsch_spontan_30_bis_100_mittel AS ( -- mittlere Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_30_bis_100_Jahre'
        AND
        int_stufe IN ('mittel')
),

int_rutsch_spontan_30_bis_100_gt_mittel AS (
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_30_bis_100_Jahre'
        AND
        int_stufe IN ('stark')
),

int_rutsch_spontan_30_bis_100_mittel_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_spontan_30_bis_100_mittel.t_id AS v_id,
        ST_Union(int_rutsch_spontan_30_bis_100_gt_mittel.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_spontan_30_bis_100_mittel
    JOIN
        int_rutsch_spontan_30_bis_100_gt_mittel
        ON ST_Intersects(int_rutsch_spontan_30_bis_100_mittel.geometrie, int_rutsch_spontan_30_bis_100_gt_mittel.geometrie)
    GROUP BY
        int_rutsch_spontan_30_bis_100_mittel.t_id 
),

int_rutsch_spontan_30_bis_100_mittel_diff AS ( -- Gibt alle "vorhanden" Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_spontan_30_bis_100_mittel
    LEFT JOIN 
        int_rutsch_spontan_30_bis_100_mittel_umgebung
        ON int_rutsch_spontan_30_bis_100_mittel.t_id = int_rutsch_spontan_30_bis_100_mittel_umgebung.v_id
),

int_rutsch_spontan_30_bis_100_stark AS ( -- starke Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_30_bis_100_Jahre'
        AND    
        int_stufe = 'stark'    
),

int_rutsch_spontan_100_bis_300_gt_keine AS ( -- Jaehrlichkeit 100 - 300 Jahre - keine Intensitaeten
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_100_bis_300_Jahre'
        AND
        int_stufe IN ('schwach', 'mittel', 'stark')
),

int_rutsch_spontan_100_bis_300_keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_spontan_keine.t_id AS v_id,
        ST_Union(int_rutsch_spontan_100_bis_300_gt_keine.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_spontan_keine
    JOIN
        int_rutsch_spontan_100_bis_300_gt_keine
        ON ST_Intersects(int_rutsch_spontan_keine.geometrie, int_rutsch_spontan_100_bis_300_gt_keine.geometrie)
    GROUP BY
        int_rutsch_spontan_keine.t_id 
),

int_rutsch_spontan_100_bis_300_keine_diff AS ( -- Gibt alle "vorhanden" Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_spontan_keine
    LEFT JOIN 
        int_rutsch_spontan_100_bis_300_keine_umgebung
        ON int_rutsch_spontan_keine.t_id = int_rutsch_spontan_100_bis_300_keine_umgebung.v_id
),

int_rutsch_spontan_100_bis_300_schwach AS ( -- schwache Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_100_bis_300_Jahre'
        AND
        int_stufe IN ('schwach')
),

int_rutsch_spontan_100_bis_300_gt_schwach AS (
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_100_bis_300_Jahre'
        AND
        int_stufe IN ('mittel', 'stark')
),

int_rutsch_spontan_100_bis_300_schwach_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_spontan_100_bis_300_schwach.t_id AS v_id,
        ST_Union(int_rutsch_spontan_100_bis_300_gt_schwach.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_spontan_100_bis_300_schwach
    JOIN
        int_rutsch_spontan_100_bis_300_gt_schwach
        ON ST_Intersects(int_rutsch_spontan_100_bis_300_schwach.geometrie, int_rutsch_spontan_100_bis_300_gt_schwach.geometrie)
    GROUP BY
        int_rutsch_spontan_100_bis_300_schwach.t_id 
),

int_rutsch_spontan_100_bis_300_schwach_diff AS ( -- Gibt alle "vorhanden" Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_spontan_100_bis_300_schwach
    LEFT JOIN 
        int_rutsch_spontan_100_bis_300_schwach_umgebung
        ON int_rutsch_spontan_100_bis_300_schwach.t_id = int_rutsch_spontan_100_bis_300_schwach_umgebung.v_id
),

int_rutsch_spontan_100_bis_300_mittel AS ( -- mittlere Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_100_bis_300_Jahre'
        AND
        int_stufe IN ('mittel')
),

int_rutsch_spontan_100_bis_300_gt_mittel AS (
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE
        wkp = 'von_100_bis_300_Jahre'
        AND
        int_stufe IN ('stark')
),

int_rutsch_spontan_100_bis_300_mittel_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_rutsch_spontan_100_bis_300_mittel.t_id AS v_id,
        ST_Union(int_rutsch_spontan_100_bis_300_gt_mittel.geometrie) AS mpoly_umgebung
    FROM
        int_rutsch_spontan_100_bis_300_mittel
    JOIN
        int_rutsch_spontan_100_bis_300_gt_mittel
        ON ST_Intersects(int_rutsch_spontan_100_bis_300_mittel.geometrie, int_rutsch_spontan_100_bis_300_gt_mittel.geometrie)
    GROUP BY
        int_rutsch_spontan_100_bis_300_mittel.t_id 
),

int_rutsch_spontan_100_bis_300_mittel_diff AS ( -- Gibt alle "vorhanden" Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_rutsch_spontan_100_bis_300_mittel
    LEFT JOIN 
        int_rutsch_spontan_100_bis_300_mittel_umgebung
        ON int_rutsch_spontan_100_bis_300_mittel.t_id = int_rutsch_spontan_100_bis_300_mittel_umgebung.v_id
),

int_rutsch_spontan_100_bis_300_stark AS ( -- starke Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_rutsch_spontan
    WHERE 
        wkp = 'von_100_bis_300_Jahre'
        AND    
        int_stufe = 'stark'    
),

ik_syn_mgdm AS (

SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "keine"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'keine' AS int_stufe,
    'von_0_bis_30_Jahre' AS wkp,
    'spontane_Rutschung' AS teilproz,
    bez_kanton,
    '' AS bemerkung
FROM int_rutsch_spontan_0_bis_30_keine_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "schwach"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'schwach' AS int_stufe,
    'von_0_bis_30_Jahre' AS wkp,    
    'spontane_Rutschung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung
FROM int_rutsch_spontan_0_bis_30_schwach_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "mittel"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'mittel' AS int_stufe,
    'von_0_bis_30_Jahre' AS wkp,    
    'spontane_Rutschung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung    
FROM int_rutsch_spontan_0_bis_30_mittel_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "stark"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometrie))).geom, 0.001)))).geom AS geometrie,
    'stark' AS int_stufe,
    'von_0_bis_30_Jahre' AS wkp,
    'spontane_Rutschung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung
FROM int_rutsch_spontan_0_bis_30_stark
GROUP BY bez_kanton

UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "keine"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'keine' AS int_stufe,
    'von_30_bis_100_Jahre' AS wkp,
    'spontane_Rutschung' AS teilproz,
    bez_kanton,
    '' AS bemerkung
FROM int_rutsch_spontan_30_bis_100_keine_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "schwach"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'schwach' AS int_stufe,
    'von_30_bis_100_Jahre' AS wkp,    
    'spontane_Rutschung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung
FROM int_rutsch_spontan_30_bis_100_schwach_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "mittel"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'mittel' AS int_stufe,
    'von_30_bis_100_Jahre' AS wkp,    
    'spontane_Rutschung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung    
FROM int_rutsch_spontan_30_bis_100_mittel_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "stark"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometrie))).geom, 0.001)))).geom AS geometrie,
    'stark' AS int_stufe,
    'von_30_bis_100_Jahre' AS wkp,
    'spontane_Rutschung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung
FROM int_rutsch_spontan_30_bis_100_stark
GROUP BY bez_kanton

UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "keine"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'keine' AS int_stufe,
    'von_100_bis_300_Jahre' AS wkp,
    'spontane_Rutschung' AS teilproz,
    bez_kanton,
    '' AS bemerkung
FROM int_rutsch_spontan_100_bis_300_keine_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "schwach"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'schwach' AS int_stufe,
    'von_100_bis_300_Jahre' AS wkp,    
    'spontane_Rutschung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung
FROM int_rutsch_spontan_100_bis_300_schwach_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "mittel"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'mittel' AS int_stufe,
    'von_100_bis_300_Jahre' AS wkp,    
    'spontane_Rutschung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung    
FROM int_rutsch_spontan_100_bis_300_mittel_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "stark"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometrie))).geom, 0.001)))).geom AS geometrie,
    'stark' AS int_stufe,
    'von_100_bis_300_Jahre' AS wkp,
    'spontane_Rutschung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung
FROM int_rutsch_spontan_100_bis_300_stark
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
