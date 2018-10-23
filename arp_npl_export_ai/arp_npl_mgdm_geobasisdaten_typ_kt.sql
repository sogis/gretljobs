DELETE FROM arp_npl_mgdm.geobasisdaten_typ_kt
;

INSERT INTO arp_npl_mgdm.geobasisdaten_typ_kt (
    code,
    bezeichnung,
    abkuerzung,
    hauptnutzung_ch)

--Grundnutzung
SELECT
    substring(ilicode FROM 2 FOR 3) AS code,
    replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung,
    substring(ilicode FROM 1 FOR 4) AS abkuerzung,
    hauptnutzung.t_id AS hauptnutzung_ch
FROM
    arp_npl.nutzungsplanung_np_typ_kanton_grundnutzung AS grundnutzung
    LEFT JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hauptnutzung
        ON hauptnutzung.code::text = substring(ilicode FROM 2 FOR 2)

UNION

--ueberlagernde Flaechen
SELECT
    substring(ilicode FROM 2 FOR 3) AS code,
    replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung,
    substring(ilicode FROM 1 FOR 4) AS abkuerzung,
    hauptnutzung.t_id AS hauptnutzung_ch
FROM
    arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_flaeche AS ueberlagernd_flaeche
    LEFT JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hauptnutzung
        ON hauptnutzung.code::text = substring(ilicode FROM 2 FOR 2)
WHERE 
    CAST(substring(ilicode FROM 2 FOR 3) AS integer) NOT IN (593, 594, 595, 596, 680, 681, 682, 683, 684, 685, 686)

UNION

--ueberlagernde Linien
SELECT
    substring(ilicode FROM 2 FOR 3) AS code,
    replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung,
    substring(ilicode FROM 1 FOR 4) AS abkuerzung,
    hauptnutzung.t_id AS hauptnutzung_ch
FROM
    arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_linie AS ueberlagernd_linie
    LEFT JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hauptnutzung
        ON hauptnutzung.code::text = substring(ilicode FROM 2 FOR 2)

UNION

--ueberlagernde Punkte
SELECT
    substring(ilicode FROM 2 FOR 3) AS code,
    replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung,
    substring(ilicode FROM 1 FOR 4) AS abkuerzung,
    hauptnutzung.t_id AS hauptnutzung_ch
FROM
    arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_punkt AS ueberlagernd_punkt
    LEFT JOIN arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hauptnutzung
        ON hauptnutzung.code::text = substring(ilicode FROM 2 FOR 2)
;
