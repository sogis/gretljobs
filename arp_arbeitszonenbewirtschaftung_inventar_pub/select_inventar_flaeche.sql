SELECT
    geometrie,
    grundstuecknummer,
    grundbuch,
    gemeinde,
    egrid,
    grundstueckflaeche,
    eigentuemer,
    region,
    nutzungsgrad,
    nutzungsgrad_txt,
    zonenreglement,
    gestaltungsplan,
    gestaltungsplanpflicht,
    CASE
        WHEN gestaltungsplanpflicht=TRUE
            THEN 'ja'
        ELSE 'nein'
    END AS gestaltungsplanpflicht_txt,
    bebauungsstand,
    bebauungsstand_txt,
    baureglement,
    grundnutzung_typ_kt,
    flaeche_beschnitten,
	flaeche_unbebaut,
    unbebaut,
    CASE
        WHEN unbebaut=TRUE
            THEN 'ja'
        WHEN unbebaut=FALSE
            THEN 'nein'
        ELSE NULL
    END AS unbebaut_txt,
    bestaendige_nutzung,
    CASE
        WHEN bestaendige_nutzung=TRUE
            THEN 'ja'
        WHEN bestaendige_nutzung=FALSE
            THEN 'nein'
        ELSE NULL
    END AS bestaendige_nutzung_txt,
    in_planung,
    CASE
        WHEN in_planung=TRUE
            THEN 'ja'
        WHEN in_planung=FALSE
            THEN 'nein'
        ELSE NULL
    END AS in_planung_txt,
    unternutzte_arbeitszone,
    CASE
        WHEN unternutzte_arbeitszone=TRUE
            THEN 'ja'
        WHEN unternutzte_arbeitszone=FALSE
            THEN 'nein'
        ELSE NULL
    END AS unternutzte_arbeitszone_txt,
    erweiterbar,
    CASE
        WHEN erweiterbar=TRUE
            THEN 'ja'
        WHEN erweiterbar=FALSE
            THEN 'nein'
        ELSE NULL
    END AS erweiterbar_txt,
    gebunden,
    CASE
        WHEN gebunden=TRUE
            THEN 'ja'
        WHEN gebunden=FALSE
            THEN 'nein'
        ELSE NULL
    END AS gebunden_txt,
    zonierung_kontrollieren,
    CASE
        WHEN zonierung_kontrollieren=TRUE
            THEN 'ja'
        WHEN zonierung_kontrollieren=FALSE
            THEN 'nein'
        ELSE NULL
    END AS zonierung_kontrollieren_txt,
    bemerkung,
    watchlist,
    CASE
        WHEN watchlist=TRUE
            THEN 'ja'
        WHEN watchlist=FALSE
            THEN 'nein'
        ELSE NULL
    END AS watchlist_txt,
    watchlist_grund,
    watchlist_objekttyp,
    publizieren_oeffentlich,
    CASE
        WHEN publizieren_oeffentlich=TRUE
            THEN 'ja'
        ELSE 'nein'
    END AS publizieren_oeffentlich_txt,
    dossier,
    flaeche_erweiterbar,
    bewertung_vorhanden,
    CASE
        WHEN bewertung_vorhanden=TRUE
            THEN 'ja'
        ELSE 'nein'
    END AS bewertung_vorhanden_txt
FROM
    arp_arbeitszonenbewirtschaftung_staging_v1.inventar_flaeche_v