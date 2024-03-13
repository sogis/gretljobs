INSERT INTO
    arp_richtplan_v2.richtplankarte_ueberlagernde_linie (
        t_id,
        objektnummer,
        objekttyp,
        geometrie,
        objektname,
        abstimmungskategorie,
        bedeutung,
        astatus
        )

SELECT
    t_id,
    objektnummer,
    objekttyp,
    geometrie,
    objektname,
    abstimmungskategorie,
    bedeutung,
    astatus
FROM
    arp_richtplan_v1.richtplankarte_ueberlagernde_linie 
WHERE
    objekttyp != 'Historischer_Verkehrsweg'
;

INSERT INTO
    arp_richtplan_v2.richtplankarte_ueberlagernde_linie_dokument (
        t_id,
        dokument,
        ueberlagernde_linie
        )

SELECT 
    t_id,
    dokument,
    ueberlagernde_linie
FROM
    arp_richtplan_v1.richtplankarte_ueberlagernde_linie_dokument
;