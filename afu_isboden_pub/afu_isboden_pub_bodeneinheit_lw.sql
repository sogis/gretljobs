SELECT
    pk_ogc_fid AS t_id,
    gemnr,
    objnr,
    wasserhhgr,
    wasserhhgr_beschreibung,
    wasserhhgr_qgis_txt,
    bodentyp,
    bodentyp_beschreibung,
    gelform,
    CASE
        WHEN gelform = 'a' OR gelform = 'b' OR gelform = 'c' OR gelform = 'd' OR gelform = 'e'
            THEN '0-10%: Keine Einschränkung'
        WHEN gelform = 'f' OR gelform = 'g' OR gelform = 'h' OR gelform = 'i'
            THEN '10-15%: Hackfruchtanbau und Vollerntemaschine möglich'
        WHEN gelform = 'j' OR gelform = 'k' OR gelform = 'l' OR gelform = 'm' OR gelform = 'n'
            THEN '10-15%: Hackfruchtanbau stark erschwert, Getreidebau erschwert; Mähdrescher möglich, evtl. Hangmähdrescher'
        WHEN gelform = 'o' OR gelform = 'p' OR gelform ='q' OR gelform = 'r'
            THEN '25-35%: Getreideanbau stark eingeschränkt, Hangmähdrescher; Hangtraktoren.'
        WHEN gelform = 's' OR gelform = 't' OR gelform = 'u' OR gelform = 'v' OR gelform = 'w' OR gelform = 'x' OR gelform = 'y' OR gelform = 'z'
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
        WHEN skelett_ob = 2 OR skelett_ob = 3
            THEN 'viele Steine (10-20%)'
        WHEN skelett_ob = 4 OR skelett_ob = 5
            THEN 'sehr viele Steine (20-30%)'
        WHEN skelett_ob = 6 OR skelett_ob = 7
            THEN 'extrem viele Steine (>30%)'
    END AS skelett_ob_txt,
    skelett_ob_beschreibung,
    skelett_ub,
    skelett_ub_beschreibung,
    koernkl_ob,
    CASE 
        WHEN koernkl_ob = 1 OR koernkl_ob = 2 OR koernkl_ob = 3 OR koernkl_ob = 4
            THEN 'Leichte, sandige Böden:<br>leicht bearbeitbar, trocknen leicht ab.'
        WHEN koernkl_ob = 5 OR koernkl_ob = 6 OR koernkl_ob = 10 OR koernkl_ob = 11 OR koernkl_ob = 12
            THEN 'Mittelschwere, lehmige bis schluffige Böden:<br>normal bearbeitbar, trocknen mässig schnell ab.'
        WHEN koernkl_ob = 7 OR koernkl_ob = 8 OR koernkl_ob = 9 OR koernkl_ob = 13
            THEN 'Schwere, tonige Böden:<br>schwer bearbeitbar, trocknen sehr langsam ab.'
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
            THEN 'Geringe Durchwurzelungstiefe;<br> schlechtes Speichervermögen für Nährstoffe und Wasser'
        WHEN pflngr_qgis_int = 2
            THEN 'Mässige Durchwurzelungstiefe;<br> genügendes Speichervermögen für Nährstoffe und Wasser'
        WHEN pflngr_qgis_int = 3
            THEN 'Grosse Durchwurzelungstiefe;<br> gutes Speichervermögen für Nährstoffe und Wasser'
        WHEN pflngr_qgis_int = 4 
            THEN 'Sehr grosse Durchwurzelungstiefe;<br> sehr gutes Speichervermögen für Nährstoffe und Wasser'
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
            THEN 'wenig empfindlicher Unterboden:<br>Bearbeitung mit üblicher Sorgfalt.'
        WHEN verdempf = 2
            THEN 'mässig empfindlicher Unterboden:<br>nach Abtrocknungsphase, gut mechanisch belastbar.'
        WHEN verdempf = 3
            THEN 'empfindlicher Unterboden:<br>erhöhte Sorgfalt beim Befahren und Feldarbeiten notwendig, Trockenperioden sind optimal zu nutzen.'
        WHEN verdempf = 4
            THEN 'stark empfindlicher Unterboden:<br>nur eingeschränkt mechanisch belastbar, längere Trockenperioden abwarten, ergänzende lastreduzierende und lastverteilende Massnahmen ergreifen.'
        WHEN verdempf = 5
            THEN 'extrem empfindlicher Unterboden:<br>möglichst Verzicht auf ackerbauliche Nutzung, bereits geringe Auflasten können irreversible Schäden verursachen.'
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
;