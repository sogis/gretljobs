SELECT 
    gvm_so_2015_prognose_2025.gid, 
    gvm_so_2015_prognose_2025.name, 
    gvm_so_2015_prognose_2025.sostrid, 
    gvm_so_2015_prognose_2025.eid, 
    gvm_so_2015_prognose_2025.fromnodeno, 
    gvm_so_2015_prognose_2025.tonodeno, 
    CASE
        WHEN (gvm_so_2015_prognose_2025."VOLVEHPR_1" + gvm_so_2015_prognose_2025."GR_VOLVE_1") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_prognose_2025."VOLVEHPR_1" + gvm_so_2015_prognose_2025."GR_VOLVE_1"
    END AS dtv2025, 
    CASE
        WHEN (gvm_so_2015_prognose_2025."VOLVEHPR_2" + gvm_so_2015_prognose_2025."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_prognose_2025."VOLVEHPR_2" + gvm_so_2015_prognose_2025."GR_VOLVE_2" - (gvm_so_2015_prognose_2025."VOLVEHPR_2" + gvm_so_2015_prognose_2025."GR_VOLVE_2") / 100 * 3
    END AS dtv2025_pw, 
    CASE
        WHEN (gvm_so_2015_prognose_2025."VOLVEHPR_2" + gvm_so_2015_prognose_2025."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE (gvm_so_2015_prognose_2025."VOLVEHPR_2" + gvm_so_2015_prognose_2025."GR_VOLVE_2") / 100 * 3
    END AS dtv2025_mr, 
    CASE
        WHEN (gvm_so_2015_prognose_2025."VOLVEHPR_3" + gvm_so_2015_prognose_2025."GR_VOLVE_3") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_prognose_2025."VOLVEHPR_3" + gvm_so_2015_prognose_2025."GR_VOLVE_3"
    END AS dtv2025_li, 
    CASE
        WHEN (gvm_so_2015_prognose_2025."VOLVEHPR_4" + gvm_so_2015_prognose_2025."GR_VOLVE_4") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_prognose_2025."VOLVEHPR_4" + gvm_so_2015_prognose_2025."GR_VOLVE_4"
    END AS dtv2025_lkw, 
    CASE
        WHEN (gvm_so_2015_prognose_2025."VOLVEHPR_5" + gvm_so_2015_prognose_2025."GR_VOLVE_5") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_prognose_2025."VOLVEHPR_5" + gvm_so_2015_prognose_2025."GR_VOLVE_5"
    END AS dtv2025_lz, 
    verkehrsmodell.lineslope(gvm_so_2015_prognose_2025.wkb_geometry) AS neigung_be, 
    gvm_so_2015_prognose_2025."V0PRT" AS geschwindigkeit, 
    st_length(gvm_so_2015_prognose_2025.wkb_geometry) AS laenge, 
    gvm_so_2015_prognose_2025."CAPPRT" AS kapazitaet, 
    CASE
        WHEN gvm_so_2015_prognose_2025."CAPPRT" > 0 THEN (100::double precision / gvm_so_2015_prognose_2025."CAPPRT"::double precision * 
        CASE
            WHEN (gvm_so_2015_prognose_2025."VOLVEHPR_1" + gvm_so_2015_prognose_2025."GR_VOLVE_1") <= (-198) 
                THEN 0
            ELSE gvm_so_2015_prognose_2025."VOLVEHPR_1" + gvm_so_2015_prognose_2025."GR_VOLVE_1"
        END::double precision)::integer
        ELSE 0
    END AS auslastung, 
    gvm_so_2015_prognose_2025."TYPENO" AS typeno, 
    gvm_so_2015_prognose_2025.wkb_geometry
FROM 
    verkehrsmodell2015.gvm_so_2015_prognose_2025
WHERE 
    (gvm_so_2015_prognose_2025."VOLVEHPR_1" + gvm_so_2015_prognose_2025."GR_VOLVE_1") > 50
;
