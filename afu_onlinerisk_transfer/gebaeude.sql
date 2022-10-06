SELECT
    g.id_gebaeude AS t_id,
    g.egid,
    k.text AS name_gebaeude,
    'Point(' || g.koordinate_x::text || ' ' || g.koordinate_y::text || ')' AS geometrie,
    g.zusatz,
    g.id_untersuchungseinheit
  FROM afu_online_risk.gebaeude g
   LEFT JOIN afu_online_risk.konstruktion k ON g.id_gebaeude = k.id_konstruktion;
;
