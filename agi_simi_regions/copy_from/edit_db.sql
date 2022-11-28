select 
    uuid_generate_v4 () AS id,
    lower(teilgebiet.identifier) as identifier,
    teilgebiet.bezeichnung as title,
    st_asbinary(apolygon) as geom_wkb, 
    localtimestamp AS updated,
    lower(abdeckung.identifier) AS coverage_ident
from 
    agi_metadaten_datenabdeckung_v1.abdeckung_teilgebiet teilgebiet
left join 
    agi_metadaten_datenabdeckung_v1.abdeckung_datenabdeckung abdeckung
    on 
    abdeckung.t_id = teilgebiet.rdatenabdeckung 
