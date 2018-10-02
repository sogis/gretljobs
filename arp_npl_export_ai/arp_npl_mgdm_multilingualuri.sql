DELETE FROM arp_npl_mgdm.multilingualuri
;

INSERT INTO arp_npl_mgdm.multilingualuri(
    rechtsvrschrftn_dkment_textimweb
)

SELECT
    t_id
FROM
    arp_npl_mgdm.rechtsvorschrften_dokument
;
