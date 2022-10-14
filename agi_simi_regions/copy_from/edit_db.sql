select 
    uuid_generate_v4 () AS id,
    abdeckung.identifier as identifier,
    abdeckung.identifier as title,
    st_asbinary(st_union(apolygon)) as geom_wkb, 
    localtimestamp AS updated,
    'metadaten_abdeckung' AS coverage_ident
from 
    agi_metadaten_datenabdeckung_v1.abdeckung_teilgebiet teilgebiet
left join 
    agi_metadaten_datenabdeckung_v1.abdeckung_datenabdeckung abdeckung
    on 
    abdeckung.t_id = teilgebiet.datenabdeckung 
group by 
    abdeckung.identifier