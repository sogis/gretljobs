SELECT
    t_id,
    t_ili_tid,
    objektnummer,
    objekttyp,
    objektname,
    abstimmungskategorie,
    bedeutung,
    planungsstand,
    status,
    geometrie
FROM
    arp_richtplan_delete.richtplankarte_ueberlagernde_linie
;