update 
    avt_gesamtverkehrsmodell_2019_pub_v1.miv_verkehrsdichte_2019 verkehr 
set 
    dtv_klasse_txt  = klasse.dispname 
from 
    avt_gesamtverkehrsmodell_2019_pub_v1.klasse_dtv klasse
where 
    verkehr.dtv_klasse = klasse.ilicode
;

update 
    avt_gesamtverkehrsmodell_2019_pub_v1.miv_verkehrsdichte_prognose_2030 verkehr 
set 
    dtv_klasse_txt  = klasse.dispname 
from 
    avt_gesamtverkehrsmodell_2019_pub_v1.klasse_dtv klasse
where 
    verkehr.dtv_klasse = klasse.ilicode
;

update 
    avt_gesamtverkehrsmodell_2019_pub_v1.miv_verkehrsdichte_prognose_2040 verkehr 
set 
    dtv_klasse_txt  = klasse.dispname 
from 
    avt_gesamtverkehrsmodell_2019_pub_v1.klasse_dtv klasse
where 
    verkehr.dtv_klasse = klasse.ilicode
;