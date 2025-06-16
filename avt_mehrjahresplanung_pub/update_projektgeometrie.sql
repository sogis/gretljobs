-- Setze ein Obsolet-Datum für manuell erfasste Geometrien, welche in der
-- Projektliste nicht mehr vorkommen
WITH projekte AS (
    SELECT
        CASE
            WHEN projektsuffix IS NULL THEN projektnr
            ELSE projektnr || '.' || projektsuffix
        END AS projektidentifikation
    FROM
        avt_mehrjahresplanung_v2.projekte_projekt
)
UPDATE
    avt_mehrjahresplanung_v2.projekte_projektgeometrie pg
SET
    obsolet = NOW()
WHERE
    pg.projektidentifikation NOT IN (SELECT projektidentifikation FROM projekte)
AND
    obsolet IS NULL;

-- Lösche alle manuell erfassten Geometrien, deren Obsolet-Datum länger als
-- sechs Monate zurückliegt
DELETE FROM
    avt_mehrjahresplanung_v2.projekte_projektgeometrie pg
WHERE 
    obsolet IS NOT NULL
AND
    NOW() - obsolet > '6 months';