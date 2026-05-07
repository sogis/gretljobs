WITH
wt_tab70_1 AS (
  SELECT 'Pb'::varchar(5) AS metall, 2.49::float8 AS von, 2.71::float8 AS bis, 1.0::float8 AS wert1 UNION ALL
  SELECT 'Pb', 2.79, 3.21, 2.0 UNION ALL
  SELECT 'Pb', 3.29, 3.71, 3.0 UNION ALL
  SELECT 'Pb', 3.79, 4.21, 4.0 UNION ALL
  SELECT 'Pb', 4.29, 4.71, 5.0 UNION ALL
  SELECT 'Pb', 4.79, 5.21, 5.0 UNION ALL
  SELECT 'Pb', 5.29, 5.71, 5.0 UNION ALL
  SELECT 'Pb', 5.79, 6.21, 5.0 UNION ALL
  SELECT 'Pb', 6.29, 6.71, 5.0 UNION ALL
  SELECT 'Pb', 6.79, 8.01, 5.0
),

wt_tab70_2 AS (
  SELECT 'Pb'::varchar(5) AS metall, 4.0::float8 AS grenz_ph, 5.0::float8 AS humus, 4.0::float8 AS ton
),

wt_tab70_3 AS (
  SELECT  8::int4 AS hum_von,  15::int4 AS hum_bis, 2.0::float8 AS bind_st, 0.5::float8 AS wert2 UNION ALL
  SELECT 15, 100, 2.0, 0.5 UNION ALL
  SELECT  0,   2, 2.0, 0.0 UNION ALL
  SELECT  2,   8, 2.0, 0.0 UNION ALL
  SELECT  8,  15, 3.0, 0.5 UNION ALL
  SELECT 15, 100, 3.0, 1.0 UNION ALL
  SELECT  0,   2, 3.0, 0.0 UNION ALL
  SELECT  2,   8, 3.0, 0.5 UNION ALL
  SELECT  8,  15, 3.5, 1.0 UNION ALL
  SELECT 15, 100, 3.5, 1.0 UNION ALL
  SELECT  0,   2, 3.5, 0.0 UNION ALL
  SELECT  2,   8, 3.5, 0.5 UNION ALL
  SELECT 15, 100, 4.0, 1.5 UNION ALL
  SELECT  8,  15, 4.0, 1.0 UNION ALL
  SELECT  2,   8, 4.0, 0.5 UNION ALL
  SELECT  0,   2, 4.0, 0.0 UNION ALL
  SELECT 15, 100, 5.0, 2.0 UNION ALL
  SELECT  8,  15, 5.0, 1.5 UNION ALL
  SELECT  2,   8, 5.0, 1.0 UNION ALL
  SELECT  0,   2, 5.0, 0.0
),

wt_tab70_4 AS (
  SELECT  0::int4 AS ton_von,  5::int4 AS ton_bis, 2::int4 AS bind_st, 0.0::float8 AS wert3 UNION ALL
  SELECT  5, 12, 2, 0.0 UNION ALL
  SELECT 12, 25, 2, 0.5 UNION ALL
  SELECT 25, 65, 2, 0.5 UNION ALL
  SELECT 65,100, 2, 0.5 UNION ALL
  SELECT  0,  5, 3, 0.0 UNION ALL
  SELECT  5, 12, 3, 0.0 UNION ALL
  SELECT 12, 25, 3, 0.5 UNION ALL
  SELECT 25, 65, 3, 0.5 UNION ALL
  SELECT 65,100, 3, 1.0 UNION ALL
  SELECT  0,  5, 4, 0.0 UNION ALL
  SELECT  5, 12, 4, 0.5 UNION ALL
  SELECT 12, 25, 4, 0.5 UNION ALL
  SELECT 25, 65, 4, 1.0 UNION ALL
  SELECT 65,100, 4, 1.5 UNION ALL
  SELECT  0,  5, 5, 0.0 UNION ALL
  SELECT  5, 12, 5, 0.5 UNION ALL
  SELECT 12, 25, 5, 1.0 UNION ALL
  SELECT 25, 65, 5, 1.5 UNION ALL
  SELECT 65,100, 5, 2.0
),

