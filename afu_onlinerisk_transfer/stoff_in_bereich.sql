SELECT
    bstof.id_assoziation AS t_id,
    CASE WHEN bstof.text IS NOT NULL THEN bstof.text ELSE sta.text END AS name_stoff,
    sta.text AS name_stoff_alternativ,
    round(sto.ms_stfv::numeric,1) AS ms_stfv,
    round(bstof.menge::numeric,1) AS max_menge,
    bstof.bemerkung::text AS bemerkung,
    bstof.id_bereich
  FROM afu_online_risk.bereichstoff bstof
    LEFT JOIN afu_online_risk.stoff sto ON bstof.id_stoff = sto.id_stoff
    LEFT JOIN afu_online_risk.stammdaten sta ON sto.id_stoff = sta.id_stammdaten
   WHERE bstof.menge IS NOT NULL and bstof.menge > 0
;
