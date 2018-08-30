DELETE FROM arp_npl_mgdm.geobasisdaten_grundnutzung_zonenflaeche;

INSERT INTO arp_npl_mgdm.geobasisdaten_grundnutzung_zonenflaeche (
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ,
    geometrie
)

SELECT
    grundnutzung.publiziertab,
    grundnutzung.rechtsstatus,
    grundnutzung.bemerkungen,
    typ.t_id AS typ,
    grundnutzung.geometrie
FROM
    arp_npl.nutzungsplanung_grundnutzung AS grundnutzung
    LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung
        ON grundnutzung.typ_grundnutzung = nutzungsplanung_typ_grundnutzung.t_id
    LEFT JOIN arp_npl_mgdm.geobasisdaten_typ AS typ 
        ON typ.code = nutzungsplanung_typ_grundnutzung.code_kommunal
;
        
