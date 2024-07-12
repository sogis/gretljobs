WITH aimport AS
(
    SELECT
        max(importdate) AS importdate, dataset
    FROM
        agi_dm01avso24.t_ili2db_import
    GROUP BY
        dataset
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
        agi_dm01avso24.einzelobjekte_objektname AS objekt
        INNER JOIN agi_dm01avso24.einzelobjekte_objektnamepos AS pos
            ON pos.objektnamepos_von = objekt.t_id
        LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
            ON pos.t_basket = basket.t_id
        LEFT JOIN aimport
            ON basket.dataset = aimport.dataset
    WHERE 
        pos.pos IS NOT NULL
),

einzelobjekt_flaeche_base AS
(
    SELECT
        DISTINCT ON (einzelobjekt.t_id)    
        einzelobjekt.t_id,
        einzelobjekt.entstehung,
        split_part(einzelobjekt.art,'.',array_upper(string_to_array(einzelobjekt.art,'.'), 1)) AS art_txt,
        nachfuehrung.gueltigereintrag AS nachfuehrung
    FROM
        agi_dm01avso24.einzelobjekte_flaechenelement AS flaeche
        LEFT JOIN agi_dm01avso24.einzelobjekte_einzelobjekt AS einzelobjekt
            ON flaeche.flaechenelement_von = einzelobjekt.t_id
        LEFT JOIN agi_dm01avso24.einzelobjekte_eonachfuehrung AS nachfuehrung
            ON einzelobjekt.entstehung = nachfuehrung.t_id
),

einzelobjekt_flaeche AS (
    SELECT
        einzelobjekt_position.objektname,
        einzelobjekt_position.orientierung,
        einzelobjekt_position.hali,
        einzelobjekt_position.vali,
        ef.art_txt,
        'EO_Flaeche' AS herkunft,
        einzelobjekt_position.bfs_nr,
        einzelobjekt_position.importdatum,
        ef.nachfuehrung,
        'realisiert' AS astatus,
        einzelobjekt_position.pos 
    FROM
        einzelobjekt_flaeche_base ef
        INNER JOIN einzelobjekt_position
            ON ef.t_id = einzelobjekt_position.objektname_von
),

einzelobjekt_linie_base AS
(
    SELECT
        DISTINCT ON (einzelobjekt.t_id)
        einzelobjekt.t_id,
        einzelobjekt.entstehung,
        split_part(einzelobjekt.art,'.',array_upper(string_to_array(einzelobjekt.art,'.'), 1)) AS art_txt,
        nachfuehrung.gueltigereintrag AS nachfuehrung
    FROM
        agi_dm01avso24.einzelobjekte_linienelement AS linie
        LEFT JOIN agi_dm01avso24.einzelobjekte_einzelobjekt AS einzelobjekt
            ON linie.linienelement_von = einzelobjekt.t_id
        LEFT JOIN agi_dm01avso24.einzelobjekte_eonachfuehrung AS nachfuehrung
            ON einzelobjekt.entstehung = nachfuehrung.t_id
),

einzelobjekt_linie AS (
    SELECT
        einzelobjekt_position.objektname,
        einzelobjekt_position.orientierung,
        einzelobjekt_position.hali,
        einzelobjekt_position.vali,
        el.art_txt,
        'EO_Linie' AS herkunft,
        einzelobjekt_position.bfs_nr,
        einzelobjekt_position.importdatum,
        el.nachfuehrung,
        'realisiert' AS astatus,
        einzelobjekt_position.pos 
    FROM
        einzelobjekt_linie_base el
        INNER JOIN einzelobjekt_position
            ON el.t_id = einzelobjekt_position.objektname_von
),

