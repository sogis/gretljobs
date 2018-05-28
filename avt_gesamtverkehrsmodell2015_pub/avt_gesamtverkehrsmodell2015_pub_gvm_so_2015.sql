SELECT gvm_so_2015_dtv.name, gvm_so_2015_dtv.sostrid, gvm_so_2015_dtv.eid, 
    gvm_so_2015_dtv.fromnodeno, gvm_so_2015_dtv.tonodeno, 
        CASE
            WHEN (gvm_so_2015_dtv."VOLVEHPR_1" + gvm_so_2015_dtv."GR_VOLVE_1") = (-198) THEN 0
            ELSE gvm_so_2015_dtv."VOLVEHPR_1" + gvm_so_2015_dtv."GR_VOLVE_1"
        END AS dtv2015, 
        CASE
            WHEN (gvm_so_2015_dtv."VOLVEHPR_2" + gvm_so_2015_dtv."GR_VOLVE_2") = (-198) THEN 0
            ELSE gvm_so_2015_dtv."VOLVEHPR_2" + gvm_so_2015_dtv."GR_VOLVE_2" - (gvm_so_2015_dtv."VOLVEHPR_2" + gvm_so_2015_dtv."GR_VOLVE_2") / 100 * 3
        END AS dtv2015_pw, 
        CASE
            WHEN (gvm_so_2015_dtv."VOLVEHPR_2" + gvm_so_2015_dtv."GR_VOLVE_2") = (-198) THEN 0
            ELSE (gvm_so_2015_dtv."VOLVEHPR_2" + gvm_so_2015_dtv."GR_VOLVE_2") / 100 * 3
        END AS dtv2015_mr, 
        CASE
            WHEN (gvm_so_2015_dtv."VOLVEHPR_3" + gvm_so_2015_dtv."GR_VOLVE_3") = (-198) THEN 0
            ELSE gvm_so_2015_dtv."VOLVEHPR_3" + gvm_so_2015_dtv."GR_VOLVE_3"
        END AS dtv2015_li, 
        CASE
            WHEN (gvm_so_2015_dtv."VOLVEHPR_4" + gvm_so_2015_dtv."GR_VOLVE_4") = (-198) THEN 0
            ELSE gvm_so_2015_dtv."VOLVEHPR_4" + gvm_so_2015_dtv."GR_VOLVE_4"
        END AS dtv2015_lkw, 
        CASE
            WHEN (gvm_so_2015_dtv."VOLVEHPR_5" + gvm_so_2015_dtv."GR_VOLVE_5") = (-198) THEN 0
            ELSE gvm_so_2015_dtv."VOLVEHPR_5" + gvm_so_2015_dtv."GR_VOLVE_5"
        END AS dtv2015_lz, 
    verkehrsmodell.lineslope(gvm_so_2015_dtv.wkb_geometry) AS neigung_be, 
    gvm_so_2015_dtv."V0PRT" AS geschwindigkeit, 
    gvm_so_2015_dtv."Shape_Leng" AS laenge, 
    gvm_so_2015_dtv."CAPPRT" AS kapazitaet, 
        CASE
            WHEN (gvm_so_2015_dtv."VOLVEHPR_1" + gvm_so_2015_dtv."GR_VOLVE_1") = (-198) OR gvm_so_2015_dtv."CAPPRT" = 0 THEN 0::numeric
            ELSE round((100::double precision / gvm_so_2015_dtv."CAPPRT"::double precision * (gvm_so_2015_dtv."VOLVEHPR_1" + gvm_so_2015_dtv."GR_VOLVE_1")::double precision)::numeric, 2)
        END AS auslastung, 
    gvm_so_2015_dtv."TYPENO" AS typeno, gvm_so_2015_dtv.wkb_geometry
   FROM verkehrsmodell2015.gvm_so_2015_dtv;
