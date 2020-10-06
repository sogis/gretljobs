/* Erstellt den Teilprozess Felssturz_Bergsturz für die IK synoptisch MGDM aus dem Layer IK Sturz. 
 * */

WITH

int_fels_bergsturz AS ( -- Besonderheit beim Prozess Bergsturz/Felssturz, es gibt nur starke Intensitaeten (alle Jaehrlichkeiten) oder Intensitaet vorhanden
    SELECT
        t_id,
        int_stufe,
        prozessa AS bez_kanton,
        wkp,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_ik_sturz
    WHERE
        prozessa IN ('Felssturz','Bergsturz')
),


int_felssturz_keine AS ( -- wird für alle Jährlichkeiten aus dem ganzen Perimeter generiert, da oft nicht vorhanden
    SELECT
        t_id,
        'keine' AS int_stufe,
        'Felssturz_Bergsturz' AS bez_kanton,
        geometrie
    FROM
        afu_gefahrenkartierung.gefahrenkartirung_perimeter_gefahrenkartierung
    WHERE
        ik_sturz = true
),

int_felssturz_0_bis_30_gt_keine AS ( -- Jaehrlichkeit 0 - 30 Jahre - keine Intensitaeten 
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_fels_bergsturz
    WHERE
        wkp = 'von_0_bis_30_Jahre'
        AND
        int_stufe IN ('schwach', 'mittel', 'stark')
),

int_felssturz_0_bis_30_keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_felssturz_keine.t_id AS v_id,
        ST_Union(int_felssturz_0_bis_30_gt_keine.geometrie) AS mpoly_umgebung
    FROM
        int_felssturz_keine
    JOIN
        int_felssturz_0_bis_30_gt_keine
        ON ST_Intersects(int_felssturz_keine.geometrie, int_felssturz_0_bis_30_gt_keine.geometrie)
    GROUP BY
        int_felssturz_keine.t_id
),

int_felssturz_0_bis_30_keine_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
            geometrie
        ) AS res_poly
    FROM
        int_felssturz_keine
    LEFT JOIN 
        int_felssturz_0_bis_30_keine_umgebung
        ON int_felssturz_keine.t_id = int_felssturz_0_bis_30_keine_umgebung.v_id
),

int_felssturz_0_bis_30_stark AS ( -- starke Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_fels_bergsturz
    WHERE 
        wkp = 'von_0_bis_30_Jahre'
        AND    
        int_stufe = 'stark'
),


int_felssturz_30_bis_100_gt_keine AS ( -- Jaehrlichkeit 30 - 100 Jahre - keine Intensitaeten
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_fels_bergsturz
    WHERE
        wkp = 'von_30_bis_100_Jahre'
        AND
        int_stufe IN ('schwach', 'mittel', 'stark')
),

int_felssturz_30_bis_100_keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_felssturz_keine.t_id AS v_id,
        ST_Union(int_felssturz_30_bis_100_gt_keine.geometrie) AS mpoly_umgebung
    FROM
        int_felssturz_keine
    JOIN
        int_felssturz_30_bis_100_gt_keine
        ON ST_Intersects(int_felssturz_keine.geometrie, int_felssturz_30_bis_100_gt_keine.geometrie)
    GROUP BY
        int_felssturz_keine.t_id
),

int_felssturz_30_bis_100_keine_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
            geometrie
        ) AS res_poly
    FROM
        int_felssturz_keine
    LEFT JOIN 
        int_felssturz_30_bis_100_keine_umgebung
        ON int_felssturz_keine.t_id = int_felssturz_30_bis_100_keine_umgebung.v_id
),

int_felssturz_30_bis_100_stark AS ( -- starke Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_fels_bergsturz
    WHERE
        wkp = 'von_30_bis_100_Jahre'
        AND    
        int_stufe = 'stark'
),

int_felssturz_100_bis_300_gt_keine AS ( -- Jaehrlichkeit 100 - 300 Jahre - keine Intensitaeten
    SELECT
        t_id,
        int_stufe,
        geometrie
    FROM
        int_fels_bergsturz
    WHERE
        wkp = 'von_100_bis_300_Jahre'
        AND
        int_stufe IN ('schwach', 'mittel', 'stark')
),

int_felssturz_100_bis_300_keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_felssturz_keine.t_id AS v_id,
        ST_Union(int_felssturz_100_bis_300_gt_keine.geometrie) AS mpoly_umgebung
    FROM
        int_felssturz_keine
    JOIN
        int_felssturz_100_bis_300_gt_keine
        ON ST_Intersects(int_felssturz_keine.geometrie, int_felssturz_100_bis_300_gt_keine.geometrie)
    GROUP BY
        int_felssturz_keine.t_id
),

int_felssturz_100_bis_300_keine_diff AS ( -- Gibt alle "vorhanden" Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
            geometrie
        ) AS res_poly
    FROM
        int_felssturz_keine
    LEFT JOIN 
        int_felssturz_100_bis_300_keine_umgebung
        ON int_felssturz_keine.t_id = int_felssturz_100_bis_300_keine_umgebung.v_id
),

