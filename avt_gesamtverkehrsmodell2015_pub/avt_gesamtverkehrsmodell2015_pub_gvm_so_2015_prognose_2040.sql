SELECT 
    gvm_so_2015_prognose_2040.gid, 
    gvm_so_2015_prognose_2040.name, 
    gvm_so_2015_prognose_2040.sostrid, 
    gvm_so_2015_prognose_2040.eid, 
    gvm_so_2015_prognose_2040.fromnodeno, 
    gvm_so_2015_prognose_2040.tonodeno, 
    CASE
        WHEN (gvm_so_2015_prognose_2040."VOLVEHPR_1" + gvm_so_2015_prognose_2040."GR_VOLVE_1") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_prognose_2040."VOLVEHPR_1" + gvm_so_2015_prognose_2040."GR_VOLVE_1"
    END AS dtv2040, 
    CASE
        WHEN (gvm_so_2015_prognose_2040."VOLVEHPR_2" + gvm_so_2015_prognose_2040."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_prognose_2040."VOLVEHPR_2" + gvm_so_2015_prognose_2040."GR_VOLVE_2" - (gvm_so_2015_prognose_2040."VOLVEHPR_2" + gvm_so_2015_prognose_2040."GR_VOLVE_2") / 100 * 3
    END AS dtv2040_pw, 
    CASE
        WHEN (gvm_so_2015_prognose_2040."VOLVEHPR_2" + gvm_so_2015_prognose_2040."GR_VOLVE_2") <= (-198) 
            THEN 0
        ELSE (gvm_so_2015_prognose_2040."VOLVEHPR_2" + gvm_so_2015_prognose_2040."GR_VOLVE_2") / 100 * 3
    END AS dtv2040_mr, 
    CASE
        WHEN (gvm_so_2015_prognose_2040."VOLVEHPR_3" + gvm_so_2015_prognose_2040."GR_VOLVE_3") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_prognose_2040."VOLVEHPR_3" + gvm_so_2015_prognose_2040."GR_VOLVE_3"
    END AS dtv2040_li, 
    CASE
        WHEN (gvm_so_2015_prognose_2040."VOLVEHPR_4" + gvm_so_2015_prognose_2040."GR_VOLVE_4") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_prognose_2040."VOLVEHPR_4" + gvm_so_2015_prognose_2040."GR_VOLVE_4"
    END AS dtv2040_lkw, 
    CASE
        WHEN (gvm_so_2015_prognose_2040."VOLVEHPR_5" + gvm_so_2015_prognose_2040."GR_VOLVE_5") <= (-198) 
            THEN 0
        ELSE gvm_so_2015_prognose_2040."VOLVEHPR_5" + gvm_so_2015_prognose_2040."GR_VOLVE_5"
    END AS dtv2040_lz, 
    verkehrsmodell.lineslope(gvm_so_2015_prognose_2040.wkb_geometry) AS neigung_be, 
    gvm_so_2015_prognose_2040."V0PRT" AS geschwindigkeit, 
    st_length(gvm_so_2015_prognose_2040.wkb_geometry) AS laenge, 
    gvm_so_2015_prognose_2040."CAPPRT" AS kapazitaet, 
    CASE
        WHEN gvm_so_2015_prognose_2040."CAPPRT" > 0 
            THEN (100::double precision / gvm_so_2015_prognose_2040."CAPPRT"::double precision * 
            CASE
                WHEN (gvm_so_2015_prognose_2040."VOLVEHPR_1" + gvm_so_2015_prognose_2040."GR_VOLVE_1") <= (-198) 
                    THEN 0
                ELSE gvm_so_2015_prognose_2040."VOLVEHPR_1" + gvm_so_2015_prognose_2040."GR_VOLVE_1"
            END::double precision)::integer
        ELSE 0
    END AS auslastung, 
    gvm_so_2015_prognose_2040."TYPENO" AS typeno, 
    gvm_so_2015_prognose_2040.wkb_geometry
FROM 
    verkehrsmodell2015.gvm_so_2015_prognose_2040
;
