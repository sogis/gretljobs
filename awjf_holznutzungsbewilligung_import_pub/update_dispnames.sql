UPDATE awjf_holznutzungsbewilligung_pub_v1.holznutzungsbewilligung
    SET
        erzeugungsland_txt          = country.dispname,
        datenherr_txt               = canton.dispname,
        allgholzart_txt             = holz.dispname,
        bestaetigung_legalitaet_txt = (
            CASE bestaetigung_legalitaet
                WHEN TRUE THEN 'ja'
                WHEN FALSE THEN 'nein'
            END
        ) 
    FROM
        awjf_holznutzungsbewilligung_pub_v1.countrycode_iso3166_1 AS country,
        awjf_holznutzungsbewilligung_pub_v1.chcantoncode AS canton,
        awjf_holznutzungsbewilligung_pub_v1.holznutzungsbewilligung_allgholzart AS holz
    WHERE
        erzeugungsland = country.ilicode
        AND
        datenherr = canton.ilicode
        AND
        allgholzart = holz.ilicode
;