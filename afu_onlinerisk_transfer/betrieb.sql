SELECT
      b.id_betrieb AS t_id,
      k.text::varchar(255) AS name_betrieb,
	  b.zusatz,
	  b.firmenhistory,
      b.bur_nummer,
	  b.egid,
	  b.eigentuemer_betrieb,
	  b.eigentuemer_areal,
	  b.eigentuemer_gebaeude,
	  b.flaeche::integer,
	  b.personal,
	  b.letzte_kontrolle,
	  b.naechste_kontrolle,
	  0 AS anzahl_szenarien_brand,
	  0 AS anzahl_szenarien_explosion,
	  0 AS anzahl_szenarien_toxische_wolke,  
	  'Point(' || b.koordinate_x::text || ' ' || b.koordinate_y::text || ')' AS geometrie
  FROM afu_online_risk.betrieb b
   LEFT JOIN afu_online_risk.konstruktion k
      ON b.id_betrieb = k.id_konstruktion
   LEFT JOIN afu_online_risk.verordnung v
      ON b.id_betrieb = v.id_betrieb AND v.aktiv = 1
   LEFT JOIN afu_online_risk.verordnungsrelevanz vr
      ON v.id_verordnungsrelevanz = vr.id_verordnungsrelevanz
   LEFT JOIN afu_online_risk.stammdaten vrstd
      ON vr.id_verordnungsrelevanz = vrstd.id_stammdaten AND vrstd.aktiv = 1
  WHERE vrstd.text = 'Störfallverordnung'
   ;
