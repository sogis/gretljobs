SELECT
    wkb_geometry AS geometrie,
    streckennummer AS t_id,
    dtv2030_bus_modulo,
    dtv2030_bahn_modulo,
    asp2030_bus_modulo,
    asp2030_bahn_modulo,
    msp2030_bus_modulo,
    msp2030_bahn_modulo,
    dwv2030_bus_modulo,
    dwv2030_bahn_modulo
FROM 
    oev_netz.gv2010_modulo2030
;