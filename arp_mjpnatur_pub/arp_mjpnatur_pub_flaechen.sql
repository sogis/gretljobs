SELECT 
    vbart.kurzbez AS vereinbarungsart, 
    vereinbarung.vereinbarungsid AS vereinbarungid, 
    vereinbarung.vbnr, 
    vereinbarung.pid, 
    vereinbarung.persid, 
    flaechenart.bez::character varying(30) AS flaechenart, 
    ST_Multi(flaechen_geom_t.wkb_geometry) AS geometrie, 
    vereinbarung.fallid, 
    flaechen.flaecheid AS t_id, 
    flaechen_geom_t.polyid AS flaechenid, 
    flaechen.flaechenartid, 
    flaechen.flaeche, 
    round((ST_Area(flaechen_geom_t.wkb_geometry) / 10000::double precision)::numeric, 2) AS gis_flaeche, 
    CASE
        WHEN vereinbarung.statuscd = 4 
            THEN 91
        WHEN vereinbarung.statuscd = 1 
            THEN 90
        ELSE vbart_flaechenart.legende
    END AS legende, 
    flaechen.notiz, 
    CASE
        WHEN round(flaechen.laufmeter, 0) = (-9999)::numeric 
            THEN NULL::numeric
        ELSE flaechen.laufmeter
    END AS laufmeter, 
    flaechen.schnittzeitpunkt, 
    flaechen.flurname, 
    flaechen.oeqv_q_attest, 
    codb.bez AS oeqv_q_attest_txt, 
    flaechen.balkenmaeher, 
    flaechen.herbstweide, 
    flaechen.rkzugstreifen, 
    flaechen.emden, 
    codc.bez AS emden_txt, 
    flaechen.bffii_flaeche, 
    flaechen.bffii_indikatoren, 
    CASE
        WHEN flaechen.letzter_unterhalt = '9999-01-01'::date 
            THEN NULL::date
        ELSE flaechen.letzter_unterhalt
    END AS letzter_unterhalt, 
    CASE
        WHEN flaechen.datum_beurt = '9999-01-01'::date 
            THEN NULL::date
        ELSE flaechen.datum_beurt
    END AS datum_beurt, 
    CASE
        WHEN flaechen.datum_oeqv = '9999-01-01'::date 
            THEN NULL::date
        ELSE flaechen.datum_oeqv
    END AS datum_oeqv, 
    CASE
        WHEN flaechen.new_date > flaechen_geom_t.new_date 
            THEN flaechen.new_date::date::character varying::text
        ELSE flaechen_geom_t.new_date::date::character varying::text || ' (G)'::text
    END AS gueltigab, 
    flaechen.gueltigbis, 
    flaechen.wiesenkategorie, 
    coda.kurzbez AS wiesenkat_txt, 
    flaechen.flaeche_hecke,
    (flaechen_geom_t.polyid || '
'::text) || coda.kurzbez::text AS besch_flaeche, 
    (vereinbarung.vbnr::text || '
'::text) || flaechen_geom_t.polyid AS besch_akarte
FROM 
    mjpnatur.vereinbarung
    JOIN mjpnatur.flaechen 
        ON flaechen.vereinbarungid = vereinbarung.vereinbarungsid
    JOIN mjpnatur.flaechen_geom_t 
        ON flaechen_geom_t.polyid = flaechen.polyid
    JOIN mjpnatur.vbart 
        ON vbart.vbartid = vereinbarung.vbartid
    JOIN mjpnatur.flaechenart 
        ON flaechenart.flaechenartid = flaechen.flaechenartid
    JOIN mjpnatur.code coda 
        ON flaechen.wiesenkategorie = coda.codeid
    LEFT JOIN ( 
        SELECT 
            code.codeid, 
            code.codetypid, 
            code.spcd, 
            code.kuerzel, 
            code.kurzbez, 
            code.bez, 
            code.konstantenbez, 
            code.sortnr
        FROM 
            mjpnatur.code
        WHERE 
            code.codetypid::text = 'OEQV'::text) AS codb 
        ON flaechen.oeqv_q_attest = codb.codeid
    LEFT JOIN ( 
        SELECT 
            code.codeid, 
            code.codetypid, 
            code.spcd, 
            code.kuerzel, 
            code.kurzbez, 
            code.bez, 
            code.konstantenbez, 
            code.sortnr
        FROM 
            mjpnatur.code
        WHERE 
            code.codetypid::text = 'EMD'::text) AS codc 
        ON flaechen.emden = codc.codeid
    LEFT JOIN mjpnatur.vbart_flaechenart 
        ON 
            vbart_flaechenart.vbartid = vereinbarung.vbartid 
            AND 
            vbart_flaechenart.flaechenartid = flaechen.flaechenartid
WHERE 
    flaechen_geom_t.archive = 0 
    AND 
    flaechen.archive = 0 
    AND 
    vereinbarung.archive = 0 
    AND 
    vbart.archive = 0 
    AND 
    coda.codetypid::text = 'FLK'::text 
    AND 
    vbart_flaechenart.archive = 0
;