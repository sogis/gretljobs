SELECT
    linienelement.geometrie AS wkb_geometry,
    CASE 
        WHEN einzelobjekt.art = 'Mauer.Mauer'
            THEN 0   
        WHEN einzelobjekt.art = 'Mauer.Laermschutzwand'
            THEN 39   
        WHEN einzelobjekt.art = 'unterirdisches_Gebaeude'
            THEN 1   
        WHEN einzelobjekt.art = 'uebriger_Gebaeudeteil'
            THEN 2   
        WHEN einzelobjekt.art = 'eingedoltes_oeffentliches_Gewaesser'
            THEN 3   
        WHEN einzelobjekt.art = 'wichtige_Treppe'
            THEN 4   
        WHEN einzelobjekt.art = 'Tunnel_Unterfuehrung_Galerie'
            THEN 5   
        WHEN einzelobjekt.art = 'Bruecke_Passerelle'
            THEN 6   
        WHEN einzelobjekt.art = 'Bahnsteig'
            THEN 10   
        WHEN einzelobjekt.art = 'Brunnen'
            THEN 7   
        WHEN einzelobjekt.art = 'Reservoir'
            THEN 8   
        WHEN einzelobjekt.art = 'Pfeiler'
            THEN 9   
        WHEN einzelobjekt.art = 'Unterstand'
            THEN 10   
        WHEN einzelobjekt.art = 'Silo_Turm_Gasometer'
            THEN 11   
        WHEN einzelobjekt.art = 'Hochkamin'
            THEN 12   
        WHEN einzelobjekt.art = 'Denkmal'
            THEN 13   
        WHEN einzelobjekt.art = 'Mast_Antenne.Mast_Antenne'
            THEN 14   
        WHEN einzelobjekt.art = 'Mast_Antenne.Mast_Leitung'
            THEN 41   
        WHEN einzelobjekt.art = 'Aussichtsturm'
            THEN 15   
        WHEN einzelobjekt.art = 'Uferverbauung'
            THEN 16   
        WHEN einzelobjekt.art = 'Schwelle'
            THEN 17   
        WHEN einzelobjekt.art = 'Lawinenverbauung'
            THEN 17   
        WHEN einzelobjekt.art = 'massiver_Sockel'
            THEN 18   
        WHEN einzelobjekt.art = 'Ruine_archaeologisches_Objekt'
            THEN 19   
        WHEN einzelobjekt.art = 'Landungssteg'
            THEN 20   
        WHEN einzelobjekt.art = 'einzelner_Fels'
            THEN 21   
        WHEN einzelobjekt.art = 'schmale_bestockte_Flaeche'
            THEN 22   
        WHEN einzelobjekt.art = 'Rinnsal'
            THEN 23   
        WHEN einzelobjekt.art = 'schmaler_Weg.schmaler_Weg'
            THEN 24   
        WHEN einzelobjekt.art = 'schmaler_Weg.Fahrspur'
            THEN 43   
        WHEN einzelobjekt.art = 'Hochspannungsfreileitung'
            THEN 25   
        WHEN einzelobjekt.art = 'Druckleitung'
            THEN 26   
        WHEN einzelobjekt.art = 'Bahngeleise.Bahngeleise'
            THEN 27   
        WHEN einzelobjekt.art = 'Bahngeleise.Bahngeleise_ueberdeckt'
            THEN 44   
        WHEN einzelobjekt.art = 'Luftseilbahn'
            THEN 28   
        WHEN einzelobjekt.art = 'Gondelbahn_Sesselbahn'
            THEN 29   
        WHEN einzelobjekt.art = 'Materialseilbahn'
            THEN 30   
        WHEN einzelobjekt.art = 'Skilift'
            THEN 31   
        WHEN einzelobjekt.art = 'Faehre'
            THEN 32   
        WHEN einzelobjekt.art = 'Grotte_Hoehleneingang'
            THEN 33   
        WHEN einzelobjekt.art = 'Achse'
            THEN 34   
        WHEN einzelobjekt.art = 'wichtiger_Einzelbaum'
            THEN 35   
        WHEN einzelobjekt.art = 'Bildstock_Kruzifix'
            THEN 36   
        WHEN einzelobjekt.art = 'Quelle'
            THEN 37   
        WHEN einzelobjekt.art = 'Bezugspunkt'
            THEN 38   
        WHEN einzelobjekt.art = 'weitere'
            THEN -9   
    END AS art,
    CAST(linienelement.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.einzelobjekte_linienelement AS linienelement
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON linienelement.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.einzelobjekte_einzelobjekt AS einzelobjekt
        ON linienelement.linienelement_von = einzelobjekt.t_id
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
