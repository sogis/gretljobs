UPDATE 
    afu_bodeneinheiten_pub_v1.bodeneinheit_landwirtschaft
    SET 
    verdichtungsempfindlichkeit =
  CASE

    -- Prioritaet 1: Bodentyp N oder M immer 5
    WHEN bodentyp IN ('N', 'M') THEN 5

    -- Prioritaet 2: Spezialfall -> 1
    WHEN bodentyp IN ('R', 'O', 'X', 'F')
         AND (
           skelettgehalt_unterboden IN ('kies', 'geroell')
           OR skelettgehalt_unterboden IS NULL
         )
      THEN 1

    -- Grundlogik
    WHEN wasserhaushalt IN ('a', 'b', 'c', 'd', 'e') THEN
      CASE
        WHEN skelettgehalt_unterboden IN ('kiesreich', 'steinreich') THEN
          CASE
            WHEN koernungsklasse_unterboden IN ('sand', 'lehmiger_sand') THEN 1
            WHEN koernungsklasse_unterboden IN ('sandiger_schluff', 'schluff') THEN 3
            WHEN bodentyp = 'X' THEN 3
            ELSE 2
          END
        ELSE
          CASE
            WHEN koernungsklasse_unterboden IN ('sandiger_schluff', 'schluff') THEN 3
            WHEN bodentyp = 'X' THEN 3
            ELSE 2
          END
      END

    WHEN wasserhaushalt IN ('f', 'g', 'h', 'i', 'k', 'l', 'm', 'n') THEN
      CASE
        WHEN koernungsklasse_unterboden IN ('sandiger_schluff', 'schluff') THEN 4
        WHEN bodentyp = 'X' THEN 4
        ELSE 3
      END

    WHEN wasserhaushalt IN ('s', 't', 'u') THEN
      CASE
        WHEN koernungsklasse_unterboden IN (
          'lehmiger_ton',
          'ton',
          'sandiger_schluff',
          'schluff',
          'toniger_schluff'
        ) THEN 5
        WHEN bodentyp = 'X' THEN 5
        ELSE 4
      END

    WHEN wasserhaushalt IN ('o', 'p', 'q', 'r', 'v', 'w', 'x', 'y', 'z') THEN 5

    ELSE NULL
  END
;
    
UPDATE 
    afu_bodeneinheiten_pub_v1.bodeneinheit_landwirtschaft
    SET 
    verdichtungsempfindlichkeit_beschreibung =
    CASE
        WHEN verdichtungsempfindlichkeit = 1 THEN 'wenig empfindlicher Unterboden: Bearbeitung mit üblicher Sorgfalt.'
        WHEN verdichtungsempfindlichkeit = 2 THEN 'mässig empfindlicher Unterboden: nach Abtrocknungsphase gut mechanisch belastbar.'
        WHEN verdichtungsempfindlichkeit = 3 THEN 'empfindlicher Unterboden: erhöhte Sorgfalt beim Befahren und Feldarbeiten notwendig, Trockenperioden sind optimal zu nutzen.'
        WHEN verdichtungsempfindlichkeit = 4 THEN 'stark empfindlicher Unterboden: nur eingeschränkt mechanisch belastbar, längere Trockenperioden abwarten, ergänzende lastreduzierende und lastverteilende Massnahmen ergreifen.'
        WHEN verdichtungsempfindlichkeit = 5 THEN 'extrem empfindlicher Unterboden: möglichst Verzicht auf ackerbauliche Nutzung, bereits geringe Auflasten können irreversible Schäden verursachen.'
        ELSE NULL
    END
;
