SELECT 
    wkb_geometry AS geometrie,
    streckennummer AS t_id,
    dtv2010_bus_modulo,
    dtv2010_bahn_modulo,
    asp2010_bus_modulo,
    asp2010_bahn_modulo,
    msp2010_bus_modulo,
    msp2010_bahn_modulo,
    dwv2010_bus_modulo,
    dwv2010_bahn_modulo
FROM 
    oev_netz.gv2010_modulo;