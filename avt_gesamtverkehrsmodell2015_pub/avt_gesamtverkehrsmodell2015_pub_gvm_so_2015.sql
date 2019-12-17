SELECT 
    gvm_so_2015_dtv.name, 
    gvm_so_2015_dtv.sostrid, 
    gvm_so_2015_dtv.eid, 
    gvm_so_2015_dtv.fromnodeno, 
    gvm_so_2015_dtv.tonodeno, 
    CASE
        WHEN (gvm_so_2015_dtv."VOLVEHPR_1" + gvm_so_2015_dtv."GR_VOLVE_1") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_dtv."VOLVEHPR_1" + gvm_so_2015_dtv."GR_VOLVE_1"
    END AS dtv2015, 
    CASE
        WHEN (gvm_so_2015_dtv."VOLVEHPR_2" + gvm_so_2015_dtv."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_dtv."VOLVEHPR_2" + gvm_so_2015_dtv."GR_VOLVE_2" - (gvm_so_2015_dtv."VOLVEHPR_2" + gvm_so_2015_dtv."GR_VOLVE_2") / 100 * 3
    END AS dtv2015_pw, 
    CASE
        WHEN (gvm_so_2015_dtv."VOLVEHPR_2" + gvm_so_2015_dtv."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE (gvm_so_2015_dtv."VOLVEHPR_2" + gvm_so_2015_dtv."GR_VOLVE_2") / 100 * 3
    END AS dtv2015_mr, 
    CASE
        WHEN (gvm_so_2015_dtv."VOLVEHPR_3" + gvm_so_2015_dtv."GR_VOLVE_3") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_dtv."VOLVEHPR_3" + gvm_so_2015_dtv."GR_VOLVE_3"
    END AS dtv2015_li, 
    CASE
        WHEN (gvm_so_2015_dtv."VOLVEHPR_4" + gvm_so_2015_dtv."GR_VOLVE_4") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_dtv."VOLVEHPR_4" + gvm_so_2015_dtv."GR_VOLVE_4"
    END AS dtv2015_lkw, 
    CASE
        WHEN (gvm_so_2015_dtv."VOLVEHPR_5" + gvm_so_2015_dtv."GR_VOLVE_5") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_dtv."VOLVEHPR_5" + gvm_so_2015_dtv."GR_VOLVE_5"
    END AS dtv2015_lz, 
    CASE
        WHEN (gvm_so_2015_asp."VOLVEHPR_1" + gvm_so_2015_asp."GR_VOLVE_1") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_asp."VOLVEHPR_1" + gvm_so_2015_asp."GR_VOLVE_1"
    END AS asp2015, 
    CASE
        WHEN (gvm_so_2015_asp."VOLVEH_D_2" + gvm_so_2015_asp."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_asp."VOLVEH_D_2" + gvm_so_2015_asp."GR_VOLVE_2" - (gvm_so_2015_asp."VOLVEH_D_2" + gvm_so_2015_asp."GR_VOLVE_2") / 100 * 3
    END AS asp2015_pw, 
    CASE
        WHEN (gvm_so_2015_asp."VOLVEH_D_2" + gvm_so_2015_asp."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE (gvm_so_2015_asp."VOLVEH_D_2" + gvm_so_2015_asp."GR_VOLVE_2") / 100 * 3
    END AS asp2015_mr, 
    CASE
        WHEN (gvm_so_2015_asp."VOLVEH_D_3" + gvm_so_2015_asp."GR_VOLVE_3") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_asp."VOLVEH_D_3" + gvm_so_2015_asp."GR_VOLVE_3"
    END AS asp2015_li, 
    CASE
        WHEN (gvm_so_2015_asp."VOLVEH_D_4" + gvm_so_2015_asp."GR_VOLVE_4") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_asp."VOLVEH_D_4" + gvm_so_2015_asp."GR_VOLVE_4"
    END AS asp2015_lkw, 
    CASE
        WHEN (gvm_so_2015_asp."VOLVEH_D_5" + gvm_so_2015_asp."GR_VOLVE_5") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_asp."VOLVEH_D_5" + gvm_so_2015_asp."GR_VOLVE_5"
    END AS asp2015_lz, 
    CASE
        WHEN (gvm_so_2015_dwv."VOLVEHPR_1" + gvm_so_2015_dwv."GR_VOLVE_1") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_dwv."VOLVEHPR_1" + gvm_so_2015_dwv."GR_VOLVE_1"
    END AS dwv2015, 
    CASE
        WHEN (gvm_so_2015_dwv."VOLVEHPR_2" + gvm_so_2015_dwv."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_dwv."VOLVEHPR_2" + gvm_so_2015_dwv."GR_VOLVE_2" - (gvm_so_2015_dwv."VOLVEHPR_2" + gvm_so_2015_dwv."GR_VOLVE_2") / 100 * 3
    END AS dwv2015_pw, 
    CASE
        WHEN (gvm_so_2015_dwv."VOLVEHPR_2" + gvm_so_2015_dwv."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE (gvm_so_2015_dwv."VOLVEHPR_2" + gvm_so_2015_dwv."GR_VOLVE_2") / 100 * 3
    END AS dwv2015_mr, 
    CASE
        WHEN (gvm_so_2015_dwv."VOLVEHPR_3" + gvm_so_2015_dwv."GR_VOLVE_3") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_dwv."VOLVEHPR_3" + gvm_so_2015_dwv."GR_VOLVE_3"
    END AS dwv2015_li, 
    CASE
        WHEN (gvm_so_2015_dwv."VOLVEHPR_4" + gvm_so_2015_dwv."GR_VOLVE_4") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_dwv."VOLVEHPR_4" + gvm_so_2015_dwv."GR_VOLVE_4"
    END AS dwv2015_lkw, 
    CASE
        WHEN (gvm_so_2015_dwv."VOLVEHPR_5" + gvm_so_2015_dwv."GR_VOLVE_5") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_dwv."VOLVEHPR_5" + gvm_so_2015_dwv."GR_VOLVE_5"
    END AS dwv2015_lz,
    round((verkehrsmodell.lineslope(gvm_so_2015_dtv.wkb_geometry)*100)::numeric,4) AS neigung_be, 
    trim(TRAILING 'km/h' FROM gvm_so_2015_dtv."V0PRT") AS geschwindigkeit, 
    gvm_so_2015_dtv."Shape_Leng" AS laenge, 
    gvm_so_2015_dtv."CAPPRT" AS kapazitaet, 
    CASE
        WHEN (gvm_so_2015_dtv."VOLVEHPR_1" + gvm_so_2015_dtv."GR_VOLVE_1") <= (-198) OR gvm_so_2015_dtv."CAPPRT" = 0 
            THEN 0::numeric
        ELSE round((100::double precision / gvm_so_2015_dtv."CAPPRT"::double precision * (gvm_so_2015_dtv."VOLVEHPR_1" + gvm_so_2015_dtv."GR_VOLVE_1")::double precision)::numeric, 2)
    END AS auslastung, 
    gvm_so_2015_dtv."TYPENO" AS typeno, 
    gvm_so_2015_dtv.wkb_geometry
FROM 
    verkehrsmodell2015.gvm_so_2015_dtv, 
    verkehrsmodell2015.gvm_so_2015_asp, 
    verkehrsmodell2015.gvm_so_2015_dwv 
WHERE 
    gvm_so_2015_dtv.eid = gvm_so_2015_asp.eid 
    AND
    gvm_so_2015_dtv.eid = gvm_so_2015_dwv.eid
    AND 
    (gvm_so_2015_dtv."VOLVEHPR_1" + gvm_so_2015_dtv."GR_VOLVE_1") > 50
;
