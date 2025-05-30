-- Datenumbau ins DMAV DMAVSUP_UntereinheitGrundbuch_V1_0. Dient zur Datenabgabe in diesem Modell. 
-- Daten könnten pro Gemeinde (dataset) exporteirt werden.

DELETE
    FROM
        agi_dmav_untereinheit_grundbuch_v1.t_ili2db_basket
;


DELETE
    FROM
        agi_dmav_untereinheit_grundbuch_v1.t_ili2db_dataset
;

DELETE
    FROM
        agi_dmav_untereinheit_grundbuch_v1.unterenhtgrndbuch_grundbuchkreis
;

WITH grundbucheinheit AS (
    SELECT
        kreis.bfsnr AS t_datasetname,
        'SO' AS kanton,
        kreis.bfsnr AS gemeinde,
        kreis.nbident,
        kreis.aname,
        kreis.nbident AS egris_subkreis,
        kreis.grundbuchkreisnummer AS egris_los
     FROM
        agi_av_gb_administrative_einteilungen_v2.grundbuchkreise_grundbuchkreis AS kreis
    )

INSERT INTO agi_dmav_untereinheit_grundbuch_v1.t_ili2db_dataset
SELECT
    DISTINCT ON (kreis.gemeinde)
    nextval('agi_dmav_untereinheit_grundbuch_v1.t_ili2db_seq'::regclass) AS t_id,
    kreis.gemeinde AS t_datasetname
FROM
    grundbucheinheit AS kreis
;

INSERT INTO agi_dmav_untereinheit_grundbuch_v1.t_ili2db_basket
SELECT
    nextval('agi_dmav_untereinheit_grundbuch_v1.t_ili2db_seq'::regclass) AS t_id,
    dataset.t_id AS dataset,
    'DMAVSUP_UntereinheitGrundbuch_V1_0.UntereinheitGrundbuch' AS topic,
    'dmav_untereinheit_grundbuch_' || dataset.datasetname AS t_ili_tid,
    dataset.datasetname AS attachmentkey,
    NULL AS domains
FROM
    agi_dmav_untereinheit_grundbuch_v1.t_ili2db_dataset AS dataset    
;

WITH grundbucheinheit AS (
    SELECT
        kreis.bfsnr AS t_datasetname,
        'SO' AS kanton,
        kreis.bfsnr AS gemeinde,
        kreis.nbident,
        kreis.aname,
        kreis.nbident AS egris_subkreis,
        kreis.grundbuchkreisnummer AS egris_los
     FROM
        agi_av_gb_administrative_einteilungen_v2.grundbuchkreise_grundbuchkreis AS kreis
    )

INSERT INTO agi_dmav_untereinheit_grundbuch_v1.unterenhtgrndbuch_grundbuchkreis
SELECT
    nextval('agi_dmav_untereinheit_grundbuch_v1.t_ili2db_seq'::regclass) AS t_id,
    b.t_id AS t_basket,
    kreis.t_datasetname,
    'SO' AS kanton,
    kreis.gemeinde,
    kreis.nbident,
    kreis.aname,
    kreis.egris_subkreis,
    kreis.egris_los
FROM
   grundbucheinheit AS kreis
    LEFT JOIN
        agi_dmav_untereinheit_grundbuch_v1.t_ili2db_basket AS b
            ON kreis.gemeinde = b.attachmentkey::integer
;