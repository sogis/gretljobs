UPDATE
    avt_mehrjahresplanung_v1.projekte_projekt
SET
    projektidentifikation =
        CASE
            WHEN projektsuffix IS NULL THEN projektnr
            ELSE projektnr || '.' || projektsuffix
        END
;