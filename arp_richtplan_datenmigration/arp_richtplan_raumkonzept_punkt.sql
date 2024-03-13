INSERT INTO
    arp_richtplan_v2.raumkonzept_punkt (
        objekttyp,
        geometrie
        )

SELECT
    CASE objekttyp
        WHEN 'Freizeitnutzung'
            THEN 'Landschaft_Freizeitnutzung'
        WHEN 'Zentrumsstruktur.Hauptzentrum'
            THEN 'Siedlung_Zentrumsstruktur.Hauptzentrum'
        WHEN 'Zentrumsstruktur.Regionalzentrum'
            THEN 'Siedlung_Zentrumsstruktur.Regionalzentrum'
        WHEN 'Zentrumsstruktur.Stuetzpunktgemeinde'
            THEN 'Siedlung_Zentrumsstruktur.Stuetzpunktgemeinde'
    END AS objekttyp,
    geometrie
FROM
    arp_richtplan_v1.detailkarten_ueberlagernder_punkt
;