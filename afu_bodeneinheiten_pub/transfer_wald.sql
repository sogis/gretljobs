-- Transfer der Hauptausprägungen Wald
-- Quelle: afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_wald
-- Ziel:   afu_bodeneinheiten_pub_v1.bodeneinheit_wald
--
-- Es werden ausschliesslich Hauptausprägungen transferiert.
-- Nebenausprägungen werden bewusst NICHT berücksichtigt.
--
-- Diverse Ableitungen (z.B. Wasserhaushalt, Bodenbearbeitbarkeit, pH-Text,
-- Humusgehalt-Text, Humusform-Beschreibung, Bodenpunktzahl-Text) wurden
-- anhand des gelieferten Referenz-SQL-Skripts nachgebildet.

WITH untertypen_k AS (
SELECT 
    bodeneinheitwaldassociation_k AS bodeneinheit_id, 
    string_agg(acode, ', ' ORDER BY acode) AS codes 
FROM 
    afu_bodeneinheiten_v1.untertyp_k_hauptwald 
WHERE 
    acode IS NOT NULL 
GROUP BY 
    bodeneinheitwaldassociation_k
), 
untertypen_p AS (
SELECT 
    bodeneinheitwaldassociation_p AS bodeneinheit_id, 
    string_agg(acode, ', ' ORDER BY acode) AS codes 
FROM 
    afu_bodeneinheiten_v1.untertyp_p_hauptwald 
WHERE 
    acode IS NOT NULL 
GROUP BY 
    bodeneinheitwaldassociation_p
), 
untertypen_div AS (
SELECT 
    bodeneinheitwaldassociation_diverse AS bodeneinheit_id, 
    string_agg(acode, ', ' ORDER BY acode) AS codes 
FROM 
    afu_bodeneinheiten_v1.untertyp_diverse_hauptwald 
WHERE 
    acode IS NOT NULL 
GROUP BY 
    bodeneinheitwaldassociation_diverse
)
INSERT INTO 
    afu_bodeneinheiten_pub_v1.bodeneinheit_wald (
    migriert,
    bodeneinheit_nummer,
    skelettgehalt_unterboden,
    skelettgehalt_unterboden_txt,
    skelettgehalt_unterboden_beschreibung,
    skelettgehalt_oberboden,
    skelettgehalt_oberboden_txt,
    skelettgehalt_oberboden_beschreibung,
    humusform_wald,
    humusform_wald_txt,
    humusform_wald_beschreibung,
    maechtigkeit_ahh,
    gemeinde_bfs_nr,
    wasserhaushalt,
    wasserhaushalt_txt,
    wasserhaushalt_charakter,
    wasserhaushalt_spezifisch,
    wasserhaushalt_uebergreifend,
    bodentyp,
    bodentyp_txt,
    gelaendeform,
    gelaendeform_txt,
    gelaendeform_beschreibung,
    geologie,
    koernungsklasse_oberboden,
    koernungsklasse_oberboden_txt,
    koernungsklasse_unterboden,
    koernungsklasse_unterboden_txt,
    bodenart_bodenbearbeitbarkeit,
    tongehalt_oberboden,
    tongehalt_unterboden,
    schluffgehalt_oberboden,
    schluffgehalt_unterboden,
    karbonatgrenze,
    kalkgehalt_oberboden,
    kalkgehalt_oberboden_txt,
    kalkgehalt_unterboden,
    kalkgehalt_unterboden_txt,
    ph_oberboden,
    ph_oberboden_beschreibung,
    ph_unterboden,
    ph_unterboden_beschreibung,
    maechtigkeit_ah,
    humusgehalt_ah,
    humusgehalt_ah_beschreibung,
    gefuegeform_unterboden,
    gefuegeform_unterboden_txt,
    gefuegeform_oberboden,
    gefuegeform_oberboden_txt,
    gefuegegroesse_unterboden,
    gefuegegroesse_unterboden_txt,
    gefuegegroesse_oberboden,
    gefuegegroesse_oberboden_txt,
    pflanzennutzbaregruendigkeit,
    pflanzennutzbaregruendigkeit_beschreibung,
    bodenpunktzahl,
    bodenpunktzahl_beschreibung,
    bemerkung,
    los,
    kartierjahr,
    kartierteam,
    kartierquartal,
    bindungsstaerke_cadmium,
    bindungsstaerke_zink,
    bindungsstaerke_kupfer,
    bindungsstaerke_blei,
    wurzelraum_feldkapazitaet_unterboden,
    wurzelraum_feldkapazitaet_oberboden,
    wurzelraum_feldkapazitaet,
    wurzelraum_feldkapazitaet_beschreibung,
    verdichtungsempfindlichkeit,
    verdichtungsempfindlichkeit_beschreibung,
    untertypen,
    gemeindenummer_bfs_aktuell,
    geometrie
)
SELECT 
    true,
    src.bodeneinheit_nummer,
    src.unterboden0_skelettgehalt_unterboden,
    CASE
        WHEN src.unterboden0_skelettgehalt_unterboden = 'skelettfrei'
            THEN 'keine oder nur wenige Steine (0-5%)'
        WHEN src.unterboden0_skelettgehalt_unterboden = 'schwach_skeletthaltig'
            THEN 'mässig viele Steine (5-10%)'
        WHEN src.unterboden0_skelettgehalt_unterboden IN ('skeletthaltig')
            THEN 'viele Steine (10-20%)'
        WHEN src.unterboden0_skelettgehalt_unterboden IN ('stark_skeletthaltig')
            THEN 'sehr viele Steine (20-30%)'
        WHEN src.unterboden0_skelettgehalt_unterboden IN ('skelettreich','kies')
            THEN 'extrem viele Steine (> 30%)'
    END AS skelettgehalt_unterboden_txt,
    sgu.dispname AS skelettgehalt_unterboden_beschreibung,
    src.oberboden0_skelettgehalt_oberboden,
    CASE
        WHEN src.oberboden0_skelettgehalt_oberboden = 'skelettfrei'
            THEN 'keine oder nur wenige Steine (0-5%)'
        WHEN src.oberboden0_skelettgehalt_oberboden = 'schwach_skeletthaltig'
            THEN 'mässig viele Steine (5-10%)'
        WHEN src.oberboden0_skelettgehalt_oberboden IN ('skeletthaltig')
            THEN 'viele Steine (10-20%)'
        WHEN src.oberboden0_skelettgehalt_oberboden IN ('stark_skeletthaltig')
            THEN 'sehr viele Steine (20-30%)'
        WHEN src.oberboden0_skelettgehalt_oberboden IN ('skelettreich','kies')
            THEN 'extrem viele Steine (> 30%)'
    END AS skelettgehalt_oberboden_txt,
    sgo.dispname AS skelettgehalt_oberboden_beschreibung,
    src.humusform_wald,
    CASE 
        WHEN src.humusform_wald IN ('M', 'Mt', 'Mf')
            THEN 'Mull: Hohe biologische Aktivität mit vollständigem Streuabbau nach 1-2 Jahren. Über 8 cm mächtiger, gut strukturierter Oberboden. Günstiger Wasser-, Luft- und Nährstoffhaushalt.'
        WHEN src.humusform_wald IN ('Fm', 'Fa', 'Fr', 'Fl')
            THEN 'Moder: Wegen Säuregrad reduzierte biologische Aktivität. Verlangsamter, unvollständiger Streuabbau, daher organische Auflage. 4-8 cm mächtiger Oberboden. Saure, nährstoffarme Böden in krautarmen Laub- und Nadelwäldern.'
        WHEN src.humusform_wald IN ('L', 'La', 'Lr')
            THEN 'Rohhumus: Geringe biologische Aktivität. Gehemmter Streuabbau mit ausgeprägten Auflagehorizonten und geringmächtigem Oberboden. Stark saure, nährstoffarme Böden mit schwer abbaubarer Streu (Nadelwälder).'
        WHEN src.humusform_wald IN ('MHt', 'MHf')
            THEN 'Feuchtmull: Hohe biologische Aktivität mit vollständigem Streuabbau nach 1-2 Jahren. Über 8 cm mächtiger, gut strukturierter Oberboden. Trotz schwach vernässtem Boden günstiger Wasser-, Luft- und Nährstoffhaushalt.'
        WHEN src.humusform_wald IN ('FHm', 'FHa', 'FHr', 'FHl')
            THEN 'Feuchtmoder: Wegen Vernässung reduzierte biologische Aktivität. Verlangsamter, unvollständiger Streuabbau, daher organische Auflage. 4-8 cm mächtiger Oberboden.Vernässte, z.T. saure, nährstoffarme Böden.'
        WHEN src.humusform_wald IN ('Lha', 'LHr')
            THEN 'Feuchtrohhumus: Geringe biologische Aktivität. Gehemmter Streuabbau mit ausgeprägten Auflagehorizonten und geringmächtigem Oberboden.Vernässte, stark saure, nährstoffarme Böden mit schwer abbaubarer Streu (Nadelwälder).'
        WHEN src.humusform_wald = 'A'
            THEN 'Anmoor: Unvollständiger Streuabbau wegen häufigem Luftmangel. Der dunkle Horizont mit hohem Anteil an organischer Substanz ist strukturarm und schwach sauer bis alkalisch.'
        WHEN src.humusform_wald = 'T'
            THEN 'Torf: Anreicherung von kaum zersetzten Pflanzenrückständen, v.a. Torfmoose wegen dauernder Wassersättigung und stark sauren Bedingungen. Faserig, schwammig.'
        ELSE hfw.description::varchar(50)
    END AS humusform_wald_txt,
    hfw.dispname AS humusform_wald_beschreibung,
    src.maechtigkeit_ahh AS maechtigkeit_ahh,
    src.gemeinde_nr AS gemeinde_bfs_nr,
    src.wasserhaushalt,
    wh.dispname AS wasserhaushalt_txt,
    concat_ws(
        ', ',
        CASE 
            WHEN 
                (
                    src.wasserhaushalt IN ('a', 'b', 'f', 'k', 's')
                    OR (
                        src.wasserhaushalt = 'o'
                        AND src.pflanzennutzbaregruendigkeit >= 70
                    )
                )
                THEN 'tiefgründiger Boden, d.h. pflanzennutzbare Gründigkeit > 70 cm'
            WHEN 
                (
                    src.wasserhaushalt IN ('c', 'd', 'g', 'h', 'l', 'm', 'q', 't', 'v', 'x')
                    OR (
                        src.wasserhaushalt = 'o'
                        AND (
                            src.pflanzennutzbaregruendigkeit < 70
                            OR src.pflanzennutzbaregruendigkeit IS NULL
                        )
                    )
                    OR (
                        src.wasserhaushalt = 'p'
                        AND src.pflanzennutzbaregruendigkeit >= 30
                    )
                    OR (
                        src.wasserhaushalt = 'u'
                        AND src.pflanzennutzbaregruendigkeit >= 30
                    )
                    OR (
                        src.wasserhaushalt = 'w'
                        AND src.pflanzennutzbaregruendigkeit >= 30
                    )
                )
                THEN 'mittelgründiger Boden, d.h. pflanzennutzbare Gründigkeit 30 - 70 cm'
            WHEN 
                (
                    src.wasserhaushalt IN ('e', 'i', 'n', 'r')
                    OR (
                        src.wasserhaushalt = 'p'
                        AND (
                            src.pflanzennutzbaregruendigkeit < 30
                            OR src.pflanzennutzbaregruendigkeit IS NULL
                        )
                    )
                    OR (
                        src.wasserhaushalt = 'u'
                        AND src.pflanzennutzbaregruendigkeit < 30
                    )
                    OR (
                        src.wasserhaushalt = 'w'
                        AND (
                            src.pflanzennutzbaregruendigkeit < 30
                            OR src.pflanzennutzbaregruendigkeit IS NULL
                        )
                    )
                    OR src.wasserhaushalt IN ('y', 'z')
                )
                THEN 'flachgründiger Boden, d.h. pflanzennutzbare Gründigkeit < 30 cm'
        END,
        CASE 
            WHEN src.wasserhaushalt IN ('a', 'b', 'c', 'd', 'e')
                THEN 'kein Einfluss von Stau- oder Grundwasser'
            WHEN src.wasserhaushalt IN ('f', 'g', 'h', 'i')
                THEN 'leichter Einfluss von Stauwasser'
            WHEN src.wasserhaushalt IN ('k', 'l', 'm', 'n')
                THEN 'leichter Einfluss von Grund- oder Hangwasser'
            WHEN src.wasserhaushalt IN ('o', 'p', 'q', 'r')
                THEN 'starker Einfluss von Stauwasser. Falls nicht drainiert, stellenweise dauernd vernässt'
            WHEN src.wasserhaushalt IN ('s', 't', 'u', 'v', 'w', 'x', 'y', 'z')
                THEN 'starker Einfluss von Grund- oder Hangwasser. Falls nicht drainiert, stellenweise dauernd vernässt'
        END
    ) AS wasserhaushalt_charakter,
    CASE 
        WHEN src.wasserhaushalt = 'a'
            THEN 'a - sehr tiefgründig'
        WHEN src.wasserhaushalt = 'b'
            THEN 'b - tiefgründig'
        WHEN src.wasserhaushalt = 'c'
            THEN 'c - mässig tiefgründig'
        WHEN src.wasserhaushalt = 'd'
            THEN 'd - ziemlich flachgründig'
        WHEN src.wasserhaushalt = 'e'
            THEN 'e - flachgründig und sehr flachgründig'
        WHEN src.wasserhaushalt = 'f'
            THEN 'f - tiefgründig'
        WHEN src.wasserhaushalt = 'g'
            THEN 'g - mässig tiefgründig'
        WHEN src.wasserhaushalt = 'h'
            THEN 'h - ziemlich flachgründig'
        WHEN src.wasserhaushalt = 'i'
            THEN 'i - flachgründig und sehr flachgründig'
        WHEN src.wasserhaushalt = 'k'
            THEN 'k - tiefgründig'
        WHEN src.wasserhaushalt = 'l'
            THEN 'l - mässig tiefgründig'
        WHEN src.wasserhaushalt = 'm'
            THEN 'm - ziemlich flachgründig'
        WHEN src.wasserhaushalt = 'n'
            THEN 'n - flachgründig und sehr flachgründig'
        WHEN src.wasserhaushalt = 'o'
            THEN 'o - mässig tiefgründig und tiefgründig'
        WHEN src.wasserhaushalt = 'p'
            THEN 'p - ziemlich flachgründig und flachgründig'
        WHEN src.wasserhaushalt = 'q'
            THEN 'q - ziemlich flachgründig'
        WHEN src.wasserhaushalt = 'r'
            THEN 'r - flachgründig und sehr flachgründig'
        WHEN src.wasserhaushalt = 's'
            THEN 's - tiefgründig'
        WHEN src.wasserhaushalt = 't'
            THEN 't - mässig tiefgründig'
        WHEN src.wasserhaushalt = 'u'
            THEN 'u - ziemlich flachgründig und flachgründig'
        WHEN src.wasserhaushalt = 'v'
            THEN 'v - mässig tiefgründig'
        WHEN src.wasserhaushalt = 'w'
            THEN 'w - ziemlich flachgründig und flachgründig'
        WHEN src.wasserhaushalt = 'x'
            THEN 'x - ziemlich flachgründig'
        WHEN src.wasserhaushalt = 'y'
            THEN 'y - flachgründig und sehr flachgründig'
        WHEN src.wasserhaushalt = 'z'
            THEN 'z - sehr flachgründig'
    END AS wasserhaushalt_spezifisch,
    CASE 
        WHEN src.wasserhaushalt IN ('a', 'b', 'c', 'd', 'e')
            THEN 'Senkrecht durchwaschen, normal durchlässig und'
        WHEN src.wasserhaushalt IN ('f', 'g', 'h', 'i')
            THEN 'Senkrecht durchwaschen, stauwasserbeeinflusst und'
        WHEN src.wasserhaushalt IN ('k', 'l', 'm', 'n')
            THEN 'Senkrecht durchwaschen, grund- oder hangwasserbeeinflusst und'
        WHEN src.wasserhaushalt IN ('o', 'p')
            THEN 'Stauwassergeprägt, selten bis zur Oberfläche porengesättigt und'
        WHEN src.wasserhaushalt IN ('q', 'r')
            THEN 'Stauwassergeprägt, häufig bis zur Oberfläche porengesättigt und'
        WHEN src.wasserhaushalt IN ('s', 't', 'u')
            THEN 'Grund- oder hangwassergeprägt, selten bis zur Oberfläche porengesättigt und'
        WHEN src.wasserhaushalt IN ('v', 'w')
            THEN 'Grund- oder hangwassergeprägt, häufig bis zur Oberfläche porengesättigt und '
        WHEN src.wasserhaushalt IN ('x', 'y')
            THEN 'Grund- oder hangwassergeprägt, meist bis zur Oberfläche porengesättigt und'
        WHEN src.wasserhaushalt = 'z'
            THEN 'Grund- oder hangwassergeprägt, dauernd bis zur Oberfläche porengesättigt und'
    END AS wasserhaushalt_uebergreifend,
    src.bodentyp,
    bt.dispname AS bodentyp_txt,
    src.gelaendeform,
    gf.dispname AS gelaendeform_txt,
    NULL::varchar(50) AS gelaendeform_beschreibung,
    src.geologie,
    src.oberboden0_koernungsklasse,
    kko.dispname AS koernungsklasse_oberboden_txt,
    src.unterboden0_koernungsklasse,
    kku.dispname AS koernungsklasse_unterboden_txt,
    CASE 
        WHEN src.oberboden0_koernungsklasse IN ('toniger_lehm', 'lehmiger_ton', 'ton', 'toniger_schluff')
            THEN 'Schwere, tonige Böden: trocknen sehr langsam ab.'
        WHEN src.oberboden0_koernungsklasse IN ('sandiger_lehm', 'lehm', 'sandiger_schluff', 'schluff', 'lehmiger_schluff')
            THEN 'Mittelschwere, lehmige bis schluffige Böden: trocknen mässig schnell ab.'
        WHEN src.oberboden0_koernungsklasse IN ('sand', 'schluffiger_sand', 'lehmiger_sand', 'lehmreicher_sand')
            THEN 'Leichte, sandige Böden: trocknen schnell ab.'
    END AS bodenart_bodenbearbeitbarkeit,
    src.oberboden0_tongehalt,
    src.unterboden0_tongehalt,
    src.oberboden0_schluffgehalt,
    src.unterboden0_schluffgehalt,
    src.karbonatgrenze,
    src.oberboden0_kalkgehalt,
    kgo.dispname AS kalkgehalt_oberboden_txt,
    src.unterboden0_kalkgehalt,
    kgu.dispname AS kalkgehalt_unterboden_txt,
    src.oberboden0_ph,
    CASE 
        WHEN src.oberboden0_ph > 0 AND src.oberboden0_ph <= 3.2
            THEN 'sehr stark sauer'
        WHEN src.oberboden0_ph > 3.2 AND src.oberboden0_ph <= 4.2
            THEN 'stark sauer'
        WHEN src.oberboden0_ph > 4.2 AND src.oberboden0_ph <= 5.0
            THEN 'sauer'
        WHEN src.oberboden0_ph > 5.0 AND src.oberboden0_ph <= 6.1
            THEN 'schwach sauer'
        WHEN src.oberboden0_ph > 6.1 AND src.oberboden0_ph <= 6.7
            THEN 'neutral'
        WHEN src.oberboden0_ph > 6.7
            THEN 'alkalisch'
    END AS ph_oberboden_beschreibung,
    src.unterboden0_ph,
    CASE 
        WHEN src.unterboden0_ph > 0 AND src.unterboden0_ph <= 3.2
            THEN 'sehr stark sauer'
        WHEN src.unterboden0_ph > 3.2 AND src.unterboden0_ph <= 4.2
            THEN 'stark sauer'
        WHEN src.unterboden0_ph > 4.2 AND src.unterboden0_ph <= 5.0
            THEN 'sauer'
        WHEN src.unterboden0_ph > 5.0 AND src.unterboden0_ph <= 6.1
            THEN 'schwach sauer'
        WHEN src.unterboden0_ph > 6.1 AND src.unterboden0_ph <= 6.7
            THEN 'neutral'
        WHEN src.unterboden0_ph > 6.7
            THEN 'alkalisch'
    END AS ph_unterboden_beschreibung,
    src.maechtigkeit_ah,
    src.humusgehalt_ah,
    CASE 
        WHEN src.humusgehalt_ah > 0 AND src.humusgehalt_ah < 2
            THEN '< 2.0%: humusarm'
        WHEN src.humusgehalt_ah >= 2 AND src.humusgehalt_ah < 5
            THEN '2.0 - 4.9%: schwach humos'
        WHEN src.humusgehalt_ah >= 5 AND src.humusgehalt_ah < 10
            THEN '5.0 - 9.9%: humos'
        WHEN src.humusgehalt_ah >= 10 AND src.humusgehalt_ah < 20
            THEN '10.0 - 19.9%: humusreich'
        WHEN src.humusgehalt_ah >= 20 AND src.humusgehalt_ah < 30
            THEN '20.0 - 29.9%: sehr humusreich'
        WHEN src.humusgehalt_ah >= 30
            THEN '>= 30.0%: organisch'
    END AS humusgehalt_ah_beschreibung,
    src.unterboden0_gefuegeform,
    gfu.dispname AS gefuegeform_unterboden_txt,
    src.oberboden0_gefuegeform,
    gfo.dispname AS gefuegeform_oberboden_txt,
    src.unterboden0_gefuegegroesse,
    ggu.dispname AS gefuegegroesse_unterboden_txt,
    src.oberboden0_gefuegegroesse,
    ggo.dispname AS gefuegegroesse_oberboden_txt,
    src.pflanzennutzbaregruendigkeit,
    CASE 
        WHEN 
            src.pflanzennutzbaregruendigkeit = 0 
            OR
            src.pflanzennutzbaregruendigkeit IS NULL
                THEN
                    CASE
                        WHEN
                            src.bodenpunktzahl > 0
                            AND
                            src.bodenpunktzahl <= 49
                                THEN 'Geringe Durchwurzelungstiefe; schlechtes Speichervermögen für Nährstoffe und Wasser'
                        WHEN
                            src.bodenpunktzahl >= 50
                            AND
                            src.bodenpunktzahl <= 69
                                THEN 'Mässige Durchwurzelungstiefe; genügendes Speichervermögen für Nährstoffe und Wasser'
                        WHEN
                            src.bodenpunktzahl >= 70
                            AND
                            src.bodenpunktzahl <= 79
                                THEN 'Grosse Durchwurzelungstiefe; gutes Speichervermögen für Nährstoffe und Wasser'
                        WHEN src.bodenpunktzahl >= 80
                            THEN 'Sehr grosse Durchwurzelungstiefe; sehr gutes Speichervermögen für Nährstoffe und Wasser'
                    END
        WHEN src.pflanzennutzbaregruendigkeit > 0
            THEN
                CASE
                    WHEN
                        src.pflanzennutzbaregruendigkeit > 0
                        AND
                        src.pflanzennutzbaregruendigkeit <= 29
                            THEN 'Geringe Durchwurzelungstiefe; schlechtes Speichervermögen für Nährstoffe und Wasser'
                    WHEN
                        src.pflanzennutzbaregruendigkeit >= 30
                        AND
                        src.pflanzennutzbaregruendigkeit <= 49
                            THEN 'Mässige Durchwurzelungstiefe; genügendes Speichervermögen für Nährstoffe und Wasser'
                    WHEN
                        src.pflanzennutzbaregruendigkeit >= 50
                        AND
                        src.pflanzennutzbaregruendigkeit <= 69
                            THEN 'Grosse Durchwurzelungstiefe; gutes Speichervermögen für Nährstoffe und Wasser'
                    WHEN 
                        src.pflanzennutzbaregruendigkeit >= 70
                            THEN 'Sehr grosse Durchwurzelungstiefe; sehr gutes Speichervermögen für Nährstoffe und Wasser'
                END
    END AS pflanzennutzbaregruendigkeit_beschreibung,        
    src.bodenpunktzahl,
    CASE 
        WHEN src.bodenpunktzahl >= 90
            THEN 'Beste Bodeneigenschaften; Fruchtfolge ohne Einschränkungen'
        WHEN src.bodenpunktzahl >= 80 AND src.bodenpunktzahl < 90
            THEN 'Sehr gute Fruchtfolgeböden; Hackfruchtanbau eingeschränkt'
        WHEN src.bodenpunktzahl >= 70 AND src.bodenpunktzahl < 80
            THEN 'Gute Fruchtfolgeböden für getreidebetonte Fruchtfolge'
        WHEN src.bodenpunktzahl >= 50 AND src.bodenpunktzahl < 70
            THEN 'Gute Futterbauböden; futterbaubetonte Fruchtfolge, Ackerbau stark eingeschränkt'
        WHEN src.bodenpunktzahl >= 35 AND src.bodenpunktzahl < 50
            THEN 'Futterbaulich nutzbare Standorte'
        WHEN src.bodenpunktzahl >= 20 AND src.bodenpunktzahl < 35
            THEN 'Extensive Bewirtschaftung angezeigt'
        WHEN src.bodenpunktzahl > 0 AND src.bodenpunktzahl < 20
            THEN 'Für die landwirtschaftliche Nutzung ungeeignet'
        WHEN src.bodenpunktzahl = 0 OR src.bodenpunktzahl IS NULL
            THEN 'keine Information'
    END AS bodenpunktzahl_beschreibung,
    src.bemerkungen AS bemerkung,
    los.los,
    src.kartierjahr,
    kt.teamkuerzel AS kartierteam,
    src.kartierquartal,
    NULL::numeric(3,1) AS bindungsstaerke_cadmium,
    NULL::numeric(3,1) AS bindungsstaerke_zink,
    NULL::numeric(3,1) AS bindungsstaerke_kupfer,
    NULL::numeric(3,1) AS bindungsstaerke_blei,
    NULL::numeric(8,5) AS wurzelraum_feldkapazitaet_unterboden,
    NULL::numeric(8,5) AS wurzelraum_feldkapazitaet_oberboden,
    NULL::numeric(8,5) AS wurzelraum_feldkapazitaet,
    NULL::varchar(200) AS wurzelraum_feldkapazitaet_beschreibung,
    NULL::int4 AS verdichtungsempfindlichkeit,
    NULL::varchar(150) AS verdichtungsempfindlichkeit_beschreibung,
    NULLIF(
        concat_ws(
            ', ',
            src.untertyp_e,
            src.untertyp_i,
            src.untertyp_g,
            src.untertyp_r,
            uk.codes,
            up.codes,
            ud.codes
        ),
        ''
    )::varchar(200) AS untertypen,
    src.gemeinde_nr AS gemeindenummer_bfs_aktuell,
    src.geometrie
