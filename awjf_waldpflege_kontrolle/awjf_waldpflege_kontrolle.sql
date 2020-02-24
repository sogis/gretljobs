SELECT
    FALSE AS kontrolle_forstkreis,
    NULL AS bemerkung_forstkreis,
    NULL AS mehrfachpflege,
    0 AS beitrag,
    gesuchsteller.gesuchsteller,
    gesuchsteller.eigentuemerart,
    gesuchsteller.forstrevier,
    gesuchsteller.forstkreis,
    gesuchsteller.anrede,
    gesuchsteller.name1,
    gesuchsteller.name2,
    gesuchsteller.adresszusatz,
    gesuchsteller.strasse_hausnummer,
    gesuchsteller.plz,
    gesuchsteller.ortschaft,
    NULL AS bemerkung_stab,
    gesuchsteller.kreditorennummer,
    gesuchsteller.abstufung_50_100,
    ST_Area(waldpflege.geometrie) / 10000 AS flaeche,
    waldpflege.geometrie,
    waldpflege.bemerkung,
    waldpflege.jahr,
    waldpflege.gesuchnummer,
    waldpflege.dauerwald,
    waldpflege.erfasser
FROM 
   awjf_waldpflege_erfassung.waldpflege_waldpflege AS waldpflege
   LEFT JOIN awjf_gesuchsteller.gesuchsteller_gesuchsteller As gesuchsteller
   ON waldpflege.gesuchnummer = gesuchsteller.gesuchsnummer
;
