/* Erstellt den Teilprozess Einsturz_Absenkung für die IK synoptisch MGDM aus dem Layer IK Absenkung_Einsturz. 
 * */

WITH

int_absenkung AS (  -- es gibt bei Absenkung/Einsturz-Flaechen nur mittlere Intensitäten (alle Jährlichkeiten ohne Restgefaehrdung)
    SELECT
        t_id,
        int_stufe,
        'Absenkung_Einsturz' AS bez_kanton,
        wkp,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_ik_absenkung_einsturz
),

int_absenkung_keine AS ( -- wird für alle Jährlichkeiten aus dem ganzen Perimeter generiert, da oft nicht vorhanden
    SELECT
        t_id,
        'keine' AS int_stufe,
        'Absenkung_Einsturz' AS bez_kanton,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_perimeter_gefahrenkartierung
    WHERE
        ik_abs_ein = true    
),

int_absenkung_0_bis_30_gt_keine AS ( -- Jaehrlichkeit 0 - 30 Jahre - keine Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_absenkung
    WHERE
        wkp = 'von_0_bis_30_Jahre'
        AND
        int_stufe IN ('mittel')
),

int_absenkung_0_bis_30_keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_absenkung_keine.t_id AS v_id,
        ST_Union(int_absenkung_0_bis_30_gt_keine.geometrie) AS mpoly_umgebung
    FROM
        int_absenkung_keine
    JOIN
        int_absenkung_0_bis_30_gt_keine
        ON ST_Intersects(int_absenkung_keine.geometrie, int_absenkung_0_bis_30_gt_keine.geometrie)
    GROUP BY
        int_absenkung_keine.t_id 
),

int_absenkung_0_bis_30_keine_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_absenkung_keine
    LEFT JOIN 
        int_absenkung_0_bis_30_keine_umgebung
        ON int_absenkung_keine.t_id = int_absenkung_0_bis_30_keine_umgebung.v_id
),

int_absenkung_0_bis_30_mittel AS ( -- mittlere Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_absenkung
    WHERE
        wkp = 'von_0_bis_30_Jahre'
        AND
        int_stufe IN ('mittel')
),

int_absenkung_30_bis_100_gt_keine AS ( -- Jaehrlichkeit 30 - 100 Jahre - keine Intensitaeten
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_absenkung
    WHERE
        wkp = 'von_30_bis_100_Jahre'
        AND
        int_stufe IN ('mittel')
),

int_absenkung_30_bis_100_keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_absenkung_keine.t_id AS v_id,
        ST_Union(int_absenkung_30_bis_100_gt_keine.geometrie) AS mpoly_umgebung
    FROM
        int_absenkung_keine
    JOIN
        int_absenkung_30_bis_100_gt_keine
        ON ST_Intersects(int_absenkung_keine.geometrie, int_absenkung_30_bis_100_gt_keine.geometrie)
    GROUP BY
        int_absenkung_keine.t_id 
),

int_absenkung_30_bis_100_keine_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_absenkung_keine
    LEFT JOIN 
        int_absenkung_30_bis_100_keine_umgebung
        ON int_absenkung_keine.t_id = int_absenkung_30_bis_100_keine_umgebung.v_id
),

int_absenkung_30_bis_100_mittel AS ( -- mittlere Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_absenkung
    WHERE
        wkp = 'von_30_bis_100_Jahre'
        AND
        int_stufe IN ('mittel')
),

int_absenkung_100_bis_300_gt_keine AS ( -- Jaehrlichkeit 100 - 300 Jahre - keine Intensitaeten
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_absenkung
    WHERE
        wkp = 'von_100_bis_300_Jahre'
        AND
        int_stufe IN ('mittel')
),

int_absenkung_100_bis_300_keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_absenkung_keine.t_id AS v_id,
        ST_Union(int_absenkung_100_bis_300_gt_keine.geometrie) AS mpoly_umgebung
    FROM
        int_absenkung_keine
    JOIN
        int_absenkung_100_bis_300_gt_keine
        ON ST_Intersects(int_absenkung_keine.geometrie, int_absenkung_100_bis_300_gt_keine.geometrie)
    GROUP BY
        int_absenkung_keine.t_id 
),

int_absenkung_100_bis_300_keine_diff AS ( -- Gibt alle "vorhanden" Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
             geometrie
        ) AS res_poly
    FROM
        int_absenkung_keine
    LEFT JOIN 
        int_absenkung_100_bis_300_keine_umgebung
        ON int_absenkung_keine.t_id = int_absenkung_100_bis_300_keine_umgebung.v_id
),

int_absenkung_100_bis_300_mittel AS ( -- mittlere Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_absenkung
    WHERE
        wkp = 'von_100_bis_300_Jahre'
        AND
        int_stufe IN ('mittel')
),

ik_syn_mgdm AS (

SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "keine"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'keine' AS int_stufe,
    'von_0_bis_30_Jahre' AS wkp,
    'Einsturz_Absenkung' AS teilproz,
    bez_kanton,
    '' AS bemerkung
FROM int_absenkung_0_bis_30_keine_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "mittel"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometrie))).geom, 0.001)))).geom AS geometrie,
    'mittel' AS int_stufe,
    'von_0_bis_30_Jahre' AS wkp,    
    'Einsturz_Absenkung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung    
FROM int_absenkung_0_bis_30_mittel
GROUP BY bez_kanton

UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "keine"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'keine' AS int_stufe,
    'von_30_bis_100_Jahre' AS wkp,
    'Einsturz_Absenkung' AS teilproz,
    bez_kanton,
    '' AS bemerkung
FROM int_absenkung_30_bis_100_keine_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "mittel"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometrie))).geom, 0.001)))).geom AS geometrie,
    'mittel' AS int_stufe,
    'von_30_bis_100_Jahre' AS wkp,    
    'Einsturz_Absenkung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung    
FROM int_absenkung_30_bis_100_mittel
GROUP BY bez_kanton

UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "keine"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'keine' AS int_stufe,
    'von_100_bis_300_Jahre' AS wkp,
    'Einsturz_Absenkung' AS teilproz,
    bez_kanton,
    '' AS bemerkung
FROM int_absenkung_100_bis_300_keine_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "mittel"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometrie))).geom, 0.001)))).geom AS geometrie,
    'mittel' AS int_stufe,
    'von_100_bis_300_Jahre' AS wkp,    
    'Einsturz_Absenkung' AS teilproz,
    bez_kanton,    
    '' AS bemerkung    
FROM int_absenkung_100_bis_300_mittel
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

