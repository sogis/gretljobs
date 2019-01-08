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
        ON 
            (
                typ.code = nutzungsplanung_typ_ueberlagernd_linie.code_kommunal
                AND
                nutzungsplanung_typ_ueberlagernd_linie.abkuerzung IS NULL
                AND
                typ.abkuerzung IS NULL
                AND 
                nutzungsplanung_typ_ueberlagernd_linie.verbindlichkeit = typ.verbindlichkeit
                AND 
                nutzungsplanung_typ_ueberlagernd_linie.bezeichnung = typ.bezeichnung
            )
            OR
            (
                typ.code = nutzungsplanung_typ_ueberlagernd_linie.code_kommunal
                AND
                nutzungsplanung_typ_ueberlagernd_linie.abkuerzung = typ.abkuerzung
                AND 
                nutzungsplanung_typ_ueberlagernd_linie.verbindlichkeit = typ.verbindlichkeit
                AND 
                nutzungsplanung_typ_ueberlagernd_linie.bezeichnung = typ.bezeichnung
            )
;
