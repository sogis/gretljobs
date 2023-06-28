SELECT 
    'Grundwasservorkommen' AS hinweis,
    true as hinweis_oeffentlich,
    geometrie AS mpoly
FROM afu_grundwassergeometrie_pub_v1.grundwasserstrom_begrenzung_hgw;
