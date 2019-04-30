SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    ivssig,
    CASE
        WHEN 101 <= ivssig AND ivssig <= 103
            THEN 'lokal'
        WHEN 201 <= ivssig AND ivssig <= 203
            THEN 'regional'
        WHEN 301 <= ivssig AND ivssig <=303
            THEN 'national'
    END AS bedeutung,
    CASE
        WHEN ivssig % 100 = 1
            THEN 'historischer Verlauf'
        WHEN ivssig % 100 = 2
            THEN 'historischer Verlauf mit Substanz'
        WHEN ivssig % 100 =3
            THEN 'historischer Verlauf mit viel Substanz'
    END AS substanz,
    ivsid,
    ivsnr,
    ivsname,
    ivstyp,
    CASE
        WHEN ivstyp = 1
            THEN 'Strecke'
        WHEN ivstyp = 2
            THEN 'Linienführung'
        WHEN ivstyp = 3
            THEN 'Abschnitt einer Linienführung'
        WHEN ivstyp = 4
            THEN 'Abschnitt einer Strecke (wenn keine Linienführungen vorkommen)'
    END AS ivs_typ,
    ivskanton,
    ivssort,
    concat('https://geo.so.ch/docs/ch.so.arp.ivs/', ivssort,'.pdf') AS link
FROM
    public.arp_ivsso_line
WHERE
    archive = 0
;