int_felssturz_100_bis_300_stark AS ( -- starke Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_fels_bergsturz
    WHERE 
        wkp = 'von_100_bis_300_Jahre'
        AND    
        int_stufe = 'stark'
), 

int_felssturz_groesser_300_gt_keine AS ( -- Jaehrlichkeit groesser 300 Jahre - keine Intensitaeten
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_fels_bergsturz
    WHERE
        wkp = 'groesser_300_Jahre'
        AND
        int_stufe IN ('vorhanden')
),

int_felssturz_groesser_300_keine_umgebung AS ( -- Gibt die umgebenden Polygone als homogenisiertes Polygon zurück
    SELECT
        int_felssturz_keine.t_id AS v_id,
        ST_Union(int_felssturz_groesser_300_gt_keine.geometrie) AS mpoly_umgebung
    FROM
        int_felssturz_keine
    JOIN
        int_felssturz_groesser_300_gt_keine
        ON ST_Intersects(int_felssturz_keine.geometrie, int_felssturz_groesser_300_gt_keine.geometrie)
    GROUP BY
        int_felssturz_keine.t_id
),

int_felssturz_groesser_300_keine_diff AS ( -- Gibt alle Teilpolygone zurück, welche nicht von einer höheren Intensität überdeckt werden
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        COALESCE(
            ST_Difference(geometrie, mpoly_umgebung),
            geometrie
        ) AS res_poly
    FROM
        int_felssturz_keine
    LEFT JOIN 
        int_felssturz_groesser_300_keine_umgebung
        ON int_felssturz_keine.t_id = int_felssturz_groesser_300_keine_umgebung.v_id
),

int_felssturz_groesser_300_vorhanden AS ( -- vorhandene Intensitaeten (Restgefaehrdung)
    SELECT
        t_id,
        int_stufe,
        bez_kanton,
        geometrie
    FROM
        int_fels_bergsturz
    WHERE
        wkp = 'groesser_300_Jahre'
        AND
        int_stufe = 'vorhanden'
),

ik_syn_mgdm AS (

SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "keine"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'keine' AS int_stufe,
    'von_0_bis_30_Jahre' AS wkp,
    'Felssturz_Bergsturz' AS teilproz,
    bez_kanton,
    null AS bemerkung
FROM int_felssturz_0_bis_30_keine_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "stark"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometrie))).geom, 0.001)))).geom AS geometrie,
    'stark' AS int_stufe,
    'von_0_bis_30_Jahre' AS wkp,
    'Felssturz_Bergsturz' AS teilproz,
    bez_kanton,    
    null AS bemerkung
FROM int_felssturz_0_bis_30_stark
GROUP BY bez_kanton

UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "keine"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'keine' AS int_stufe,
    'von_30_bis_100_Jahre' AS wkp,
    'Felssturz_Bergsturz' AS teilproz,
    bez_kanton,
    null AS bemerkung
FROM int_felssturz_30_bis_100_keine_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "stark"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometrie))).geom, 0.001)))).geom AS geometrie,
    'stark' AS int_stufe,
    'von_30_bis_100_Jahre' AS wkp,
    'Felssturz_Bergsturz' AS teilproz,
    bez_kanton,    
    null AS bemerkung
FROM int_felssturz_30_bis_100_stark
GROUP BY bez_kanton

UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "keine"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'keine' AS int_stufe,
    'von_100_bis_300_Jahre' AS wkp,
    'Felssturz_Bergsturz' AS teilproz,
    bez_kanton,
    null AS bemerkung
FROM int_felssturz_100_bis_300_keine_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "stark"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometrie))).geom, 0.001)))).geom AS geometrie,
    'stark' AS int_stufe,
    'von_100_bis_300_Jahre' AS wkp,
    'Felssturz_Bergsturz' AS teilproz,
    bez_kanton,    
    null AS bemerkung
FROM int_felssturz_100_bis_300_stark
GROUP BY bez_kanton

UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "stark"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(res_poly))).geom, 0.001)))).geom AS geometrie,
    'keine' AS int_stufe,
    'groesser_300_Jahre' AS wkp,
    'Felssturz_Bergsturz' AS teilproz,
    bez_kanton,    
    null AS bemerkung
FROM int_felssturz_groesser_300_keine_diff
GROUP BY bez_kanton
UNION ALL
SELECT -- Union, damit allfällige Ueberlappungen innerhalb der "stark"-Flächen entfernt werden. Dump, damit das Endresultat nicht ein Monster-Multipolygon ist.
    (ST_Dump(ST_MakeValid(ST_SnapToGrid((ST_Dump(ST_Union(geometrie))).geom, 0.001)))).geom AS geometrie,
    'vorhanden' AS int_stufe,
    'groesser_300_Jahre' AS wkp,
    'Felssturz_Bergsturz' AS teilproz,
    bez_kanton,    
    null AS bemerkung
FROM int_felssturz_groesser_300_vorhanden
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
