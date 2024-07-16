/*
----------------------------------------------------
-------------------- Beginn CTE --------------------
----------------------------------------------------
 */

WITH

standort AS (
    SELECT
        standort.standortid AS profilnummer,
        standort.t_id AS standort_id,
        erhebung.t_id AS erhebung_id,
        erhebungsart.codeid AS erhebungsart,
        projekt.aname AS projektname,
        profil.t_id AS profil_id
    FROM 
        afu_bodendaten_nabodat_v1.punktdaten_standort AS standort
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_projektstandort AS projektstandort
        ON standort.t_id = projektstandort.standort
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_projekt AS projekt
        ON projektstandort.projekt = projekt.t_id
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_erhebung AS erhebung
        ON standort.t_id = erhebung.standort
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_erhebungsart AS erhebungsart
        ON erhebung.erhebungsart = erhebungsart.t_id
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_profil AS profil
        ON erhebung.t_id = profil.erhebung
),

horizont AS (
    SELECT 
        standort.profilnummer,
        standort.standort_id,
        standort.profil_id,
        standort.erhebung_id,
        standort.erhebungsart,
        standort.projektname,
        horizont.t_id,
        horizont.tiefevon,
        horizont.tiefebis,
        horizont.horizontnr AS horizontnummer,
        horizont.HorizontbezeichungAusgangsinfo AS horizontbezeichnung,
        horizont.humusgehaltfeld AS zustand_organische_substanz,
        horizont.TonFeld AS tongehalt,
        horizont.SchluffFeld AS schluffgehalt,
        horizont.SandFeld AS sandgehalt,
        horizont.KiesFeld AS kiesanteil,
        horizont.SteineFeld AS steinanteil,
        horizont.pHFeld AS ph_wert,
        kalk.codeid AS kalkgehalt
    FROM
        standort 
    RIGHT JOIN afu_bodendaten_nabodat_v1.punktdaten_horizont AS horizont
        ON standort.profil_id = horizont.profil
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_horizontbezeichnung AS horizontbezeichnung
        ON horizont.horizontbezeichnung = horizontbezeichnung.t_id
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_kalkreaktionhcl AS kalk
        ON horizont.kalkreaktionhcl = kalk.t_id
),

gefuege AS (
    SELECT
        horizont.t_id AS horizont_id, --Für Join mit punktdaten_horizont
        gefuege.horizont,
        string_agg(gefuegeform.codeid || coalesce(gefuegegroesse.codeid,''),', ') AS gefuege
    FROM
        horizont 
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_gefuege AS gefuege
        ON horizont.t_id = gefuege.horizont
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_form AS gefuegeform
        ON gefuege.form = gefuegeform.t_id
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_groesse AS gefuegegroesse
        ON gefuege.groesse = gefuegegroesse.t_id
    GROUP BY
        horizont.t_id,
        gefuege.horizont
),

farbe AS (
    SELECT 
        horizont.t_id AS horizont_id, --für Join mit punktdaten_horizont
        bodenfarbe.horizont,
        string_agg(farbtonzahl.codeid || ' ' || farbtontext.codetext_de || ' ' || farbtonhelligkeit.codeid || '/' || farbtonintensitaet.codeid,', ') AS farbe
    FROM 
        horizont 
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_bodenfarbe AS bodenfarbe
        ON horizont.t_id = bodenfarbe.horizont
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_farbtonzahl AS farbtonzahl
        ON bodenfarbe.farbtonzahl = farbtonzahl.t_id
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_farbtontext AS farbtontext
        ON bodenfarbe.farbtontext = farbtontext.t_id
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_helligkeit AS farbtonhelligkeit
        ON bodenfarbe.helligkeit = farbtonhelligkeit.t_id
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_intensitaet AS farbtonintensitaet
        ON bodenfarbe.intensitaet = farbtonintensitaet.t_id
    GROUP BY 
        horizont.t_id,
        bodenfarbe.horizont
),

messungen AS (
    SELECT
        horizont.t_id AS horizont_id, --Für Join mit punktdaten_horizont
        (messung.messwerte) ->> 'Bodenkennwerte // Organische Substanz'::text AS zustand_organische_substanz_labor,
        (messung.messwerte) ->> 'Bodenkennwerte // Tongehalt (< 0.002 mm)'::text AS tongehalt_labor,
        (messung.messwerte) ->> 'Bodenkennwerte // Schluffgehalt (0.002 - 0.05 mm)'::text AS schluffgehalt_labor,
        (messung.messwerte) ->> 'Bodenkennwerte // Sandgehalt (0.05 - 2 mm)'::text AS sandgehalt_labor,
        (messung.messwerte) ->> 'Bodenkennwerte // Kalk (CaCO3)'::text AS kalkgehalt_labor,
        (messung.messwerte) ->> 'Bodenkennwerte // pH-Wert'::text AS cacl2_wert,
        (messung.messwerte) ->> 'Bodenkennwerte // Potentielle Kationenaustauschkapazität'::text AS kak_pot,
        (messung.messwerte) ->> 'Bodenkennwerte // Effektive Kationenaustauschkapazität'::text AS kak_eff
    FROM
        afu_bodendaten_nabodat_v1.punktdaten_profil profil
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_horizont AS horizont
        ON horizont.profil = profil.t_id
    LEFT JOIN afu_bodendaten_nabodat_v1.erhebung_probe_profil_v AS hilfsview --View
        ON hilfsview.erhebung_profil = profil.erhebung
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_probe AS probe
        ON
            hilfsview.erhebung_probe = probe.erhebung
            AND
            probe.tiefevon = horizont.tiefevon
    LEFT JOIN (
        SELECT
            json_object_agg(analyseparameter.parametertext_de, messung_1.messwert) AS messwerte,
            messung_1.probe
        FROM
            afu_bodendaten_nabodat_v1.punktdaten_messung messung_1
        LEFT JOIN afu_bodendaten_nabodat_v1.codelistnnlysdten_analyseparameter analyseparameter
            ON messung_1.analyseparameter = analyseparameter.t_id
        GROUP BY
            messung_1.probe
    ) AS messung
        ON messung.probe = probe.t_id
)

/*
----------------------------------------------------
--------------------- Ende CTE ---------------------
----------------------------------------------------

----------------------------------------------------
-------------- Beginn SELECT auf CTE's -------------
----------------------------------------------------
 */

SELECT
    horizont.profilnummer,
    horizont.horizontnummer,
    horizont.tiefevon,
    horizont.tiefebis,
    horizont.horizontbezeichnung,
    horizont.zustand_organische_substanz,
    messungen.zustand_organische_substanz_labor,
    horizont.tongehalt,
    messungen.tongehalt_labor,
    horizont.schluffgehalt,
    messungen.schluffgehalt_labor,
    horizont.sandgehalt,
    messungen.sandgehalt_labor,
    horizont.kiesanteil,
    horizont.steinanteil,
    horizont.ph_wert,
    horizont.kalkgehalt,
    messungen.kalkgehalt_labor,
    gefuege.gefuege,
    farbe.farbe,
    messungen.cacl2_wert,
    messungen.kak_pot,
    messungen.kak_eff
FROM 
    horizont
LEFT JOIN gefuege 
    ON horizont.t_id = gefuege.horizont_id
LEFT JOIN farbe
    ON horizont.t_id = farbe.horizont_id
LEFT JOIN messungen 
    ON horizont.t_id = messungen.horizont_id
WHERE 
    horizont.projektname = 'Bodenkartierung Kt. SO'
AND 
    horizont.erhebungsart != 'PN'
;