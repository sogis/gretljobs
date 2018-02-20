WITH einzelobjekt_flaeche AS
(
    SELECT
        DISTINCT ON (einzelobjekt.tid)    
        einzelobjekt.tid,
        einzelobjekt.entstehung,
        einzelobjekt.art,
        split_part(einzelobjekt.art_txt,'.',array_upper(string_to_array(einzelobjekt.art_txt,'.'), 1)) AS art_txt,
        to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung
    FROM
        av_avdpool_ng.einzelobjekte_flaechenelement AS flaeche
        LEFT JOIN av_avdpool_ng.einzelobjekte_einzelobjekt AS einzelobjekt
            ON flaeche.flaechenelement_von = einzelobjekt.tid
        LEFT JOIN av_avdpool_ng.einzelobjekte_eonachfuehrung AS nachfuehrung
            ON einzelobjekt.entstehung = nachfuehrung.tid
),
einzelobjekt_linie AS
(
    SELECT
        DISTINCT ON (einzelobjekt.tid)
        einzelobjekt.tid,
        einzelobjekt.entstehung,
        einzelobjekt.art,
        split_part(einzelobjekt.art_txt,'.',array_upper(string_to_array(einzelobjekt.art_txt,'.'), 1)) AS art_txt,
        to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung
    FROM
        av_avdpool_ng.einzelobjekte_linienelement AS linie
        LEFT JOIN av_avdpool_ng.einzelobjekte_einzelobjekt AS einzelobjekt
            ON linie.linienelement_von = einzelobjekt.tid
        LEFT JOIN av_avdpool_ng.einzelobjekte_eonachfuehrung AS nachfuehrung
            ON einzelobjekt.entstehung = nachfuehrung.tid
),
einzelobjekt_punkt AS
(
    SELECT
        DISTINCT ON (einzelobjekt.tid)
        einzelobjekt.tid,
        einzelobjekt.entstehung,
        einzelobjekt.art,
        split_part(einzelobjekt.art_txt,'.',array_upper(string_to_array(einzelobjekt.art_txt,'.'), 1)) AS art_txt,
        to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung
    FROM
        av_avdpool_ng.einzelobjekte_punktelement AS punkt
        LEFT JOIN av_avdpool_ng.einzelobjekte_einzelobjekt AS einzelobjekt
            ON punkt.punktelement_von = einzelobjekt.tid
        LEFT JOIN av_avdpool_ng.einzelobjekte_eonachfuehrung AS nachfuehrung
            ON einzelobjekt.entstehung = nachfuehrung.tid
),
einzelobjekt_position AS
(
    SELECT
        objekt.objektname_von,
        objekt."name" AS objektname,
        CASE
            WHEN pos.ori IS NULL 
                THEN 0
            ELSE (100 - pos.ori) * 0.9 
        END AS orientierung,
        CASE 
            WHEN pos.hali_txt IS NULL 
                THEN 'Center'
            ELSE pos.hali_txt
        END AS hali,
        CASE 
            WHEN pos.vali_txt IS NULL 
                THEN 'Half'
            ELSE pos.vali_txt
        END AS vali,
        pos.pos,
        pos.gem_bfs AS bfs_nr,
        pos.lieferdatum AS importdatum
    FROM
        av_avdpool_ng.einzelobjekte_objektname AS objekt
        INNER JOIN av_avdpool_ng.einzelobjekte_objektnamepos AS pos
            ON pos.objektnamepos_von = objekt.tid
    WHERE 
        pos.pos IS NOT NULL
)
SELECT 
    objekt."name" AS objektname,
    CASE
        WHEN pos.ori IS NULL 
            THEN 0
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL 
            THEN 'Center'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL 
            THEN 'Half'
        ELSE pos.vali_txt
    END AS vali,
    bodenbedeckung.art,
    CASE 
        WHEN split_part(bodenbedeckung.art_txt,'.', array_upper(string_to_array(bodenbedeckung.art_txt, '.'), 1))='fliessendes' 
            THEN 'fliessendes Gewaesser'
        WHEN split_part(bodenbedeckung.art_txt,'.', array_upper(string_to_array(bodenbedeckung.art_txt, '.'), 1))='stehendes' 
            THEN 'stehendes Gewaesser'
        ELSE split_part(bodenbedeckung.art_txt,'.', array_upper(string_to_array(bodenbedeckung.art_txt, '.'), 1))
    END AS art_txt,
    'BB' AS herkunft,
    pos.gem_bfs AS bfs_nr,
    pos.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    'realisiert' AS status,
    pos.pos 
