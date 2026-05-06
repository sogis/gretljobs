-- ============================================================================
-- Update nutzbare Feldkapazität für afu_bodeneinheiten_pub_v1.bodeneinheit_landwirtschaft
-- ============================================================================
WITH
src AS (
    SELECT
        b.t_id AS bodeneinheit_id,
        lower(b.wasserhaushalt) AS wasserhaushalt,
        b.bodentyp,
        b.untertypen,
        regexp_replace(upper(COALESCE(b.untertypen, '')), '\s+', '', 'g') AS untertypen_norm,

        b.skelettgehalt_oberboden AS skelett_ob,
        b.skelettgehalt_oberboden_txt AS skelett_ob_txt,
        b.skelettgehalt_unterboden AS skelett_ub,
        b.skelettgehalt_unterboden_txt AS skelett_ub_txt,

        b.koernungsklasse_oberboden AS koernkl_ob,
        b.koernungsklasse_oberboden_txt AS koernkl_ob_txt,
        b.koernungsklasse_unterboden AS koernkl_ub,
        b.koernungsklasse_unterboden_txt AS koernkl_ub_txt,

        b.tongehalt_oberboden::numeric AS ton_ob,
        b.tongehalt_unterboden::numeric AS ton_ub,
        b.schluffgehalt_oberboden::numeric AS schluff_ob,
        b.schluffgehalt_unterboden::numeric AS schluff_ub,
        b.maechtigkeit_ah::numeric AS maechtigkeit_ah,
        b.humusgehalt_ah::numeric AS humusgeh_ah,

        b.gefuegeform_oberboden AS gefuegeform_ob,
        b.gefuegeform_unterboden AS gefuegeform_ub,
        b.gefuegegroesse_oberboden AS gefueggr_ob,
        b.gefuegegroesse_oberboden_txt AS gefueggr_ob_txt,
        b.gefuegegroesse_unterboden AS gefueggr_ub,
        b.gefuegegroesse_unterboden_txt AS gefueggr_ub_txt,

        b.pflanzennutzbaregruendigkeit::numeric AS pflngr,
        b.bodenpunktzahl::numeric AS bodpktzahl
    FROM afu_bodeneinheiten_pub_v1.bodeneinheit_landwirtschaft b
    WHERE b.wasserhaushalt IS NOT NULL
),

basis AS (
    SELECT
        s.*,

        COALESCE(
            NULLIF(substring(COALESCE(s.skelett_ob_txt, '') from '^\s*([0-9]+)'), '')::int,
            CASE s.skelett_ob
                WHEN 'skelettfrei' THEN 0
                WHEN 'schwach_skeletthaltig' THEN 1
                WHEN 'kieshaltig' THEN 2
                WHEN 'steinhaltig' THEN 3
                WHEN 'stark_kieshaltig' THEN 4
                WHEN 'stark_steinhaltig' THEN 5
                WHEN 'kiesreich' THEN 6
                WHEN 'steinreich' THEN 7
                WHEN 'kies' THEN 8
                WHEN 'geroell' THEN 9
            END,
            NULLIF(regexp_replace(COALESCE(s.skelett_ob, ''), '[^0-9]', '', 'g'), '')::int
        ) AS skelett_ob_i,

        COALESCE(
            NULLIF(substring(COALESCE(s.skelett_ub_txt, '') from '^\s*([0-9]+)'), '')::int,
            CASE s.skelett_ub
                WHEN 'skelettfrei' THEN 0
                WHEN 'schwach_skeletthaltig' THEN 1
                WHEN 'kieshaltig' THEN 2
                WHEN 'steinhaltig' THEN 3
                WHEN 'stark_kieshaltig' THEN 4
                WHEN 'stark_steinhaltig' THEN 5
                WHEN 'kiesreich' THEN 6
                WHEN 'steinreich' THEN 7
                WHEN 'kies' THEN 8
                WHEN 'geroell' THEN 9
            END,
            NULLIF(regexp_replace(COALESCE(s.skelett_ub, ''), '[^0-9]', '', 'g'), '')::int
        ) AS skelett_ub_i,

        COALESCE(
            NULLIF(substring(COALESCE(s.koernkl_ob_txt, '') from '^\s*([0-9]+)'), '')::int,
            CASE s.koernkl_ob
                WHEN 'sand' THEN 1
                WHEN 'schluffiger_sand' THEN 2
                WHEN 'lehmiger_sand' THEN 3
                WHEN 'lehmreicher_sand' THEN 4
                WHEN 'sandiger_lehm' THEN 5
                WHEN 'lehm' THEN 6
                WHEN 'toniger_lehm' THEN 7
                WHEN 'lehmiger_ton' THEN 8
                WHEN 'ton' THEN 9
                WHEN 'sandiger_schluff' THEN 10
                WHEN 'schluff' THEN 11
                WHEN 'lehmiger_schluff' THEN 12
                WHEN 'toniger_schluff' THEN 13
            END,
            NULLIF(regexp_replace(COALESCE(s.koernkl_ob, ''), '[^0-9]', '', 'g'), '')::int
        ) AS koernkl_ob_i,

        COALESCE(
            NULLIF(substring(COALESCE(s.koernkl_ub_txt, '') from '^\s*([0-9]+)'), '')::int,
            CASE s.koernkl_ub
                WHEN 'sand' THEN 1
                WHEN 'schluffiger_sand' THEN 2
                WHEN 'lehmiger_sand' THEN 3
                WHEN 'lehmreicher_sand' THEN 4
                WHEN 'sandiger_lehm' THEN 5
                WHEN 'lehm' THEN 6
                WHEN 'toniger_lehm' THEN 7
                WHEN 'lehmiger_ton' THEN 8
                WHEN 'ton' THEN 9
                WHEN 'sandiger_schluff' THEN 10
                WHEN 'schluff' THEN 11
                WHEN 'lehmiger_schluff' THEN 12
                WHEN 'toniger_schluff' THEN 13
            END,
            NULLIF(regexp_replace(COALESCE(s.koernkl_ub, ''), '[^0-9]', '', 'g'), '')::int
        ) AS koernkl_ub_i,

        COALESCE(
            NULLIF(substring(COALESCE(s.gefueggr_ob_txt, '') from '^\s*([0-9]+)'), '')::int,
            CASE s.gefueggr_ob
                WHEN 'kleiner_als_2' THEN 1
                WHEN 'von_2_bis_5' THEN 2
                WHEN 'von_5_bis_10' THEN 3
                WHEN 'von_10_bis_20' THEN 4
                WHEN 'von_20_bis_50' THEN 5
                WHEN 'von_50_bis_100' THEN 6
                WHEN 'groesser_als_100' THEN 7
            END,
            NULLIF(regexp_replace(COALESCE(s.gefueggr_ob, ''), '[^0-9]', '', 'g'), '')::int
        ) AS gefueggr_ob_i,

        COALESCE(
            NULLIF(substring(COALESCE(s.gefueggr_ub_txt, '') from '^\s*([0-9]+)'), '')::int,
            CASE s.gefueggr_ub
                WHEN 'kleiner_als_2' THEN 1
                WHEN 'von_2_bis_5' THEN 2
                WHEN 'von_5_bis_10' THEN 3
                WHEN 'von_10_bis_20' THEN 4
                WHEN 'von_20_bis_50' THEN 5
                WHEN 'von_50_bis_100' THEN 6
                WHEN 'groesser_als_100' THEN 7
            END,
            NULLIF(regexp_replace(COALESCE(s.gefueggr_ub, ''), '[^0-9]', '', 'g'), '')::int
        ) AS gefueggr_ub_i,

        POSITION(',I3,' IN ',' || COALESCE(regexp_replace(upper(s.untertypen), '\s+', '', 'g'), '') || ',') > 0 AS ut_i3,
        POSITION(',I4,' IN ',' || COALESCE(regexp_replace(upper(s.untertypen), '\s+', '', 'g'), '') || ',') > 0 AS ut_i4,
        POSITION(',R1,' IN ',' || COALESCE(regexp_replace(upper(s.untertypen), '\s+', '', 'g'), '') || ',') > 0 AS ut_r1,
        POSITION(',R2,' IN ',' || COALESCE(regexp_replace(upper(s.untertypen), '\s+', '', 'g'), '') || ',') > 0 AS ut_r2,
        POSITION(',R3,' IN ',' || COALESCE(regexp_replace(upper(s.untertypen), '\s+', '', 'g'), '') || ',') > 0 AS ut_r3,
        POSITION(',R4,' IN ',' || COALESCE(regexp_replace(upper(s.untertypen), '\s+', '', 'g'), '') || ',') > 0 AS ut_r4,
        POSITION(',R5,' IN ',' || COALESCE(regexp_replace(upper(s.untertypen), '\s+', '', 'g'), '') || ',') > 0 AS ut_r5,
        POSITION(',G3,' IN ',' || COALESCE(regexp_replace(upper(s.untertypen), '\s+', '', 'g'), '') || ',') > 0 AS ut_g3,
        POSITION(',G4,' IN ',' || COALESCE(regexp_replace(upper(s.untertypen), '\s+', '', 'g'), '') || ',') > 0 AS ut_g4,
        POSITION(',G5,' IN ',' || COALESCE(regexp_replace(upper(s.untertypen), '\s+', '', 'g'), '') || ',') > 0 AS ut_g5,
        POSITION(',G6,' IN ',' || COALESCE(regexp_replace(upper(s.untertypen), '\s+', '', 'g'), '') || ',') > 0 AS ut_g6
    FROM src s
),

