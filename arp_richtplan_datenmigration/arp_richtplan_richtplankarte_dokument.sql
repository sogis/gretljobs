INSERT INTO
    arp_richtplan_v2.richtplankarte_dokument (
        t_id,
        titel,
        publiziertab,
        dateipfad,
        bemerkung
        )

SELECT
    t_id,
    titel,
    publiziertab,
    dateipfad,
    bemerkung
FROM
    arp_richtplan_v1.richtplankarte_dokument
;