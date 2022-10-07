SELECT
   b.id_bereich AS t_id,
   k.text AS name_bereich,
   b.etage,
   b.id_gebaeude
  FROM afu_online_risk.bereich b
    LEFT JOIN afu_online_risk.konstruktion k ON b.id_bereich = k.id_konstruktion;
