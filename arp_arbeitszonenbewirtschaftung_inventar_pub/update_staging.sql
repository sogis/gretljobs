UPDATE arp_arbeitszonenbewirtschaftung_staging_v1.arbtsznnng_nvntar_arbeitszonenbewirtschaftung_inventar
SET
     nutzungsgrad_txt=n.dispname,
     bauzonenstatistik_txt=b.dispname,
     gestaltungsplanpflicht_txt=(
        CASE 
            WHEN gestaltungsplanpflicht = TRUE 
                THEN 'ja' 
            ELSE 'nein' 
        END) 
FROM
    arp_arbeitszonenbewirtschaftung_staging_v1.arbtszng_nvntar_arbeitszonenbewirtschaftung_inventar_baustik AS b,
    arp_arbeitszonenbewirtschaftung_staging_v1.arbtszng_nvntar_arbeitszonenbewirtschaftung_inventar_nutgrad AS n    
WHERE
    nutzungsgrad=n.ilicode
    AND
    bauzonenstatistik=b .ilicode