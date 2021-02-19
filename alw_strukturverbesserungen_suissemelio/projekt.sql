SELECT
    t_id,
    geometrie,
    projekttyp AS projekttypen,
    geschaeftsnummer,
    kantonsnummer
  FROM alw_strukturverbesserungen.raeumlicheelemnte_projekt
    WHERE
      projekttyp NOT IN ('Tiefbau','Hochbau','Weitere_ALW_Projekte')
      AND geschaeftsnummer IS NOT NULL
;
