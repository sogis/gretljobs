WITH charakter_wasserhaushalt AS (
    SELECT
        bodeneinheit_onlinedata_t.pk_isboden AS t_id,
        CASE
            WHEN wasserhhgr_t.code IN ('a', 'b', 'c', 'd', 'e')
                THEN 'kein Einfluss von Stau- oder Grundwasser'
            WHEN wasserhhgr_t.code IN ('f', 'g', 'h', 'i')
                THEN 'leichter Einfluss von Stauwasser'
            WHEN wasserhhgr_t.code IN ('k', 'l', 'm', 'n')
                THEN 'leichter Einfluss von Grund- oder Hangwasser'
            WHEN wasserhhgr_t.code IN ('o', 'p', 'q', 'r')
                THEN 'starker Einfluss von Stauwasser. Falls nicht drainiert, stellenweise dauernd vernässt'
            WHEN wasserhhgr_t.code IN ('s', 't', 'u', 'v', 'w', 'x', 'y', 'z')
                THEN 'starker Einfluss von Grund- oder Hangwasser. Falls nicht drainiert, stellenweise dauernd vernässt'
        END AS charakter_wasserhaushalt,
        CASE
            WHEN
                bodeneinheit_onlinedata_t.is_wald IS TRUE
                AND
                (
                    wasserhhgr_t.code IN ('a', 'b', 'f', 'k', 's')
                    OR
                    (
                        wasserhhgr_t.code ='o'
                        AND
                        bodeneinheit_auspraegung_t.pflngr >= 70
                    )
                )
                THEN 'tiefgründiger Boden, d.h. pflanzennutzbare Gründigkeit > 70 cm'
            WHEN
                bodeneinheit_onlinedata_t.is_wald IS TRUE         
                AND
                (
                    wasserhhgr_t.code  IN ('c', 'd', 'g', 'h', 'l', 'm', 'q', 't', 'v', 'x')
                    OR
                    (
                        (
                            wasserhhgr_t.code ='o'
                            AND
                            (
                                bodeneinheit_auspraegung_t.pflngr < 70
                                OR
                                bodeneinheit_auspraegung_t.pflngr IS NULL
                            )
                        )
                        OR
                        (
                            wasserhhgr_t.code = 'p'
                            AND
                            bodeneinheit_auspraegung_t.pflngr >= 30
                        )
                        OR
                        (
                            wasserhhgr_t.code = 'u'
                            AND
                            bodeneinheit_auspraegung_t.pflngr >= 30
                        )
                        OR
                        (
                            wasserhhgr_t.code = 'w'
                            AND
                            bodeneinheit_auspraegung_t.pflngr >= 30
                        )
                    )
                )
                THEN 'mittelgründiger Boden, d.h. pflanzennutzbare Gründigkeit 30 - 70 cm'
            WHEN
                bodeneinheit_onlinedata_t.is_wald IS TRUE  
                AND
                ((   
                    wasserhhgr_t.code IN ('e', 'i', 'n')
                    OR
                    (
                        wasserhhgr_t.code ='p'
                        AND
                        (
                            bodeneinheit_auspraegung_t.pflngr < 30
                            OR
                            bodeneinheit_auspraegung_t.pflngr IS NULL
                        )
                    )
                    OR
                    wasserhhgr_t.code = 'r'
                )
                OR
                (
                    (
                        wasserhhgr_t.code = 'u'
                        AND
                        bodeneinheit_auspraegung_t.pflngr < 30
                    )
                    OR
                    (
                        wasserhhgr_t.code = 'w'
                        AND
                        (
                            bodeneinheit_auspraegung_t.pflngr < 30
                            OR
                            bodeneinheit_auspraegung_t.pflngr IS NULL
                        )
                    )
                    OR
                    wasserhhgr_t.code IN ('y', 'z')
                )) 
                THEN 'flachgründiger Boden, d.h. pflanzennutzbare Gründigkeit < 30 cm'
        END AS wald_charakter_wasserhaushalt
    FROM
        afu_isboden.bodeneinheit_onlinedata_t
        LEFT JOIN afu_isboden.bodeneinheit_t
            ON bodeneinheit_onlinedata_t.objnr = bodeneinheit_t.objnr
        LEFT JOIN afu_isboden.bodeneinheit_auspraegung_t
            ON bodeneinheit_auspraegung_t.fk_bodeneinheit = bodeneinheit_t.pk_ogc_fid
        LEFT JOIN afu_isboden.wasserhhgr_t
            ON wasserhhgr_t.pk_wasserhhgr = bodeneinheit_auspraegung_t.fk_wasserhhgr
    WHERE
        bodeneinheit_onlinedata_t.archive = 0
        AND
        bodeneinheit_auspraegung_t.is_hauptauspraegung
        AND
        bodeneinheit_onlinedata_t.gemnr = bodeneinheit_t.gemnr
        AND
        bodeneinheit_t.archive = 0
        AND
        bodeneinheit_t.los = bodeneinheit_onlinedata_t.los
)


