DELETE FROM arp_waldreservate_mgdm_v1.waldreservat_teilobjekt 
;
DELETE FROM arp_waldreservate_mgdm_v1.waldreservat 
;

INSERT INTO arp_waldreservate_mgdm_v1.waldreservat  (
    t_id, 
    t_ili_tid,
    objnummer,
    aname, 
    obj_gesflaeche, 
    obj_gisflaeche
)
SELECT 
    t_id, 
    t_ili_tid,
    objnummer, 
    aname, 
    obj_gesflaeche, 
    obj_gisflaeche
FROM 
    arp_waldreservate_v1.geobasisdaten_waldreservat
;


INSERT INTO arp_waldreservate_mgdm_v1.waldreservat_teilobjekt (
    t_id,
    t_ili_tid,
    teilobj_nr, 
    mcpfe_class, 
    obj_gisteilobjekt, 
    geo_obj, 
    wr
)
SELECT 
    teilobjekt.t_id AS t_id,
    teilobjekt.t_ili_tid AS t_ili_tid,
    teilobj_nr, 
    code.t_id AS mcpfe_code, 
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




