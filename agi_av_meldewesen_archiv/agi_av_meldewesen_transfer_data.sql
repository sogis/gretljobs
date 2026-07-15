BEGIN;

WITH move_data AS (
    DELETE FROM agi_av_meldewesen_work_v1.meldungen_meldung
    WHERE datum_abgeschlossen IS NOT NULL
        AND datum_abgeschlossen < CURRENT_DATE - INTERVAL '1 year'
    RETURNING *
)
INSERT INTO agi_av_meldewesen_archiv_v1.meldungen_meldung
SELECT *
FROM move_data;

COMMIT;