INSERT INTO arp_npl_mgdm.localiseduri(
    atext,
    alanguage,
    multilingualuri_localisedtext
)
SELECT
    CASE 
        WHEN textimweb IS NULL THEN 'http://document.not.available'
        ELSE 'https://geoweb.so.ch/zonenplaene/Zonenplaene_pdf/' || textimweb  
    END AS atext,
    'de' AS alanguage,
    multilingualuri.t_id AS multilingualuri_localisedtext
FROM
    arp_npl.rechtsvorschrften_dokument AS dokument_so
    LEFT JOIN arp_npl_mgdm.rechtsvorschrften_dokument AS dokument_ch
        ON 
            (
                dokument_so.titel = dokument_ch.titel
                AND
                dokument_so.offiziellertitel IS NULL
                AND 
                dokument_ch.offiziellertitel IS NULL
                AND
                dokument_so.publiziertab = dokument_ch.publiziertab
            )
            OR
            (
                dokument_so.titel = dokument_ch.titel
                AND
                dokument_so.offiziellertitel = dokument_ch.offiziellertitel
                AND
                dokument_so.publiziertab = dokument_ch.publiziertab
            )
    LEFT JOIN arp_npl_mgdm.multilingualuri
        ON multilingualuri.rechtsvrschrftn_dkment_textimweb = dokument_ch.t_id
;