INSERT INTO
    arp_richtplan_v2.raumkonzept_flaeche (
        objektname,
        objekttyp,
        geometrie
        )

SELECT
    objektname,
    CASE objekttyp
        WHEN 'Handlungsraum.agglogepraegt'
            THEN 'Siedlung_Handlungsraum.agglogepraegt'
        WHEN 'Handlungsraum.laendlich'
            THEN 'Siedlung_Handlungsraum.laendlich'
        WHEN 'Handlungsraum.urban'
            THEN 'Siedlung_Handlungsraum.urban'
        WHEN 'Freizeit_Sport_Erholung'
            THEN 'Freizeit_Sport_Erholung'
        WHEN 'landwirtschaftliches_Vorranggebiet'
            THEN 'Landschaft.Vorranggebiet'
        WHEN 'naturnaher_Landschaftsraum'
            THEN 'Landschaft.naturnaher_Landschaftsraum'
    END AS objekttyp,
    geometrie
FROM
    arp_richtplan_v1.detailkarten_ueberlagernde_flaeche
;