lut_korr_skelettgehalt(skelettklasse, korrekturfaktor) AS (
    VALUES
        (0, 0.975),
        (1, 0.925),
        (2, 0.85),
        (3, 0.85),
        (4, 0.75),
        (5, 0.75),
        (6, 0.6),
        (7, 0.6),
        (8, 0.4),
        (9, 0.4)
),

lut_bodart(bodart, ton_v, ton_b, schl_v, schl_b) AS (
    VALUES
        ('Tt', 65, 99.99, 0, 34.99),
        ('Ts2', 45, 64.99, 0, 14.99),
        ('Tl', 45, 64.99, 15, 29.99),
        ('Tu2', 45, 64.99, 30, 54.99),
        ('Ts3', 35, 44.99, 0, 14.99),
        ('Lt3', 35, 44.99, 30, 49.99),
        ('Tu3', 30, 44.99, 50, 64.99),
        ('Lt2', 25, 34.99, 30, 49.99),
        ('Lts', 25, 44.99, 15, 29.99),
        ('Ts4', 25, 34.99, 0, 14.99),
        ('Tu4', 25, 34.99, 65, 74.99),
        ('St3', 17, 24.99, 0, 14.99),
        ('Ls2', 17, 24.99, 40, 49.99),
        ('Ls3', 17, 24.99, 30, 39.99),
        ('Ls4', 17, 24.99, 15, 29.99),
        ('Ut4', 17, 24.99, 65, 82.99),
        ('Lu', 17, 29.99, 50, 64.99),
        ('Sl4', 12, 16.99, 10, 39.99),
        ('Ut3', 12, 16.99, 65, 87.99),
        ('Sl3', 8, 11.99, 10, 39.99),
        ('Slu', 8, 16.99, 40, 49.99),
        ('Ut2', 8, 11.99, 65, 91.99),
        ('Uls', 8, 16.99, 50, 64.99),
        ('Sl2', 5, 7.99, 10, 24.99),
        ('St2', 5, 16.99, 0, 9.99),
        ('Ss', 0, 4.99, 0, 9.99),
        ('Su2', 0, 4.99, 10, 24.99),
        ('Su3', 0, 7.99, 25, 39.99),
        ('Su4', 0, 7.99, 40, 49.99),
        ('Uu', 0, 7.99, 80, 99.99),
        ('Us', 0, 7.99, 50, 79.99)
),

lut_trockenrohdichte(bodenart, ladi, trockenrohdichte) AS (
    VALUES
        ('Ss', 'Ld1', 1.18),
        ('Sl2', 'Ld1', 1.15),
        ('Sl3', 'Ld1', 1.13),
        ('Sl4', 'Ld1', 1.1),
        ('Slu', 'Ld1', 1.09),
        ('St2', 'Ld1', 1.14),
        ('St3', 'Ld1', 1.09),
        ('Su2', 'Ld1', 1.17),
        ('Su3', 'Ld1', 1.15),
        ('Su4', 'Ld1', 1.14),
        ('Ls2', 'Ld1', 1.05),
        ('Ls3', 'Ld1', 1.06),
        ('Ls4', 'Ld1', 1.07),
        ('Lt2', 'Ld1', 1.01),
        ('Lt3', 'Ld1', 0.96),
        ('Lts', 'Ld1', 1),
        ('Lu', 'Ld1', 1.03),
        ('Uu', 'Ld1', 1.09),
        ('Uls', 'Ld1', 1.08),
        ('Us', 'Ld1', 1.12),
        ('Ut2', 'Ld1', 1.07),
        ('Ut3', 'Ld1', 1.05),
        ('Ut4', 'Ld1', 1.02),
        ('Tt', 'Ld1', 0.81),
        ('Tl', 'Ld1', 0.9),
        ('Tu2', 'Ld1', 0.9),
        ('Tu3', 'Ld1', 0.96),
        ('Tu4', 'Ld1', 0.99),
        ('Ts2', 'Ld1', 0.92),
        ('Ts3', 'Ld1', 0.99),
        ('Ts4', 'Ld1', 1.04),
        ('Ss', 'Ld2', 1.4),
        ('Sl2', 'Ld2', 1.37),
        ('Sl3', 'Ld2', 1.35),
        ('Sl4', 'Ld2', 1.32),
        ('Slu', 'Ld2', 1.31),
        ('St2', 'Ld2', 1.36),
        ('St3', 'Ld2', 1.31),
        ('Su2', 'Ld2', 1.39),
        ('Su3', 'Ld2', 1.37),
        ('Su4', 'Ld2', 1.36),
        ('Ls2', 'Ld2', 1.27),
        ('Ls3', 'Ld2', 1.28),
        ('Ls4', 'Ld2', 1.29),
        ('Lt2', 'Ld2', 1.23),
        ('Lt3', 'Ld2', 1.18),
        ('Lts', 'Ld2', 1.22),
        ('Lu', 'Ld2', 1.25),
        ('Uu', 'Ld2', 1.31),
        ('Uls', 'Ld2', 1.3),
        ('Us', 'Ld2', 1.34),
        ('Ut2', 'Ld2', 1.29),
        ('Ut3', 'Ld2', 1.27),
        ('Ut4', 'Ld2', 1.24),
        ('Tt', 'Ld2', 1.03),
        ('Tl', 'Ld2', 1.12),
        ('Tu2', 'Ld2', 1.12),
        ('Tu3', 'Ld2', 1.18),
        ('Tu4', 'Ld2', 1.21),
        ('Ts2', 'Ld2', 1.14),
        ('Ts3', 'Ld2', 1.21),
        ('Ts4', 'Ld2', 1.26),
        ('Ss', 'Ld3', 1.63),
        ('Sl2', 'Ld3', 1.6),
        ('Sl3', 'Ld3', 1.58),
        ('Sl4', 'Ld3', 1.55),
        ('Slu', 'Ld3', 1.54),
        ('St2', 'Ld3', 1.59),
        ('St3', 'Ld3', 1.54),
        ('Su2', 'Ld3', 1.62),
        ('Su3', 'Ld3', 1.6),
        ('Su4', 'Ld3', 1.59),
        ('Ls2', 'Ld3', 1.5),
        ('Ls3', 'Ld3', 1.51),
        ('Ls4', 'Ld3', 1.52),
        ('Lt2', 'Ld3', 1.46),
        ('Lt3', 'Ld3', 1.41),
        ('Lts', 'Ld3', 1.45),
        ('Lu', 'Ld3', 1.48),
        ('Uu', 'Ld3', 1.54),
        ('Uls', 'Ld3', 1.53),
        ('Us', 'Ld3', 1.57),
        ('Ut2', 'Ld3', 1.52),
        ('Ut3', 'Ld3', 1.5),
        ('Ut4', 'Ld3', 1.47),
        ('Tt', 'Ld3', 1.26),
        ('Tl', 'Ld3', 1.35),
        ('Tu2', 'Ld3', 1.35),
        ('Tu3', 'Ld3', 1.41),
        ('Tu4', 'Ld3', 1.44),
        ('Ts2', 'Ld3', 1.37),
        ('Ts3', 'Ld3', 1.44),
        ('Ts4', 'Ld3', 1.49),
        ('Ss', 'Ld4', 1.83),
        ('Sl2', 'Ld4', 1.8),
        ('Sl3', 'Ld4', 1.78),
        ('Sl4', 'Ld4', 1.75),
        ('Slu', 'Ld4', 1.74),
        ('St2', 'Ld4', 1.79),
        ('St3', 'Ld4', 1.74),
        ('Su2', 'Ld4', 1.82),
        ('Su3', 'Ld4', 1.8),
        ('Su4', 'Ld4', 1.79),
        ('Ls2', 'Ld4', 1.7),
        ('Ls3', 'Ld4', 1.71),
        ('Ls4', 'Ld4', 1.72),
        ('Lt2', 'Ld4', 1.66),
        ('Lt3', 'Ld4', 1.61),
        ('Lts', 'Ld4', 1.65),
        ('Lu', 'Ld4', 1.68),
        ('Uu', 'Ld4', 1.74),
        ('Uls', 'Ld4', 1.73),
        ('Us', 'Ld4', 1.77),
        ('Ut2', 'Ld4', 1.72),
        ('Ut3', 'Ld4', 1.7),
        ('Ut4', 'Ld4', 1.67),
        ('Tt', 'Ld4', 1.46),
        ('Tl', 'Ld4', 1.55),
        ('Tu2', 'Ld4', 1.55),
        ('Tu3', 'Ld4', 1.61),
        ('Tu4', 'Ld4', 1.64),
        ('Ts2', 'Ld4', 1.57),
        ('Ts3', 'Ld4', 1.64),
        ('Ts4', 'Ld4', 1.69),
        ('Ss', 'Ld5', 1.98),
        ('Sl2', 'Ld5', 1.95),
        ('Sl3', 'Ld5', 1.93),
        ('Sl4', 'Ld5', 1.9),
        ('Slu', 'Ld5', 1.89),
        ('St2', 'Ld5', 1.94),
        ('St3', 'Ld5', 1.89),
        ('Su2', 'Ld5', 1.97),
        ('Su3', 'Ld5', 1.95),
        ('Su4', 'Ld5', 1.94),
        ('Ls2', 'Ld5', 1.85),
        ('Ls3', 'Ld5', 1.86),
        ('Ls4', 'Ld5', 1.87),
        ('Lt2', 'Ld5', 1.81),
        ('Lt3', 'Ld5', 1.76),
        ('Lts', 'Ld5', 1.8),
        ('Lu', 'Ld5', 1.83),
        ('Uu', 'Ld5', 1.89),
        ('Uls', 'Ld5', 1.88),
        ('Us', 'Ld5', 1.92),
        ('Ut2', 'Ld5', 1.87),
        ('Ut3', 'Ld5', 1.85),
        ('Ut4', 'Ld5', 1.82),
        ('Tt', 'Ld5', 1.61),
        ('Tl', 'Ld5', 1.7),
        ('Tu2', 'Ld5', 1.7),
        ('Tu3', 'Ld5', 1.76),
        ('Tu4', 'Ld5', 1.79),
        ('Ts2', 'Ld5', 1.72),
        ('Ts3', 'Ld5', 1.79),
        ('Ts4', 'Ld5', 1.84)
),