FROM 
    afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_wald src
LEFT JOIN 
    afu_bodeneinheiten_v1.skelettgehalt_wald sgu
    ON 
    sgu.ilicode = src.unterboden0_skelettgehalt_unterboden
LEFT JOIN 
    afu_bodeneinheiten_v1.skelettgehalt_wald sgo
    ON 
    sgo.ilicode = src.oberboden0_skelettgehalt_oberboden
LEFT JOIN 
    afu_bodeneinheiten_v1.humusform_wald hfw
    ON 
    hfw.ilicode = src.humusform_wald
LEFT JOIN 
    afu_bodeneinheiten_v1.wasserhaushaltcode_enum wh
    ON 
    wh.ilicode = src.wasserhaushalt
LEFT JOIN 
    afu_bodeneinheiten_v1.bodentypcode bt
    ON 
    bt.ilicode = src.bodentyp
LEFT JOIN 
    afu_bodeneinheiten_v1.gelaendeform gf
    ON 
    gf.ilicode = src.gelaendeform
LEFT JOIN 
    afu_bodeneinheiten_v1.koernungsklasse kko
    ON 
    kko.ilicode = src.oberboden0_koernungsklasse
LEFT JOIN 
    afu_bodeneinheiten_v1.koernungsklasse kku
    ON 
    kku.ilicode = src.unterboden0_koernungsklasse
