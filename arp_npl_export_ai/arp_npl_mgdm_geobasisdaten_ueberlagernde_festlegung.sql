INSERT INTO arp_npl_mgdm.geobasisdaten_ueberlagernde_festlegung (
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ,
    geometrie
)

SELECT
    flaeche.publiziertab,
    flaeche.rechtsstatus,
    flaeche.bemerkungen,
    typ.t_id AS typ,
    flaeche.geometrie
FROM
    arp_npl.nutzungsplanung_ueberlagernd_flaeche AS flaeche
    LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche
        ON flaeche.typ_ueberlagernd_flaeche = nutzungsplanung_typ_ueberlagernd_flaeche.t_id
    JOIN arp_npl_mgdm.geobasisdaten_typ AS typ
        ON 
            (
                typ.code = nutzungsplanung_typ_ueberlagernd_flaeche.code_kommunal
                AND
                nutzungsplanung_typ_ueberlagernd_flaeche.abkuerzung IS NULL
                AND 
                typ.abkuerzung IS NULL
                AND
                nutzungsplanung_typ_ueberlagernd_flaeche.verbindlichkeit = typ.verbindlichkeit
                AND 
                nutzungsplanung_typ_ueberlagernd_flaeche.bezeichnung = typ.bezeichnung
            )
            OR
            (
                typ.code = nutzungsplanung_typ_ueberlagernd_flaeche.code_kommunal
                AND
                nutzungsplanung_typ_ueberlagernd_flaeche.abkuerzung = typ.abkuerzung
                AND 
                nutzungsplanung_typ_ueberlagernd_flaeche.verbindlichkeit = typ.verbindlichkeit
                AND 
                nutzungsplanung_typ_ueberlagernd_flaeche.bezeichnung = typ.bezeichnung
            )
        LEFT JOIN arp_npl_mgdm.geobasisdaten_typ_kt
            ON typ.typ_kt = geobasisdaten_typ_kt.t_id
        LEFT JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch
            ON hauptnutzung_ch_hauptnutzung_ch.t_id = geobasisdaten_typ_kt.hauptnutzung_ch
WHERE
    substring(cast(hauptnutzung_ch_hauptnutzung_ch.code AS text) FROM 1 FOR 1)::text != '8'
;