update 
    afu_stoerfallverordnung_v1.gewaessereigenschaften eigenschaft 
set 
    typ_txt = (select 
                   dispname 
               from 
                   afu_stoerfallverordnung_v1.abschnittstyp abschnittstyp 
               where 
                   eigenschaft.typ = abschnittstyp.ilicode)
;

update 
    afu_stoerfallverordnung_v1.gewaessereigenschaften eigenschaft 
set 
    groesse_txt = (select 
                       dispname 
                   from 
                       afu_stoerfallverordnung_v1.gewaessereigenschaften_groesse groesse
                   where 
                       eigenschaft.groesse = groesse.ilicode)
;

update 
    afu_stoerfallverordnung_v1.gewaessereigenschaften eigenschaft 
set 
    qualitaet_txt = (select 
                         dispname 
                     from 
                         afu_stoerfallverordnung_v1.digitalisierungsdetail qualitaet
                   where 
                       eigenschaft.qualitaet = qualitaet.ilicode)
;

update 
    afu_stoerfallverordnung_v1.gewaessereigenschaften eigenschaft 
set 
    eigentum_txt = (select 
                        dispname 
                    from 
                        afu_stoerfallverordnung_v1.eigentumsart eigentumsart
                    where 
                        eigenschaft.eigentum = eigentumsart.ilicode)
;