lut_nfk_aus_trd(bodenart, trdmin, trdmax, nfk) AS (
    VALUES
        ('Ls2', 0.1, 1.2, 18),
        ('Ls2', 1.2, 1.4, 15),
        ('Ls2', 1.4, 1.6, 14),
        ('Ls2', 1.6, 1.8, 12),
        ('Ls2', 1.8, 91, 10),
        ('Ls3', 0.1, 1.2, 18),
        ('Ls3', 1.2, 1.4, 14),
        ('Ls3', 1.4, 1.6, 12),
        ('Ls3', 1.6, 1.8, 11),
        ('Ls3', 1.8, 91, 9),
        ('Ls4', 0.1, 1.2, 18),
        ('Ls4', 1.2, 1.4, 14),
        ('Ls4', 1.4, 1.6, 12),
        ('Ls4', 1.6, 1.8, 11),
        ('Ls4', 1.8, 91, 9),
        ('Lt2', 0.1, 1.2, 15),
        ('Lt2', 1.2, 1.4, 12),
        ('Lt2', 1.4, 1.6, 10),
        ('Lt2', 1.6, 91, 8),
        ('Lt3', 0.1, 1.2, 14),
        ('Lt3', 1.2, 1.4, 11),
        ('Lt3', 1.4, 1.6, 9),
        ('Lt3', 1.6, 91, 7),
        ('Lts', 0.1, 1.2, 16),
        ('Lts', 1.2, 1.4, 13),
        ('Lts', 1.4, 1.6, 11),
        ('Lts', 1.6, 91, 9),
        ('Lu', 0.1, 1.2, 18),
        ('Lu', 1.2, 1.4, 15),
        ('Lu', 1.4, 1.6, 13),
        ('Lu', 1.6, 91, 11),
        ('Sl2', 0.1, 1.4, 15),
        ('Sl2', 1.4, 1.6, 13),
        ('Sl2', 1.6, 1.8, 11),
        ('Sl2', 1.8, 91, 10),
        ('Sl3', 0.1, 1.4, 15),
        ('Sl3', 1.4, 1.6, 13),
        ('Sl3', 1.6, 1.8, 12),
        ('Sl3', 1.8, 91, 10),
        ('Sl4', 0.1, 1.4, 15),
        ('Sl4', 1.4, 1.6, 12),
        ('Sl4', 1.6, 1.8, 11),
        ('Sl4', 1.8, 91, 9),
        ('Slu', 0.1, 1.4, 18),
        ('Slu', 1.4, 1.6, 15),
        ('Slu', 1.6, 1.8, 14),
        ('Slu', 1.8, 91, 13),
        ('Ss', 0.1, 1.4, 9),
        ('Ss', 1.4, 1.6, 9),
        ('Ss', 1.6, 91, 9),
        ('St2', 0.1, 1.4, 13),
        ('St2', 1.4, 1.6, 10),
        ('St2', 1.6, 1.8, 8),
        ('St2', 1.8, 91, 7),
        ('St3', 0.1, 1.4, 15),
        ('St3', 1.4, 1.6, 12),
        ('St3', 1.6, 1.8, 9),
        ('St3', 1.8, 91, 7),
        ('Su2', 0.1, 1.4, 16),
        ('Su2', 1.4, 1.6, 15),
        ('Su2', 1.6, 1.8, 13),
        ('Su2', 1.8, 91, 12),
        ('Su3', 0.1, 1.4, 19),
        ('Su3', 1.4, 1.6, 17),
        ('Su3', 1.6, 1.8, 15),
        ('Su3', 1.8, 91, 13),
        ('Su4', 0.1, 1.4, 20),
        ('Su4', 1.4, 1.6, 18),
        ('Su4', 1.6, 1.8, 17),
        ('Su4', 1.8, 91, 15),
        ('Tl', 0.1, 1.2, 14),
        ('Tl', 1.2, 1.4, 12),
        ('Tl', 1.4, 1.6, 8),
        ('Tl', 1.6, 91, 6),
        ('Ts2', 0.1, 1.2, 15),
        ('Ts2', 1.2, 1.4, 13),
        ('Ts2', 1.4, 1.6, 10),
        ('Ts2', 1.6, 91, 8),
        ('Ts3', 0.1, 1.2, 17),
        ('Ts3', 1.2, 1.4, 14),
        ('Ts3', 1.4, 1.6, 10),
        ('Ts3', 1.6, 91, 9),
        ('Ts4', 0.1, 1.2, 17),
        ('Ts4', 1.2, 1.4, 14),
        ('Ts4', 1.4, 1.6, 11),
        ('Ts4', 1.6, 91, 10),
        ('Tt', 0.1, 1.2, 13),
        ('Tt', 1.2, 1.4, 11),
        ('Tt', 1.4, 91, 7),
        ('Tu2', 0.1, 1.2, 15),
        ('Tu2', 1.2, 1.4, 13),
        ('Tu2', 1.4, 1.6, 9),
        ('Tu2', 1.6, 91, 6),
        ('Tu3', 0.1, 1.2, 17),
        ('Tu3', 1.2, 1.4, 14),
        ('Tu3', 1.4, 1.6, 12),
        ('Tu3', 1.6, 91, 10),
        ('Tu4', 0.1, 1.2, 18),
        ('Tu4', 1.2, 1.4, 15),
        ('Tu4', 1.4, 1.6, 13),
        ('Tu4', 1.6, 91, 11),
        ('Uls', 0.1, 1.2, 20),
        ('Uls', 1.2, 1.4, 19),
        ('Uls', 1.4, 1.6, 18),
        ('Uls', 1.6, 91, 16),
        ('Us', 0.1, 1.2, 22),
        ('Us', 1.2, 1.4, 21),
        ('Us', 1.4, 1.6, 19),
        ('Us', 1.6, 91, 17),
        ('Ut2', 0.1, 1.2, 21),
        ('Ut2', 1.2, 1.4, 20),
        ('Ut2', 1.4, 1.6, 18),
        ('Ut2', 1.6, 91, 17),
        ('Ut3', 0.1, 1.2, 20),
        ('Ut3', 1.2, 1.4, 19),
        ('Ut3', 1.4, 1.6, 17),
        ('Ut3', 1.6, 91, 16),
        ('Ut4', 0.1, 1.2, 18),
        ('Ut4', 1.2, 1.4, 17),
        ('Ut4', 1.4, 1.6, 16),
        ('Ut4', 1.6, 91, 14),
        ('Uu', 0.1, 1.2, 25),
        ('Uu', 1.2, 1.4, 23),
        ('Uu', 1.4, 1.6, 21),
        ('Uu', 1.6, 91, 19),
        ('fS', 0.1, 1.4, 11),
        ('fS', 1.4, 1.6, 11),
        ('fS', 1.6, 91, 11),
        ('fSgs', 0.1, 1.4, 11),
        ('fSgs', 1.4, 1.6, 11),
        ('fSgs', 1.6, 91, 11),
        ('fSms', 0.1, 1.4, 11),
        ('fSms', 1.4, 1.6, 11),
        ('fSms', 1.6, 91, 11),
        ('gS', 0.1, 1.4, 5),
        ('gS', 1.4, 1.6, 5),
        ('gS', 1.6, 91, 5),
        ('mS', 0.1, 1.4, 9),
        ('mS', 1.4, 1.6, 9),
        ('mS', 1.6, 91, 9),
        ('mSfs', 0.1, 1.4, 9),
        ('mSfs', 1.4, 1.6, 9),
        ('mSfs', 1.6, 91, 9),
        ('mSgs', 0.1, 1.4, 9),
        ('mSgs', 1.4, 1.6, 9),
        ('mSgs', 1.6, 91, 9)
),

