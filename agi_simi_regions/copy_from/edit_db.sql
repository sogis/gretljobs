SELECT  
    uuid_generate_v4 () AS id,
    lower(teilgebiet.identifier) AS identifier,
    teilgebiet.bezeichnung AS title,
    st_asbinary(apolygon) AS geom_wkb, 
    localtimestamp AS updated,
    lower(abdeckung.identifier) AS coverage_ident
FROM  
    agi_metadaten_datenabdeckung_v2.abdeckung_teilgebiet teilgebiet
LEFT JOIN 
    agi_metadaten_datenabdeckung_v2.abdeckung_datenabdeckung abdeckung
    ON 
    abdeckung.t_id = teilgebiet.rdatenabdeckung 
WHERE abdeckung.identifier = 'dmav_pilot_2025'
