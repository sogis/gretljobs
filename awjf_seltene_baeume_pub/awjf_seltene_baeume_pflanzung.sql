SELECT 
      array_to_json(info.info)::text AS bauminfo,
      pflanzung.id_forstrevier, 
      pflanzung.pflanzung, 
      pflanzung.erfassungsjahr, 
      pflanzung.waldgesellschaft, 
      pflanzung.eigentuemer, 
      pflanzung.sponsor, 
      gemeinden.gemeindename AS gemeinde, 
      forst.forstrevier AS forstbetrieb, 
      forst.forstkreis, 
      pflanzung.bemerkung, 
      pflanzung.gesuchnummer,
      pflanzung.auszahlung_erfolgte, 
      pflanzung.auszahlungsjahr, 
      pflanzung.geometrie
  FROM 
      awjf_seltene_baeume.seltene_baumarten_pflanzung pflanzung 
  LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gemeinden 
       ON ST_DWithin(pflanzung.geometrie, gemeinden.geometrie,0) 
  LEFT JOIN ( 
             SELECT 
                 geometrie.geometrie, 
                 forstrevier.aname AS forstrevier, 
                 forstkreis.aname AS forstkreis 
             FROM 
                 awjf_forstreviere.forstreviere_forstreviergeometrie geometrie 
             LEFT JOIN awjf_forstreviere.forstreviere_forstkreis forstkreis 
                 ON geometrie.forstkreis = forstkreis.t_id
             LEFT JOIN awjf_forstreviere.forstreviere_forstrevier forstrevier 
                 ON geometrie.forstrevier = forstrevier.t_id
             ) forst 
             ON ST_DWithin(pflanzung.geometrie, forst.geometrie,0)
  LEFT JOIN (
             SELECT 
                 beziehung.pflanzung, 
                 array_agg(coalesce(anzahl_baeume,1)||' x '||baumart.baumart||' '||coalesce(info,'')) AS info
             FROM 
                 awjf_seltene_baeume.seltene_baumarten_beziehung_pflanzung_baumtyp beziehung 
             LEFT JOIN awjf_seltene_baeume.seltene_baumarten_baumtyp baumart 
                 ON baumart.t_id = beziehung.baumtyp
             GROUP BY pflanzung
             ) info 
             ON info.pflanzung = pflanzung.t_id
;
