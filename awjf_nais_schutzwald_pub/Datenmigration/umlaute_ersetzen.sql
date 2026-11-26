-- PostgreSQL: nur die Dateinamen im neuen NaiS-Erfassungsschema bereinigen.
-- Die alte Tabelle awjf_schutzwald_v1.dokument bleibt unverändert.
-- Keine Tabellen oder Funktionen anlegen: SELECT-/UPDATE-Rechte genügen
-- zusätzlich zu den üblichen Schema- und Verbindungsrechten.
-- Zuerst als Vorschau ausführen. Erst nach Prüfung ROLLBACK durch COMMIT ersetzen.
BEGIN;

-- Diese Ausgabe vor der tatsächlichen Umstellung als CSV sichern.
-- Der WITH-Ausdruck ist eine Abfrage, keine temporäre Tabelle.
WITH namen AS (
    SELECT t_id, dokument AS alter_name,
        replace(replace(replace(replace(replace(replace(replace(replace(
            normalize(dokument, NFC), 'Ä', 'AE'), 'Ö', 'OE'), 'Ü', 'UE'), 'ä', 'ae'),
            'ö', 'oe'), 'ü', 'ue'), 'ẞ', 'SS'), 'ß', 'ss') AS neuer_name
    FROM awjf_nais_schutzwald_v1.nais_dokument
)
SELECT
    t_id,
    alter_name,
    neuer_name
FROM namen
WHERE alter_name <> neuer_name
ORDER BY t_id;

-- Zeilenweise Änderung; IDs und alle anderen Attribute bleiben erhalten.
WITH aenderungen AS (
    SELECT t_id, dokument AS alter_name,
        replace(replace(replace(replace(replace(replace(replace(replace(
            normalize(dokument, NFC), 'Ä', 'AE'), 'Ö', 'OE'), 'Ü', 'UE'), 'ä', 'ae'),
            'ö', 'oe'), 'ü', 'ue'), 'ẞ', 'SS'), 'ß', 'ss') AS neuer_name
    FROM awjf_nais_schutzwald_v1.nais_dokument
)
UPDATE awjf_nais_schutzwald_v1.nais_dokument AS d
SET dokument = a.neuer_name
FROM aenderungen AS a
WHERE d.t_id = a.t_id
  AND a.alter_name <> a.neuer_name
RETURNING d.t_id, a.alter_name, d.dokument AS neuer_name;

-- Standard: Probelauf, keine bleibende Datenänderung.
-- Für die tatsächliche Umstellung diese Zeile durch COMMIT; ersetzen.
COMMIT;
--ROLLBACK;
