SELECT 
    a.gid, 
    a.name, 
    a.sostrid, 
    a.eid, 
    a.fromnodeno, 
    a.tonodeno, 
    CASE
        WHEN (a."VOLVEHPR_1" + a."GR_VOLVE_1") <= (-198) 
            THEN 0
        ELSE a."VOLVEHPR_1" + a."GR_VOLVE_1"
    END AS dtv2040, 
    CASE
        WHEN (a."VOLVEHPR_2" + a."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE a."VOLVEHPR_2" + a."GR_VOLVE_2" - (a."VOLVEHPR_2" + a."GR_VOLVE_2") / 100 * 3
    END AS dtv2040_pw, 
    CASE
        WHEN (a."VOLVEHPR_2" + a."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE (a."VOLVEHPR_2" + a."GR_VOLVE_2") / 100 * 3
    END AS dtv2040_mr, 
    CASE
        WHEN (a."VOLVEHPR_3" + a."GR_VOLVE_3") <= (-198) 
            THEN 0
        ELSE a."VOLVEHPR_3" + a."GR_VOLVE_3"
    END AS dtv2040_li, 
    CASE
        WHEN (a."VOLVEHPR_4" + a."GR_VOLVE_4") <= (-198) 
            THEN 0
        ELSE a."VOLVEHPR_4" + a."GR_VOLVE_4"
    END AS dtv2040_lkw, 
    CASE
        WHEN (a."VOLVEHPR_5" + a."GR_VOLVE_5") <= (-198) 
            THEN 0
        ELSE a."VOLVEHPR_5" + a."GR_VOLVE_5"
    END AS dtv2040_lz, 
    CASE
        WHEN (b."VOLVEHPR_1" + b."GR_VOLVE_1") <= (-198) 
            THEN 0
        ELSE b."VOLVEHPR_1" + b."GR_VOLVE_1"
    END AS asp2040, 
    CASE
        WHEN (b."VOLVEHPR_2" + b."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE b."VOLVEHPR_2" + b."GR_VOLVE_2" - (b."VOLVEHPR_2" + b."GR_VOLVE_2") / 100 * 3
    END AS asp2040_pw, 
    CASE
        WHEN (b."VOLVEHPR_2" + b."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE (b."VOLVEHPR_2" + b."GR_VOLVE_2") / 100 * 3
    END AS asp2040_mr, 
    CASE
        WHEN (b."VOLVEHPR_3" + b."GR_VOLVE_3") <= (-198) 
            THEN 0
        ELSE b."VOLVEHPR_3" + b."GR_VOLVE_3"
    END AS asp2040_li, 
    CASE
        WHEN (b."VOLVEHPR_4" + b."GR_VOLVE_4") <= (-198) 
            THEN 0
        ELSE b."VOLVEHPR_4" + b."GR_VOLVE_4"
    END AS asp2040_lkw, 
    CASE
        WHEN (b."VOLVEHPR_5" + b."GR_VOLVE_5") <= (-198) 
            THEN 0
        ELSE b."VOLVEHPR_5" + b."GR_VOLVE_5"
    END AS asp2040_lz,   
    CASE
        WHEN (c."VOLVEHPR_1" + c."GR_VOLVE_1") <= (-198) 
            THEN 0
        ELSE c."VOLVEHPR_1" + c."GR_VOLVE_1"
    END AS dwv2040, 
    CASE
        WHEN (c."VOLVEHPR_2" + c."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE c."VOLVEHPR_2" + c."GR_VOLVE_2" - (c."VOLVEHPR_2" + c."GR_VOLVE_2") / 100 * 3
    END AS dwv2040_pw, 
    CASE
        WHEN (c."VOLVEHPR_2" + c."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE (c."VOLVEHPR_2" + c."GR_VOLVE_2") / 100 * 3
    END AS dwv2040_mr, 
    CASE
        WHEN (c."VOLVEHPR_3" + c."GR_VOLVE_3") <= (-198) 
            THEN 0
        ELSE c."VOLVEHPR_3" + c."GR_VOLVE_3"
    END AS dwv2040_li, 
    CASE
        WHEN (c."VOLVEHPR_4" + c."GR_VOLVE_4") <= (-198) 
            THEN 0
        ELSE c."VOLVEHPR_4" + c."GR_VOLVE_4"
    END AS dwv2040_lkw, 
    CASE
        WHEN (c."VOLVEHPR_5" + c."GR_VOLVE_5") <= (-198) 
            THEN 0
        ELSE c."VOLVEHPR_5" + c."GR_VOLVE_5"
    END AS dwv2040_lz,
    verkehrsmodell.lineslope(a.wkb_geometry) AS neigung_be, 
    trim(TRAILING 'km/h' FROM a."V0PRT") AS geschwindigkeit, 
    st_length(a.wkb_geometry) AS laenge, 
    a."CAPPRT" AS kapazitaet, 
    CASE
        WHEN a."CAPPRT" > 0 
            THEN (100::double precision / a."CAPPRT"::double precision * 
            CASE
                WHEN (a."VOLVEHPR_1" + a."GR_VOLVE_1") <= (-198) 
                    THEN 0
                ELSE a."VOLVEHPR_1" + a."GR_VOLVE_1"
            END::double precision)::integer
        ELSE 0
    END AS auslastung, 
    a."TYPENO" AS typeno, 
    a.wkb_geometry
FROM 
    verkehrsmodell2015.gvm_so_2015_prognose_2040 a, 
    verkehrsmodell2015.gvm_so_2015_prognose_2040_asp b, 
    verkehrsmodell2015.gvm_so_2015_prognose_2040_dwv c
WHERE 
    a.gid = b.gid
    AND
    a.gid = c.gid
    AND
    (a."VOLVEHPR_1" + a."GR_VOLVE_1") > 50
;
