INSERT INTO arp_npl_mgdm.rechtsvorschrften_hinweisweiteredokumente(
    ursprung,
    hinweis
)

WITH dokumente_ch_so AS (
    SELECT
        dokument_ch.t_id AS ch_t_id,
        dokument_so.t_id AS so_t_id
    FROM
        arp_npl.rechtsvorschrften_dokument AS dokument_so
        LEFT JOIN arp_npl_mgdm.rechtsvorschrften_dokument AS dokument_ch
            ON
                (
                    dokument_so.titel = dokument_ch.titel 
                    AND
                    dokument_so.offiziellertitel IS NULL
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
)

SELECT
    hinweis_ch.ch_t_id AS hinweis,
    ursprung_ch.ch_t_id AS ursprung
FROM arp_npl.rechtsvorschrften_hinweisweiteredokumente AS hinweis
    LEFT JOIN dokumente_ch_so AS hinweis_ch
        ON hinweis_ch.so_t_id = hinweis.hinweis
    LEFT JOIN dokumente_ch_so AS ursprung_ch
        ON ursprung_ch.so_t_id = hinweis.ursprung
;