einzelobjekt_punkt_base AS
(
    SELECT
        DISTINCT ON (einzelobjekt.t_id)
        einzelobjekt.t_id,
        einzelobjekt.entstehung,
        split_part(einzelobjekt.art,'.',array_upper(string_to_array(einzelobjekt.art,'.'), 1)) AS art_txt,
        nachfuehrung.gueltigereintrag AS nachfuehrung
    FROM
        agi_dm01avso24.einzelobjekte_punktelement AS punkt
        LEFT JOIN agi_dm01avso24.einzelobjekte_einzelobjekt AS einzelobjekt
            ON punkt.punktelement_von = einzelobjekt.t_id
        LEFT JOIN agi_dm01avso24.einzelobjekte_eonachfuehrung AS nachfuehrung
            ON einzelobjekt.entstehung = nachfuehrung.t_id
),

einzelobjekt_punkt AS
(
    SELECT
        einzelobjekt_position.objektname,
        einzelobjekt_position.orientierung,
        einzelobjekt_position.hali,
        einzelobjekt_position.vali,
        ep.art_txt,
        'EO_Punkt' AS herkunft,
        einzelobjekt_position.bfs_nr,
        einzelobjekt_position.importdatum,
        ep.nachfuehrung,
        'realisiert' AS astatus,
        einzelobjekt_position.pos 
    FROM
        einzelobjekt_punkt_base ep
        INNER JOIN einzelobjekt_position
            ON ep.t_id = einzelobjekt_position.objektname_von
),

boden_obj AS (
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
        agi_dm01avso24.bodenbedeckung_objektnamepos AS pos 
        LEFT JOIN agi_dm01avso24.bodenbedeckung_objektname AS objekt
            ON pos.objektnamepos_von = objekt.t_id
        LEFT JOIN agi_dm01avso24.bodenbedeckung_boflaeche AS bodenbedeckung
            ON objekt.objektname_von = bodenbedeckung.t_id
        LEFT JOIN agi_dm01avso24.bodenbedeckung_bbnachfuehrung AS nachfuehrung
            ON bodenbedeckung.entstehung = nachfuehrung.t_id
        LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
            ON pos.t_basket = basket.t_id
        LEFT JOIN aimport
            ON basket.dataset = aimport.dataset   
),

boden_proj_obj AS (
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
        agi_dm01avso24.bodenbedeckung_projobjektnamepos AS pos
        LEFT JOIN agi_dm01avso24.bodenbedeckung_projobjektname AS objekt
            ON pos.projobjektnamepos_von = objekt.t_id
        LEFT JOIN agi_dm01avso24.bodenbedeckung_projboflaeche AS bodenbedeckung
            ON objekt.projobjektname_von = bodenbedeckung.t_id
        LEFT JOIN agi_dm01avso24.bodenbedeckung_bbnachfuehrung AS nachfuehrung
            ON bodenbedeckung.entstehung = nachfuehrung.t_id
        LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
            ON pos.t_basket = basket.t_id
        LEFT JOIN aimport
            ON basket.dataset = aimport.dataset       
),

obj_union_all AS (
  SELECT objektname, orientierung, hali, vali, art_txt, herkunft, bfs_nr, importdatum, nachfuehrung, astatus, pos FROM einzelobjekt_flaeche
  UNION ALL
  SELECT objektname, orientierung, hali, vali, art_txt, herkunft, bfs_nr, importdatum, nachfuehrung, astatus, pos FROM einzelobjekt_linie
  UNION ALL
  SELECT objektname, orientierung, hali, vali, art_txt, herkunft, bfs_nr, importdatum, nachfuehrung, astatus, pos FROM einzelobjekt_punkt
  UNION ALL
  SELECT objektname, orientierung, hali, vali, art_txt, herkunft, bfs_nr, importdatum, nachfuehrung, astatus, pos FROM boden_obj
  UNION ALL
  SELECT objektname, orientierung, hali, vali, art_txt, herkunft, bfs_nr, importdatum, nachfuehrung, astatus, pos FROM boden_proj_obj
)

SELECT 
  ${basket_tid} AS t_basket,
  obj_union_all.*
FROM obj_union_all
;