lut_os(bodenart, osmin, osmax, zuschlag) AS (
    VALUES
        ('Ss', 1, 2, 2),
        ('Sl2', 1, 2, 1),
        ('Sl3', 1, 2, 1),
        ('Sl4', 1, 2, 1),
        ('Slu', 1, 2, 1),
        ('St2', 1, 2, 2),
        ('St3', 1, 2, 2),
        ('Su2', 1, 2, 2),
        ('Su3', 1, 2, 2),
        ('Su4', 1, 2, 2),
        ('Ls2', 1, 2, 1),
        ('Ls3', 1, 2, 2),
        ('Ls4', 1, 2, 2),
        ('Lt2', 1, 2, 1),
        ('Lt3', 1, 2, 1),
        ('Lts', 1, 2, 1),
        ('Lu', 1, 2, 1),
        ('Uu', 1, 2, 1),
        ('Uls', 1, 2, 1),
        ('Us', 1, 2, 1),
        ('Ut2', 1, 2, 1),
        ('Ut3', 1, 2, 1),
        ('Ut4', 1, 2, 1),
        ('Tt', 1, 2, 1),
        ('Tl', 1, 2, 1),
        ('Tu2', 1, 2, 1),
        ('Tu3', 1, 2, 1),
        ('Tu4', 1, 2, 1),
        ('Ts2', 1, 2, 2),
        ('Ts3', 1, 2, 2),
        ('Ts4', 1, 2, 2),
        ('Ss', 2, 4, 4),
        ('Sl2', 2, 4, 3),
        ('Sl3', 2, 4, 3),
        ('Sl4', 2, 4, 3),
        ('Slu', 2, 4, 3),
        ('St2', 2, 4, 4),
        ('St3', 2, 4, 4),
        ('Su2', 2, 4, 4),
        ('Su3', 2, 4, 4),
        ('Su4', 2, 4, 4),
        ('Ls2', 2, 4, 3),
        ('Ls3', 2, 4, 4),
        ('Ls4', 2, 4, 4),
        ('Lt2', 2, 4, 3),
        ('Lt3', 2, 4, 2),
        ('Lts', 2, 4, 2),
        ('Lu', 2, 4, 2),
        ('Uu', 2, 4, 2),
        ('Uls', 2, 4, 3),
        ('Us', 2, 4, 3),
        ('Ut2', 2, 4, 3),
        ('Ut3', 2, 4, 3),
        ('Ut4', 2, 4, 3),
        ('Tt', 2, 4, 2),
        ('Tl', 2, 4, 2),
        ('Tu2', 2, 4, 2),
        ('Tu3', 2, 4, 2),
        ('Tu4', 2, 4, 2),
        ('Ts2', 2, 4, 4),
        ('Ts3', 2, 4, 4),
        ('Ts4', 2, 4, 4),
        ('Ss', 4, 8, 7),
        ('Sl2', 4, 8, 5),
        ('Sl3', 4, 8, 5),
        ('Sl4', 4, 8, 5),
        ('Slu', 4, 8, 5),
        ('St2', 4, 8, 5),
        ('St3', 4, 8, 6),
        ('Su2', 4, 8, 7),
        ('Su3', 4, 8, 6),
        ('Su4', 4, 8, 6),
        ('Ls2', 4, 8, 5),
        ('Ls3', 4, 8, 6),
        ('Ls4', 4, 8, 7),
        ('Lt2', 4, 8, 4),
        ('Lt3', 4, 8, 3),
        ('Lts', 4, 8, 4),
        ('Lu', 4, 8, 5),
        ('Uu', 4, 8, 4),
        ('Uls', 4, 8, 5),
        ('Us', 4, 8, 5),
        ('Ut2', 4, 8, 6),
        ('Ut3', 4, 8, 6),
        ('Ut4', 4, 8, 6),
        ('Tt', 4, 8, 3),
        ('Tl', 4, 8, 3),
        ('Tu2', 4, 8, 3),
        ('Tu3', 4, 8, 4),
        ('Tu4', 4, 8, 4),
        ('Ts2', 4, 8, 6),
        ('Ts3', 4, 8, 6),
        ('Ts4', 4, 8, 6),
        ('Ss', 8, 15, 13),
        ('Sl2', 8, 15, 10),
        ('Sl3', 8, 15, 10),
        ('Sl4', 8, 15, 10),
        ('Slu', 8, 15, 10),
        ('St2', 8, 15, 7),
        ('St3', 8, 15, 8),
        ('Su2', 8, 15, 10),
        ('Su3', 8, 15, 9),
        ('Su4', 8, 15, 9),
        ('Ls2', 8, 15, 9),
        ('Ls3', 8, 15, 9),
        ('Ls4', 8, 15, 10),
        ('Lt2', 8, 15, 7),
        ('Lt3', 8, 15, 6),
        ('Lts', 8, 15, 7),
        ('Lu', 8, 15, 8),
        ('Uu', 8, 15, 7),
        ('Uls', 8, 15, 8),
        ('Us', 8, 15, 8),
        ('Ut2', 8, 15, 8),
        ('Ut3', 8, 15, 8),
        ('Ut4', 8, 15, 8),
        ('Tt', 8, 15, 5),
        ('Tl', 8, 15, 5),
        ('Tu2', 8, 15, 5),
        ('Tu3', 8, 15, 6),
        ('Tu4', 8, 15, 7),
        ('Ts2', 8, 15, 8),
        ('Ts3', 8, 15, 9),
        ('Ts4', 8, 15, 9)
),

