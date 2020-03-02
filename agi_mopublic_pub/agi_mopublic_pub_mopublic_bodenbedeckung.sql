SELECT
    CASE 
        WHEN split_part(bodenbedeckung.art,'.', array_upper(string_to_array(bodenbedeckung.art, '.'), 1))='fliessendes' 
            THEN 'fliessendes Gewaesser'
        WHEN split_part(bodenbedeckung.art,'.', array_upper(string_to_array(bodenbedeckung.art, '.'), 1))='stehendes' 
            THEN 'stehendes Gewaesser'
        ELSE split_part(bodenbedeckung.art,'.', array_upper(string_to_array(bodenbedeckung.art, '.'), 1))
    END AS art_txt,
    CAST(bodenbedeckung.t_datasetname AS INT) AS bfs_nr,
    gebaeudenummer.gwr_egid AS egid,
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    bodenbedeckung.geometrie AS geometrie
FROM
    agi_dm01avso24.bodenbedeckung_boflaeche AS bodenbedeckung
    LEFT JOIN agi_dm01avso24.bodenbedeckung_gebaeudenummer AS gebaeudenummer
        ON gebaeudenummer.gebaeudenummer_von = bodenbedeckung.t_id
    LEFT JOIN agi_dm01avso24.bodenbedeckung_bbnachfuehrung AS nachfuehrung
        ON bodenbedeckung.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
    	ON bodenbedeckung.t_basket = basket.t_id
    LEFT JOIN 
    (
    	SELECT
			max(importdate) AS importdate, dataset
		FROM
			agi_dm01avso24.t_ili2db_import
		GROUP BY
			dataset 
    ) AS  aimport
    	ON basket.dataset = aimport.dataset        
; 
