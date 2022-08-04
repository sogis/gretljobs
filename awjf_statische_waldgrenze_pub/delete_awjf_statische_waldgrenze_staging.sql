--Dokument
DELETE FROM
    awjf_statische_waldgrenze_staging_v1.waldgrenze_dokument
;

--waldgrenze_art_waldgrenze
DELETE FROM
    awjf_statische_waldgrenze_staging_v1.waldgrenze_art_waldgrenze
;

--waldgrenze_planungsart
DELETE FROM
    awjf_statische_waldgrenze_staging_v1.waldgrenze_planungsart
;

--waldgrenze_rechtsstatus
DELETE FROM
    awjf_statische_waldgrenze_staging_v1.waldgrenze_rechtsstatus
;

--waldgrenze_verbindlichkeit
DELETE FROM
    awjf_statische_waldgrenze_staging_v1.waldgrenze_verbindlichkeit
;

--waldgrenze_waldgrenze
DELETE FROM
    awjf_statische_waldgrenze_staging_v1.waldgrenze_waldgrenze
;

-- Basket / Dataset 
DELETE FROM
    awjf_statische_waldgrenze_staging_v1.t_ili2db_basket
;

DELETE FROM
    awjf_statische_waldgrenze_staging_v1.t_ili2db_dataset
;