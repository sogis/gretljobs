SELECT
    boflaechesymbol.pos AS wkb_geometry,
    aimport.importdate AS new_date,    
    CAST('9999-01-01' AS timestamp) AS archive_date,
    0 AS archive,
    boflaechesymbol.ori AS symbolori,
    CASE 
        WHEN boflaeche.art = 'Gewaesser.fliessendes'
            THEN 0   
        WHEN boflaeche.art = 'Gewaesser.stehendes'
            THEN 2   
        WHEN boflaeche.art = 'Gewaesser.Schilfguertel'
            THEN 1   
        WHEN boflaeche.art = 'befestigt.Wasserbecken'
            THEN 2   
        WHEN boflaeche.art = 'humusiert.Hoch_Flachmoor'
            THEN 3   
        WHEN boflaeche.art = 'humusiert.Intensivkultur.Reben'
            THEN 4   
    END AS art,
    CASE
        WHEN boflaechesymbol.ori >= 0 AND boflaechesymbol.ori < 100
            THEN (100-boflaechesymbol.ori)*0.9
        WHEN boflaechesymbol.ori = 100
            THEN 360
        WHEN boflaechesymbol.ori > 100 AND boflaechesymbol.ori <= 400
            THEN ((100-boflaechesymbol.ori)*0.9)+360
    END AS txt_rot,
    0 AS los
FROM
    agi_dm01avso24.bodenbedeckung_boflaechesymbol AS boflaechesymbol
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON boflaechesymbol.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.bodenbedeckung_boflaeche AS boflaeche
        ON boflaechesymbol.boflaechesymbol_von = boflaeche.t_id
    LEFT JOIN 
    (
        SELECT
            max(importdate) AS importdate,
            dataset
        FROM
            agi_dm01avso24.t_ili2db_import
        GROUP BY
            dataset 
    ) AS  aimport
        ON basket.dataset = aimport.dataset
;
