SELECT
    pk_ogc_fid AS t_id,
    gemnr,
    objnr,
    wasserhhgr,
    wasserhhgr_beschreibung,
    wasserhhgr_qgis_txt,
    CASE
        WHEN 
            is_wald IS TRUE
            AND 
            (
                wasserhhgr IN ('a', 'b', 'f', 'k','s')
                OR
                (
                    wasserhhgr ='o' 
                    AND 
                    pflngr >=70
                )
            )
            THEN 'tiefgründiger Boden, d.h. pflanzennutzbare Gründigkeit > 70 cm'
        WHEN
            is_wald IS TRUE  
            AND
            (
                wasserhhgr  IN ('c', 'd', 'g', 'h', 'l', 'm', 'q', 't', 'v', 'x')
                OR 
                (
                    (
                        wasserhhgr ='o' 
                        AND 
                        (
                            pflngr < 70 
                            OR 
                            pflngr IS NULL
                        )
                    ) 
                    OR 
                    ( 
                        wasserhhgr ='p' 
                        AND 
                        pflngr >= 30
                    )
                    OR 
                    ( 
                        wasserhhgr ='u' 
                        AND 
                        pflngr >= 30
                    ) 
                    OR
                    (  
                        wasserhhgr='w' 
                        AND  
                        pflngr >= 30
                    )
                )
            )
            THEN 'mittelgründiger Boden, d.h. pflanzennutzbare Gründigkeit 30 - 70 cm'
        WHEN
            is_wald IS TRUE
            AND 
            (
                wasserhhgr IN ('e', 'i', 'n') 
                OR 
                (
                    wasserhhgr ='p' 
                    AND 
                    (
                        pflngr < 30 
                        OR 
                        pflngr IS NULL
                    )
                ) 
                OR 
                wasserhhgr ='r'
            ) 
            OR
            (
                (
                    wasserhhgr ='u' 
                    AND 
                    pflngr < 30
                ) 
                OR 
                ( 
                    wasserhhgr ='w' 
                    AND 
                    (
                        pflngr <30 
                        OR 
                        pflngr IS NULL
                    )
                ) 
                OR  
                wasserhhgr IN ('y', 'z')
            )
            THEN 'flachgründiger Boden, d.h. pflanzennutzbare Gründigkeit < 30 cm'
    END AS wasserhhgr_qgis_wald_txt,
    bodentyp,
    bodentyp_beschreibung,
    gelform,
    CASE 
        WHEN gelform IN ('a', 'b', 'c', 'd', 'e')
            THEN '0-10%: Keine Einschränkung'
        WHEN gelform IN ('f', 'g', 'h', 'i')
            THEN '10-15%: Hackfruchtanbau und Vollerntemaschine möglich'
        WHEN gelform IN ('j', 'k', 'l', 'm', 'n')
            THEN '10-15%: Hackfruchtanbau stark erschwert, Getreidebau erschwert; Mähdrescher möglich, evtl. Hangmähdrescher'
        WHEN gelform IN ('o', 'p', 'q', 'r')
            THEN '25-35%: Getreideanbau stark eingeschränkt, Hangmähdrescher; Hangtraktoren.'
        WHEN gelform IN ('s', 't', 'u', 'v', 'w', 'x', 'y', 'z')
            THEN '>35%: nur Hähwiese und Weide möglich; spezialisierte Hangmechanisierung'
    END AS gelform_txt,
    gelform_beschreibung,
    geologie,
    untertyp_e,
    untertyp_k,
    untertyp_i,
    untertyp_g,
    untertyp_r,
    untertyp_p,
    untertyp_div,
    skelett_ob,
    CASE 
        WHEN skelett_ob = 0
            THEN 'Keine oder nur wenige Steine (0-5%)'
        WHEN skelett_ob = 1
            THEN 'mässig viele Steine (5-10%)'
        WHEN skelett_ob IN (2, 3)
            THEN 'viele Steine (10-20%)'
        WHEN skelett_ob IN (4, 5)
            THEN 'sehr viele Steine (20-30%)'
        WHEN skelett_ob IN (6, 7)
            THEN 'extrem viele Steine (>30%)'
    END AS skelett_ob_txt,
    skelett_ob_beschreibung,
    skelett_ub,
    NULL AS skelett_ub_txt,
    skelett_ub_beschreibung,
    koernkl_ob,
    CASE 
        WHEN koernkl_ob IN (1, 2, 3, 4)
            THEN 'Leichte, sandige Böden: leicht bearbeitbar, trocknen leicht ab.'
        WHEN koernkl_ob IN (5, 6, 10, 11, 12)
            THEN 'Mittelschwere, lehmige bis schluffige Böden: normal bearbeitbar, trocknen mässig schnell ab.'
        WHEN koernkl_ob IN (7, 8, 9, 13)
            THEN 'Schwere, tonige Böden: schwer bearbeitbar, trocknen sehr langsam ab.'
    END AS koernkl_ob_txt,
    koernkl_ob_beschreibung,
    koernkl_ub,
    koernkl_ub_beschreibung,
    ton_ob,
    ton_ub,
    schluff_ob,
    schluff_ub,
    karbgrenze,
    kalkgeh_ob,
    kalkgeh_ob_beschreibung,
    kalkgeh_ub,
    kalkgeh_ub_beschreibung,
    ph_ob,
    ph_ob_qgis_txt,
    ph_ub,
    ph_ub_qgis_txt,
    maechtigk_ah,
    humusgeh_ah,
    humusgeh_ah_qgis_txt,
    humusform_wa,
    humusform_wa_beschreibung,
    humusform_wa_qgis_txt,
    maechtigk_ahh,
    gefuegeform_ob,
    gefuegeform_ob_beschreibung,
    gefuegeform_t_ob_qgis_int,
    gefuegeform_ub,
    gefuegeform_ub_beschreibung,
    gefueggr_ob,
    gefueggr_ob_beschreibung,
    gefueggr_ub,
    gefueggr_ub_beschreibung,
    pflngr,
    pflngr_qgis_int,
    CASE 
        WHEN pflngr_qgis_int = 1
            THEN 'Geringe Durchwurzelungstiefe; schlechtes Speichervermögen für Nährstoffe und Wasser'
        WHEN pflngr_qgis_int = 2
            THEN 'Mässige Durchwurzelungstiefe; genügendes Speichervermögen für Nährstoffe und Wasser'
        WHEN pflngr_qgis_int = 3
            THEN 'Grosse Durchwurzelungstiefe; gutes Speichervermögen für Nährstoffe und Wasser'
        WHEN pflngr_qgis_int = 4 
            THEN 'Sehr grosse Durchwurzelungstiefe; sehr gutes Speichervermögen für Nährstoffe und Wasser'
    END AS pflngr_qgis_int_txt,
    bodpktzahl,
    bodpktzahl_qgis_txt,
    bemerkungen,
    los,
    kartierjahr,
    kartierer,
    kartierquartal,
    is_wald,
    bindst_cd,
    bindst_zn,
    bindst_cu,
    bindst_pb,
    nfkapwe_ob,
    nfkapwe_ub,
    nfkapwe,
    nfkapwe_qgis_txt,
    verdempf,
    CASE 
        WHEN verdempf = 1 
            THEN 'wenig empfindlicher Unterboden: Bearbeitung mit üblicher Sorgfalt.'
        WHEN verdempf = 2
            THEN 'mässig empfindlicher Unterboden: nach Abtrocknungsphase, gut mechanisch belastbar.'
        WHEN verdempf = 3
            THEN 'empfindlicher Unterboden: erhöhte Sorgfalt beim Befahren und Feldarbeiten notwendig, Trockenperioden sind optimal zu nutzen.'
        WHEN verdempf = 4
            THEN 'stark empfindlicher Unterboden: nur eingeschränkt mechanisch belastbar, längere Trockenperioden abwarten, ergänzende lastreduzierende und lastverteilende Massnahmen ergreifen.'
        WHEN verdempf = 5
            THEN 'extrem empfindlicher Unterboden: möglichst Verzicht auf ackerbauliche Nutzung, bereits geringe Auflasten können irreversible Schäden verursachen.'
    END AS verdempf_txt,
    drain_wel,
    wassastoss,
    is_hauptauspraegung,
    gewichtung_auspraegung,
    wkb_geometry AS geometrie
