TRUNCATE afu_bodeneinheiten_v1.untertyp_diverse_hauptlandwirtschaft;

WITH dataset AS ( 
    SELECT  
        t_id
    FROM 
        afu_bodeneinheiten_v1.t_ili2db_dataset 
    WHERE  
        datasetname = 'migration'
), 
basket AS (
    SELECT 
        t_id  
    FROM 
        afu_bodeneinheiten_v1.t_ili2db_basket 
    WHERE  
        attachmentkey = 'migration'
), 
multienum_json AS (
    SELECT
        concat(
            '["',
            replace(untertyp_div,',','","'),
            '"]'
        ) AS enums_json,
        gemnr, 
        objnr, 
        t_id
    FROM 
        afu_bodeneinheiten_v1.import_table 
    WHERE 
        ist_hauptauspraegung = 'true' 
        AND 
        ist_wald = 'false' 
        AND 
        untertyp_div IS NOT NULL
)
,
untertypen AS (
    SELECT 
        je.value AS acode,
        gemnr, 
        objnr, 
        hauptauspraegung.t_id AS id
    FROM 
        multienum_json
    JOIN 
        json_array_elements_text(multienum_json.enums_json::json) AS je(value) 
        ON 
        true
    LEFT JOIN 
        afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_landwirtschaft hauptauspraegung
        ON 
        hauptauspraegung.gemeinde_nr = multienum_json.gemnr 
        AND 
        hauptauspraegung.bodeneinheit_nummer = multienum_json.objnr
)

INSERT INTO 
    afu_bodeneinheiten_v1.untertyp_diverse_hauptlandwirtschaft  (
        t_basket, 
        t_datasetname,
        bodeneinheitlandassociation_diverse, 
        acode
    )
SELECT  
    basket.t_id,
    dataset.t_id,
    id,
    trim(acode) --Damit die Leerzeichen weg gehen.
FROM 
    basket, 
    dataset,
    untertypen 
WHERE 
    id IS NOT NULL
;