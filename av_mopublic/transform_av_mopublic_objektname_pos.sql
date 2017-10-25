WITH eof AS
(
    SELECT
        DISTINCT ON (eo.tid)    
        eo.tid,
        eo.entstehung,
        eo.art,
        split_part(eo.art_txt,'.',array_upper(string_to_array(eo.art_txt,'.'), 1)) AS art_txt,
        to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung
    FROM
        av_avdpool_ng.einzelobjekte_flaechenelement AS f
        LEFT JOIN av_avdpool_ng.einzelobjekte_einzelobjekt AS eo
        ON f.flaechenelement_von = eo.tid
        LEFT JOIN av_avdpool_ng.einzelobjekte_eonachfuehrung AS nf
        ON eo.entstehung = nf.tid
),
eol AS
(
    SELECT
        DISTINCT ON (eo.tid)
        eo.tid,
        eo.entstehung,
        eo.art,
        split_part(eo.art_txt,'.',array_upper(string_to_array(eo.art_txt,'.'), 1)) AS art_txt,
        to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung
    FROM
        av_avdpool_ng.einzelobjekte_linienelement AS l
        LEFT JOIN av_avdpool_ng.einzelobjekte_einzelobjekt AS eo
        ON l.linienelement_von = eo.tid
        LEFT JOIN av_avdpool_ng.einzelobjekte_eonachfuehrung AS nf
        ON eo.entstehung = nf.tid
),
eop AS
(
    SELECT
        DISTINCT ON (eo.tid)
        eo.tid,
        eo.entstehung,
        eo.art,
        split_part(eo.art_txt,'.',array_upper(string_to_array(eo.art_txt,'.'), 1)) AS art_txt,
        to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung
    FROM
        av_avdpool_ng.einzelobjekte_punktelement AS p
        LEFT JOIN av_avdpool_ng.einzelobjekte_einzelobjekt AS eo
        ON p.punktelement_von = eo.tid
        LEFT JOIN av_avdpool_ng.einzelobjekte_eonachfuehrung AS nf
        ON eo.entstehung = nf.tid
),
eopos AS
(
    SELECT
        o.objektname_von,
        o."name" AS objektname,
        CASE
            WHEN p.ori IS NULL THEN 0
            ELSE (100 - p.ori) * 0.9 
        END AS orientierung,
        CASE 
            WHEN p.hali_txt IS NULL THEN 'Center'
            ELSE p.hali_txt
        END AS hali,
        CASE 
            WHEN p.vali_txt IS NULL THEN 'Half'
            ELSE p.vali_txt
        END AS vali,
        p.pos,
        p.gem_bfs AS bfs_nr,
        p.lieferdatum AS importdatum
    FROM
        av_avdpool_ng.einzelobjekte_objektname AS o
        INNER JOIN av_avdpool_ng.einzelobjekte_objektnamepos AS p
        ON p.objektnamepos_von = o.tid
    WHERE 
        p.pos IS NOT NULL
)
SELECT 
    o."name" AS objektname,
    CASE
        WHEN p.ori IS NULL THEN 0
        ELSE (100 - p.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN p.hali_txt IS NULL THEN 'Center'
        ELSE p.hali_txt
    END AS hali,
    CASE 
        WHEN p.vali_txt IS NULL THEN 'Half'
        ELSE p.vali_txt
    END AS vali,
    bb.art,
    CASE 
        WHEN split_part(bb.art_txt,'.', array_upper(string_to_array(bb.art_txt, '.'), 1))='fliessendes' THEN 'fliessendes Gewaesser'
        WHEN split_part(bb.art_txt,'.', array_upper(string_to_array(bb.art_txt, '.'), 1))='stehendes' THEN 'stehendes Gewaesser'
        ELSE split_part(bb.art_txt,'.', array_upper(string_to_array(bb.art_txt, '.'), 1))
    END AS art_txt,
    'BB' AS herkunft,
    p.gem_bfs AS bfs_nr,
    p.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    'realisiert' AS status,
    p.pos 
FROM
    av_avdpool_ng.bodenbedeckung_objektnamepos AS p 
    LEFT JOIN av_avdpool_ng.bodenbedeckung_objektname AS o 
    ON p.objektnamepos_von = o.tid
    LEFT JOIN av_avdpool_ng.bodenbedeckung_boflaeche AS bb
    ON o.objektname_von = bb.tid
    LEFT JOIN av_avdpool_ng.bodenbedeckung_bbnachfuehrung AS nf
    ON bb.entstehung = nf.tid
    
UNION ALL

SELECT 
    o."name" AS objektname,
    CASE
        WHEN p.ori IS NULL THEN 0
        ELSE (100 - p.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN p.hali_txt IS NULL THEN 'Center'
        ELSE p.hali_txt
    END AS hali,
    CASE 
        WHEN p.vali_txt IS NULL THEN 'Half'
        ELSE p.vali_txt
    END AS vali,
    bb.art,
    CASE 
        WHEN split_part(bb.art_txt,'.', array_upper(string_to_array(bb.art_txt, '.'), 1))='fliessendes' THEN 'fliessendes Gewaesser'
        WHEN split_part(bb.art_txt,'.', array_upper(string_to_array(bb.art_txt, '.'), 1))='stehendes' THEN 'stehendes Gewaesser'
        ELSE split_part(bb.art_txt,'.', array_upper(string_to_array(bb.art_txt, '.'), 1))
    END AS art_txt,
    'BB' AS herkunft,
    p.gem_bfs AS bfs_nr,
    p.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    'projektiert' AS status,
    p.pos 
FROM
    av_avdpool_ng.bodenbedeckung_projobjektnamepos AS p 
    LEFT JOIN av_avdpool_ng.bodenbedeckung_projobjektname AS o 
    ON p.projobjektnamepos_von = o.tid
    LEFT JOIN av_avdpool_ng.bodenbedeckung_projboflaeche AS bb
    ON o.projobjektname_von = bb.tid
    LEFT JOIN av_avdpool_ng.bodenbedeckung_bbnachfuehrung AS nf
    ON bb.entstehung = nf.tid

UNION ALL
 
SELECT
    eopos.objektname,
    eopos.orientierung,
    eopos.hali,
    eopos.vali,
    eof.art,
    eof.art_txt,
    'EO_Flaeche' AS herkunft,
    eopos.bfs_nr,
    eopos.importdatum,
    eof.nachfuehrung,
    'realisiert' AS status,
    eopos.pos 
FROM
    eof
    INNER JOIN eopos
    ON eof.tid = eopos.objektname_von
   
UNION ALL
  
SELECT
    eopos.objektname,
    eopos.orientierung,
    eopos.hali,
    eopos.vali,
    eol.art,
    eol.art_txt,
    'EO_Linie' AS herkunft,
    eopos.bfs_nr,
    eopos.importdatum,
    eol.nachfuehrung,
    'realisiert' AS status,
    eopos.pos 
FROM
    eol
    INNER JOIN eopos
    ON eol.tid = eopos.objektname_von

UNION ALL

SELECT
    eopos.objektname,
    eopos.orientierung,
    eopos.hali,
    eopos.vali,
    eop.art,
    eop.art_txt,
    'EO_Punkt' AS herkunft,
    eopos.bfs_nr,
    eopos.importdatum,
    eop.nachfuehrung,
    'realisiert' AS status,
    eopos.pos 
FROM
    eop
    INNER JOIN eopos
    ON eop.tid = eopos.objektname_von;