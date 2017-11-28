SELECT
    guid AS t_id,
    geschaeftslaufnummer,
    titel,
    beginn,
    ende,
    grundbuch,
    geschaeftseigner,
    gesuchsart,
    projektstatus,
    sachverhalt,
    xkoordinaten,
    ykoordinaten,
    wkb_geometry AS geometrie
FROM
    afu_baugk.bauprojekt
;