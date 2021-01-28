WITH aimport AS
(
    SELECT
        max(importdate) AS importdate, dataset
    FROM
        agi_lro_auflage.t_ili2db_import
    GROUP BY
        dataset
),
einzelobjekt_flaeche AS
(
    SELECT
        DISTINCT ON (einzelobjekt.t_id)    
        einzelobjekt.t_id,
        einzelobjekt.entstehung,
        split_part(einzelobjekt.art,'.',array_upper(string_to_array(einzelobjekt.art,'.'), 1)) AS art_txt,
        nachfuehrung.gueltigereintrag AS nachfuehrung
    FROM
        agi_lro_auflage.einzelobjekte_flaechenelement AS flaeche
        LEFT JOIN agi_lro_auflage.einzelobjekte_einzelobjekt AS einzelobjekt
            ON flaeche.flaechenelement_von = einzelobjekt.t_id
        LEFT JOIN agi_lro_auflage.einzelobjekte_eonachfuehrung AS nachfuehrung
            ON einzelobjekt.entstehung = nachfuehrung.t_id
),
einzelobjekt_linie AS
(
    SELECT
        DISTINCT ON (einzelobjekt.t_id)
        einzelobjekt.t_id,
        einzelobjekt.entstehung,
        split_part(einzelobjekt.art,'.',array_upper(string_to_array(einzelobjekt.art,'.'), 1)) AS art_txt,
        nachfuehrung.gueltigereintrag AS nachfuehrung
    FROM
        agi_lro_auflage.einzelobjekte_linienelement AS linie
        LEFT JOIN agi_lro_auflage.einzelobjekte_einzelobjekt AS einzelobjekt
            ON linie.linienelement_von = einzelobjekt.t_id
        LEFT JOIN agi_lro_auflage.einzelobjekte_eonachfuehrung AS nachfuehrung
            ON einzelobjekt.entstehung = nachfuehrung.t_id
),
einzelobjekt_punkt AS
(
    SELECT
        DISTINCT ON (einzelobjekt.t_id)
        einzelobjekt.t_id,
        einzelobjekt.entstehung,
        split_part(einzelobjekt.art,'.',array_upper(string_to_array(einzelobjekt.art,'.'), 1)) AS art_txt,
        nachfuehrung.gueltigereintrag AS nachfuehrung
    FROM
        agi_lro_auflage.einzelobjekte_punktelement AS punkt
        LEFT JOIN agi_lro_auflage.einzelobjekte_einzelobjekt AS einzelobjekt
            ON punkt.punktelement_von = einzelobjekt.t_id
        LEFT JOIN agi_lro_auflage.einzelobjekte_eonachfuehrung AS nachfuehrung
            ON einzelobjekt.entstehung = nachfuehrung.t_id
),
einzelobjekt_position AS
(
    SELECT
        objekt.objektname_von,
        objekt.aname AS objektname,
        CASE
            WHEN pos.ori IS NULL 
                THEN 0
            ELSE (100 - pos.ori) * 0.9 
        END AS orientierung,
        CASE 
            WHEN pos.hali IS NULL 
                THEN 'Center'
            ELSE pos.hali
        END AS hali,
        CASE 
            WHEN pos.vali IS NULL 
                THEN 'Half'
            ELSE pos.vali
        END AS vali,
        pos.pos,
        CAST(pos.t_datasetname AS INT) AS bfs_nr,    
        aimport.importdate AS importdatum
    FROM
        agi_lro_auflage.einzelobjekte_objektname AS objekt
        INNER JOIN agi_lro_auflage.einzelobjekte_objektnamepos AS pos
            ON pos.objektnamepos_von = objekt.t_id
        LEFT JOIN agi_lro_auflage.t_ili2db_basket AS basket
            ON pos.t_basket = basket.t_id
        LEFT JOIN aimport
            ON basket.dataset = aimport.dataset
    WHERE 
        pos.pos IS NOT NULL
)
SELECT 
    objekt.aname AS objektname,
    CASE
        WHEN pos.ori IS NULL 
            THEN 0
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali IS NULL 
            THEN 'Center'
        ELSE pos.hali
    END AS hali,
    CASE 
        WHEN pos.vali IS NULL 
            THEN 'Half'
        ELSE pos.vali
    END AS vali,
    CASE 
        WHEN split_part(bodenbedeckung.art,'.', array_upper(string_to_array(bodenbedeckung.art, '.'), 1))='fliessendes' 
            THEN 'fliessendes Gewaesser'
        WHEN split_part(bodenbedeckung.art,'.', array_upper(string_to_array(bodenbedeckung.art, '.'), 1))='stehendes' 
            THEN 'stehendes Gewaesser'
        ELSE split_part(bodenbedeckung.art,'.', array_upper(string_to_array(bodenbedeckung.art, '.'), 1))
    END AS art_txt,
    'BB' AS herkunft,
    CAST(pos.t_datasetname AS INT) AS bfs_nr,    
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    'realisiert' AS astatus,
    pos.pos 
