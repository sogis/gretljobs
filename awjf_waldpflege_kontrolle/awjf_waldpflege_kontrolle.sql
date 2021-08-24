SELECT
    FALSE AS kontrolle_forstkreis,
    NULL AS bemerkung_forstkreis,
    NULL AS mehrfachpflege,
    CASE
        WHEN dauerwald IS TRUE
            THEN gepflegte_flaeche * 4.5 * abstufung_50_100
        WHEN dauerwald IS FALSE
            THEN gepflegte_flaeche * 15 * abstufung_50_100
    END AS beitrag,
    gesuchsteller.gesuchsteller,
    NULL AS eigentuemerart,
    gesuchsteller.forstrevier,
    gesuchsteller.forstkreis,
    gesuchsteller.abstufung_50_100,
    ST_Area(waldpflege.geometrie) / 100 AS flaeche,
    waldpflege.geometrie,
    waldpflege.bemerkung,
    waldpflege.jahr,
    waldpflege.gesuchnummer,
    waldpflege.dauerwald,
    waldpflege.erfasser,
    FALSE AS innerhalb_kontingent,
    waldpflege.abgabe_forstkreis,
    waldpflege.gepflegte_flaeche,
    waldpflege.pflegeart
FROM 
   awjf_waldpflege_erfassung.waldpflege_waldpflege AS waldpflege
   LEFT JOIN awjf_gesuchsteller.gesuchsteller_gesuchsteller As gesuchsteller
   ON waldpflege.gesuchnummer = gesuchsteller.gesuchsnummer
WHERE
    waldpflege.abgabe_forstkreis IS TRUE
AND
    gepflegte_flaeche IS NOT NULL
AND
    abstufung_50_100 IS NOT NULL
;
