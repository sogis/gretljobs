DELETE FROM arp_npl_mgdm.geobasisdaten_laermempfindlichkeit_zonenflaeche
;

INSERT INTO arp_npl_mgdm.geobasisdaten_laermempfindlichkeit_zonenflaeche(
    publiziertab,
    rechtsstatus,
    bemerkungen,
    es,
    geometrie
)

SELECT
    flaeche.publiziertab,
    flaeche.rechtsstatus,
    flaeche.bemerkungen,
    typ.t_id AS es,
    flaeche.geometrie
FROM
    arp_npl.nutzungsplanung_ueberlagernd_flaeche AS flaeche
    LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche
        ON flaeche.typ_ueberlagernd_flaeche = nutzungsplanung_typ_ueberlagernd_flaeche.t_id
    JOIN arp_npl_mgdm.laermmp95_v1_1geobasisdaten_typ AS typ 
        ON typ.code = nutzungsplanung_typ_ueberlagernd_flaeche.code_kommunal
;