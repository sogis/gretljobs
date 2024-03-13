INSERT INTO
    arp_richtplan_v2.richtplankarte_ueberlagernde_flaeche (
        t_id,
        objektnummer,
        objekttyp,
        weitere_informationen,
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
    weitere_informationen,
    geometrie,
    objektname,
    abstimmungskategorie,
    bedeutung,
    astatus
FROM
    arp_richtplan_v1.richtplankarte_ueberlagernde_flaeche
WHERE
    objekttyp != 'Juraschutzzone'
AND
    t_id != 4689
;

INSERT INTO
    arp_richtplan_v2.richtplankarte_ueberlagernde_flaeche_dokument (
        t_id,
        dokument,
        ueberlagernde_flaeche
        )

SELECT 
    d.t_id,
    d.dokument,
    d.ueberlagernde_flaeche
FROM
    arp_richtplan_v1.richtplankarte_ueberlagernde_flaeche_dokument AS d
INNER JOIN
    arp_richtplan_v2.richtplankarte_ueberlagernde_flaeche AS f ON d.ueberlagernde_flaeche = f.t_id
;