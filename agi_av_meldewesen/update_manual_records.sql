WITH grundstuecke AS 
(
    SELECT 
        g.nummer, g.nbident, g.egris_egrid, g.art, o.geometrie 
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
,
gemeinden_grundstueck AS 
(
    SELECT 
        grundstuecke.nummer,
        grundstuecke.nbident,
        grundstuecke.egris_egrid,
        gemeinden.aname
    FROM 
        grundstuecke 
        LEFT JOIN gemeinden 
        ON ST_Intersects(ST_PointOnSurface(grundstuecke.geometrie), gemeinden.geometrie) 
)
UPDATE 
    agi_av_meldewesen_work_v1.meldungen_meldung 
SET 
    t_ili_tid = '_' || CAST(uuid_generate_v4() AS TEXT),
    grundstuecksnummer = subquery.nummer,
    nbident = subquery.nbident,
    egrid = subquery.egris_egrid,
    gemeinde = subquery.aname
FROM 
(
    SELECT 
        nummer,
        nbident,
        egris_egrid,
        aname
    FROM  
        gemeinden_grundstueck
) 
AS subquery
WHERE 
    t_ili_tid IS NULL OR length(trim(t_ili_tid)) = 0
;
