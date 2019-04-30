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
    ST_SnapToGrid(grundnutzung.geometrie, 0.001) AS geometrie
FROM
    arp_npl.nutzungsplanung_grundnutzung AS grundnutzung
    LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung
        ON grundnutzung.typ_grundnutzung = nutzungsplanung_typ_grundnutzung.t_id
    LEFT JOIN arp_npl_mgdm.geobasisdaten_typ AS typ 
        ON 
            (
                typ.code = nutzungsplanung_typ_grundnutzung.code_kommunal
                AND
                nutzungsplanung_typ_grundnutzung.abkuerzung IS NULL
                AND
                typ.abkuerzung IS NULL
                AND 
                nutzungsplanung_typ_grundnutzung.verbindlichkeit = typ.verbindlichkeit
                AND 
                nutzungsplanung_typ_grundnutzung.bezeichnung = typ.bezeichnung
            )
            OR
            (
                typ.code = nutzungsplanung_typ_grundnutzung.code_kommunal
                AND
                nutzungsplanung_typ_grundnutzung.abkuerzung = typ.abkuerzung
                AND 
                nutzungsplanung_typ_grundnutzung.verbindlichkeit = typ.verbindlichkeit
                AND 
                nutzungsplanung_typ_grundnutzung.bezeichnung = typ.bezeichnung
            )
;
