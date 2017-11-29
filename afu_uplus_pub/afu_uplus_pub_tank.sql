SELECT 
    tank.tksmitarbeiters AS gis_user, 
    tank.tksid AS gis_id, 
    (tank.tkstanknrs::text || '-'::text) || tank.tkstankzusatzs::text AS tank_nr, 
    usstandort.ustbezeichnungs AS bezeichnung, 
    (usstandort.uststrasses::text || ' '::text) || usstandort.usthausnummers::text AS strnr, 
    (usstandort.ustplzs::text || ' '::text) || usstandort.ustorts::text AS plzort, 
    tank.tksvolumenl AS volumen, tank.tkszones AS gwsz, 
    CASE
        WHEN tank.tksbewilligungn = 0 
            THEN 'weiss'::text
        WHEN tank.tksbewilligungn = 1 
            THEN 'gelb/weiss'::text
        WHEN tank.tksbewilligungn = 2 
            THEN 'gelb'::text
        WHEN tank.tksbewilligungn = 3 
            THEN 'blau'::text
        WHEN tank.tksbewilligungn = 4 
            THEN 'rot'::text
        WHEN tank.tksbewilligungn = 9 
            THEN 'nicht bestimmt'::text
        ELSE ''::text
    END AS gefahrenzone, 
    tank.tkslagerguts AS lagergut, 
    codesid.coicode1s AS lagergutbez, 
    tank.tksstatuss AS status, 
    t.dtesprache1s AS statusbez, 
    tank.tkstanknrs::integer AS tanknr, 
    tank.tkstankzusatzs AS tanknrzusatz, 
    tank.tksanlages AS anlagetyp, 
    d.dtesprache1s AS anlagetypbez, 
    tank.tksid AS t_id, 
    usstandort.ustkoordx1f AS ustkoordx, 
    usstandort.ustkoordy1f AS ustkoordy, 
    usstandort.ustgeometry1o AS geometrie
FROM 
    uplus_so.tank
    LEFT JOIN uplus_so.usstandort 
        ON usstandort.ustid = tank.tksustid
    LEFT JOIN uplus_so.codesid 
        ON tank.tkslagerguts::integer = codesid.coiid
    LEFT JOIN uplus_so.deftext d 
        ON 
            d.dtegruppes::text = 'TksAnlageS'::text 
            AND 
            tank.tksanlages::integer = d.dtenummerl
    LEFT JOIN uplus_so.deftext t 
        ON 
            t.dtegruppes::text = 'TksStatusS'::text 
            AND 
            tank.tksstatuss::text = t.dteinterns::text
WHERE 
    tank.tksaufid = 70 
    AND 
    usstandort.ustkoordx1f IS NOT NULL 
    AND 
    usstandort.ustkoordy1f IS NOT NULL 
    AND 
    usstandort.ustkoordx2f IS NULL 
    AND 
    usstandort.ustkoordy2f IS NULL
    
    
UNION 


SELECT 
    tank.tksmitarbeiters AS gis_user, 
    tank.tksid AS gis_id, 
    (tank.tkstanknrs::text || '-'::text) || tank.tkstankzusatzs::text AS tank_nr, 
    usstandort.ustbezeichnungs AS bezeichnung, 
    (usstandort.uststrasses::text || ' '::text) || usstandort.usthausnummers::text AS strnr, 
    (usstandort.ustplzs::text || ' '::text) || usstandort.ustorts::text AS plzort, 
    tank.tksvolumenl AS volumen, 
    tank.tkszones AS gwsz, 
    CASE
        WHEN tank.tksbewilligungn = 0 
            THEN 'weiss'::text
        WHEN tank.tksbewilligungn = 1 
            THEN 'gelb/weiss'::text
        WHEN tank.tksbewilligungn = 2 
            THEN 'gelb'::text
        WHEN tank.tksbewilligungn = 3 
            THEN 'blau'::text
        WHEN tank.tksbewilligungn = 4 
            THEN 'rot'::text
        WHEN tank.tksbewilligungn = 9 
            THEN 'nicht bestimmt'::text
        ELSE ''::text
    END AS gefahrenzone, 
    tank.tkslagerguts AS lagergut, 
    codesid.coicode1s AS lagergutbez, 
    tank.tksstatuss AS status, 
    t.dtesprache1s AS statusbez, 
    tank.tkstanknrs::integer AS tanknr, 
    tank.tkstankzusatzs AS tanknrzusatz, 
    tank.tksanlages AS anlagetyp, 
    d.dtesprache1s AS anlagetypbez, 
    tank.tksid AS t_id, 
    usstandort.ustkoordx2f AS ustkoordx, 
    usstandort.ustkoordy2f AS ustkoordy, 
    usstandort.ustgeometry2o AS geometrie
FROM uplus_so.tank
    LEFT JOIN uplus_so.usstandort 
        ON usstandort.ustid = tank.tksustid
    LEFT JOIN uplus_so.codesid 
        ON tank.tkslagerguts::integer = codesid.coiid
    LEFT JOIN uplus_so.deftext d 
        ON 
            d.dtegruppes::text = 'TksAnlageS'::text 
            AND 
            tank.tksanlages::integer = d.dtenummerl
    LEFT JOIN uplus_so.deftext t 
        ON 
            t.dtegruppes::text = 'TksStatusS'::text 
            AND 
            tank.tksstatuss::text = t.dteinterns::text
WHERE 
    tank.tksaufid = 70 
    AND 
    usstandort.ustkoordx2f IS NOT NULL 
    AND 
    usstandort.ustkoordy2f IS NOT NULL
;