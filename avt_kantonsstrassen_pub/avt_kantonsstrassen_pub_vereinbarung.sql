SELECT
    main_id AS t_id,
    objekt,
    adresse_grundeigentuemer,
    wkb_geometry AS geometrie,
    beschrieb,
    konto_intervall,
    datum_vertragsabschluss,
    rechtsgrundlage,
    aktiv,
    zahlungsintervall,
    faelligkeit,
    zeitdauer,
    bemerkung,
    datum_erfassung,
    datum_ablauf,
    datum_letzte_zahlung,
    konto_art,
    adresse_paechter,
    anzahl_raten,
    anzahl_raten_getilgt,
    vereinbarung_mit,
    datum_last_change,
    abteilung 
FROM
    avt_vobj.vereinbarungen
;