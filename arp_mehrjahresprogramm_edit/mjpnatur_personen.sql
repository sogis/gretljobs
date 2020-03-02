SELECT 
    "name" AS aname,
    vorname,
    ort AS ortschaft,
    adresse,
    persid AS personenid
FROM mjpnatur.personen
WHERE archive = 0
