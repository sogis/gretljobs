--Dokument
DELETE FROM
    afu_gewaesserschutz_staging_v3.gewaesserschutz_dokument
;

DELETE FROM
    afu_gewaesserschutz_staging_v3.gewaesserschutz_gewaesserschutzbereich
;

DELETE FROM
    afu_gewaesserschutz_staging_v3.gewaesserschutz_bereich_typ
;

DELETE FROM
    afu_gewaesserschutz_staging_v3.gewaesserschutz_rechtsstatusart
;

DELETE FROM
    afu_gewaesserschutz_staging_v3.gewaesserschutz_schutzareal
;

DELETE FROM
    afu_gewaesserschutz_staging_v3.gewaesserschutz_schutzzone
;

DELETE FROM
    afu_gewaesserschutz_staging_v3.gewaesserschutz_zoneundareal_typ
;

DELETE FROM
    afu_gewaesserschutz_staging_v3.gewaesserschutz_zustroembereich
;

-- Basket / Dataset 
DELETE FROM
    afu_gewaesserschutz_staging_v3.t_ili2db_basket
;

DELETE FROM
    afu_gewaesserschutz_staging_v3.t_ili2db_dataset
;