FROM
    afu_isboden.bodeneinheit_lw_qgis_server_client_t
WHERE
    archive = 0
    
UNION ALL

SELECT
    pk_ogc_fid AS t_id,
    gemnr,
    objnr,
    wasserhhgr,
    wasserhhgr_beschreibung,
    wasserhhgr_qgis_txt,
    CASE
        WHEN 
            is_wald IS TRUE
            AND 
            (
                wasserhhgr IN ('a', 'b', 'f', 'k','s')
                OR
                (
                    wasserhhgr ='o' 
                    AND 
                    pflngr >=70
                )
            )
            THEN 'tiefgründiger Boden, d.h. pflanzennutzbare Gründigkeit > 70 cm'
        WHEN
            is_wald IS TRUE  
            AND
            (
                wasserhhgr  IN ('c', 'd', 'g', 'h', 'l', 'm', 'q', 't', 'v', 'x')
                OR 
                (
                    (
                        wasserhhgr ='o' 
                        AND 
                        (
                            pflngr < 70 
                            OR 
                            pflngr IS NULL
                        )
                    ) 
                    OR 
                    ( 
                        wasserhhgr ='p' 
                        AND 
                        pflngr >= 30
                    )
                    OR 
                    ( 
                        wasserhhgr ='u' 
                        AND 
                        pflngr >= 30
                    ) 
                    OR
                    (  
                        wasserhhgr='w' 
                        AND  
                        pflngr >= 30
                    )
                )
            )
            THEN 'mittelgründiger Boden, d.h. pflanzennutzbare Gründigkeit 30 - 70 cm'
        WHEN
            is_wald IS TRUE
            AND 
            (
                wasserhhgr IN ('e', 'i', 'n') 
                OR 
                (
                    wasserhhgr ='p' 
                    AND 
                    (
                        pflngr < 30 
                        OR 
                        pflngr IS NULL
                    )
                ) 
                OR 
                wasserhhgr ='r'
            ) 
            OR
            (
                (
                    wasserhhgr ='u' 
                    AND 
                    pflngr < 30
                ) 
                OR 
                ( 
                    wasserhhgr ='w' 
                    AND 
                    (
                        pflngr <30 
                        OR 
                        pflngr IS NULL
                    )
                ) 
                OR  
                wasserhhgr IN ('y', 'z')
            )
            THEN 'flachgründiger Boden, d.h. pflanzennutzbare Gründigkeit < 30 cm'
    END AS wasserhhgr_qgis_wald_txt,
    bodentyp,
    bodentyp_beschreibung,
    gelform,
    NULL AS gelform_txt,
    gelform_beschreibung,
    geologie,
    untertyp_e,
    untertyp_k,
    untertyp_i,
    untertyp_g,
    untertyp_r,
    untertyp_p,
    untertyp_div,
    skelett_ob,
    CASE 
        WHEN skelett_ob = 0
            THEN 'Keine oder nur wenige Steine (0-5%)'
        WHEN skelett_ob = 1
            THEN 'mässig viele Steine (5-10%)'
        WHEN skelett_ob IN (2, 3)
            THEN 'viele Steine (10-20%)'
        WHEN skelett_ob IN (4, 5)
            THEN 'sehr viele Steine (20-30%)'
        WHEN skelett_ob IN (6, 7)
            THEN 'extrem viele Steine (>30%)'
    END AS skelett_ob_txt,
    skelett_ob_beschreibung,
    skelett_ub,
    CASE 
        WHEN skelett_ub = 0
            THEN 'Keine oder nur wenige Steine (0-5%)'
        WHEN skelett_ub = 1
            THEN 'mässig viele Steine (5-10%)'
        WHEN skelett_ub IN (2, 3)
            THEN 'viele Steine (10-20%)'
        WHEN skelett_ub IN (4, 5)
            THEN 'sehr viele Steine (20-30%)'
        WHEN skelett_ub IN (6, 7)
            THEN 'extrem viele Steine (>30%)'
    END AS skelett_ub_txt,
    skelett_ub_beschreibung,
    koernkl_ob,
    CASE
        WHEN koernkl_ob IN (1, 2, 3, 4)
            THEN 'Leichte, sandige Böden: leicht bearbeitbar, trocknen schnell ab.'
        WHEN koernkl_ob IN (5, 6, 10, 11, 12)
            THEN 'Mittelschwere, lehmige bis schluffige Böden: normal bearbeitbar, trocknen mässig schnell ab.'
        WHEN koernkl_ob IN (7, 8, 9, 13)
            THEN 'Schwere, tonige Böden: schwer bearbeitbar, trocknen sehr langsam ab.'
    END AS koernkl_ob_txt,
    koernkl_ob_beschreibung,
    koernkl_ub,
    koernkl_ub_beschreibung,
    ton_ob,
    ton_ub,
    schluff_ob,
    schluff_ub,
    karbgrenze,
    kalkgeh_ob,
    kalkgeh_ob_beschreibung,
    kalkgeh_ub,
    kalkgeh_ub_beschreibung,
    ph_ob,
    ph_ob_qgis_txt,
    ph_ub,
    ph_ub_qgis_txt,
    maechtigk_ah,
    humusgeh_ah,
    humusgeh_ah_qgis_txt,
    humusform_wa,
    humusform_wa_beschreibung,
    humusform_wa_qgis_txt,
    maechtigk_ahh,
    gefuegeform_ob,
    gefuegeform_ob_beschreibung,
    gefuegeform_t_ob_qgis_int,
    gefuegeform_ub,
    gefuegeform_ub_beschreibung,
    gefueggr_ob,
    gefueggr_ob_beschreibung,
    gefueggr_ub,
    gefueggr_ub_beschreibung,
    pflngr,
    pflngr_qgis_int,
    NULL AS pflngr_qgis_int_txt,
    bodpktzahl,
    bodpktzahl_qgis_txt,
    bemerkungen,
    los,
    kartierjahr,
    kartierer,
    kartierquartal,
    is_wald,
    bindst_cd,
    bindst_zn,
    bindst_cu,
    bindst_pb,
    nfkapwe_ob,
    nfkapwe_ub,
    nfkapwe,
    nfkapwe_qgis_txt,
    verdempf,
    CASE
        WHEN verdempf = 1
            THEN 'wenig empfindlicher Unterboden: Bearbeitung mit üblicher Sorgfalt.'
        WHEN verdempf = 2
            THEN 'mässig empfindlicher Unterboden: nach Abtrocknungsphase, gut mechanisch belastbar, Rückegassenabstand 30 m oder mehr empfohlen.'
        WHEN verdempf = 3
            THEN 'empfindlicher Unterboden: erhöhte Sorgfalt beim Befahren und Feldarbeiten notwendig, Trockenperioden sind optimal zu nutzen, Rückegassenabstand 50 m oder mehr empfohlen.'
        WHEN verdempf = 4
            THEN 'stark empfindlicher Unterboden: nur eingeschränkt mechanisch belastbar, längere Trockenperioden abwarten, ergänzende lastreduzierende und lastverteilende Massnahmen ergreifen, Rückegassenabstand 50 m oder mehr empfohlen.'
        WHEN verdempf = 5
            THEN 'extrem empfindlicher Unterboden: möglichst Verzicht auf ackerbauliche Nutzung, bereits geringe Auflasten können irreversible Schäden verursachen, befahren vermeiden, falls dennoch nötig: nur mit lastverteilenden und lastreduzierenden Massnahmen und erst nach längeren Trockenperioden.'
    END AS verdempf_txt,
    drain_wel,
    wassastoss,
    is_hauptauspraegung,
    gewichtung_auspraegung,
    wkb_geometry AS geometrie
FROM
    afu_isboden.bodeneinheit_wald_qgis_server_client_t
WHERE 
    archive = 0
;