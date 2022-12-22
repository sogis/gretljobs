SELECT
    g.id_gebaeude AS t_id,
    CASE WHEN g.egid = '0' THEN NULL ELSE g.egid END::integer AS egid,
    k.text AS name_gebaeude,
    g.zusatz,
    'Point(' || g.koordinate_x::text || ' ' || g.koordinate_y::text || ')' AS geometrie,
    g.id_untersuchungseinheit
  FROM afu_online_risk.gebaeude g
    LEFT JOIN afu_online_risk.konstruktion k
      ON g.id_gebaeude = k.id_konstruktion
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
  WHERE vrstd.text = 'Störfallverordnung'
;