wt_tab70_4sk AS (
  SELECT '4'::text AS skelett, 0.5::float8 AS minuswert UNION ALL
  SELECT '4-5', 0.5 UNION ALL
  SELECT '4-6', 0.5 UNION ALL
  SELECT '4-7', 0.5 UNION ALL
  SELECT '5',   0.5 UNION ALL
  SELECT '5-6', 0.5 UNION ALL
  SELECT '5-7', 0.5 UNION ALL
  SELECT '5-8', 0.5 UNION ALL
  SELECT '6',   0.5 UNION ALL
  SELECT '6-7', 0.5 UNION ALL
  SELECT '6-8', 0.5 UNION ALL
  SELECT '6-9', 0.5 UNION ALL
  SELECT '7',   0.5 UNION ALL
  SELECT '7-8', 1.0 UNION ALL
  SELECT '7-9', 1.0 UNION ALL
  SELECT '8',   1.0 UNION ALL
  SELECT '9',   1.0
),

select_table AS (
    SELECT
        t_id AS pk_bodeneinheit,
        ph_oberboden,
        humusgehalt_ah,
        COALESCE(tongehalt_oberboden, 0) AS ton_eff,
        CASE
            WHEN skelettgehalt_oberboden = 'skelettfrei' THEN '0'
            WHEN skelettgehalt_oberboden = 'schwach_skeletthaltig' THEN '1'
            WHEN skelettgehalt_oberboden = 'skeletthaltig' THEN '2'
            WHEN skelettgehalt_oberboden = 'stark_skeletthaltig' THEN '4'
            WHEN skelettgehalt_oberboden = 'skelettreich' THEN '6'
            WHEN skelettgehalt_oberboden = 'kies' THEN '8'
        END AS sk,

    -- val1 aus wt_tab70_1 (Basis nach pH)
        COALESCE(t1.wert1, 0) AS val1,

    -- Bedingung pH > grenz_ph
        (ph_oberboden > t2.grenz_ph) AS use_extra,

    -- val2 (Humus-Zuschlag)
        CASE
            WHEN ph_oberboden > t2.grenz_ph THEN COALESCE(hum.wert2, 0)
            ELSE 0
        END AS val2,

    -- val3 (Ton-Zuschlag mit Skelett-Abzug)
        CASE
            WHEN ph_oberboden > t2.grenz_ph THEN
                GREATEST(
                    COALESCE(tonv.wert3, 0)
                    - COALESCE(sk_tab.minuswert, 0),
                    0
                )
            ELSE 0
        END AS val3,

    -- Endwert wie bindst_berechnen
        CASE
            WHEN ph_oberboden > t2.grenz_ph THEN
                COALESCE(t1.wert1, 0)
                + COALESCE(hum.wert2, 0)
                + GREATEST(
                    COALESCE(tonv.wert3, 0)
                    - COALESCE(sk_tab.minuswert, 0),
                    0
                )
            ELSE
                COALESCE(t1.wert1, 0)
        END AS bindst_pb_neu
    FROM afu_bodeneinheiten_pub_v1.bodeneinheit_wald

    LEFT JOIN 
        wt_tab70_1 t1
        ON 
        t1.von <= ph_oberboden
        AND 
        t1.bis > ph_oberboden

    LEFT JOIN 
        wt_tab70_2 t2
        ON 
        t2.metall = 'Pb'

    LEFT JOIN 
        wt_tab70_3 hum
        ON 
        hum.hum_von <= humusgehalt_ah
        AND 
        hum.hum_bis > humusgehalt_ah
        AND 
        hum.bind_st = t2.humus

    LEFT JOIN 
        wt_tab70_4 tonv
        ON 
        tonv.ton_von <= COALESCE(tongehalt_oberboden, 0)
        AND 
        tonv.ton_bis > COALESCE(tongehalt_oberboden, 0)
        AND 
        tonv.bind_st = t2.ton

    LEFT JOIN 
        wt_tab70_4sk sk_tab
        ON 
        sk_tab.skelett =
        CASE
            WHEN skelettgehalt_oberboden = 'skelettfrei' THEN '0'
            WHEN skelettgehalt_oberboden = 'schwach_skeletthaltig' THEN '1'
            WHEN skelettgehalt_oberboden = 'skeletthaltig' THEN '2'
            WHEN skelettgehalt_oberboden = 'stark_skeletthaltig' THEN '4'
            WHEN skelettgehalt_oberboden = 'skelettreich' THEN '6'
            WHEN skelettgehalt_oberboden = 'kies' THEN '8'
        END
    WHERE 
        bodentyp IS NOT NULL
) 

UPDATE 
    afu_bodeneinheiten_pub_v1.bodeneinheit_wald b
    SET 
    bindungsstaerke_blei = s.bindst_pb_neu
FROM 
    select_table s
WHERE 
    b.t_id = s.pk_bodeneinheit
;