lut_hydro(bodenart, hydrostufe, zuschlag) AS (
    VALUES
        ('fS', 2, 5),
        ('fSms', 2, 5),
        ('Ss', 2, 4),
        ('mS', 2, 4),
        ('gS', 2, 4),
        ('Sl2', 2, 4),
        ('Sl3', 2, 4),
        ('Slu', 2, 4),
        ('Su2', 2, 4),
        ('Su3', 2, 4),
        ('Su4', 2, 4),
        ('Sl4', 2, 3),
        ('Ls2', 2, 3),
        ('Ls3', 2, 3),
        ('Ls4', 2, 3),
        ('Uls', 2, 3),
        ('Uu', 2, 3),
        ('Us', 2, 3),
        ('Ut2', 2, 3),
        ('Ut3', 2, 3),
        ('Ut4', 2, 3),
        ('Lu', 2, 3),
        ('Tu4', 2, 3),
        ('St3', 2, 3),
        ('St2', 2, 3),
        ('Lt2', 2, 2),
        ('Lt3', 2, 2),
        ('Lts', 2, 2),
        ('Ts4', 2, 2),
        ('Ts3', 2, 2),
        ('Ts2', 2, 2),
        ('Tl', 2, 2),
        ('Tt', 2, 2),
        ('Tu3', 2, 2),
        ('Tu2', 2, 2),
        ('fS', 1, 2),
        ('fSms', 1, 2),
        ('Ss', 1, 2),
        ('mS', 1, 2),
        ('gS', 1, 2),
        ('Sl2', 1, 2),
        ('Sl3', 1, 2),
        ('Slu', 1, 2),
        ('Su2', 1, 2),
        ('Su3', 1, 2),
        ('Su4', 1, 2),
        ('Sl4', 1, 1),
        ('Ls2', 1, 1),
        ('Ls3', 1, 1),
        ('Ls4', 1, 1),
        ('Uls', 1, 1),
        ('Uu', 1, 1),
        ('Us', 1, 1),
        ('Ut2', 1, 1),
        ('Ut3', 1, 1),
        ('Ut4', 1, 1),
        ('Lu', 1, 1),
        ('Tu4', 1, 1),
        ('St3', 1, 1),
        ('St2', 1, 1),
        ('Lt2', 1, 1),
        ('Lt3', 1, 1),
        ('Lts', 1, 1),
        ('Ts4', 1, 1),
        ('Ts3', 1, 1),
        ('Ts2', 1, 1),
        ('Tl', 1, 1),
        ('Tt', 1, 1),
        ('Tu3', 1, 1),
        ('Tu2', 1, 1)
),

lut_png(whg, png_med_neu) AS (
    VALUES
        ('a', 110),
        ('b', 85),
        ('c', 60),
        ('d', 40),
        ('e', 25),
        ('f', 80),
        ('g', 60),
        ('h', 40.5),
        ('i', 25),
        ('k', 80),
        ('l', 62),
        ('m', 44),
        ('n', 25),
        ('o', 58),
        ('p', 44),
        ('q', 40),
        ('r', 26),
        ('s', 78),
        ('t', 60),
        ('u', 44),
        ('v', 59),
        ('w', 40),
        ('x', 40),
        ('y', 20),
        ('z', 9)
),

lut_whg_faktor(whg, faktor_ob, faktor_ub) AS (
    VALUES
        ('a', 1, 1.375),
        ('b', 1.053, 1.478),
        ('c', 1.129, 1.577),
        ('d', 1.136, 1.636),
        ('e', 1.333, 1.75),
        ('f', 1.036, 1.689),
        ('g', 1.053, 1.667),
        ('h', 1.056, 1.861),
        ('i', 1.06, 1.86),
        ('k', 1.038, 1.603),
        ('l', 1.074, 1.61),
        ('m', 1.133, 1.923),
        ('n', 1.136, 3),
        ('o', 1.046, 2.09),
        ('p', 1.125, 1.875),
        ('q', 1.443, 2.718),
        ('r', 1.562, 2),
        ('s', 1.083, 2.195),
        ('t', 1.069, 1.806),
        ('u', 1.156, 2.183),
        ('v', 1.188, 1.978),
        ('w', 1.25, 2.317),
        ('x', 1.307, 2.15),
        ('y', 1.344, 2.451),
        ('z', 2, 2.5)
),

aufbereitet AS (
    SELECT
        b.*,
        COALESCE(sk_ob.korrekturfaktor, 1::numeric) AS sc_skelett_korrekturfaktor_ob,
        COALESCE(sk_ub.korrekturfaktor, 1::numeric) AS sc_skelett_korrekturfaktor_ub,

        CASE
            WHEN b.koernkl_ob_i IS NOT NULL AND b.ton_ob IS NULL THEN
                CASE b.koernkl_ob_i
                    WHEN 1 THEN 2.5
                    WHEN 2 THEN 2.5
                    WHEN 3 THEN 7.5
                    WHEN 4 THEN 12.5
                    WHEN 5 THEN 17.5
                    WHEN 6 THEN 25
                    WHEN 7 THEN 35
                    WHEN 8 THEN 45
                    WHEN 9 THEN 74.9
                    WHEN 10 THEN 5
                    WHEN 11 THEN 5
                    WHEN 12 THEN 20
                    WHEN 13 THEN 40
                END
            ELSE b.ton_ob
        END AS sc_ton_ob,

        CASE
            WHEN b.koernkl_ub_i IS NOT NULL AND b.ton_ub IS NULL THEN
                CASE b.koernkl_ub_i
                    WHEN 1 THEN 2.5
                    WHEN 2 THEN 2.5
                    WHEN 3 THEN 7.5
                    WHEN 4 THEN 12.5
                    WHEN 5 THEN 17.5
                    WHEN 6 THEN 25
                    WHEN 7 THEN 35
                    WHEN 8 THEN 45
                    WHEN 9 THEN 74.9
                    WHEN 10 THEN 5
                    WHEN 11 THEN 5
                    WHEN 12 THEN 20
                    WHEN 13 THEN 40
                END
            ELSE b.ton_ub
        END AS sc_ton_ub,

        CASE
            WHEN b.koernkl_ob_i IS NOT NULL AND b.schluff_ob IS NULL THEN
                CASE
                    WHEN b.koernkl_ob_i = 1 THEN 8
                    WHEN b.koernkl_ob_i = 2 THEN 32.5
                    WHEN b.koernkl_ob_i BETWEEN 3 AND 9 THEN 25
                    WHEN b.koernkl_ob_i IN (10, 13) THEN 60
                    WHEN b.koernkl_ob_i = 11 THEN 85
                    WHEN b.koernkl_ob_i = 12 THEN 70
                END
            ELSE b.schluff_ob
        END AS sc_temp_schluff_ob,

        CASE
            WHEN b.koernkl_ub_i IS NOT NULL AND b.schluff_ub IS NULL THEN
                CASE
                    WHEN b.koernkl_ub_i = 1 THEN 8
                    WHEN b.koernkl_ub_i = 2 THEN 32.5
                    WHEN b.koernkl_ub_i BETWEEN 3 AND 9 THEN 25
                    WHEN b.koernkl_ub_i IN (10, 13) THEN 60
                    WHEN b.koernkl_ub_i = 11 THEN 85
                    WHEN b.koernkl_ub_i = 12 THEN 70
                END
            ELSE b.schluff_ub
        END AS sc_temp_schluff_ub
    FROM basis b
    LEFT JOIN lut_korr_skelettgehalt sk_ob ON sk_ob.skelettklasse = b.skelett_ob_i
    LEFT JOIN lut_korr_skelettgehalt sk_ub ON sk_ub.skelettklasse = b.skelett_ub_i
),

textur AS (
    SELECT
        a.*,
        CASE
            WHEN a.schluff_ob IS NOT NULL THEN a.schluff_ob * 1.08
            ELSE a.sc_temp_schluff_ob * 1.08
        END AS sc_schluff_ob_roh,
        CASE
            WHEN a.schluff_ub IS NOT NULL THEN a.schluff_ub * 1.08
            ELSE a.sc_temp_schluff_ub * 1.08
        END AS sc_schluff_ub_roh
    FROM aufbereitet a
),

