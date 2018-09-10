DELETE FROM arp_npl_mgdm.geobasisdaten_objektbezogene_festlegung
;

INSERT INTO arp_npl_mgdm.geobasisdaten_objektbezogene_festlegung (
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ,
    geometrie
)

SELECT
    punkt.publiziertab,
    punkt.rechtsstatus,
    punkt.bemerkungen,
    typ.t_id AS typ,
    punkt.geometrie
FROM
    arp_npl.nutzungsplanung_ueberlagernd_punkt AS punkt
    LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_punkt
        ON punkt.typ_ueberlagernd_punkt = nutzungsplanung_typ_ueberlagernd_punkt.t_id
    LEFT JOIN arp_npl_mgdm.geobasisdaten_typ AS typ
        ON typ.code = nutzungsplanung_typ_ueberlagernd_punkt.code_kommunal
;