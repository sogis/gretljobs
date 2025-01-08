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
    zonenreglement,
    gestaltungsplan,
    gestaltungsplanpflicht,
    bauzonenstatistik,
    baureglement,
    grundnutzung,
    unbebaut,
    bestaendige_nutzung,
    in_planung,
    unternutzte_arbeitszone,
    erweiterbar,
    gebunden,
    zonierung_kontrollieren,
    bemerkung,
    watchlist,
    watchlist_grund,
    watchlist_objekttyp,
    publizieren_oeffentlich,
    dossier,
    flaeche_erweiterbar,
    bewertung_vorhanden
FROM
    arp_arbeitszonenbewirtschaftung_staging_v1.inventar_flaeche_v