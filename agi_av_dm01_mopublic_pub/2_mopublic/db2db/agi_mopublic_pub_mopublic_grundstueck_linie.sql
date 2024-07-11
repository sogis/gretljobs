SELECT
    ${basket_tid} AS t_basket,
    grundstueck.nummer,
    grundstueckpos.hilfslinie
FROM
    agi_dm01avso24.liegenschaften_grundstueckpos AS grundstueckpos
    JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
        ON grundstueck.t_id  = grundstueckpos.grundstueckpos_von
WHERE grundstueckpos.hilfslinie IS NOT NULL     
;
