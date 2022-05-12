update 
    afu_gewaesser_oekomorphologie_pub_v1.bauwerk bauwerk
set 
    typ_txt = (select 
                   dispname 
               from 
                   afu_gewaesser_oekomorphologie_pub_v1.bauwerktyp typ
               where 
                   bauwerk.typ = typ.ilicode)
;