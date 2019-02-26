(SELECT 
     freistellung.id_forstrevier, 
     freistellung.pflanzung, 
     freistellung.erfassungsjahr, 
     freistellung.waldgesellschaft, 
     freistellung.eigentuemer, 
     freistellung.sponsor, 
     gemeinden.name, 
     forst.forstrevier, 
     forst.forstkreis, 
     freistellung.bemerkung, 
     freistellung.gesuchnummer, 
     freistellung.auszahlung_erfolgte, 
     freistellung.auszahlungsjahr, 
     to_json(coalesce(freistellung.anzahl,1,0)||' '||baumart.baumart) AS bauminfo, 
     freistellung.brusthoehendurchmesser, 
     st_buffer(freistellung.geometrie, 10, 'quad_segs=8') AS geometrie  
 FROM 
     awjf_seltene_baumarten.seltene_baumarten_freistellung freistellung 
 LEFT JOIN geo_gemeinden gemeinden 
     ON ST_DWithin(freistellung.geometrie, gemeinden.wkb_geometry,0) 
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
            ON ST_DWithin(freistellung.geometrie, forst.geometrie,0)
 LEFT JOIN awjf_seltene_baumarten.seltene_baumarten_baumtyp baumart 
     ON baumart.t_id = freistellung.baumtyp
 WHERE 
    gemeinden."archive"=0
 )
         
 UNION ALL 
         
 (SELECT 
      pflanzung.id_forstrevier, 
      pflanzung.pflanzung, 
      pflanzung.erfassungsjahr, 
      pflanzung.waldgesellschaft, 
      pflanzung.eigentuemer, 
      pflanzung.sponsor, 
      gemeinden."name", 
      forst.forstrevier, 
      forst.forstkreis, 
      pflanzung.bemerkung, 
      pflanzung.gesuchnummer,
      pflanzung.auszahlung_erfolgte, 
      pflanzung.auszahlungsjahr,
      array_to_json(info.info) AS bauminfo, 
      NULL AS brusthoehendurchmesser, 
      pflanzung.geometrie
  FROM 
      awjf_seltene_baumarten.seltene_baumarten_pflanzung pflanzung 
  LEFT JOIN geo_gemeinden gemeinden 
      ON ST_DWithin(pflanzung.geometrie, gemeinden.wkb_geometry,0) 
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
                 array_agg(coalesce(anzahl_baeume,1)||' '||baumart.baumart||' '||coalesce(info,'')) AS info
             FROM 
                 awjf_seltene_baumarten.seltene_baumarten_beziehung_pflanzung_baumtyp beziehung 
             LEFT JOIN awjf_seltene_baumarten.seltene_baumarten_baumtyp baumart 
                 ON baumart.t_id = beziehung.baumtyp
             GROUP BY pflanzung
             ) info 
             ON info.pflanzung = pflanzung.t_id
  WHERE gemeinden."archive"=0
  )
;
