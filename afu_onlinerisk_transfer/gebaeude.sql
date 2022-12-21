SELECT
    g.id_gebaeude AS t_id,
    CASE WHEN g.egid = '0' THEN NULL ELSE g.egid END::integer AS egid,
    k.text AS name_gebaeude,
    g.zusatz,
    'Point(' || g.koordinate_x::text || ' ' || g.koordinate_y::text || ')' AS geometrie,
    g.id_untersuchungseinheit
  FROM afu_online_risk.gebaeude g
   LEFT JOIN afu_online_risk.konstruktion k ON g.id_gebaeude = k.id_konstruktion;
;
