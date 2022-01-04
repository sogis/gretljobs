select 
    geometrie, 
    anrechenbar,
    spezialfall as bemerkung, 
    quali.t_id as qualitaet_fff
from 
    alw_fruchtfolgeflaechen_v1.fruchtfolgeflaeche fff
left join 
    alw_fruchtfolgeflaechen_mgdm_v1.qualitaet_kantonal quali 
    on 
    quali.bezeichnung = fff.bezeichnung
;