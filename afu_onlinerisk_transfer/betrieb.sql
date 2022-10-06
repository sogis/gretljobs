SELECT
      b.id_betrieb AS t_id,
      k.text::varchar(255) AS name_betrieb,
      b.bur_nummer
  FROM afu_online_risk.betrieb b
   LEFT JOIN afu_online_risk.konstruktion k ON b.id_betrieb = k.id_konstruktion;
