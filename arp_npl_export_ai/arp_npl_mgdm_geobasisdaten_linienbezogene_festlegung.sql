DELETE FROM arp_npl_mgdm.geobasisdaten_linienbezogene_festlegung;

INSERT INTO arp_npl_mgdm.geobasisdaten_linienbezogene_festlegung (
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ,
    geometrie
)

SELECT
    linie.publiziertab,
    linie.rechtsstatus,
    linie.bemerkungen,
    typ.t_id AS typ,
    linie.geometrie
FROM
    arp_npl.nutzungsplanung_ueberlagernd_linie AS linie
    LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_linie
        ON linie.typ_ueberlagernd_linie = nutzungsplanung_typ_ueberlagernd_linie.t_id
    LEFT JOIN arp_npl_mgdm.geobasisdaten_typ AS typ 
        ON typ.code = nutzungsplanung_typ_ueberlagernd_linie.code_kommunal
;
        