textur2 AS (
    SELECT
        t.*,
        CASE
            WHEN t.sc_ton_ob + t.sc_schluff_ob_roh > 100
                THEN 100 - t.sc_ton_ob - 0.01
            ELSE t.sc_schluff_ob_roh
        END AS sc_schluff_ob,
        CASE
            WHEN t.sc_ton_ub + t.sc_schluff_ub_roh > 100
                THEN 100 - t.sc_ton_ub - 0.01
            ELSE t.sc_schluff_ub_roh
        END AS sc_schluff_ub
    FROM textur t
),

bodart AS (
    SELECT
        t.*,
        (
            SELECT lb.bodart
            FROM lut_bodart lb
            WHERE t.sc_ton_ob >= lb.ton_v
              AND t.sc_ton_ob <= lb.ton_b
              AND t.sc_schluff_ob >= lb.schl_v
              AND t.sc_schluff_ob <= lb.schl_b
            ORDER BY lb.ton_v DESC, lb.schl_v DESC
            LIMIT 1
        ) AS sc_fek_ob,
        (
            SELECT lb.bodart
            FROM lut_bodart lb
            WHERE t.sc_ton_ub >= lb.ton_v
              AND t.sc_ton_ub <= lb.ton_b
              AND t.sc_schluff_ub >= lb.schl_v
              AND t.sc_schluff_ub <= lb.schl_b
            ORDER BY lb.ton_v DESC, lb.schl_v DESC
            LIMIT 1
        ) AS sc_fek_ub
    FROM textur2 t
),

gefuege AS (
    SELECT
        b.*,
        NULLIF(replace(COALESCE(b.gefuegeform_ob,'') || COALESCE(b.gefueggr_ob_i::text,''), 'NA', ''), '') AS sc_gefu_ob_ch,
        NULLIF(replace(COALESCE(b.gefuegeform_ub,'') || COALESCE(b.gefueggr_ub_i::text,''), 'NA', ''), '') AS sc_gefu_ub_ch
    FROM bodart b
),

lagerung AS (
    SELECT
        g.*,
        CASE
            WHEN g.sc_gefu_ob_ch IN ('Kr1', 'Kr2', 'Kr3', 'Kr4', 'Sp1', 'Po1', 'Po2', 'Br1', 'Br2', 'Fr1', 'Fr2') THEN 'Ld1'
            WHEN g.sc_gefu_ob_ch IN ('Kr5', 'Kr6', 'Kr7', 'Kr', 'Sp2', 'Sp3', 'Sp4', 'Po3', 'Po4', 'Pr1', 'Pr2', 'Pr3', 'Pr4', 'Fr3', 'Fr4', 'Br3', 'Br4', 'Klr1', 'Klr2', 'Klr3', 'Klr4', 'Klk1', 'Klk2', 'Klk3', 'Klk4', 'Ek', 'Ek1') THEN 'Ld2'
            WHEN g.sc_gefu_ob_ch IN ('Sp5', 'Sp6', 'Sp7', 'Po5', 'Pr5', 'Fr5', 'Br5', 'Br6', 'Br7', 'Klr5', 'Klk5') THEN 'Ld3'
            WHEN g.sc_gefu_ob_ch IN ('Po6', 'Po7', 'Fr6', 'Fr7', 'Pr6', 'Pl1', 'Pl2', 'Klr6', 'Klr7', 'Klk6', 'Klk7', 'Ko') THEN 'Ld4'
            WHEN g.sc_gefu_ob_ch IN ('Pr7', 'Pl3', 'Pl4', 'Pl5', 'Pl6', 'Pl7') THEN 'Ld5'
        END AS sc_ld_ob,
        CASE
            WHEN g.sc_gefu_ub_ch IN ('Kr1', 'Kr2', 'Kr3', 'Kr4', 'Sp1', 'Po1', 'Po2', 'Br1', 'Br2', 'Fr1', 'Fr2') THEN 'Ld1'
            WHEN g.sc_gefu_ub_ch IN ('Kr5', 'Kr6', 'Kr7', 'Kr', 'Sp2', 'Sp3', 'Sp4', 'Po3', 'Po4', 'Pr1', 'Pr2', 'Pr3', 'Pr4', 'Fr3', 'Fr4', 'Br3', 'Br4', 'Klr1', 'Klr2', 'Klr3', 'Klr4', 'Klk1', 'Klk2', 'Klk3', 'Klk4', 'Ek', 'Ek1') THEN 'Ld2'
            WHEN g.sc_gefu_ub_ch IN ('Sp5', 'Sp6', 'Sp7', 'Po5', 'Pr5', 'Fr5', 'Br5', 'Br6', 'Br7', 'Klr5', 'Klk5') THEN 'Ld3'
            WHEN g.sc_gefu_ub_ch IN ('Po6', 'Po7', 'Fr6', 'Fr7', 'Pr6', 'Pl1', 'Pl2', 'Klr6', 'Klr7', 'Klk6', 'Klk7', 'Ko') THEN 'Ld4'
            WHEN g.sc_gefu_ub_ch IN ('Pr7', 'Pl3', 'Pl4', 'Pl5', 'Pl6', 'Pl7') THEN 'Ld5'
        END AS sc_ld_ub
    FROM gefuege g
),

lagerung2 AS (
    SELECT
        l.*,
        NULLIF(regexp_replace(COALESCE(l.sc_ld_ob,''), '[^0-9]', '', 'g'), '')::int AS sc_ld_ob_num,
        NULLIF(regexp_replace(COALESCE(l.sc_ld_ub,''), '[^0-9]', '', 'g'), '')::int AS sc_ld_ub_num
    FROM lagerung l
),

lagerung3 AS (
    SELECT
        l.*,
        CASE
            WHEN l.sc_ld_ob IS NOT NULL THEN l.sc_ld_ob
            WHEN l.sc_ld_ub_num IS NOT NULL THEN 'Ld' || GREATEST(l.sc_ld_ub_num - 1, 1)::text
        END AS sc_ld_ob_eff,
        CASE
            WHEN l.sc_ld_ub IS NOT NULL THEN l.sc_ld_ub
            WHEN l.sc_ld_ob_num IS NOT NULL THEN 'Ld' || LEAST(l.sc_ld_ob_num + 1, 5)::text
        END AS sc_ld_ub_eff
    FROM lagerung2 l
),

trockenrohdichte AS (
    SELECT
        l.*,
        CASE
            WHEN l.humusgeh_ah > 1 AND l.humusgeh_ah < 6 THEN l.humusgeh_ah * 0.04
            WHEN l.humusgeh_ah > 1 AND l.humusgeh_ah <= 15 THEN 6 * 0.04 + (l.humusgeh_ah - 6) * 0.03
            WHEN l.humusgeh_ah > 15 THEN 6 * 0.04 + 9 * 0.03 + (l.humusgeh_ah - 15) * 0.01
            ELSE 0
        END AS trd_hum_abzug,

        (
            SELECT lt.trockenrohdichte
            FROM lut_trockenrohdichte lt
            WHERE lt.bodenart = l.sc_fek_ob
              AND lt.ladi = l.sc_ld_ob_eff
            LIMIT 1
        ) AS sc_trd_ob_ohne_humusabzug,

        (
            SELECT lt.trockenrohdichte
            FROM lut_trockenrohdichte lt
            WHERE lt.bodenart = l.sc_fek_ub
              AND lt.ladi = l.sc_ld_ub_eff
            LIMIT 1
        ) AS sc_trd_ub
    FROM lagerung3 l
),

trockenrohdichte2 AS (
    SELECT
        t.*,
        COALESCE(t.sc_trd_ob_ohne_humusabzug, 0) - COALESCE(t.trd_hum_abzug, 0) AS sc_trd_ob
    FROM trockenrohdichte t
),

