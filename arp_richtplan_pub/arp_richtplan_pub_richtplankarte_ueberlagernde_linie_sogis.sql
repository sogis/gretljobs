/*Bahnlinien bestehend - Richtplankarte*/
SELECT
    uuid_generate_v4() AS t_ili_tid,
    NULL AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    NULL AS dokumente,
    'bestehend' AS astatus,
    NULL AS objektnummer,
    CASE 
        WHEN tunnel IS TRUE
            THEN 'Bahnlinie.Tunnel'
        ELSE 'Bahnlinie.Schiene'
    END AS objekttyp,
    wkb_geometry AS geometrie
FROM
    public.avt_oev_netz
WHERE
    typ IN (2,3)
    AND
    "archive" = 0
;
