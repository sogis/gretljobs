 SELECT
    grundstueck.nummer,
    grundstueckpos.hilfslinie
FROM
    agi_dm01avso24.liegenschaften_projgrundstueckpos AS grundstueckpos
    JOIN agi_dm01avso24.liegenschaften_projgrundstueck AS grundstueck
        ON grundstueck.t_id  = grundstueckpos.projgrundstueckpos_von
WHERE grundstueckpos.hilfslinie IS NOT NULL 
