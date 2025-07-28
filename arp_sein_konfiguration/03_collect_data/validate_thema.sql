WITH
validation_check AS (
	SELECT
		COUNT(*) as mismatch_count
    FROM
    	sein.main.sein_sammeltabelle_filtered 
    WHERE
    	thema_sql != thema 
    OR
    	thema_sql IS NULL 
    OR
    	thema IS NULL
)

SELECT CASE 
    WHEN mismatch_count > 0 THEN 
        error(concat('VALIDATION FAILED: ', mismatch_count, ' different values between thema_sql and thema!'))
    ELSE 
        'data validated'
END AS validation_result
FROM
	validation_check;