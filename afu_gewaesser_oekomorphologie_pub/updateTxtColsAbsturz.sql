update 
    afu_gewaesser_oekomorphologie_pub_v1.absturz absturz
set 
    typ_txt = (select 
                   dispname 
               from 
                   afu_gewaesser_oekomorphologie_pub_v1.absturztyp typ
               where 
                   absturz.typ = typ.ilicode)
;

update 
    afu_gewaesser_oekomorphologie_pub_v1.absturz absturz
set 
    material_txt = (select 
                        dispname 
                    from 
                        afu_gewaesser_oekomorphologie_pub_v1.absturzmaterial material
                    where 
                        absturz.material = material.ilicode)
;