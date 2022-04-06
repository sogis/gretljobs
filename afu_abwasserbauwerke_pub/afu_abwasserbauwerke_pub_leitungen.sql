SELECT
    leitungen.geometrie,
    leitungen.laenge,
    leitungen.seso_id,
    leitungen.durchmesser,
    leitungen.gefaelle,
    leitungen.kategorie,
    leitungen.druckleitung,
    leitungen.astatus,
    leitungen.von_hoehe,
    leitungen.zu_hoehe,
    leitungen.baujahr,
    leitungen.material,
    leitungen.teilgebiet,
    leitungen.qualitaet,
    leitungen.archiv_nr,
    leitungen.erfassung,
    leitungen.erfasser,
    leitungen.bearbeitung,
    leitungen.bearbeiter,
    leitungen.ofg_connection,
    leitungen.selekt,
    leitungen.neg_imp,
    leitungen.symbol,
    leitungen.put_erfolg,
    CASE
        WHEN leitungen.eigentum = 1
            THEN 'Gemeinde'
        WHEN leitungen.eigentum = 2
            THEN 'Abwasserzweckverband'
    END AS eigentum,
    leitungen.bemerkungen,
    
    --gemeindegrenze.gemeindename,
    leitungen.gemeinde::text,
    
    abwasserreinigungsanlage.gemeinde AS ara_name
    
FROM
    afu_abwasserbauwerke_v1.leitungen AS leitungen
    LEFT JOIN afu_abwasserbauwerke_v1.abwasserreinigungsanlage AS abwasserreinigungsanlage
        ON leitungen.ara_join = abwasserreinigungsanlage.seso_join
--     LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
--         ON leitungen.gemeinde = gemeindegrenze.bfs_gemeindenummer
;