FROM
    agi_lro_auflage.bodenbedeckung_objektnamepos AS pos 
    LEFT JOIN agi_lro_auflage.bodenbedeckung_objektname AS objekt
        ON pos.objektnamepos_von = objekt.t_id
    LEFT JOIN agi_lro_auflage.bodenbedeckung_boflaeche AS bodenbedeckung
        ON objekt.objektname_von = bodenbedeckung.t_id
    LEFT JOIN agi_lro_auflage.bodenbedeckung_bbnachfuehrung AS nachfuehrung
        ON bodenbedeckung.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_lro_auflage.t_ili2db_basket AS basket
        ON pos.t_basket = basket.t_id
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset        
    
UNION ALL

SELECT 
    objekt.aname AS objektname,
    CASE
        WHEN pos.ori IS NULL 
            THEN 0
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali IS NULL 
            THEN 'Center'
        ELSE pos.hali
    END AS hali,
    CASE 
        WHEN pos.vali IS NULL 
            THEN 'Half'
        ELSE pos.vali
    END AS vali,
    CASE 
        WHEN split_part(bodenbedeckung.art,'.', array_upper(string_to_array(bodenbedeckung.art, '.'), 1))='fliessendes' 
            THEN 'fliessendes Gewaesser'
        WHEN split_part(bodenbedeckung.art,'.', array_upper(string_to_array(bodenbedeckung.art, '.'), 1))='stehendes' 
            THEN 'stehendes Gewaesser'
        ELSE split_part(bodenbedeckung.art,'.', array_upper(string_to_array(bodenbedeckung.art, '.'), 1))
    END AS art_txt,
    'BB' AS herkunft,
    CAST(pos.t_datasetname AS INT) AS bfs_nr,    
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    'projektiert' AS astatus,
    pos.pos 
FROM
    agi_lro_auflage.bodenbedeckung_projobjektnamepos AS pos
    LEFT JOIN agi_lro_auflage.bodenbedeckung_projobjektname AS objekt
        ON pos.projobjektnamepos_von = objekt.t_id
    LEFT JOIN agi_lro_auflage.bodenbedeckung_projboflaeche AS bodenbedeckung
        ON objekt.projobjektname_von = bodenbedeckung.t_id
    LEFT JOIN agi_lro_auflage.bodenbedeckung_bbnachfuehrung AS nachfuehrung
        ON bodenbedeckung.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_lro_auflage.t_ili2db_basket AS basket
        ON pos.t_basket = basket.t_id
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset        

UNION ALL

SELECT
    einzelobjekt_position.objektname,
    einzelobjekt_position.orientierung,
    einzelobjekt_position.hali,
    einzelobjekt_position.vali,
    einzelobjekt_flaeche.art_txt,
    'EO_Flaeche' AS herkunft,
    einzelobjekt_position.bfs_nr,
    einzelobjekt_position.importdatum,
    einzelobjekt_flaeche.nachfuehrung,
    'realisiert' AS astatus,
    einzelobjekt_position.pos 
FROM
    einzelobjekt_flaeche
    INNER JOIN einzelobjekt_position
        ON einzelobjekt_flaeche.t_id = einzelobjekt_position.objektname_von

UNION ALL

SELECT
    einzelobjekt_position.objektname,
    einzelobjekt_position.orientierung,
    einzelobjekt_position.hali,
    einzelobjekt_position.vali,
    einzelobjekt_linie.art_txt,
    'EO_Linie' AS herkunft,
    einzelobjekt_position.bfs_nr,
    einzelobjekt_position.importdatum,
    einzelobjekt_linie.nachfuehrung,
    'realisiert' AS astatus,
    einzelobjekt_position.pos 
FROM
    einzelobjekt_linie
    INNER JOIN einzelobjekt_position
        ON einzelobjekt_linie.t_id = einzelobjekt_position.objektname_von

UNION ALL

SELECT
    einzelobjekt_position.objektname,
    einzelobjekt_position.orientierung,
    einzelobjekt_position.hali,
    einzelobjekt_position.vali,
    einzelobjekt_punkt.art_txt,
    'EO_Punkt' AS herkunft,
    einzelobjekt_position.bfs_nr,
    einzelobjekt_position.importdatum,
    einzelobjekt_punkt.nachfuehrung,
    'realisiert' AS astatus,
    einzelobjekt_position.pos 
FROM
    einzelobjekt_punkt
    INNER JOIN einzelobjekt_position
        ON einzelobjekt_punkt.t_id = einzelobjekt_position.objektname_von
;
