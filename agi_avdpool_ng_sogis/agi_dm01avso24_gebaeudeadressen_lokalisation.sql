SELECT
    lokalisation.t_id AS tid,
    lokalisation.entstehung,
    lok_numprinzip.itfcode AS nummerierungsprinzip,
    lokalisation.nummerierungsprinzip AS nummerierungsprinzip_txt,
    lokalisation.lokalisationnummer,
    lok_attributeprov.itfcode AS attributeprovisorisch,
    lokalisation.attributeprovisorisch AS attributeprovisorisch_txt,
    lok_istoffiziellebez.itfcode AS istoffiziellebezeichnung,
    lokalisation.istoffiziellebezeichnung AS istoffiziellebezeichnung_txt,
    status_ga.itfcode AS status,
    lokalisation.astatus AS status_txt,
    lok_inaenderung.itfcode AS inaenderung,
    lokalisation.inaenderung AS inaenderung_txt,
    lok_art.itfcode AS art,
    lokalisation.art AS art_txt,
    cast(lokalisation.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gebaeudeadressen_lokalisation AS lokalisation
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lokalisation.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.status_ga AS status_ga
        ON lokalisation.astatus = status_ga.ilicode
    LEFT JOIN agi_dm01avso24.gebaeudeadrssen_lokalisation_inaenderung AS lok_inaenderung
        ON lokalisation.inaenderung = lok_inaenderung.ilicode
    LEFT JOIN agi_dm01avso24.gebaeudeadrssen_lokalisation_attributeprovisorisch AS lok_attributeprov
        ON lokalisation.attributeprovisorisch = lok_attributeprov.ilicode
    LEFT JOIN agi_dm01avso24.gebaeudeadrssen_lokalisation_istoffiziellebezeichnung AS lok_istoffiziellebez
        ON lokalisation.istoffiziellebezeichnung = lok_istoffiziellebez.ilicode
    LEFT JOIN agi_dm01avso24.gebaeudeadrssen_lokalisation_nummerierungsprinzip AS lok_numprinzip
        ON lokalisation.nummerierungsprinzip = lok_numprinzip.ilicode
    LEFT JOIN agi_dm01avso24.gebaeudeadrssen_lokalisation_art AS lok_art
        ON lokalisation.art = lok_art.ilicode
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
