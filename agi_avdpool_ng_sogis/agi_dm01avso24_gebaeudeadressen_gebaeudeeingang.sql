SELECT
    gebaeudeeingang.t_id AS tid,
    gebaeudeeingang.entstehung,
    gebaeudeeingang.gebaeudeeingang_von,
    status_ga.itfcode AS status,
    gebaeudeeingang.astatus AS status_txt,
    geb_inaenderung.itfcode AS inaenderung,
    gebaeudeeingang.inaenderung AS inaenderung_txt,
    geb_attributeprov.itfcode AS attributeprovisorisch,
    gebaeudeeingang.attributeprovisorisch AS attributeprovisorisch_txt,
    geb_istoffiziellebez.itfcode AS istoffiziellebezeichnung,
    gebaeudeeingang.istoffiziellebezeichnung AS istoffiziellebezeichnung_txt,
    gebaeudeeingang.lage,
    gebaeudeeingang.hoehenlage,
    gebaeudeeingang.hausnummer,
    geb_im_gebaeude.itfcode AS im_gebaeude,
    gebaeudeeingang.im_gebaeude AS im_gebaeude_txt,
    gebaeudeeingang.gwr_edid,
    gebaeudeeingang.gwr_egid,
    cast(gebaeudeeingang.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gebaeudeadressen_gebaeudeeingang AS gebaeudeeingang
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gebaeudeeingang.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.status_ga AS status_ga
        ON gebaeudeeingang.astatus = status_ga.ilicode
    LEFT JOIN agi_dm01avso24.gebaeudeadrssen_gebaeudeeingang_inaenderung AS geb_inaenderung
        ON gebaeudeeingang.inaenderung = geb_inaenderung.ilicode
    LEFT JOIN agi_dm01avso24.gebaeudeadrssen_gebaeudeeingang_attributeprovisorisch AS geb_attributeprov
        ON gebaeudeeingang.attributeprovisorisch = geb_attributeprov.ilicode
    LEFT JOIN agi_dm01avso24.gebaeudeadrssen_gebaeudeeingang_istoffiziellebezeichnung AS geb_istoffiziellebez
        ON gebaeudeeingang.istoffiziellebezeichnung = geb_istoffiziellebez.ilicode
    LEFT JOIN agi_dm01avso24.gebaeudeadrssen_gebaeudeeingang_im_gebaeude AS geb_im_gebaeude
        ON gebaeudeeingang.im_gebaeude = geb_im_gebaeude.ilicode
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
