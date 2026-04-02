
SELECT
    bstof.id_assoziation AS t_id,
    CASE WHEN bstof.text IS NOT NULL THEN bstof.text ELSE sta.text END AS name_stoff_in_bereich,
    sta.text AS name_alternativ,
    round(bstof.menge::numeric,1) AS max_menge,
    bstof.bemerkung::text AS bemerkung,
    bstof.id_bereich,
    bstof.id_stoff
  FROM afu_online_risk.bereichstoff bstof
    LEFT JOIN afu_online_risk.stoff sto
      ON bstof.id_stoff = sto.id_stoff
    LEFT JOIN afu_online_risk.stammdaten sta
      ON sto.id_stoff = sta.id_stammdaten
    LEFT JOIN afu_online_risk.bereich ber
      ON bstof.id_bereich = ber.id_bereich
    LEFT JOIN afu_online_risk.gebaeude g
      ON ber.id_gebaeude = g.id_gebaeude
    LEFT JOIN afu_online_risk.untersuchungseinheit ue
      ON g.id_untersuchungseinheit = ue.id_untersuchungseinheit
    LEFT JOIN afu_online_risk.betrieb b
       ON ue.id_betrieb = b.id_betrieb
    LEFT JOIN afu_online_risk.verordnung v
      ON b.id_betrieb = v.id_betrieb AND v.aktiv = 1
    LEFT JOIN afu_online_risk.verordnungsrelevanz vr
      ON v.id_verordnungsrelevanz = vr.id_verordnungsrelevanz
    LEFT JOIN afu_online_risk.stammdaten vrstd
      ON vr.id_verordnungsrelevanz = vrstd.id_stammdaten AND vrstd.aktiv = 1
WHERE
    bstof.menge IS NOT NULL and bstof.menge > 0
    AND vrstd.text = 'Störfallverordnung'
;
