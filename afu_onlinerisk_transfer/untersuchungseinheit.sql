SELECT
     ue.id_untersuchungseinheit AS t_id,
     k.text AS name_untersuchungseinheit,
     ue.zusatz,
     COALESCE(replace(ue.konsultations_abstand,'m','')::integer,0) AS konsultations_abstand,
     ue.parzellen_nummer,
     k.aktiv::boolean,
     ue.betreuung_durch,
     ue.datenerhebung_durch,
     ue.erhebungsdatum,
     ue.geprueft AS pruefungsdatum,
     'Point(' || ue.koordinate_x::text || ' ' || ue.koordinate_y::text || ')' AS geometrie,
     ue.id_betrieb
  FROM afu_online_risk.untersuchungseinheit ue
    LEFT JOIN afu_online_risk.konstruktion k
       ON ue.id_untersuchungseinheit = k.id_konstruktion
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
