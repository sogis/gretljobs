SELECT
    t_id,
    t_ili_tid,
    objektnummer,
    CASE
        WHEN objekttyp = 'Juraschutzzone.ueberlagert_Landwirtschaftsgebiet' OR objekttyp = 'Juraschutzzone.ueberlagert_Wald'
            THEN 'Juraschutzzone'
        ELSE objekttyp
    END AS objekttyp,
    weitere_informationen,
    objektname,
    abstimmungskategorie,
    bedeutung,
    planungsstand,
    status,
    geometrie
FROM
    arp_richtplan.richtplankarte_ueberlagernde_flaeche
;