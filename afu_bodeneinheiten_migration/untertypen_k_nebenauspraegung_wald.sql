TRUNCATE afu_bodeneinheiten_v1.untertyp_k_nebenwald;

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
            replace(untertyp_k,',','","'),
            '"]'
        ) AS enums_json,
        gemnr, 
        objnr, 
        t_id
    FROM 
        afu_bodeneinheiten_v1.import_table 
    WHERE 
        ist_hauptauspraegung = 'false' 
        AND 
        ist_wald = 'true' 
        AND 
        untertyp_k IS NOT NULL
)
,
untertypen AS (
    SELECT 
        je.value AS acode,
        gemnr, 
        objnr, 
        bodeneinheit.t_id AS id
    FROM 
        multienum_json
    JOIN 
        json_array_elements_text(multienum_json.enums_json::json) AS je(value) 
        ON 
        true
    LEFT JOIN 
        afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_wald hauptauspraegung
        ON 
        hauptauspraegung.gemeinde_nr = multienum_json.gemnr 
        AND 
        hauptauspraegung.bodeneinheit_nummer = multienum_json.objnr         
    LEFT JOIN 
        afu_bodeneinheiten_v1.nebenauspraegung_wald bodeneinheit
        ON 
        bodeneinheit.bodeneinheit = hauptauspraegung.t_id
        AND 
        multienum_json.t_id = bodeneinheit.import_oid 
)

INSERT INTO 
    afu_bodeneinheiten_v1.untertyp_k_nebenwald  (
        t_basket, 
        t_datasetname,
        nebenauspraegungwaldassociation_k, 
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
