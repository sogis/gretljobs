SELECT
    bstof.id_assoziation AS t_id,
    bstof.text AS name_stoff,
    sta.text AS name_stoff_alternativ,
    round(sto.ms_stfv::numeric,1) AS ms_stfv,
    round(bstof.menge::numeric,1) AS max_menge,
    bstof.id_bereich,
    bstof.bemerkung::text
  FROM afu_online_risk.bereichstoff bstof
    LEFT JOIN afu_online_risk.stoff sto ON bstof.id_stoff = sto.id_stoff
    LEFT JOIN afu_online_risk.stammdaten sta ON sto.id_stoff = sta.id_stammdaten
;
