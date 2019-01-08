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

/*800er Codes werden dem kantonalen Code 69 zugeordnet da die 800er Codes nur für punktbezogene Festlegungen zählen*/
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
WHERE
    substring(typ.code_kommunal FROM 1 FOR 1) != '8'

UNION
/*800er Codes werden dem kantonalen Code 69 zugeordnet da die 800er Codes nur für punktbezogene Festlegungen zählen*/
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
    JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hauptnutzung
        ON hauptnutzung.code::text = '69'
WHERE
    substring(typ.code_kommunal FROM 1 FOR 1) = '8'

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

/*800er Codes werden bei den ueberlagernden Flaechen 
 * dem kantonalen Code 69 zugeordnet daher muss bei den 
 * überlagernden Punkten geschaut werden, dass die richtige 
 * Zuordnung verwendet wird*/
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
    JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hauptnutzung
        ON typ_kt.hauptnutzung_ch = hauptnutzung.t_id
WHERE
    hauptnutzung.code = cast(substring(typ.code_kommunal FROM 1 FOR 2) AS integer)
;