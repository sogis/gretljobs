DELETE FROM arp_npl_mgdm.geobasisdaten_typ_dokument;

INSERT INTO arp_npl_mgdm.geobasisdaten_typ_dokument(
    vorschrift,
    typ
)


-- Grundnutzung
SELECT
    dokument_ch.t_id,
    geobasisdaten_typ.t_id
FROM
    arp_npl.nutzungsplanung_typ_grundnutzung_dokument
    LEFT JOIN
        arp_npl.nutzungsplanung_typ_grundnutzung
        ON nutzungsplanung_typ_grundnutzung.t_id = nutzungsplanung_typ_grundnutzung_dokument.typ_grundnutzung
    LEFT JOIN
        arp_npl.rechtsvorschrften_dokument AS dokument_so
        ON dokument_so.t_id = nutzungsplanung_typ_grundnutzung_dokument.dokument
    LEFT JOIN
        arp_npl_mgdm.rechtsvorschrften_dokument AS dokument_ch
        ON 
            dokument_so.titel = dokument_ch.titel 
            AND 
            dokument_so.offiziellertitel = dokument_ch.offiziellertitel
            AND
            dokument_so.publiziertab =dokument_ch.publiziertab
    LEFT JOIN 
        arp_npl_mgdm.geobasisdaten_typ
        ON geobasisdaten_typ.code = nutzungsplanung_typ_grundnutzung.code_kommunal
        
        
UNION


-- ueberlagernde Flaechen
SELECT
    dokument_ch.t_id,
    geobasisdaten_typ.t_id
FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche_dokument
    LEFT JOIN
        arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche
        ON nutzungsplanung_typ_ueberlagernd_flaeche.t_id = nutzungsplanung_typ_ueberlagernd_flaeche_dokument.typ_ueberlagernd_flaeche
    LEFT JOIN
        arp_npl.rechtsvorschrften_dokument AS dokument_so
        ON dokument_so.t_id = nutzungsplanung_typ_ueberlagernd_flaeche_dokument.dokument
    LEFT JOIN
        arp_npl_mgdm.rechtsvorschrften_dokument AS dokument_ch
        ON 
            dokument_so.titel = dokument_ch.titel 
            AND 
            dokument_so.offiziellertitel = dokument_ch.offiziellertitel
            AND
            dokument_so.publiziertab =dokument_ch.publiziertab
    LEFT JOIN 
        arp_npl_mgdm.geobasisdaten_typ
        ON geobasisdaten_typ.code = nutzungsplanung_typ_ueberlagernd_flaeche.code_kommunal
WHERE
    substring(code_kommunal FROM 1 FOR 3)::integer != 593
    AND 
    substring(code_kommunal FROM 1 FOR 3)::integer != 594
    AND
    substring(code_kommunal FROM 1 FOR 3)::integer != 595
    AND
    substring(code_kommunal FROM 1 FOR 3)::integer != 596
    AND
    substring(code_kommunal FROM 1 FOR 3)::integer != 680
    AND 
    substring(code_kommunal FROM 1 FOR 3)::integer != 681
    AND
    substring(code_kommunal FROM 1 FOR 3)::integer != 682
    AND
    substring(code_kommunal FROM 1 FOR 3)::integer != 683
    AND 
    substring(code_kommunal FROM 1 FOR 3)::integer != 684
    AND
    substring(code_kommunal FROM 1 FOR 3)::integer != 685
    AND
    substring(code_kommunal FROM 1 FOR 3)::integer != 686

    
UNION


-- ueberlagernde Linien
SELECT
    dokument_ch.t_id,
    geobasisdaten_typ.t_id
FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_linie_dokument
    LEFT JOIN
        arp_npl.nutzungsplanung_typ_ueberlagernd_linie
        ON nutzungsplanung_typ_ueberlagernd_linie.t_id = nutzungsplanung_typ_ueberlagernd_linie_dokument.typ_ueberlagernd_linie
    LEFT JOIN
        arp_npl.rechtsvorschrften_dokument AS dokument_so
        ON dokument_so.t_id = nutzungsplanung_typ_ueberlagernd_linie_dokument.dokument
    LEFT JOIN
        arp_npl_mgdm.rechtsvorschrften_dokument AS dokument_ch
        ON 
            dokument_so.titel = dokument_ch.titel 
            AND 
            dokument_so.offiziellertitel = dokument_ch.offiziellertitel
            AND
            dokument_so.publiziertab =dokument_ch.publiziertab
    LEFT JOIN 
        arp_npl_mgdm.geobasisdaten_typ
        ON geobasisdaten_typ.code = nutzungsplanung_typ_ueberlagernd_linie.code_kommunal
        
        
UNION


--ueberlagernde Punkte
SELECT
    dokument_ch.t_id,
    geobasisdaten_typ.t_id
FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_punkt_dokument
    LEFT JOIN
        arp_npl.nutzungsplanung_typ_ueberlagernd_punkt
        ON nutzungsplanung_typ_ueberlagernd_punkt.t_id = nutzungsplanung_typ_ueberlagernd_punkt_dokument.typ_ueberlagernd_punkt
    LEFT JOIN
        arp_npl.rechtsvorschrften_dokument AS dokument_so
        ON dokument_so.t_id = nutzungsplanung_typ_ueberlagernd_punkt_dokument.dokument
    LEFT JOIN
        arp_npl_mgdm.rechtsvorschrften_dokument AS dokument_ch
        ON 
            dokument_so.titel = dokument_ch.titel 
            AND 
            dokument_so.offiziellertitel = dokument_ch.offiziellertitel
            AND
            dokument_so.publiziertab =dokument_ch.publiziertab
    LEFT JOIN 
        arp_npl_mgdm.geobasisdaten_typ
        ON geobasisdaten_typ.code = nutzungsplanung_typ_ueberlagernd_punkt.code_kommunal