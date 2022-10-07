SELECT
     ue.id_untersuchungseinheit AS t_id,
     'Point(' || ue.koordinate_x::text || ' ' || ue.koordinate_y::text || ')' AS geometrie,
     k.text AS name_untersuchungseinheit,
     COALESCE(replace(ue.konsultations_abstand,'m','')::integer,0) AS konsultations_abstand,
     ue.parzellen_nummer,
     k.aktiv::boolean,
     ue.id_betrieb
  FROM afu_online_risk.untersuchungseinheit ue
    LEFT JOIN afu_online_risk.konstruktion k ON ue.id_untersuchungseinheit = k.id_konstruktion;
