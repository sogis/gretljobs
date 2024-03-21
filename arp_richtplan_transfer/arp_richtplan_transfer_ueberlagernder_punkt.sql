DELETE FROM 
    arp_richtplan_v2.richtplankarte_ueberlagernder_punkt
;

DELETE FROM
    arp_richtplan_v2.richtplankarte_dokument
;

ALTER TABLE arp_richtplan_v2.richtplankarte_ueberlagernder_punkt
ADD COLUMN t_id_old INTEGER
;

ALTER TABLE arp_richtplan_v2.richtplankarte_dokument
ADD COLUMN t_id_old INTEGER
;

INSERT INTO arp_richtplan_v2.richtplankarte_ueberlagernder_punkt (
    objekttyp,
    spezifikation,
    geometrie,
    anpassung,
    objektname,
    abstimmungskategorie,
    bedeutung,
    astatus,
    t_id_old
    )

SELECT
    objekttyp,
    spezifikation,
    geometrie,
    CASE planungsstand
        WHEN 'in_Bearbeitung'
        THEN 0
        WHEN 'in_Auflage'
        THEN 1
        WHEN 'rechtsgueltig'
        THEN 2
    END AS anpassung,
    objektname,
    abstimmungskategorie,
    bedeutung,
    astatus,
    t_id AS t_id_old
FROM
    arp_richtplan_v1.richtplankarte_ueberlagernder_punkt
;

INSERT INTO arp_richtplan_v2.richtplankarte_dokument (
    titel,
    publiziertab,
    dateipfad,
    bemerkung,
    t_id_old
    )

SELECT
    titel,
    publiziertab,
    dateipfad,
    bemerkung,
    t_id AS t_id_old
FROM
    arp_richtplan_v1.richtplankarte_dokument
;

INSERT INTO arp_richtplan_v2.richtplankarte_ueberlagernder_punkt_dokument (
    dokument,
    ueberlagernder_punkt
    )

SELECT
    dokument,
    ueberlagernder_punkt
FROM
    arp_richtplan_v1.richtplankarte_ueberlagernder_punkt_dokument
;

UPDATE
    arp_richtplan_v2.richtplankarte_ueberlagernder_punkt_dokument
SET
    dokument = t_id
FROM
    arp_richtplan_v2.richtplankarte_dokument 
WHERE
    arp_richtplan_v2.richtplankarte_ueberlagernder_punkt_dokument.dokument = arp_richtplan_v2.richtplankarte_dokument.t_id_old
;

UPDATE
    arp_richtplan_v2.richtplankarte_ueberlagernder_punkt_dokument
SET
    ueberlagernder_punkt = t_id
FROM
    arp_richtplan_v2.richtplankarte_ueberlagernder_punkt
WHERE
    arp_richtplan_v2.richtplankarte_ueberlagernder_punkt_dokument.ueberlagernder_punkt = arp_richtplan_v2.richtplankarte_ueberlagernder_punkt.t_id_old
;

ALTER TABLE arp_richtplan_v2.richtplankarte_ueberlagernder_punkt
DROP COLUMN t_id_old
;

ALTER TABLE arp_richtplan_v2.richtplankarte_dokument
DROP COLUMN t_id_old
;