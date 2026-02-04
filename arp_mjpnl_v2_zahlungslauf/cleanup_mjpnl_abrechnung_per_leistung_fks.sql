-- alle übrigen leistungen (die einmaligen, oder bereits ausbezahlten) möchten wir vom CASCADE delete bewahren, also FK auf NULL setzen
UPDATE
    ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung 
SET abrechnungpervereinbarung = NULL
WHERE 
    auszahlungsjahr = ${AUSZAHLUNGSJAHR}::integer;