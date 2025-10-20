UPDATE arp_arbeitszonenbewirtschaftung_staging_v2.arbtsznnng_nvntar_arbeitszonenbewirtschaftung_inventar
SET
    gestaltungsplanpflicht=(
        CASE 
            WHEN gestaltungsplan IS NOT NULL 
                THEN TRUE
            ELSE FALSE 
        END)   
;

UPDATE arp_arbeitszonenbewirtschaftung_staging_v2.arbtsznnng_nvntar_arbeitszonenbewirtschaftung_inventar
SET
    nutzungsgrad_txt=n.dispname,
    bebauungsstand_txt=b.dispname,
    grundstuecksart_txt=g.dispname,
    gestaltungsplanpflicht_txt=(
        CASE 
            WHEN gestaltungsplanpflicht = TRUE 
                THEN 'ja' 
            ELSE 'nein' 
        END) 
FROM
    arp_arbeitszonenbewirtschaftung_staging_v2.arbtszng_nvntar_arbeitszonenbewirtschaftung_inventar_bebtand AS b,
    arp_arbeitszonenbewirtschaftung_staging_v2.arbtszng_nvntar_arbeitszonenbewirtschaftung_inventar_nutgrad AS n,
    arp_arbeitszonenbewirtschaftung_staging_v2.arbtszng_nvntar_arbeitszonenbewirtschaftung_inventar_grusart AS g
WHERE
    nutzungsgrad=n.ilicode
    AND
    bebauungsstand=b.ilicode
    AND
    grundstuecksart=g.ilicode
; 