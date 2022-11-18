SELECT
   sto.id_stoff AS t_id,
   stasto.text AS stoff_name,
   sto.display AS stoff_anzeigetext,
   staagg.text AS aggregatzustand,
   sto.ms_stfv::numeric AS mengenschwelle_stfv,
   sto.cas AS cas_nummer,
   sto.cea_nummer AS cea_nummer,
   sto.gf_symbol1 AS gf_symbol
 FROM
   afu_online_risk.stoff sto
   LEFT JOIN afu_online_risk.stammdaten stasto ON sto.id_stoff = stasto.id_stammdaten
   LEFT JOIN afu_online_risk.stammdaten staagg ON sto.id_aggregatzustand = staagg.id_stammdaten
 ;
