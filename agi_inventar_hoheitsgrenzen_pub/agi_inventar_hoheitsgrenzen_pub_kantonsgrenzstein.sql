SELECT
    geometrie,
    steinnummer,
    vermarkung,
    schoener_stein,
    breite_tiefe,
    hoehe,
    jahreszahl,
    wappen,
    richtungskerbe,
    begehung,
    unterhalt,
    unterhaltsarbeit,
    bemerkung,
    foto1,
    foto2,
    string_agg(gemeinde.kanton, ', ' order by kanton) AS kantone,
    string_agg(gemeinde.gemeindename, ', ' order by kanton) AS gemeinden
FROM 
    agi_inventar_hoheitsgrenzen.invntr_hhtsgrnzen_kantonsgrenzstein AS grenzstein
    Left JOIN agi_inventar_hoheitsgrenzen.invntr_hhtsgrnzen_gemeinde_hoheitsgrenzstein AS grenzstein_gemeinde
        ON grenzstein.t_id = grenzstein_gemeinde.stein
    Left JOIN agi_inventar_hoheitsgrenzen.invntr_hhtsgrnzen_gemeinde AS gemeinde
        ON grenzstein_gemeinde.gemeinde = gemeinde.t_id
GROUP BY
    geometrie,
    steinnummer,
    vermarkung,
    schoener_stein,
    breite_tiefe,
    hoehe,
    jahreszahl,
    wappen,
    richtungskerbe,
    begehung,
    unterhalt,
    unterhaltsarbeit,
    bemerkung,
    foto1,
    foto2
;