LEFT JOIN 
    afu_bodeneinheiten_v1.kalkgehalt kgo
    ON 
    kgo.ilicode = src.oberboden0_kalkgehalt
LEFT JOIN 
    afu_bodeneinheiten_v1.kalkgehalt kgu
    ON 
    kgu.ilicode = src.unterboden0_kalkgehalt
LEFT JOIN 
    afu_bodeneinheiten_v1.gefuegeform gfo
    ON 
    gfo.ilicode = src.oberboden0_gefuegeform
LEFT JOIN 
    afu_bodeneinheiten_v1.gefuegeform gfu
    ON 
    gfu.ilicode = src.unterboden0_gefuegeform
LEFT JOIN 
    afu_bodeneinheiten_v1.gefuegegroesse ggo
    ON 
    ggo.ilicode = src.oberboden0_gefuegegroesse
LEFT JOIN 
    afu_bodeneinheiten_v1.gefuegegroesse ggu
    ON 
    ggu.ilicode = src.unterboden0_gefuegegroesse
LEFT JOIN 
    afu_bodeneinheiten_v1.kartierteam kt
    ON 
    kt.t_id = src.kartierer_r
LEFT JOIN 
    afu_bodeneinheiten_v1.los los
    ON 
    los.t_id = src.los
LEFT JOIN 
    untertypen_k uk
    ON 
    uk.bodeneinheit_id = src.t_id
LEFT JOIN 
    untertypen_p up
    ON 
    up.bodeneinheit_id = src.t_id
LEFT JOIN 
    untertypen_div ud
    ON 
    ud.bodeneinheit_id = src.t_id
WHERE 
    los.publizieren IS TRUE
;
