-- in der GELAN-Datenbasis sind oft 2 Jahre vorhanden: Vorjahr/aktuelles Jahr
--   resp. aktuelles Jahr und kommendes Jahr
-- Bis Ende Februar werden noch die GELAN-Daten mit bezugsjahr=Vorjahr verwendet
-- die anderen Daten werden gelöscht
-- ab März werden die alten Daten aus dem Vorjahr gelöscht

-- die Daten müssen wegen Fremdschlüssel-Beziehungen in der richtigen Reihenfolge gelöscht werden

-- zuerst summe_tiere_flaechen loeschen
WITH nmonth AS (
   -- Aktueller Monat wird extrahiert
   SELECT date_part('month',now()) AS nmonth
),
bj AS (
   SELECT
     -- falls Monat kleiner als März (3) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN nmonth < 3 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM nmonth
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_summe_tiere_flaechen
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- dann kultur_flaechen
WITH nmonth AS (
   -- Aktueller Monat wird extrahiert
  SELECT date_part('month',now()) AS nmonth
),
bj AS (
   SELECT
     -- falls Monat kleiner als März (3) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN nmonth < 3 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM nmonth
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_kultur_flaechen
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- dann kultur_punktelemente
WITH nmonth AS (
   -- Aktueller Monat wird extrahiert
  SELECT date_part('month',now()) AS nmonth
),
bj AS (
   SELECT
     -- falls Monat kleiner als März (3) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN nmonth < 3 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM nmonth
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_kultur_punktelemente
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- kulturenkatalog
WITH nmonth AS (
   -- Aktueller Monat wird extrahiert
  SELECT date_part('month',now()) AS nmonth
),
bj AS (
   SELECT
     -- falls Monat kleiner als März (3) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN nmonth < 3 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM nmonth
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_kulturenkatalog
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- bff_qualitaet
WITH nmonth AS (
   -- Aktueller Monat wird extrahiert
  SELECT date_part('month',now()) AS nmonth
),
bj AS (
   SELECT
     -- falls Monat kleiner als März (3) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN nmonth < 3 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM nmonth
)
DELETE
    FROM ${DB_Schema_MJPNL}.bff_qualitaet_bff_qualitaet
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- bewirtschaftungseinheit
WITH nmonth AS (
   -- Aktueller Monat wird extrahiert
  SELECT date_part('month',now()) AS nmonth
),
bj AS (
   SELECT
     -- falls Monat kleiner als März (3) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN nmonth < 3 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM nmonth
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- standorte
WITH nmonth AS (
   -- Aktueller Monat wird extrahiert
  SELECT date_part('month',now()) AS nmonth
),
bj AS (
   SELECT
     -- falls Monat kleiner als März (3) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN nmonth < 3 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM nmonth
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_standorte
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- bewirtschaftungseinheit
WITH nmonth AS (
   -- Aktueller Monat wird extrahiert
  SELECT date_part('month',now()) AS nmonth
),
bj AS (
   SELECT
     -- falls Monat kleiner als März (3) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN nmonth < 3 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM nmonth
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- betrieb
WITH nmonth AS (
   -- Aktueller Monat wird extrahiert
  SELECT date_part('month',now()) AS nmonth
),
bj AS (
   SELECT
     -- falls Monat kleiner als März (3) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN nmonth < 3 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM nmonth
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_betrieb
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;
