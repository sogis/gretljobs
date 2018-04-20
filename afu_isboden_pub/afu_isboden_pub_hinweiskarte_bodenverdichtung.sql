SELECT
    ogc_fid AS t_id,
    risk_final,
    verdempf_t,
    wkb_geometry AS geometrie
FROM
    afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t
;