SELECT
    bodeneinheit_onlinedata_t.pk_isboden AS t_id,
    bodeneinheit_onlinedata_t.gemnr,
    bodeneinheit_onlinedata_t.objnr,
    wasserhhgr_t.code AS wasserhhgr,
    wasserhhgr_t.beschreibung AS wasserhhgr_beschreibung,
    concat_ws(', ',charakter_wasserhaushalt.wald_charakter_wasserhaushalt, charakter_wasserhaushalt.charakter_wasserhaushalt) AS charakter_wasserhaushalt,
    CASE
        WHEN wasserhhgr_t.code = 'a'
            THEN 'a - sehr tiefgründig'
        WHEN wasserhhgr_t.code = 'b'
            THEN 'b - tiefgründig'
        WHEN wasserhhgr_t.code = 'c'
            THEN 'c - mässig tiefgründig'
        WHEN wasserhhgr_t.code = 'd'
            THEN 'd - ziemlich flachgründig'
        WHEN wasserhhgr_t.code = 'e'
            THEN 'e - flachgründig und sehr flachgründig'
        WHEN wasserhhgr_t.code = 'f'
            THEN 'f - tiefgründig'
        WHEN wasserhhgr_t.code = 'g'
            THEN 'g - mässig tiefgründig'
        WHEN wasserhhgr_t.code = 'h'
            THEN 'h - ziemlich flachgründig' 
        WHEN wasserhhgr_t.code = 'i'
            THEN 'i - flachgründig und sehr flachgründig'
        WHEN wasserhhgr_t.code = 'k'
            THEN 'k - tiefgründig'
        WHEN wasserhhgr_t.code = 'l'
            THEN 'l - mässig tiefgründig'
        WHEN wasserhhgr_t.code = 'm'
            THEN 'm - ziemlich flachgründig'
        WHEN wasserhhgr_t.code = 'n'
            THEN 'n - flachgründig und sehr flachgründig'
        WHEN wasserhhgr_t.code = 'o'
            THEN 'o - mässig tiefgründig und tiefgründig'
        WHEN wasserhhgr_t.code = 'p'
            THEN 'p - ziemlich flachgründig und flachgründig'
        WHEN wasserhhgr_t.code = 'q'
            THEN 'q - ziemlich flachgründig'
        WHEN wasserhhgr_t.code = 'r'
            THEN 'r - flachgründig und sehr flachgründig'
        WHEN wasserhhgr_t.code = 's'
            THEN 's - tiefgründig'
        WHEN wasserhhgr_t.code = 't'
            THEN 't - mässig tiefgründig'
        WHEN wasserhhgr_t.code = 'u'
            THEN 'u - ziemlich flachgründig und flachgründig'
        WHEN wasserhhgr_t.code = 'v'
            THEN 'v - mässig tiefgründig'
        WHEN wasserhhgr_t.code = 'w'
            THEN 'w - ziemlich flachgründig und flachgründig'
        WHEN wasserhhgr_t.code = 'y'
            THEN 'y - flachgründig und sehr flachgründig'
        WHEN wasserhhgr_t.code = 'x'
            THEN 'x - ziemlich flachgründig'
        WHEN wasserhhgr_t.code = 'z'
            THEN 'z - sehr flachgründig'
    END AS wasserhaushalt_spezifisch,
    CASE 
        WHEN wasserhhgr_t.code IN ('a', 'b', 'c', 'd', 'e')
            THEN 'Senkrecht durchwaschen, normal durchlässig und'
        WHEN wasserhhgr_t.code IN ('f', 'g', 'h', 'i')
            THEN 'Senkrecht durchwaschen, stauwasserbeeinflusst und'
        WHEN wasserhhgr_t.code IN ('k', 'l', 'm', 'n')
            THEN 'Senkrecht durchwaschen, grund- oder hangwasserbeeinflusst und'
        WHEN wasserhhgr_t.code IN ('o', 'p')
            THEN 'Stauwassergeprägt, selten bis zur Oberfläche porengesättigt und'
        WHEN wasserhhgr_t.code IN ('q', 'r')
            THEN 'Stauwassergeprägt, häufig bis zur Oberfläche porengesättigt und'
        WHEN wasserhhgr_t.code IN ('s', 't', 'u')
            THEN 'Grund- oder hangwassergeprägt, selten bis zur Oberfläche porengesättigt und'
        WHEN wasserhhgr_t.code IN ('v', 'w')
            THEN 'Grund- oder hangwassergeprägt, häufig bis zur Oberfläche porengesättigt und '
        WHEN wasserhhgr_t.code IN ('x', 'y')
            THEN 'Grund- oder hangwassergeprägt, meist bis zur Oberfläche porengesättigt und'
        WHEN wasserhhgr_t.code = 'z'
            THEN 'Grund- oder hangwassergeprägt, dauernd bis zur Oberfläche porengesättigt und'
    END AS wasserhaushalt_uebergreifend,
    bodentyp_t.code AS bodentyp,
    bodentyp_t.beschreibung AS bodentyp_beschreibung,
    begelfor_t.code AS gelform,
    begelfor_t.beschreibung AS gelform_beschreibung,
    CASE
        WHEN 
            begelfor_t.code IN ('a', 'b', 'c', 'd', 'e')
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '0-10%: Keine Einschränkung'
        WHEN
            begelfor_t.code IN ('f', 'g', 'h', 'i')
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '10-15%: Hackfruchtanbau und Vollerntemaschine möglich'
        WHEN
            begelfor_t.code IN ('j', 'k', 'l', 'm', 'n')
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '15-25%: Hackfruchtanbau stark erschwert, Getreidebau erschwert; Mähdrescher möglich, evtl. Hangmähdrescher'
        WHEN
            begelfor_t.code IN ('o', 'p', 'q', 'r')
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '25-35%: Getreideanbau stark eingeschränkt, Hangmähdrescher; Hangtraktoren.'
        WHEN
            begelfor_t.code IN ('s', 't', 'u', 'v', 'w', 'x', 'y', 'z')
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '>35%: nur Mähwiese und Weide möglich; spezialisierte Hangmechanisierung'
    END AS gelform_text,
    bodeneinheit_auspraegung_t.geologie,
    concat_ws(', ', untertyp.untertyp_e, untertyp.untertyp_k, untertyp.untertyp_i, untertyp.untertyp_g, untertyp.untertyp_r, untertyp.untertyp_p, untertyp.untertyp_div) AS untertyp,
    skelett_t_ob.code AS skelett_ob,
    skelett_t_ob.beschreibung AS skelett_ob_beschreibung,
    CASE
        WHEN skelett_t_ob.code = 0
            THEN 'keine oder nur wenige Steine (0-5%)'
        WHEN skelett_t_ob.code = 1
            THEN 'mässig viele Steine (5-10%)'
        WHEN skelett_t_ob.code IN (2, 3)
            THEN 'viele Steine (10-20%)'
        WHEN skelett_t_ob.code IN (4, 5)
            THEN 'sehr viele Steine (20-30%)'
        WHEN skelett_t_ob.code >= 6
            THEN 'extrem viele Steine (> 30%)'
    END AS skelett_ob_text,
    skelett_t_ub.code AS skelett_ub,
    skelett_t_ub.beschreibung AS skelett_ub_beschreibung,
    CASE
        WHEN
            skelett_t_ub.code = 0
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'keine oder nur wenige Steine (0-5%)'
        WHEN
            skelett_t_ub.code = 1
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'mässig viele Steine (5-10%)'
        WHEN
            skelett_t_ub.code IN (2, 3)
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'viele Steine (10-20%)'
        WHEN
            skelett_t_ub.code IN (4, 5)
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'sehr viele Steine (20-30%)'
        WHEN
            skelett_t_ub.code >= 6
            AND 
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'extrem viele Steine (> 30%)'
    END AS skelett_ub_text,
    koernkl_t_ob.code AS koernkl_ob,
    koernkl_t_ob.beschreibung AS koernkl_ob_beschreibung,
    CASE
        WHEN
            koernkl_t_ob.code IN (7, 8, 9, 13)
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'Schwere, tonige Böden: schwer bearbeitbar, trocknen sehr langsam ab.'
        WHEN
            koernkl_t_ob.code IN (7, 8, 9, 13)
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'Schwere, tonige Böden: trocknen sehr langsam ab.'
        WHEN
            koernkl_t_ob.code IN (5, 6, 10, 11, 12)
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'Mittelschwere, lehmige bis schluffige Böden: normal bearbeitbar, trocknen mässig schnell ab.'
        WHEN
            koernkl_t_ob.code IN (5, 6, 10, 11, 12)
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'Mittelschwere, lehmige bis schluffige Böden: trocknen mässig schnell ab.'
        WHEN 
            koernkl_t_ob.code IN (1, 2, 3, 4)
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'Leichte, sandige Böden: leicht bearbeitbar, trocknen schnell ab.'
        WHEN 
            koernkl_t_ob.code IN (1, 2, 3, 4)
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'Leichte, sandige Böden: trocknen schnell ab.'
    END AS bodenart_bodenbearbeitbarkeit,
    koernkl_t_ub.code AS koernkl_ub,
    koernkl_t_ub.beschreibung AS koernkl_ub_beschreibung,
    bodeneinheit_auspraegung_t.ton_ob,
    bodeneinheit_auspraegung_t.ton_ub,
    bodeneinheit_auspraegung_t.schluff_ob,
    bodeneinheit_auspraegung_t.schluff_ub,
    bodeneinheit_auspraegung_t.karbgrenze,
    kalkgehalt_t_ob.code AS kalkgeh_ob,
    kalkgehalt_t_ob.beschreibung AS kalkgeh_ob_beschreibung,
    kalkgehalt_t_ub.code AS kalkgeh_ub,
    kalkgehalt_t_ub.beschreibung AS kalkgeh_ub_beschreibung,
    bodeneinheit_auspraegung_t.ph_ob,
    CASE
        WHEN
            bodeneinheit_auspraegung_t.ph_ob > 0
            AND
            bodeneinheit_auspraegung_t.ph_ob <= 4.2
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'stark sauer: starke Nährstoffauswaschung; Kalkung erforderlich'
        WHEN
            bodeneinheit_auspraegung_t.ph_ob > 4.2
            AND
            bodeneinheit_auspraegung_t.ph_ob <= 5.0
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'sauer: Nährstoffauswaschung; Kalkung erforderlich'
        WHEN
            bodeneinheit_auspraegung_t.ph_ob > 5.0
            AND
            bodeneinheit_auspraegung_t.ph_ob <= 6.1
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'schwach sauer: optimale Nährstoffverhältnisse; Erhaltungskalkung empfohlen'
        WHEN
            bodeneinheit_auspraegung_t.ph_ob > 6.1
            AND
            bodeneinheit_auspraegung_t.ph_ob <= 6.7
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'neutral: optimale Nährstoffverhältnisse; Erhaltungskalkung empfohlen'
        WHEN
            bodeneinheit_auspraegung_t.ph_ob > 6.7
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
            THEN 'alkalisch: keine Kalkung'
        WHEN
            bodeneinheit_auspraegung_t.ph_ob > 0
            AND
            bodeneinheit_auspraegung_t.ph_ob <= 3.2
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'sehr stark sauer'
        WHEN
            bodeneinheit_auspraegung_t.ph_ob > 3.2
            AND
            bodeneinheit_auspraegung_t.ph_ob <= 4.2
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'stark sauer'
        WHEN 
            bodeneinheit_auspraegung_t.ph_ob > 4.2
            AND
            bodeneinheit_auspraegung_t.ph_ob <= 5.0
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'sauer'
        WHEN 
            bodeneinheit_auspraegung_t.ph_ob > 5.0
            AND
            bodeneinheit_auspraegung_t.ph_ob <= 6.1
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'schwach sauer'
        WHEN
            bodeneinheit_auspraegung_t.ph_ob > 6.1
            AND
            bodeneinheit_auspraegung_t.ph_ob <= 6.7
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'neutral'
        WHEN
            bodeneinheit_auspraegung_t.ph_ob > 6.7
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'alkalisch'
    END AS ph_ob_text,
    bodeneinheit_auspraegung_t.ph_ub, 
    CASE
        WHEN
            bodeneinheit_auspraegung_t.ph_ub > 0
            AND
            bodeneinheit_auspraegung_t.ph_ub < 3.3
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'sehr stark sauer'
        WHEN
            bodeneinheit_auspraegung_t.ph_ub >= 3.3
            AND
            bodeneinheit_auspraegung_t.ph_ub < 4.3
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'stark sauer'
        WHEN
            bodeneinheit_auspraegung_t.ph_ub >= 4.3
            AND
            bodeneinheit_auspraegung_t.ph_ub < 5.1
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'sauer'
        WHEN
            bodeneinheit_auspraegung_t.ph_ub >= 5.1
            AND
            bodeneinheit_auspraegung_t.ph_ub < 6.2
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'schwach sauer'
        WHEN
            bodeneinheit_auspraegung_t.ph_ub >= 6.2
            AND
            bodeneinheit_auspraegung_t.ph_ub < 6.8
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'neutral'
        WHEN
            bodeneinheit_auspraegung_t.ph_ub >= 6.8
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'alkalisch'
        WHEN
            bodeneinheit_auspraegung_t.ph_ub > 0
            AND
            bodeneinheit_auspraegung_t.ph_ub <= 3.2
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'sehr stark sauer'
        WHEN
            bodeneinheit_auspraegung_t.ph_ub > 3.2
            AND
            bodeneinheit_auspraegung_t.ph_ub <= 4.2
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'stark sauer'
        WHEN
            bodeneinheit_auspraegung_t.ph_ub > 4.2
            AND
            bodeneinheit_auspraegung_t.ph_ub <= 5.0
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'sauer'
        WHEN
            bodeneinheit_auspraegung_t.ph_ub > 5.0
            AND
            bodeneinheit_auspraegung_t.ph_ub <= 6.1
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'schwach sauer'
        WHEN
            bodeneinheit_auspraegung_t.ph_ub > 6.1
            AND
            bodeneinheit_auspraegung_t.ph_ub <= 6.7
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'neutral'
        WHEN
            bodeneinheit_auspraegung_t.ph_ub > 6.7
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'alkalisch'
    END AS ph_ub_text,
    bodeneinheit_auspraegung_t.maechtigk_ah,
    bodeneinheit_auspraegung_t.humusgeh_ah,
    CASE
        WHEN
            bodeneinheit_auspraegung_t.humusgeh_ah > 0
            AND
            bodeneinheit_auspraegung_t.humusgeh_ah < 2
                THEN '< 2.0%: humusarm'
        WHEN
            bodeneinheit_auspraegung_t.humusgeh_ah >= 2
            AND
            bodeneinheit_auspraegung_t.humusgeh_ah < 3
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '2.0 - 2.9%: schwach humos'
        WHEN
            bodeneinheit_auspraegung_t.humusgeh_ah >= 3
            AND
            bodeneinheit_auspraegung_t.humusgeh_ah < 4
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '3.0 - 3.9%: mässig humos'
        WHEN
            bodeneinheit_auspraegung_t.humusgeh_ah >= 4
            AND
            bodeneinheit_auspraegung_t.humusgeh_ah < 5
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '4.0 - 4.9%: mittel humos'
        WHEN
            bodeneinheit_auspraegung_t.humusgeh_ah >= 5
            AND
            bodeneinheit_auspraegung_t.humusgeh_ah < 10
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '5.0 - 9.9%: humos'
        WHEN
            bodeneinheit_auspraegung_t.humusgeh_ah >= 10
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
            THEN '>= 10.0%: humusreich bis organisch'
        WHEN
            bodeneinheit_auspraegung_t.humusgeh_ah >= 2
            AND
            bodeneinheit_auspraegung_t.humusgeh_ah < 5
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN '2.0 - 4.9%: schwach humos'
        WHEN 
            bodeneinheit_auspraegung_t.humusgeh_ah >= 5
            AND
            bodeneinheit_auspraegung_t.humusgeh_ah < 10
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN '5.0 - 9.9%: humos'
        WHEN
            bodeneinheit_auspraegung_t.humusgeh_ah >= 10
            AND
            bodeneinheit_auspraegung_t.humusgeh_ah < 20
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN '10.0 - 19.9%: humusreich'
        WHEN
            bodeneinheit_auspraegung_t.humusgeh_ah >= 20
            AND
            bodeneinheit_auspraegung_t.humusgeh_ah < 30
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN '20.0 - 29.9%: sehr humusreich'
        WHEN
            bodeneinheit_auspraegung_t.humusgeh_ah >= 30
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN '>= 30.0%: organisch'
    END AS humusgeh_ah_text,
    humusform_wa_t.code AS humusform_wa,
    humusform_wa_t.beschreibung AS humusform_wa_beschreibung,
    CASE
        WHEN humusform_wa_t.code IN ('M', 'Mt', 'Mf')
            THEN 'Mull: Hohe biologische Aktivität mit vollständigem Streuabbau nach 1-2 Jahren. Über 8 cm mächtiger, gut strukturierter Oberboden. Günstiger Wasser-, Luft- und Nährstoffhaushalt.'
        WHEN humusform_wa_t.code IN ('Fm', 'Fa', 'Fr', 'Fl')
            THEN 'Moder: Wegen Säuregrad reduzierte biologische Aktivität. Verlangsamter, unvollständiger Streuabbau, daher organische Auflage. 4-8 cm mächtiger Oberboden. Saure, nährstoffarme Böden in krautarmen Laub- und Nadelwäldern.'
        WHEN humusform_wa_t.code IN ('L', 'La', 'Lr')
            THEN 'Rohhumus: Geringe biologische Aktivität. Gehemmter Streuabbau mit ausgeprägten Auflagehorizonten und geringmächtigem Oberboden. Stark saure, nährstoffarme Böden mit schwer abbaubarer Streu (Nadelwälder).'
        WHEN humusform_wa_t.code IN ('MHt', 'MHf')
            THEN 'Feuchtmull: Hohe biologische Aktivität mit vollständigem Streuabbau nach 1-2 Jahren. Über 8 cm mächtiger, gut strukturierter Oberboden. Trotz schwach vernässtem Boden günstiger Wasser-, Luft- und Nährstoffhaushalt.'
        WHEN humusform_wa_t.code IN ('FHm', 'FHa', 'FHr', 'FHl')
            THEN 'Feuchtmoder: Wegen Vernässung reduzierte biologische Aktivität. Verlangsamter, unvollständiger Streuabbau, daher organische Auflage. 4-8 cm mächtiger Oberboden.Vernässte, z.T. saure, nährstoffarme Böden.'
        WHEN humusform_wa_t.code IN ('Lha', 'LHr')
            THEN 'Feuchtrohhumus: Geringe biologische Aktivität. Gehemmter Streuabbau mit ausgeprägten Auflagehorizonten und geringmächtigem Oberboden.Vernässte, stark saure, nährstoffarme Böden mit schwer abbaubarer Streu (Nadelwälder).'
        WHEN humusform_wa_t.code = 'A'
            THEN 'Anmoor: Unvollständiger Streuabbau wegen häufigem Luftmangel. Der dunkle Horizont mit hohem Anteil an organischer Substanz ist strukturarm und schwach sauer bis alkalisch.'
        WHEN humusform_wa_t.code = 'T'
            THEN 'Torf: Anreicherung von kaum zersetzten Pflanzenrückständen, v.a. Torfmoose wegen dauernder Wassersättigung und stark sauren Bedingungen. Faserig, schwammig.'
    END AS humusform_wa_text,
    bodeneinheit_auspraegung_t.maechtigk_ahh,
    gefuegeform_t_ob.code AS gefuegeform_ob,
    gefuegeform_t_ob.beschreibung AS gefuegeform_ob_beschreibung,
    CASE
        WHEN
            gefuegeform_t_ob.code IN ('Kr', 'Sp')
            AND
            gefueggr_t_ob.code = '2'
                THEN 1
        WHEN
            (
                gefuegeform_t_ob.code IN ('Sp', 'Br')
                AND
                gefueggr_t_ob.code IN ('3', '4')
            )
            OR
            (
                gefuegeform_t_ob.code = 'Po'
                AND
                gefueggr_t_ob.code = '2'
            )
                THEN 2
        WHEN
            (
                gefuegeform_t_ob.code = 'Po'
                AND
                gefueggr_t_ob.code IN ('3', '4')
            )
            OR
            (
                gefuegeform_t_ob.code = 'Fr'
                AND
                gefueggr_t_ob.code IN ('2', '3')
            )
            OR
            (
                gefuegeform_t_ob.code = 'Sp'
                AND
                gefueggr_t_ob.code = '5'
            )
            OR
            (
                gefuegeform_t_ob.code = 'Klr'
                AND
                gefueggr_t_ob.code IN ('4', '3', '5')
            )
            OR
            (
                gefuegeform_t_ob.code = 'Br'
                AND
                gefueggr_t_ob.code IN ('2', '5')
            )
                THEN 3
        WHEN
            (
                gefuegeform_t_ob.code IN ('Po', 'Pl')
                AND
                gefueggr_t_ob.code IN ('5', '6')
            )
            OR
            ( 
                gefuegeform_t_ob.code = 'Fr'
                AND
                gefueggr_t_ob.code IN ('4', '5')
            )
            OR
            (
                gefuegeform_t_ob.code = 'Pr'
                AND
                gefueggr_t_ob.code IN ('4', '5', '6')
            )
            OR
            (
                gefuegeform_t_ob.code = 'Klr'
                AND
                gefueggr_t_ob.code IN ('6', '7')
            )
            OR
            (
                gefuegeform_t_ob.code = 'Klk'
                AND
                gefueggr_t_ob.code IN ('3', '4', '5', '6')
            )
                THEN 4
        WHEN
            gefuegeform_t_ob.code = 'Ko'
            OR
            gefuegeform_t_ob.code = 'Ek'
            OR
            (
                gefuegeform_t_ob.code = 'Gr'
                AND
                gefueggr_t_ob.code = '1'
            )
            OR
            (
                gefuegeform_t_ob.code IN ('Po', 'Pr', 'Klk',  'Pl')
                AND
                gefueggr_t_ob.code = '7'
            )
                THEN 5
    END AS gefuegeform_ob_int,
    gefuegeform_t_ub.code AS gefuegeform_ub,
    gefuegeform_t_ub.beschreibung AS gefuegeform_ub_beschreibung,
    gefueggr_t_ob.code AS gefueggr_ob,
    gefueggr_t_ob.beschreibung AS gefueggr_ob_beschreibung,
    gefueggr_t_ub.code AS gefueggr_ub,
    gefueggr_t_ub.beschreibung AS gefueggr_ub_beschreibung,
    bodeneinheit_auspraegung_t.pflngr,
    CASE
        WHEN
            bodeneinheit_auspraegung_t.pflngr = 0
            OR
            bodeneinheit_auspraegung_t.pflngr IS NULL
                THEN
                    CASE
                        WHEN
                            bodeneinheit_auspraegung_t.bodpktzahl > 0
                            AND
                            bodeneinheit_auspraegung_t.bodpktzahl <= 49
                                THEN 1
                        WHEN
                            bodeneinheit_auspraegung_t.bodpktzahl >= 50
                            AND
                            bodeneinheit_auspraegung_t.bodpktzahl <= 69
                                THEN 2
                        WHEN
                            bodeneinheit_auspraegung_t.bodpktzahl >= 70
                            AND
                            bodeneinheit_auspraegung_t.bodpktzahl <= 79
                                THEN 3
                        WHEN bodeneinheit_auspraegung_t.bodpktzahl >= 80
                            THEN 4
                        ELSE NULL::integer
                    END
        WHEN bodeneinheit_auspraegung_t.pflngr > 0
            THEN
                CASE
                    WHEN
                        bodeneinheit_auspraegung_t.pflngr > 0
                        AND
                        bodeneinheit_auspraegung_t.pflngr <= 29
                            THEN 1
                    WHEN
                        bodeneinheit_auspraegung_t.pflngr >= 30
                        AND
                        bodeneinheit_auspraegung_t.pflngr <= 49
                            THEN 2
                    WHEN
                        bodeneinheit_auspraegung_t.pflngr >= 50
                        AND
                        bodeneinheit_auspraegung_t.pflngr <= 69
                            THEN 3
                    WHEN bodeneinheit_auspraegung_t.pflngr >= 70
                        THEN 4
                    ELSE NULL::integer
                END
        ELSE NULL::integer
    END AS pflngr_qgis_int,
    CASE
        WHEN
            bodeneinheit_auspraegung_t.pflngr = 0
            OR
            bodeneinheit_auspraegung_t.pflngr IS NULL
                THEN
                    CASE
                        WHEN
                            bodeneinheit_auspraegung_t.bodpktzahl > 0
                            AND
                            bodeneinheit_auspraegung_t.bodpktzahl <= 49
                                THEN 'Geringe Durchwurzelungstiefe; schlechtes Speichervermögen für Nährstoffe und Wasser'
                        WHEN
                            bodeneinheit_auspraegung_t.bodpktzahl >= 50
                            AND
                            bodeneinheit_auspraegung_t.bodpktzahl <= 69
                                THEN 'Mässige Durchwurzelungstiefe; genügendes Speichervermögen für Nährstoffe und Wasser'
                        WHEN
                            bodeneinheit_auspraegung_t.bodpktzahl >= 70
                            AND
                            bodeneinheit_auspraegung_t.bodpktzahl <= 79
                                THEN 'Grosse Durchwurzelungstiefe; gutes Speichervermögen für Nährstoffe und Wasser'
                        WHEN bodeneinheit_auspraegung_t.bodpktzahl >= 80
                            THEN 'Sehr grosse Durchwurzelungstiefe; sehr gutes Speichervermögen für Nährstoffe und Wasser'
                    END
        WHEN bodeneinheit_auspraegung_t.pflngr > 0
            THEN
                CASE
                    WHEN
                        bodeneinheit_auspraegung_t.pflngr > 0
                        AND
                        bodeneinheit_auspraegung_t.pflngr <= 29
                            THEN 'Geringe Durchwurzelungstiefe; schlechtes Speichervermögen für Nährstoffe und Wasser'
                    WHEN
                        bodeneinheit_auspraegung_t.pflngr >= 30
                        AND
                        bodeneinheit_auspraegung_t.pflngr <= 49
                            THEN 'Mässige Durchwurzelungstiefe; genügendes Speichervermögen für Nährstoffe und Wasser'
                    WHEN
                        bodeneinheit_auspraegung_t.pflngr >= 50
                        AND
                        bodeneinheit_auspraegung_t.pflngr <= 69
                            THEN 'Grosse Durchwurzelungstiefe; gutes Speichervermögen für Nährstoffe und Wasser'
                    WHEN bodeneinheit_auspraegung_t.pflngr >= 70
                        THEN 'Sehr grosse Durchwurzelungstiefe; sehr gutes Speichervermögen für Nährstoffe und Wasser'
                END
    END AS pflngr_text,
    bodeneinheit_auspraegung_t.bodpktzahl,
    CASE
        WHEN bodeneinheit_auspraegung_t.bodpktzahl >= 90
            THEN 'Beste Bodeneigenschaften; Fruchtfolge ohne Einschränkungen'
        WHEN
            bodeneinheit_auspraegung_t.bodpktzahl >= 80
            AND
            bodeneinheit_auspraegung_t.bodpktzahl < 90
                THEN 'Sehr gute Fruchtfolgeböden; Hackfruchtanbau eingeschränkt'
        WHEN
            bodeneinheit_auspraegung_t.bodpktzahl >= 70
            AND
            bodeneinheit_auspraegung_t.bodpktzahl < 80
                THEN 'Gute Fruchtfolgeböden für getreidebetonte Fruchtfolge'
        WHEN
            bodeneinheit_auspraegung_t.bodpktzahl >= 50
            AND
            bodeneinheit_auspraegung_t.bodpktzahl < 70
                THEN 'Gute Futterbauböden; futterbaubetonte Fruchtfolge, Ackerbau stark eingeschränkt'
        WHEN
            bodeneinheit_auspraegung_t.bodpktzahl >= 35
            AND
            bodeneinheit_auspraegung_t.bodpktzahl < 50
                THEN 'Futterbaulich nutzbare Standorte'
        WHEN 
            bodeneinheit_auspraegung_t.bodpktzahl >= 20 
            AND 
            bodeneinheit_auspraegung_t.bodpktzahl < 35 
                THEN 'Extensive Bewirtschaftung angezeigt'
        WHEN
            bodeneinheit_auspraegung_t.bodpktzahl > 0
            AND 
            bodeneinheit_auspraegung_t.bodpktzahl < 20
                THEN 'Für die landwirtschaftliche Nutzung ungeeignet'
        WHEN
            bodeneinheit_auspraegung_t.bodpktzahl = 0
            OR
            bodeneinheit_auspraegung_t.bodpktzahl IS NULL
                THEN 'keine Information'
    END AS bodpktzahl_text,
    bodeneinheit_auspraegung_t.bemerkungen,
    bodeneinheit_onlinedata_t.los,
    bodeneinheit_onlinedata_t.kjahr AS kartierjahr,
    bodeneinheit_t.fk_kartierer AS kartierer,
    bodeneinheit_t.kartierquartal,
    bodeneinheit_onlinedata_t.is_wald,
    bodeneinheit_auspraegung_t.bindst_cd,
    bodeneinheit_auspraegung_t.bindst_zn,
    bodeneinheit_auspraegung_t.bindst_cu,
    bodeneinheit_auspraegung_t.bindst_pb,
    bodeneinheit_auspraegung_t.nfkapwe_ob,
    bodeneinheit_auspraegung_t.nfkapwe_ub,
    bodeneinheit_auspraegung_t.nfkapwe,
    CASE
        WHEN   
            bodeneinheit_auspraegung_t.nfkapwe < 50
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '< 50 mm'
        WHEN
            bodeneinheit_auspraegung_t.nfkapwe >= 50
            AND
            bodeneinheit_auspraegung_t.nfkapwe < 100
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '50 - 100 mm'
        WHEN
            bodeneinheit_auspraegung_t.nfkapwe >= 100
            AND
            bodeneinheit_auspraegung_t.nfkapwe < 150
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '100 - 150 mm'
        WHEN 
            bodeneinheit_auspraegung_t.nfkapwe >= 150
            AND
            bodeneinheit_auspraegung_t.nfkapwe < 200
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '150 - 200 mm'
        WHEN
            bodeneinheit_auspraegung_t.nfkapwe >= 200
            AND
            bodeneinheit_auspraegung_t.nfkapwe < 250
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '200 - 250 mm'
        WHEN
            bodeneinheit_auspraegung_t.nfkapwe >= 250
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN '>= 250 mm'
        WHEN
            bodeneinheit_auspraegung_t.nfkapwe < 50
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN '< 50 mm; sehr grosses Trockenstressrisiko'
        WHEN
            bodeneinheit_auspraegung_t.nfkapwe >= 50
            AND
            bodeneinheit_auspraegung_t.nfkapwe < 100
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN '50 - 99 mm; sehr grosses Trockenstressrisiko'
        WHEN
            bodeneinheit_auspraegung_t.nfkapwe >= 100
            AND
            bodeneinheit_auspraegung_t.nfkapwe < 150
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN '100 - 149 mm; grosses Trockenstressrisiko'
        WHEN
            bodeneinheit_auspraegung_t.nfkapwe >= 150
            AND
            bodeneinheit_auspraegung_t.nfkapwe < 200
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN '150 - 199 mm; mässiges Trockenstressrisiko'
        WHEN
            bodeneinheit_auspraegung_t.nfkapwe >= 200
            AND
            bodeneinheit_auspraegung_t.nfkapwe < 250
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN '200 - 249 mm; kleines Trockenstressrisiko'
        WHEN
            bodeneinheit_auspraegung_t.nfkapwe >= 250
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN '>= 250 mm; kein Trockenstressrisiko'
    END AS nfkapwe_text,
    bodeneinheit_auspraegung_t.verdempf,
    CASE
        WHEN
            bodeneinheit_auspraegung_t.verdempf = 1
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE 
                THEN 'wenig empfindlicher Unterboden: befahren mit üblicher Sorgfalt.'
        WHEN
            bodeneinheit_auspraegung_t.verdempf = 2
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'mässig empfindlicher Unterboden: nach Abtrocknungsphase gut mechanisch belastbar, weiter Rückegassenabstand empfohlen'
        WHEN
            bodeneinheit_auspraegung_t.verdempf = 3
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'empfindlicher Unterboden: erhöhte Sorgfalt beim Befahren notwendig, Trockenperioden optimal nutzen, sehr weiter Rückegassenabstand empfohlen'
        WHEN
            bodeneinheit_auspraegung_t.verdempf = 4
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'stark empfindlicher Unterboden: nur eingeschränkt mechanisch belastbar, längere Trockenperioden abwarten, ergänzende lastverteilende Massnahmen ergreifen, sehr weiter Rückegassenabstand empfohlen'
        WHEN
            bodeneinheit_auspraegung_t.verdempf = 5
            AND
            bodeneinheit_onlinedata_t.is_wald IS TRUE
                THEN 'extrem empfindlicher Unterboden: bereits geringe Auflasten können irreversible Schäden verursachen, befahren vermeiden, falls dennoch nötig: nur mit lastverteilenden und lastreduzierenden Massnahmen und erst nach längeren Trockenperioden.'
        WHEN
            bodeneinheit_auspraegung_t.verdempf = 1
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'wenig empfindlicher Unterboden: Bearbeitung mit üblicher Sorgfalt.'
        WHEN
            bodeneinheit_auspraegung_t.verdempf = 2
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'mässig empfindlicher Unterboden: nach Abtrocknungsphase gut mechanisch belastbar.'
        WHEN
            bodeneinheit_auspraegung_t.verdempf = 3
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'empfindlicher Unterboden: erhöhte Sorgfalt beim Befahren und Feldarbeiten notwendig, Trockenperioden sind optimal zu nutzen.'
        WHEN
            bodeneinheit_auspraegung_t.verdempf = 4
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'stark empfindlicher Unterboden: nur eingeschränkt mechanisch belastbar, längere Trockenperioden abwarten, ergänzende lastreduzierende und lastverteilende Massnahmen ergreifen.'
        WHEN
            bodeneinheit_auspraegung_t.verdempf = 5
            AND
            bodeneinheit_onlinedata_t.is_wald IS FALSE
                THEN 'extrem empfindlicher Unterboden: möglichst Verzicht auf ackerbauliche Nutzung, bereits geringe Auflasten können irreversible Schäden verursachen.'
    END AS verdempf_text,
    bodeneinheit_auspraegung_t.drain_wel,
    bodeneinheit_auspraegung_t.wassastoss,
    bodeneinheit_auspraegung_t.is_hauptauspraegung,
    bodeneinheit_auspraegung_t.gewichtung_auspraegung,
    bodeneinheit_onlinedata_t.geom AS geometrie
