SELECT
    kontrolle_forstkreis,
    bemerkung_forstkreis,
    mehrfachpflege,
    beitrag,
    gesuchsteller,
    eigentuemerart,
    forstrevier,
    forstkreis,
    abstufung_50_100,
    flaeche,
    geometrie,
    bemerkung,
    jahr,
    gesuchnummer,
    dauerwald,
    erfasser,
    innerhalb_kontingent,
    abgabe_forstkreis,
    gepflegte_flaeche,
    pflegeart
FROM 
   awjf_waldpflege_kontrolle.waldpflege_waldpflege
WHERE
    innerhalb_kontingent = true
AND
    abgabe_forstkreis = true
;
