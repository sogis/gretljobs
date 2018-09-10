DELETE FROM arp_npl_mgdm.geobasisdaten_typ
;

INSERT INTO arp_npl_mgdm.geobasisdaten_typ (
    code,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    bemerkungen,
    typ_kt
)

SELECT
    typ.code_kommunal AS code,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt.t_id AS typ_kt
FROM
    arp_npl.nutzungsplanung_typ_grundnutzung AS typ
    JOIN arp_npl_mgdm.geobasisdaten_typ_kt AS typ_kt
        ON typ_kt.code = substring(typ.typ_kt FROM 2 FOR 3)

UNION

SELECT
    typ.code_kommunal AS code,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt.t_id AS typ_kt
FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche AS typ
    JOIN arp_npl_mgdm.geobasisdaten_typ_kt AS typ_kt
        ON typ_kt.code = substring(typ.typ_kt FROM 2 FOR 3)
        
UNION

SELECT
    typ.code_kommunal AS code,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt.t_id AS typ_kt
FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_linie AS typ
    JOIN arp_npl_mgdm.geobasisdaten_typ_kt AS typ_kt
        ON typ_kt.code = substring(typ.typ_kt FROM 2 FOR 3)

UNION

SELECT
    typ.code_kommunal AS code,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt.t_id AS typ_kt
FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_punkt AS typ
    JOIN arp_npl_mgdm.geobasisdaten_typ_kt AS typ_kt
        ON typ_kt.code = substring(typ.typ_kt FROM 2 FOR 3)
;