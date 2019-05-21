SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    bstnr,
    jahr,
    koord_x,
    koord_y,
    status_bst,
    pid_2015,
    CASE 
        WHEN saisonal = '0' 
            THEN 'Nein'
        ELSE 'Ja'
    END AS saisonal,
    "name",
    tel_p,
    tel_g,
    mobile,
    email,
    plz,
    ort
FROM
    gelan.bienen_stao_v
WHERE
    jahr = ${publikationsjahr_wechsel_herbst}
;
