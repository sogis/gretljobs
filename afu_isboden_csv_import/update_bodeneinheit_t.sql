UPDATE 
    afu_isboden.bodeneinheit_t be 
    SET
    is_wald = csv.is_wald,
    kartierjahr = csv.kartierjahr,
    fk_kartierer = csv.kartierer,
    kartierquartal = csv.kartierquartal,
    los = csv.los,
    archive = 0
FROM 
    (
    SELECT 
        objnr::integer,
        gemnr::integer,
        is_wald::boolean,
        CASE 
	        kartierer 
	        WHEN '' then NULL::bigint
            else (SELECT 
                      pk_kartiererin 
                  FROM 
                      afu_isboden.kartiererin_v 
                  WHERE 
                      name like trim(kartierer, ' ') LIMIT 1)
        END AS kartierer,
        CASE 
	        los 
	        WHEN '' then NULL
            else los::text
        END AS los,
        CASE 
	        kartierjahr 
	        WHEN '' then NULL
            else kartierjahr::integer
        END AS kartierjahr,
        CASE 
	        kartierquartal 
	        WHEN '' then NULL
            else kartierquartal::integer
        END AS kartierquartal
    FROM 
        afu_isboden_csv_import_v1.csv_import_csv_import_t
    ) AS csv
WHERE 
    be.objnr = csv.objnr
    AND 
    be.gemnr = csv.gemnr
;
