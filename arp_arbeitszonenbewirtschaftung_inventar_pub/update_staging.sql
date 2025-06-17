UPDATE arp_arbeitszonenbewirtschaftung_staging_v1.arbtsznnng_nvntar_arbeitszonenbewirtschaftung_inventar
SET
    gestaltungsplanpflicht=(
        CASE 
            WHEN gestaltungsplan IS NOT NULL 
                THEN TRUE
            ELSE FALSE 
        END)   
;

UPDATE arp_arbeitszonenbewirtschaftung_staging_v1.arbtsznnng_nvntar_arbeitszonenbewirtschaftung_inventar
SET
    nutzungsgrad_txt=n.dispname,
    bebauungsstand_txt=b.dispname,
    gestaltungsplanpflicht_txt=(
        CASE 
            WHEN gestaltungsplanpflicht = TRUE 
                THEN 'ja' 
            ELSE 'nein' 
        END) 
FROM
    arp_arbeitszonenbewirtschaftung_staging_v1.arbtszng_nvntar_arbeitszonenbewirtschaftung_inventar_bebtand AS b,
    arp_arbeitszonenbewirtschaftung_staging_v1.arbtszng_nvntar_arbeitszonenbewirtschaftung_inventar_nutgrad AS n    
WHERE
    nutzungsgrad=n.ilicode
    AND
    bebauungsstand=b .ilicode;
; 