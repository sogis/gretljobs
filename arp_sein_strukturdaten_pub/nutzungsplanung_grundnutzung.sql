SELECT  -- ohne t_basket und t_datasetname, weil in Zieltabelle nicht vorhanden
    t_id, t_ili_tid, typ_bezeichnung, typ_abkuerzung, typ_verbindlichkeit, typ_bemerkungen, typ_kt, typ_code_kommunal, typ_nutzungsziffer, typ_nutzungsziffer_art, typ_geschosszahl, geometrie, geschaefts_nummer, rechtsstatus, publiziertab, bemerkungen, erfasser, datum_erfassung, dokumente, bfs_nr, publiziertbis, typ_code_kt, typ_code_ch
FROM arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
WHERE LEFT(typ_kt, 4) IN ('N430', 'N439');