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
        ON 
            (
                typ.code = nutzungsplanung_typ_ueberlagernd_punkt.code_kommunal
                AND
                nutzungsplanung_typ_ueberlagernd_punkt.abkuerzung IS NULL
                AND 
                typ.abkuerzung IS NULL
                AND
                nutzungsplanung_typ_ueberlagernd_punkt.verbindlichkeit = typ.verbindlichkeit
                AND 
                nutzungsplanung_typ_ueberlagernd_punkt.bezeichnung = typ.bezeichnung
            )
            OR
            (
                typ.code = nutzungsplanung_typ_ueberlagernd_punkt.code_kommunal
                AND
                nutzungsplanung_typ_ueberlagernd_punkt.abkuerzung = typ.abkuerzung
                AND 
                nutzungsplanung_typ_ueberlagernd_punkt.verbindlichkeit = typ.verbindlichkeit
                AND 
                nutzungsplanung_typ_ueberlagernd_punkt.bezeichnung = typ.bezeichnung
            )
        LEFT JOIN arp_npl_mgdm.geobasisdaten_typ_kt
            ON typ.typ_kt = geobasisdaten_typ_kt.t_id
        LEFT JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch
            ON hauptnutzung_ch_hauptnutzung_ch.t_id = geobasisdaten_typ_kt.hauptnutzung_ch
WHERE
    hauptnutzung_ch_hauptnutzung_ch.code != 69
;