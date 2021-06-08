SELECT
    address.t_ili_tid,
    address.adr_egaid AS egaid,
    address.str_esid AS esid,
    address.bdg_egid AS egid,
    address.adr_edid AS edid,
    CASE 
        WHEN localisationname.stn_text IS NOT NULL THEN localisationname.stn_text
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
    address.adr_modified AS letzteaenderung,
    address.pnt_shape AS geometrie
FROM
    agi_swisstopo_gebaeudeadressen.officlndxfddrsses_address AS address
    LEFT JOIN agi_swisstopo_gebaeudeadressen.officlndxfddrsses_stn AS localisationname
    ON localisationname.offclndxfddrsss_ddress_stn_name = address.t_id 
    LEFT JOIN agi_swisstopo_gebaeudeadressen.officlndxfddrsses_zip AS zip
    ON zip.offclndxfddrsss_ddress_zip_zip6= address.t_id 
--LIMIT 100000   
;

