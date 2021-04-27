DELETE FROM awjf_waldpflege_kontrolle.waldpflege_waldpflege
WHERE
    innerhalb_kontingent = true
AND
    abgabe_forstkreis = true
;
