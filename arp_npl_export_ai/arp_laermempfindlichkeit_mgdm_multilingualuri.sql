INSERT INTO arp_laermempfindlichkeit_mgdm.multilingualuri(
    rechtsvrschrftn_dkment_textimweb
)

SELECT
    t_id
FROM
    arp_laermempfindlichkeit_mgdm.rechtsvorschrften_dokument
;