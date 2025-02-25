DELETE FROM arp_waldreservate_mgdm_v1.waldreservat_teilobjekt 
;
DELETE FROM arp_waldreservate_mgdm_v1.waldreservat 
;

INSERT INTO arp_waldreservate_mgdm_v1.waldreservat  (
    t_id,
    objnummer,
    aname, 
    obj_gesflaeche, 
    obj_gisflaeche
)
SELECT 
    t_id,
    objnummer, 
    aname, 
    obj_gesflaeche, 
    obj_gisflaeche
FROM 
    arp_waldreservate_v1.geobasisdaten_waldreservat
;


INSERT INTO arp_waldreservate_mgdm_v1.waldreservat_teilobjekt (
    teilobj_nr, 
    mcpfe_class, 
    obj_gisteilobjekt, 
    geo_obj, 
    wr
)
SELECT 
    teilobj_nr, 
    code.t_id  AS mcpfe_code, 
    obj_gisteilobjekt, 
    geo_obj, 
    wr
FROM 
    arp_waldreservate_v1.geobasisdaten_waldreservat_teilobjekt teilobjekt
LEFT JOIN 
    arp_waldreservate_mgdm_v1.mcpfe_class_catalogue code 
    ON 
    replace(teilobjekt.mcpfe_code, '_', '.') = code.acode  
;



