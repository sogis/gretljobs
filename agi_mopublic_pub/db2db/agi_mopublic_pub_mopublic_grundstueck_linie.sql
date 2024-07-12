SELECT
    ${basket_tid} AS t_basket,
    grundstueck.nummer,
    grundstueckpos.hilfslinie
FROM
    agi_dm01avso24.liegenschaften_grundstueckpos AS grundstueckpos
    JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
        ON grundstueck.t_id  = grundstueckpos.grundstueckpos_von
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON grundstueckpos.t_basket = basket.t_id    
WHERE grundstueckpos.hilfslinie IS NOT NULL     
;
