-- Mapping von GWR-Gebäudeklassen-Codes und -Beschreibungen

DROP TABLE IF EXISTS 
    export.gebklasse10_mapping CASCADE
;

CREATE TABLE
    export.gebklasse10_mapping (
    gklas_10        INTEGER,
    gklas_10_txt    TEXT
);

INSERT
    INTO export.gebklasse10_mapping
    VALUES
        (111, 'Wohnbauten'),
        (112, 'Gebäude mit zwei oder mehr Wohnungen'),
        (113, 'Wohngebäude für Gemeinschaften'),
        (121, 'Hotels und ähnliche Gebäude'),
        (122, 'Bürogebäude'),
        (123, 'Gross- und Einzelhandelsgebäude'),
        (124, 'Gebäude des Verkehrs- und Nachrichtenwesens'),
        (125, 'Industrie- und Lagergebäude'),
        (126, 'Gebäude für Kultur- und Freizeitzwecke sowie das Bildungs- und Gesundheitswesen'),
        (127, 'Sonstige Nichtwohngebäude')
;