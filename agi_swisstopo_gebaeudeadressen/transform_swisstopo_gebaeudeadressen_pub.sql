SELECT
    address.t_ili_tid,
    address.adr_egaid AS egaid,
    address.str_esid AS esid,
    address.bdg_egid AS egid,
    address.adr_edid AS edid,
    CASE 
        WHEN localisationname.stn_text_en IS NOT NULL THEN localisationname.stn_text_en
        WHEN localisationname.stn_text_rm IS NOT NULL THEN localisationname.stn_text_rm
        WHEN localisationname.stn_text_it IS NOT NULL THEN localisationname.stn_text_it
        WHEN localisationname.stn_text_fr IS NOT NULL THEN localisationname.stn_text_fr
        WHEN localisationname.stn_text_de IS NOT NULL THEN localisationname.stn_text_de
    END AS strassenname,
    address.adr_number AS nummer,
    address.bdg_name AS gebaeudename,
    zip.zip_zip4 AS plz4,
    CAST(CAST(zip.zip_zip4 AS text) || LPAD(CAST(zip.zip_zipa AS text), 2, '0') AS integer) AS plz6,
    zip.zip_name AS ortschaft,
    address.com_fosnr AS bfsnr,
    CASE 
        WHEN address.adr_status = 'planned' THEN 'geplant'
        WHEN address.adr_status = 'real' THEN 'real'
        WHEN address.adr_status = 'outdated' THEN 'abgebrochen'
    END AS astatus,
    address.adr_official AS offiziell,
    address.adr_reliable AS zuverlaessig,
    modinfo.latestmodification AS letzteaenderung,
    address.pnt_shape AS geometrie
FROM
    agi_swisstopo_gebaeudeadressen.officlndxfddrsses_address AS address
    LEFT JOIN agi_swisstopo_gebaeudeadressen.officlndxfddrsses_localisationname AS localisationname
    ON localisationname.offclndxfddrsss_ddress_stn_name = address.t_id 
    LEFT JOIN agi_swisstopo_gebaeudeadressen.officlndxfddrsses_zip6 AS zip
    ON zip.offclndxfddrsss_ddress_adr_zip = address.t_id 
    LEFT JOIN agi_swisstopo_gebaeudeadressen.modinfo AS modinfo
    ON modinfo.offclndxfddrsss_ddress_adr_modified = address.t_id 
--LIMIT 100000   
;

