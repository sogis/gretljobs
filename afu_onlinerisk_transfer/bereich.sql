SELECT
   ber.id_bereich AS t_id,
   k.text AS name_bereich,
   ber.etage,
   ber.id_gebaeude
  FROM afu_online_risk.bereich ber
    LEFT JOIN afu_online_risk.konstruktion k
      ON ber.id_bereich = k.id_konstruktion
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
  WHERE vrstd.text = 'Störfallverordnung'
;
