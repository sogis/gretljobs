WITH aggregierte_egrids AS (
    SELECT
        h.t_id,
        string_agg(e.egrid, ', ' ORDER BY e.egrid) AS egrids
    FROM
        awjf_holznutzungsbewilligung_v1.holznutzung_holznutzungsbewilligung h
    JOIN
        awjf_holznutzungsbewilligung_v1.holznutzung_holznutzungsbewilligung_egrid e ON h.t_id = e.holzntzng_hngsbwllgung_egrid
    GROUP BY
        h.t_id
),
aggregierte_gemeinden AS (
    SELECT
        h.t_id,
        string_agg(g.gemeinde::text, ', ' ORDER BY g.gemeinde) AS gemeinden
    FROM
        awjf_holznutzungsbewilligung_v1.holznutzung_holznutzungsbewilligung h
    JOIN
        awjf_holznutzungsbewilligung_v1.holznutzung_holznutzungsbewilligung_gemeinde g ON h.t_id = g.holzntzng_hngsbwllgung_gemeinde
    GROUP BY
        h.t_id
),
aggregierte_reviere AS (
    SELECT
        h.t_id,
        string_agg(r.revier, ', ' ORDER BY r.revier) AS reviere
    FROM
        awjf_holznutzungsbewilligung_v1.holznutzung_holznutzungsbewilligung h
    JOIN
        awjf_holznutzungsbewilligung_v1.holznutzung_holznutzungsbewilligung_revier r ON h.t_id = r.holzntzng_hngsbwllgung_revier
    GROUP BY
        h.t_id
),
aggregierte_mengenholzarten AS (
    SELECT
        h.t_id,
        jsonb_agg(
            jsonb_build_object(
                '@type', 'SO_AWJF_Holznutzungsbewilligung_Publikation_20251222.Holznutzung.MengeHolzart',
                'Bew_Menge_Holzart', mh.bew_menge_holzart,
                'Bew_Holzart_Code', cat.acode,
                'Bew_Holzart_Text', ltext.atext
            ) ORDER BY mh.bew_menge_holzart DESC
        ) AS mengenholzarten
    FROM
        awjf_holznutzungsbewilligung_v1.holznutzung_holznutzungsbewilligung h
    JOIN
        awjf_holznutzungsbewilligung_v1.holznutzung_mengeholzart mh ON h.t_id = mh.holzntzng_hngsbwllgung_mengeholzart
    JOIN
        awjf_holznutzungsbewilligung_v1.codelisten_bewilligte_holzart_catalogue cat ON mh.bewilligte_holzart = cat.t_id
    JOIN
        awjf_holznutzungsbewilligung_v1.multilingualtext mtext ON cat.t_id = mtext.codlstn_bwllzrt_ctlgue_definition
    JOIN
        awjf_holznutzungsbewilligung_v1.localisedtext ltext ON mtext.t_id = ltext.multilingualtext_localisedtext AND ltext.alanguage = 'de'
    GROUP BY
        h.t_id
)
SELECT
    /* MANDATORY */
    flaeche,
    e.egrids,
    erzeugungsland,
    datenherr,
    g.gemeinden,
    r.reviere,
    bewilligende_behoerde,
    bew_erteilt_am,
    bew_gueltig_bis,
    bew_menge_total,
    bestaetigung_legalitaet,
    /* NULLABLE */
    allgholzart,
    bew_menge_lbh,
    bew_menge_ndh,
    mh.mengenholzarten,
    kantonale_referenz
FROM
    awjf_holznutzungsbewilligung_v1.holznutzung_holznutzungsbewilligung h
JOIN
    aggregierte_egrids e USING (t_id)
JOIN
    aggregierte_gemeinden g USING (t_id)
JOIN
    aggregierte_reviere r USING (t_id)
LEFT JOIN
    aggregierte_mengenholzarten mh USING (t_id)
;