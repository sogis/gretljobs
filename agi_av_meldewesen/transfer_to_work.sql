WITH grundstuecke AS 
(
    SELECT 
        g.nummer, g.egris_egrid, g.art, o.geometrie 
    FROM 
        agi_dm01avso24.liegenschaften_grundstueck AS g 
    LEFT JOIN 
        (
            SELECT 
                liegenschaft_von AS von, geometrie 
            FROM
                agi_dm01avso24.liegenschaften_liegenschaft
            UNION ALL 
            SELECT 
                selbstrecht_von AS von, geometrie 
            FROM 
                agi_dm01avso24.liegenschaften_selbstrecht
            UNION ALL 
            SELECT 
                bergwerk_von AS von, geometrie 
            FROM 
                agi_dm01avso24.liegenschaften_bergwerk
        ) o ON o.von = g.t_id 
)
,
gemeinden AS 
(
    SELECT 
        aname, geometrie
    FROM 
        agi_dm01avso24.gemeindegrenzen_gemeinde AS gem
    LEFT JOIN
        agi_dm01avso24.gemeindegrenzen_gemeindegrenze AS grenze ON grenze.gemeindegrenze_von = gem.t_id  
)

INSERT INTO 
    agi_av_meldewesen_work_v1.meldungen_meldung 
(
    t_ili_tid,
    lage,
    grundstuecksnummer,
    egrid,
    nbident,
    datum_meldung,
    meldegrund,
    baujahr,
    gemeinde,
    gebaeudebezeichnung,
    gebaeudeadresse,
    egid,
    versicherungsbeginn,
    verwalter,
    eigentuemer,
    baulicher_mehrwert,
    astatus,
    messageid,
    insuranceobjectid,
    bemerkungen
)
SELECT 
    m.t_ili_tid,
    ST_GeometryN(ST_GeneratePoints(grundstuecke.geometrie, 1), 1) AS lage,
    m.grundstuecksnummer,
    m.egrid,
    m.nbident,
    m.datum_meldung,
    m.meldegrund,
    m.baujahr,
    gemeinden.aname AS gemeinde,
    m.gebaeudebezeichnung,
    m.gebaeudeadresse,
    m.egid,
    m.versicherungsbeginn,
    m.verwalter,
    m.eigentuemer,
    m.baulicher_mehrwert,
    m.astatus,
    m.messageid,
    m.insuranceobjectid,
    CASE 
        WHEN m.lage IS NULL THEN 'Koordinate automatisch gerechnet.'
    END AS bemerkungen
FROM 
    agi_av_meldewesen_import_v1.meldungen_meldung AS m 
LEFT JOIN
    grundstuecke ON m.egrid = grundstuecke.egris_egrid 
LEFT JOIN 
    gemeinden ON ST_Intersects(ST_PointOnSurface(grundstuecke.geometrie), gemeinden.geometrie)
ON CONFLICT (messageid) DO NOTHING
;