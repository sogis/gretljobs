INSERT INTO
    arp_richtplan_v2.richtplankarte_ueberlagernder_punkt (
        t_id,
        objekttyp,
        spezifikation,
        geometrie,
        objektname,
        abstimmungskategorie,
        bedeutung,
        astatus
        )

SELECT
    t_id,
    objekttyp,
    spezifikation,
    geometrie,
    objektname,
    abstimmungskategorie,
    bedeutung,
    astatus
FROM
    arp_richtplan_v1.richtplankarte_ueberlagernder_punkt
;

INSERT INTO
    arp_richtplan_v2.richtplankarte_ueberlagernder_punkt_dokument (
        t_id,
        dokument,
        ueberlagernder_punkt 
        )

SELECT 
    t_id,
    dokument,
    ueberlagernder_punkt
FROM
    arp_richtplan_v1.richtplankarte_ueberlagernder_punkt_dokument