SELECT 
     coalesce(freistellung.anzahl,1,0)||' x '||baumart.baumart AS bauminfo, 
     freistellung.brusthoehendurchmesser, 
     freistellung.id_forstrevier, 
     freistellung.pflanzung, 
     freistellung.erfassungsjahr, 
     freistellung.waldgesellschaft, 
     freistellung.eigentuemer, 
     freistellung.sponsor, 
     gemeinden.gemeindename AS gemeinde , 
     forst.forstrevier AS forstbetrieb, 
     forst.forstkreis, 
     freistellung.bemerkung, 
     freistellung.gesuchnummer, 
     freistellung.auszahlung_erfolgte, 
     freistellung.auszahlungsjahr, 
     freistellung.geometrie AS geometrie  
 FROM 
     awjf_seltene_baeume.seltene_baumarten_freistellung freistellung 
LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gemeinden 
      ON ST_DWithin(freistellung.geometrie, gemeinden.geometrie,0)  
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
 LEFT JOIN awjf_seltene_baeume.seltene_baumarten_baumtyp baumart 
     ON baumart.t_id = freistellung.baumtyp
;
