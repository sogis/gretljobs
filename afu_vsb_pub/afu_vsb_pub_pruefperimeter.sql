SELECT
    flaecheid AS t_id,
    wkb_geometry AS geometrie,
    belastungstyp,
    statustyp,
    bezeichnung,
    anz_order
FROM
    vsb.afu_pruefperimeter_qgis_server_client_t

