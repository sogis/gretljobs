SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    ivssig,
    CASE 
        WHEN ivssig = 550
            THEN 'Wegkreuz'
        WHEN ivssig = 551
            THEN 'Kirche'
        WHEN ivssig = 552
            THEN 'Kapelle'
        WHEN ivssig = 553
            THEN 'Burg, Schloss / Burgstelle, Ruine'
        WHEN ivssig = 554
            THEN 'Profanes Gebäude'
        WHEN ivssig = 555
            THEN 'Gewerbebetrieb'
        WHEN ivssig = 556
            THEN 'Distanzstein'
        WHEN ivssig = 557
            THEN 'Anderer Stein'
        WHEN ivssig = 558
            THEN 'Bildstock / Wegkapelle'
        WHEN ivssig = 559
            THEN 'Brunnen'
        WHEN ivssig = 560
            THEN 'Einzelbaum'
        WHEN ivssig = 561
            THEN 'Inschrift'
        WHEN ivssig = 562
            THEN 'Anderer Wegbegleiter'
        WHEN ivssig = 564
            THEN 'Bergwerk'
        WHEN ivssig = 566
            THEN 'Anlegestelle / Hafen'
        WHEN ivssig = 567
            THEN 'Fähre'
    END AS ivs_wegbegleiter
FROM 
    public.arp_ivsso_pnt
WHERE
    archive = 0
;