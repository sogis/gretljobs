DELETE FROM arp_npl_mgdm.rechtsvorschrften_dokument
;

INSERT INTO arp_npl_mgdm.rechtsvorschrften_dokument (
    t_type,
    titel,
    offiziellertitel,
    abkuerzung,
    kanton,
    gemeinde,
    publiziertab,
    rechtsstatus,
    bemerkungen
)

SELECT
    CASE
        WHEN rechtsvorschrift IS TRUE
            THEN 'rechtsvorschrften_rechtsvorschrift'
        ELSE 'rechtsvorschrften_dokument'
    END AS t_type,
    titel,
    offiziellertitel,
    abkuerzung,
    kanton,
    gemeinde,
    publiziertab,
    rechtsstatus,
    bemerkungen
FROM
    arp_npl.rechtsvorschrften_dokument
;