FROM
    afu_isboden.bodeneinheit_onlinedata_t
    LEFT JOIN afu_isboden.bodeneinheit_t
        ON bodeneinheit_onlinedata_t.objnr = bodeneinheit_t.objnr
    LEFT JOIN charakter_wasserhaushalt
        ON charakter_wasserhaushalt.t_id = bodeneinheit_onlinedata_t.pk_isboden
    LEFT JOIN afu_isboden.bodeneinheit_auspraegung_t
        ON 
            bodeneinheit_auspraegung_t.fk_bodeneinheit = bodeneinheit_t.pk_ogc_fid
            AND
            bodeneinheit_auspraegung_t.is_hauptauspraegung
    LEFT JOIN afu_isboden.wasserhhgr_t
        ON wasserhhgr_t.pk_wasserhhgr = bodeneinheit_auspraegung_t.fk_wasserhhgr
    LEFT JOIN afu_isboden.bodentyp_t
        ON bodentyp_t.pk_bodentyp = bodeneinheit_auspraegung_t.fk_bodentyp
    LEFT JOIN afu_isboden.begelfor_t
        ON begelfor_t.pk_begelfor = bodeneinheit_auspraegung_t.fk_begelfor
    LEFT JOIN afu_isboden.skelett_t AS skelett_t_ob
        ON skelett_t_ob.pk_skelett = bodeneinheit_auspraegung_t.fk_skelett_ob
    LEFT JOIN afu_isboden.skelett_t AS skelett_t_ub
        ON skelett_t_ub.pk_skelett = bodeneinheit_auspraegung_t.fk_skelett_ub
    LEFT JOIN afu_isboden.koernkl_t AS koernkl_t_ob
        ON koernkl_t_ob.pk_koernkl = bodeneinheit_auspraegung_t.fk_koernkl_ob
    LEFT JOIN afu_isboden.koernkl_t AS koernkl_t_ub
        ON koernkl_t_ub.pk_koernkl = bodeneinheit_auspraegung_t.fk_koernkl_ub
    LEFT JOIN afu_isboden.kalkgehalt_t AS kalkgehalt_t_ob
        ON kalkgehalt_t_ob.pk_kalkgehalt = bodeneinheit_auspraegung_t.fk_kalkgehalt_ob
    LEFT JOIN afu_isboden.kalkgehalt_t AS kalkgehalt_t_ub
        ON kalkgehalt_t_ub.pk_kalkgehalt = bodeneinheit_auspraegung_t.fk_kalkgehalt_ub
    LEFT JOIN afu_isboden.humusform_wa_t
        ON humusform_wa_t.pk_humusform_wa = bodeneinheit_auspraegung_t.fk_humusform_wa
    LEFT JOIN afu_isboden.gefuegeform_t AS gefuegeform_t_ob
        ON gefuegeform_t_ob.pk_gefuegeform = bodeneinheit_auspraegung_t.fk_gefuegeform_ob
    LEFT JOIN afu_isboden.gefuegeform_t AS gefuegeform_t_ub
        ON gefuegeform_t_ub.pk_gefuegeform = bodeneinheit_auspraegung_t.fk_gefuegeform_ub
    LEFT JOIN afu_isboden.gefueggr_t AS gefueggr_t_ob
        ON gefueggr_t_ob.pk_gefueggr = bodeneinheit_auspraegung_t.fk_gefueggr_ob
    LEFT JOIN afu_isboden.gefueggr_t AS gefueggr_t_ub
        ON gefueggr_t_ub.pk_gefueggr = bodeneinheit_auspraegung_t.fk_gefueggr_ub
    LEFT JOIN
        (
            SELECT
                zw_bodeneinheit_untertyp_t.fk_bodeneinheit,
                (
                    SELECT
                        afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'E') AS filter_array
                ) AS untertyp_e,
                (
                    SELECT
                        afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'K') AS filter_array
                ) AS untertyp_k,
                (
                    SELECT
                        afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'I') AS filter_array
                ) AS untertyp_i,
                (
                    SELECT
                        afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'G') AS filter_array
                ) AS untertyp_g,
                (
                    SELECT
                        afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'R') AS filter_array
                ) AS untertyp_r,
                (
                    SELECT
                        afu_isboden.filter_array(array_agg(untertyp_t.code)::text[], 'P') AS filter_array
                ) AS untertyp_p,
                CASE
                    WHEN regexp_replace(regexp_replace(regexp_replace(regexp_replace(array_agg(untertyp_t.code)::text, '({|})'::text, ''::text, 'g'::text), '(E|K|I|G|R|P).'::text, ''::text, 'g'::text), '( ,|^,)'::text, ''::text, 'g'::text), '( |^,)'::text, ''::text, 'g'::text) = ''::text 
                        THEN NULL::text
                    ELSE regexp_replace(string_agg(untertyp_t.code,', ')::text, '(E|K|I|G|R|P).(,|})'::text, ''::text, 'g'::text)
                END AS untertyp_div
            FROM
                afu_isboden.zw_bodeneinheit_untertyp AS zw_bodeneinheit_untertyp_t
                LEFT JOIN afu_isboden.untertyp_t
                    ON untertyp_t.pk_untertyp = zw_bodeneinheit_untertyp_t.fk_untertyp
            GROUP BY
                zw_bodeneinheit_untertyp_t.fk_bodeneinheit
        ) AS untertyp
        ON untertyp.fk_bodeneinheit = bodeneinheit_auspraegung_t.pk_bodeneinheit
WHERE
    bodeneinheit_onlinedata_t.archive = 0
    AND
    bodeneinheit_onlinedata_t.is_haupt
    AND
    bodeneinheit_auspraegung_t.is_hauptauspraegung
    AND
    bodeneinheit_onlinedata_t.gemnr = bodeneinheit_t.gemnr
    AND
    bodeneinheit_t.archive = 0
    AND
    bodeneinheit_t.los = bodeneinheit_onlinedata_t.los
; 