nfk_stufe1 AS (
    SELECT
        t.*,
        CASE
            WHEN t.humusgeh_ah >= 15 AND t.humusgeh_ah <= 30 THEN 37
            ELSE (
                SELECT ln.nfk
                FROM lut_nfk_aus_trd ln
                WHERE ln.bodenart = t.sc_fek_ob
                  AND t.sc_trd_ob > ln.trdmin
                  AND t.sc_trd_ob <= ln.trdmax
                LIMIT 1
            )
        END AS sc_nfk_ob_1_vor_zuschlag,

        (
            SELECT ln.nfk
            FROM lut_nfk_aus_trd ln
            WHERE ln.bodenart = t.sc_fek_ub
              AND t.sc_trd_ub >= ln.trdmin
              AND t.sc_trd_ub <= ln.trdmax
            LIMIT 1
        ) AS sc_nfk_ub
    FROM trockenrohdichte2 t
),

nfk_stufe2 AS (
    SELECT
        n.*,
        COALESCE((
            SELECT lo.zuschlag
            FROM lut_os lo
            WHERE lo.bodenart = n.sc_fek_ob
              AND n.humusgeh_ah >= lo.osmin
              AND n.humusgeh_ah <= lo.osmax
            LIMIT 1
        ), 0) AS sc_os_zuschlag_ob,

        CASE
            WHEN n.ut_i3 THEN 1
            WHEN n.ut_i4 THEN 2
        END AS sc_hydrostufe_ob,

        CASE
            WHEN n.ut_r1 OR n.ut_i3 THEN 1
            WHEN n.ut_r2 OR n.ut_r3 OR n.ut_r4 OR n.ut_i4 THEN 2
        END AS sc_hydrostufe_ub
    FROM nfk_stufe1 n
),

nfk_stufe3 AS (
    SELECT
        n.*,
        n.sc_nfk_ob_1_vor_zuschlag + n.sc_os_zuschlag_ob AS sc_nfk_ob_2_nach_os_zuschlag,

        COALESCE((
            SELECT lh.zuschlag
            FROM lut_hydro lh
            WHERE lh.bodenart = n.sc_fek_ob
              AND lh.hydrostufe = n.sc_hydrostufe_ob
            LIMIT 1
        ), 0) AS sc_hydro_zuschlag_ob,

        COALESCE((
            SELECT lh.zuschlag
            FROM lut_hydro lh
            WHERE lh.bodenart = n.sc_fek_ub
              AND lh.hydrostufe = n.sc_hydrostufe_ub
            LIMIT 1
        ), 0) AS sc_hydro_zuschlag_ub
    FROM nfk_stufe2 n
),

nfk_stufe4 AS (
    SELECT
        n.*,
        n.sc_nfk_ob_2_nach_os_zuschlag + n.sc_hydro_zuschlag_ob AS sc_nfk_ob_3_nach_hydro_zuschlag,
        n.sc_nfk_ub + n.sc_hydro_zuschlag_ub AS sc_nfk_ub_3_nach_hydro_zuschlag,
        CASE
            WHEN (n.bodentyp IN ('M', 'N')) OR (n.humusgeh_ah >= 30) THEN 1
            ELSE 0
        END AS sc_nm30corg
    FROM nfk_stufe3 n
),

organik AS (
    SELECT
        n.*,

        CASE
            WHEN n.sc_nm30corg = 1 AND n.wasserhaushalt IN ('x', 'y', 'z') THEN 'sv12'
            WHEN n.sc_nm30corg = 1 AND n.wasserhaushalt IN ('v', 'w') THEN 'sv3'
            WHEN n.sc_nm30corg = 1 AND n.wasserhaushalt IN ('s', 't', 'u') THEN 'sv45'
        END AS sc_ob_substanzvol_roh,

        CASE
            WHEN n.sc_nm30corg = 1 AND n.wasserhaushalt IN ('v', 'w', 'x', 'y', 'z') THEN 'sv12'
            WHEN n.sc_nm30corg = 1 AND n.wasserhaushalt IN ('s', 't', 'u') THEN 'sv3'
            WHEN n.sc_nm30corg = 1 AND n.wasserhaushalt IN ('k', 'l', 'm', 'n') THEN 'sv45'
        END AS sc_ub_substanzvol_roh,

        CASE
            WHEN (n.bodentyp = 'M' OR n.bodentyp = 'N') AND n.humusgeh_ah >= 30 THEN
                CASE
                    WHEN n.gefuegeform_ob = 'obl' THEN 'z12'
                    WHEN n.gefuegeform_ob = 'ofi' THEN 'z3'
                    WHEN n.gefuegeform_ob = 'osm' THEN 'z45'
                END
        END AS sc_ob_zs,

        CASE
            WHEN n.bodentyp = 'M' OR n.bodentyp = 'N' THEN
                CASE
                    WHEN n.gefuegeform_ub = 'obl' THEN 'z12'
                    WHEN n.gefuegeform_ub = 'ofi' THEN 'z3'
                    WHEN n.gefuegeform_ub = 'osm' THEN 'z45'
                END
        END AS sc_ub_zs,

        CASE
            WHEN n.sc_nm30corg = 1 AND n.humusgeh_ah >= 30 THEN
                CASE
                    WHEN n.gefuegeform_ob IN ('Kr', 'Sp', 'Br') OR n.sc_gefu_ob_ch IN ('Po1', 'Po2', 'Po3', 'Po4') THEN 'nHv'
                    WHEN n.gefuegeform_ob = 'Ko' THEN 'nHm'
                    WHEN n.sc_gefu_ob_ch IN ('Pr5', 'Pr6', 'Pr7') THEN 'nHt'
                    WHEN n.gefuegeform_ob IN ('Klr', 'Klk', 'Fr', 'Ek') THEN 'nHr_nHw'
                    ELSE 'nHr_nHw'
                END
        END AS sc_ob_torfart,

        CASE
            WHEN n.sc_nm30corg = 1 AND n.bodentyp IN ('M', 'N') THEN
                CASE
                    WHEN n.gefuegeform_ub IN ('Kr', 'Sp', 'Br') OR n.sc_gefu_ub_ch IN ('Po1', 'Po2', 'Po3', 'Po4') THEN 'nHv'
                    WHEN n.gefuegeform_ub = 'Ko' THEN 'nHm'
                    WHEN n.sc_gefu_ub_ch IN ('Po5', 'Po6', 'Po7', 'Pr1', 'Pr2', 'Pr3', 'Pr4') THEN 'nHa'
                    WHEN n.sc_gefu_ub_ch IN ('Pr5', 'Pr6', 'Pr7') THEN 'nHt'
                    WHEN n.gefuegeform_ub IN ('Klr', 'Klk', 'Fr', 'Ek') THEN 'nHr_nHw'
                    ELSE 'nHr_nHw'
                END
        END AS sc_ub_torfart
    FROM nfk_stufe4 n
),

organik2 AS (
    SELECT
        o.*,
        CASE
            WHEN o.sc_ob_torfart IN ('nHv', 'nHm', 'nHa') AND o.sc_ob_substanzvol_roh IN ('sv12', 'sv3') AND o.sc_ob_zs IS NULL THEN 'sv45'
            WHEN o.sc_ob_torfart IN ('nHt', 'nHr_nHw') AND o.sc_ob_substanzvol_roh = 'sv12' AND o.sc_ob_zs IS NULL THEN 'sv3'
            ELSE o.sc_ob_substanzvol_roh
        END AS sc_ob_substanzvol,

        CASE
            WHEN o.sc_ub_torfart IN ('nHv', 'nHm', 'nHa') AND o.sc_ub_substanzvol_roh IN ('sv12', 'sv3') AND o.sc_ub_zs IS NULL THEN 'sv45'
            WHEN o.sc_ub_torfart IN ('nHt', 'nHr_nHw') AND o.sc_ub_substanzvol_roh = 'sv12' AND o.sc_ub_zs IS NULL THEN 'sv3'
            ELSE o.sc_ub_substanzvol_roh
        END AS sc_ub_substanzvol
    FROM organik o
),

lut_zs_sv_to_nfk(zs, sv, nfk) AS (
    VALUES
        ('z12', 'sv12', 55),
        ('z12', 'sv3', 58),
        ('z12', 'sv45', 60),
        ('z3', 'sv12', 60),
        ('z3', 'sv3', 60),
        ('z3', 'sv45', 60),
        ('z45', 'sv12', 60),
        ('z45', 'sv3', 65),
        ('z45', 'sv45', 55)
),