FROM
    av_avdpool_ng.bodenbedeckung_objektnamepos AS pos 
    LEFT JOIN av_avdpool_ng.bodenbedeckung_objektname AS objekt
        ON pos.objektnamepos_von = objekt.tid
    LEFT JOIN av_avdpool_ng.bodenbedeckung_boflaeche AS bodenbedeckung
        ON objekt.objektname_von = bodenbedeckung.tid
    LEFT JOIN av_avdpool_ng.bodenbedeckung_bbnachfuehrung AS nachfuehrung
        ON bodenbedeckung.entstehung = nachfuehrung.tid
    
UNION ALL

SELECT 
    objekt."name" AS objektname,
    CASE
        WHEN pos.ori IS NULL 
            THEN 0
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL 
            THEN 'Center'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL 
            THEN 'Half'
        ELSE pos.vali_txt
    END AS vali,
    bodenbedeckung.art,
    CASE 
        WHEN split_part(bodenbedeckung.art_txt,'.', array_upper(string_to_array(bodenbedeckung.art_txt, '.'), 1))='fliessendes' 
            THEN 'fliessendes Gewaesser'
        WHEN split_part(bodenbedeckung.art_txt,'.', array_upper(string_to_array(bodenbedeckung.art_txt, '.'), 1))='stehendes' 
            THEN 'stehendes Gewaesser'
        ELSE split_part(bodenbedeckung.art_txt,'.', array_upper(string_to_array(bodenbedeckung.art_txt, '.'), 1))
    END AS art_txt,
    'BB' AS herkunft,
    pos.gem_bfs AS bfs_nr,
    pos.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    'projektiert' AS status,
    pos.pos 
FROM
    av_avdpool_ng.bodenbedeckung_projobjektnamepos AS pos
    LEFT JOIN av_avdpool_ng.bodenbedeckung_projobjektname AS objekt
        ON pos.projobjektnamepos_von = objekt.tid
    LEFT JOIN av_avdpool_ng.bodenbedeckung_projboflaeche AS bodenbedeckung
        ON objekt.projobjektname_von = bodenbedeckung.tid
    LEFT JOIN av_avdpool_ng.bodenbedeckung_bbnachfuehrung AS nachfuehrung
        ON bodenbedeckung.entstehung = nachfuehrung.tid

UNION ALL
 
SELECT
    einzelobjekt_position.objektname,
    einzelobjekt_position.orientierung,
    einzelobjekt_position.hali,
    einzelobjekt_position.vali,
    einzelobjekt_flaeche.art,
    einzelobjekt_flaeche.art_txt,
    'EO_Flaeche' AS herkunft,
    einzelobjekt_position.bfs_nr,
    einzelobjekt_position.importdatum,
    einzelobjekt_flaeche.nachfuehrung,
    'realisiert' AS status,
    einzelobjekt_position.pos 
FROM
    einzelobjekt_flaeche
    INNER JOIN einzelobjekt_position
        ON einzelobjekt_flaeche.tid = einzelobjekt_position.objektname_von
   
UNION ALL
  
SELECT
    einzelobjekt_position.objektname,
    einzelobjekt_position.orientierung,
    einzelobjekt_position.hali,
    einzelobjekt_position.vali,
    einzelobjekt_linie.art,
    einzelobjekt_linie.art_txt,
    'EO_Linie' AS herkunft,
    einzelobjekt_position.bfs_nr,
    einzelobjekt_position.importdatum,
    einzelobjekt_linie.nachfuehrung,
    'realisiert' AS status,
    einzelobjekt_position.pos 
FROM
    einzelobjekt_linie
    INNER JOIN einzelobjekt_position
        ON einzelobjekt_linie.tid = einzelobjekt_position.objektname_von

UNION ALL

SELECT
    einzelobjekt_position.objektname,
    einzelobjekt_position.orientierung,
    einzelobjekt_position.hali,
    einzelobjekt_position.vali,
    einzelobjekt_punkt.art,
    einzelobjekt_punkt.art_txt,
    'EO_Punkt' AS herkunft,
    einzelobjekt_position.bfs_nr,
    einzelobjekt_position.importdatum,
    einzelobjekt_punkt.nachfuehrung,
    'realisiert' AS status,
    einzelobjekt_position.pos 
FROM
    einzelobjekt_punkt
    INNER JOIN einzelobjekt_position
        ON einzelobjekt_punkt.tid = einzelobjekt_position.objektname_von
;