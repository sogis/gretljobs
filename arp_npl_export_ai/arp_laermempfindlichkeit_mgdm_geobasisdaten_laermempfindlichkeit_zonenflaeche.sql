INSERT INTO arp_laermempfindlichkeit_mgdm.geobasisdaten_laermempfindlichkeit_zonenflaeche (
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
    ST_Buffer(ST_SnapToGrid(flaeche.geometrie, 0.001), 0) AS geometrie
FROM
    arp_npl.nutzungsplanung_ueberlagernd_flaeche AS flaeche
    LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche
        ON flaeche.typ_ueberlagernd_flaeche = nutzungsplanung_typ_ueberlagernd_flaeche.t_id
    JOIN arp_laermempfindlichkeit_mgdm.geobasisdaten_typ AS typ
        ON typ.code = nutzungsplanung_typ_ueberlagernd_flaeche.code_kommunal
WHERE 
    flaeche.rechtsstatus = 'inKraft'
;