lut_ta_sv_to_nfk(ta, sv, nfk) AS (
    VALUES
        ('nHt', 'sv3', 50),
        ('nHr_nHw', 'sv3', 58),
        ('nHv', 'sv45', 32),
        ('nHm', 'sv45', 29),
        ('nHa', 'sv45', 29),
        ('nHt', 'sv45', 40),
        ('nHr_nHw', 'sv45', 50)
),

organik3 AS (
    SELECT
        o.*,

        CASE
            WHEN o.bodentyp IN ('M', 'N') THEN (
                SELECT l.nfk
                FROM lut_zs_sv_to_nfk l
                WHERE l.zs = o.sc_ob_zs
                  AND l.sv = o.sc_ob_substanzvol
                LIMIT 1
            )
        END AS sc_nfk_ob_mn_basis,

        CASE
            WHEN o.bodentyp IN ('M', 'N') THEN (
                SELECT l.nfk
                FROM lut_zs_sv_to_nfk l
                WHERE l.zs = o.sc_ub_zs
                  AND l.sv = o.sc_ub_substanzvol
                LIMIT 1
            )
        END AS sc_nfk_ub_mn_basis,

        CASE
            WHEN o.bodentyp NOT IN ('M', 'N') AND o.sc_nm30corg = 1 THEN (
                SELECT l.nfk
                FROM lut_ta_sv_to_nfk l
                WHERE l.ta = o.sc_ob_torfart
                  AND l.sv = o.sc_ob_substanzvol
                LIMIT 1
            )
        END AS sc_nfk_ob_30corg,

        CASE
            WHEN o.bodentyp NOT IN ('M', 'N') AND o.sc_nm30corg = 1 THEN (
                SELECT l.nfk
                FROM lut_ta_sv_to_nfk l
                WHERE l.ta = o.sc_ub_torfart
                  AND l.sv = o.sc_ub_substanzvol
                LIMIT 1
            )
        END AS sc_nfk_ub_30corg
    FROM organik2 o
),

organik4 AS (
    SELECT
        o.*,

        COALESCE(
            o.sc_nfk_ob_mn_basis,
            CASE
                WHEN o.bodentyp IN ('M', 'N') THEN (
                    SELECT l.nfk
                    FROM lut_ta_sv_to_nfk l
                    WHERE l.ta = o.sc_ob_torfart
                      AND l.sv = o.sc_ob_substanzvol
                    LIMIT 1
                )
            END
        ) AS sc_nfk_ob_mn,

        COALESCE(
            o.sc_nfk_ub_mn_basis,
            CASE
                WHEN o.bodentyp IN ('M', 'N') THEN (
                    SELECT l.nfk
                    FROM lut_ta_sv_to_nfk l
                    WHERE l.ta = o.sc_ub_torfart
                      AND l.sv = o.sc_ub_substanzvol
                    LIMIT 1
                )
            END
        ) AS sc_nfk_ub_mn
    FROM organik3 o
),

nfk_final AS (
    SELECT
        o.*,
        COALESCE(o.sc_nfk_ob_mn, o.sc_nfk_ob_30corg, o.sc_nfk_ob_3_nach_hydro_zuschlag) AS sc_nfk_ob_4_nm30corg,
        COALESCE(o.sc_nfk_ub_mn, o.sc_nfk_ub_30corg, o.sc_nfk_ub_3_nach_hydro_zuschlag) AS sc_nfk_ub_4_nm30corg
    FROM organik4 o
),

png_berechnet AS (
    SELECT
        n.*,
        COALESCE(
            n.pflngr,
            CASE
                WHEN n.bodpktzahl IN (0, 1, 2, 3, 4, 49, 79, 89) THEN NULL
                WHEN n.bodpktzahl < 20 THEN (n.bodpktzahl + 20) / 4.0
                WHEN n.bodpktzahl < 50 THEN (n.bodpktzahl - 5) / 1.5
                WHEN n.bodpktzahl < 70 THEN n.bodpktzahl - 20
                WHEN n.bodpktzahl >= 70 THEN (n.bodpktzahl - 45) * 2.0
                ELSE NULL
            END,
            lp.png_med_neu
        ) AS sc_png,
        wf.faktor_ob AS sc_ob_cm_pfn_fkt,
        wf.faktor_ub AS sc_ub_cm_pfn_fkt
    FROM nfk_final n
    LEFT JOIN lut_png lp ON lp.whg = n.wasserhaushalt
    LEFT JOIN lut_whg_faktor wf ON wf.whg = n.wasserhaushalt
),

wurzelraum AS (
    SELECT
        p.*,

        CASE
            WHEN p.sc_png IS NULL AND p.maechtigkeit_ah IS NULL THEN NULL
            WHEN p.maechtigkeit_ah IS NULL THEN p.sc_png
            WHEN p.sc_ob_cm_pfn_fkt IS NULL OR p.sc_ob_cm_pfn_fkt = 0 THEN p.sc_png
            WHEN p.sc_png IS NULL THEN p.maechtigkeit_ah / p.sc_ob_cm_pfn_fkt
            ELSE LEAST(p.sc_png, p.maechtigkeit_ah / p.sc_ob_cm_pfn_fkt)
        END AS sc_ob_cm_pfn
    FROM png_berechnet p
),

wurzelraum2 AS (
    SELECT
        w.*,
        w.sc_png - w.sc_ob_cm_pfn AS sc_ub_cm_pfn,
        w.maechtigkeit_ah * w.sc_skelett_korrekturfaktor_ob AS sc_ob_cm_fuer_nfk,
        floor((w.sc_png - w.sc_ob_cm_pfn) * w.sc_ub_cm_pfn_fkt) AS sc_ub_cm_fuer_nfk
    FROM wurzelraum w
),

result AS (
    SELECT
        w.bodeneinheit_id,
        ROUND((w.sc_ob_cm_fuer_nfk * w.sc_nfk_ob_4_nm30corg / 10.0)::numeric, 5) AS wurzelraum_feldkapazitaet_oberboden,
        ROUND((w.sc_ub_cm_fuer_nfk * w.sc_nfk_ub_4_nm30corg / 10.0)::numeric, 5) AS wurzelraum_feldkapazitaet_unterboden,
        ROUND((
            COALESCE(w.sc_ob_cm_fuer_nfk * w.sc_nfk_ob_4_nm30corg / 10.0, 0)
          + COALESCE(w.sc_ub_cm_fuer_nfk * w.sc_nfk_ub_4_nm30corg / 10.0, 0)
        )::numeric, 5) AS wurzelraum_feldkapazitaet
    FROM wurzelraum2 w
)

UPDATE 
    afu_bodeneinheiten_pub_v1.bodeneinheit_landwirtschaft AS tgt
    SET
        wurzelraum_feldkapazitaet_oberboden = r.wurzelraum_feldkapazitaet_oberboden,
        wurzelraum_feldkapazitaet_unterboden = r.wurzelraum_feldkapazitaet_unterboden,
        wurzelraum_feldkapazitaet = r.wurzelraum_feldkapazitaet
FROM 
    result r
WHERE 
    tgt.t_id = r.bodeneinheit_id
;

UPDATE 
    afu_bodeneinheiten_pub_v1.bodeneinheit_landwirtschaft
    SET 
    wurzelraum_feldkapazitaet_beschreibung = 
    CASE
        WHEN 
            wurzelraum_feldkapazitaet < 50 
        THEN '< 50 mm'
        WHEN 
            wurzelraum_feldkapazitaet >= 50
            AND 
            wurzelraum_feldkapazitaet < 100
        THEN 
            '50 - 100 mm'
        WHEN 
            wurzelraum_feldkapazitaet >= 100
            AND 
            wurzelraum_feldkapazitaet < 150
        THEN 
            '100 - 150 mm'
        WHEN 
            wurzelraum_feldkapazitaet >= 150
            AND 
            wurzelraum_feldkapazitaet < 200
        THEN 
            '150 - 200 mm'
        WHEN 
            wurzelraum_feldkapazitaet >= 200
            AND 
            wurzelraum_feldkapazitaet < 250
        THEN 
            '200 - 250 mm'
        WHEN 
            wurzelraum_feldkapazitaet >= 250
        THEN 
            '>= 250 mm'
        ELSE NULL
    END
;
