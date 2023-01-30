-- in der GELAN-Datenbasis sind oft 2 Jahre vorhanden: Vorjahr/aktuelles Jahr
--   resp. aktuelles Jahr und kommendes Jahr
-- Bis Ende Februar werden noch die GELAN-Daten mit bezugsjahr=Vorjahr verwendet
-- die anderen Daten werden gelöscht
-- ab März werden die alten Daten aus dem Vorjahr gelöscht

-- die Daten müssen wegen Fremdschlüssel-Beziehungen in der richtigen Reihenfolge gelöscht werden

-- zuerst summe_tiere_flaechen loeschen
WITH ndays AS (
   -- Anzahl Tage im aktuellen Jahr werden extrahiert
   SELECT EXTRACT('day' FROM age(now(),(date_part('year',now())::TEXT || '-01-01 00:00:000')::timestamp)) AS ndays
),
bj AS (
   SELECT
     -- falls jünger als Ende Februar (60 Tage) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN ndays < 60 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM ndays
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_summe_tiere_flaechen
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- dann kultur_flaechen
WITH ndays AS (
   -- Anzahl Tage im aktuellen Jahr werden extrahiert
   SELECT EXTRACT('day' FROM age(now(),(date_part('year',now())::TEXT || '-01-01 00:00:000')::timestamp)) AS ndays
),
bj AS (
   SELECT
     -- falls jünger als Ende Februar (60 Tage) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN ndays < 60 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM ndays
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_kultur_flaechen
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- dann kultur_punktelemente
WITH ndays AS (
   -- Anzahl Tage im aktuellen Jahr werden extrahiert
   SELECT EXTRACT('day' FROM age(now(),(date_part('year',now())::TEXT || '-01-01 00:00:000')::timestamp)) AS ndays
),
bj AS (
   SELECT
     -- falls jünger als Ende Februar (60 Tage) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN ndays < 60 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM ndays
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_kultur_punktelemente
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- kulturenkatalog
WITH ndays AS (
   -- Anzahl Tage im aktuellen Jahr werden extrahiert
   SELECT EXTRACT('day' FROM age(now(),(date_part('year',now())::TEXT || '-01-01 00:00:000')::timestamp)) AS ndays
),
bj AS (
   SELECT
     -- falls jünger als Ende Februar (60 Tage) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN ndays < 60 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM ndays
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_kulturenkatalog
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- bewirtschaftungseinheit
WITH ndays AS (
   -- Anzahl Tage im aktuellen Jahr werden extrahiert
   SELECT EXTRACT('day' FROM age(now(),(date_part('year',now())::TEXT || '-01-01 00:00:000')::timestamp)) AS ndays
),
bj AS (
   SELECT
     -- falls jünger als Ende Februar (60 Tage) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN ndays < 60 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM ndays
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- standorte
WITH ndays AS (
   -- Anzahl Tage im aktuellen Jahr werden extrahiert
   SELECT EXTRACT('day' FROM age(now(),(date_part('year',now())::TEXT || '-01-01 00:00:000')::timestamp)) AS ndays
),
bj AS (
   SELECT
     -- falls jünger als Ende Februar (60 Tage) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN ndays < 60 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM ndays
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_standorte
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- bewirtschaftungseinheit
WITH ndays AS (
   -- Anzahl Tage im aktuellen Jahr werden extrahiert
   SELECT EXTRACT('day' FROM age(now(),(date_part('year',now())::TEXT || '-01-01 00:00:000')::timestamp)) AS ndays
),
bj AS (
   SELECT
     -- falls jünger als Ende Februar (60 Tage) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN ndays < 60 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM ndays
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_bewirtschaftungseinheit
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;

-- betrieb
WITH ndays AS (
   -- Anzahl Tage im aktuellen Jahr werden extrahiert
   SELECT EXTRACT('day' FROM age(now(),(date_part('year',now())::TEXT || '-01-01 00:00:000')::timestamp)) AS ndays
),
bj AS (
   SELECT
     -- falls jünger als Ende Februar (60 Tage) werden die Daten des
     -- Vorjahres verwendet
     CASE
         WHEN ndays < 60 THEN 
           date_part('year',now())::int4 - 1
         ELSE date_part('year',now())::int4
     END AS bezugsjahr
   FROM ndays
)
DELETE
    FROM ${DB_Schema_MJPNL}.betrbsdttrktrdten_betrieb
  WHERE
    bezugsjahr != (SELECT bezugsjahr FROM bj)
;
