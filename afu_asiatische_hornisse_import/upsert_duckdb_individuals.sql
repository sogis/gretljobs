/*
Diese SQL-Query führt unseren Datenbestand mit den heruntergeladenen Daten von infofauna zusammen
mittels UPSERT (INSERT, bei Konflikt UPDATE).
Technischer Hinweis:
Wenn man *immer alle* Zielfelder überschreiben möchte, reicht INSERT OR REPLACE INTO ohne ON CONFLICT.
Aber wir wollen a) die vom AfU geführten Felder nicht überschreiben (massnahmenstatus, bemerkung_massnahme)
und benötigen b) eine WHERE Clause um das UPDATE auf Zeilen einschränken zu können, in denen sich
tatsächlich etwas geändert hat (-> Logging).
*/

INSERT INTO afu_individuals (
    t_ili_tid,
    import_occurrence_id,
    import_unique_nest_id,
    geometrie,
    import_materialentity_id,
    import_datum_sichtung,
    import_ort,
    import_kanton,
    import_x_koordinate,
    import_y_koordinate,
    import_lat,
    import_lon,
    import_bemerkung,
    import_foto_url
)
SELECT
    gen_random_uuid() AS t_ili_tid,  -- neue Records benötigen eine t_ili_tid
    occurence_id,  -- sic!
    nid_unique_id,
    geometrie,
    materialentityid,
    date_decouverte,
    "location",
    canton,
    lv95_east_x,
    lv95_north_y,
    import_lat,
    import_lon,
    remarques,
    "image"
FROM infofauna_individuals
-- Bei Konflikt auf "import_materialentity_id" UPDATE anstatt INSERT
ON CONFLICT (import_materialentity_id)
DO UPDATE SET
	-- Alle importierten Felder überschreiben
    import_occurrence_id = EXCLUDED.import_occurrence_id,
    import_unique_nest_id = EXCLUDED.import_unique_nest_id,
    geometrie = EXCLUDED.geometrie,
    import_datum_sichtung = EXCLUDED.import_datum_sichtung,
    import_ort = EXCLUDED.import_ort,
    import_kanton = EXCLUDED.import_kanton,
    import_x_koordinate = EXCLUDED.import_x_koordinate,
    import_y_koordinate = EXCLUDED.import_y_koordinate,
    import_lat = EXCLUDED.import_lat,
    import_lon = EXCLUDED.import_lon,
    import_bemerkung = EXCLUDED.import_bemerkung,
    import_foto_url = EXCLUDED.import_foto_url
WHERE
    -- UPDATE nur ausführen, wenn sich mindestens ein Wert geändert hat
    import_occurrence_id IS DISTINCT FROM EXCLUDED.import_occurrence_id
    OR import_unique_nest_id IS DISTINCT FROM EXCLUDED.import_unique_nest_id
    OR geometrie IS DISTINCT FROM EXCLUDED.geometrie
    OR import_datum_sichtung IS DISTINCT FROM EXCLUDED.import_datum_sichtung
    OR import_ort IS DISTINCT FROM EXCLUDED.import_ort
    OR import_kanton IS DISTINCT FROM EXCLUDED.import_kanton
    OR import_x_koordinate IS DISTINCT FROM EXCLUDED.import_x_koordinate
    OR import_y_koordinate IS DISTINCT FROM EXCLUDED.import_y_koordinate
    OR import_lat IS DISTINCT FROM EXCLUDED.import_lat
    OR import_lon IS DISTINCT FROM EXCLUDED.import_lon
    OR import_bemerkung IS DISTINCT FROM EXCLUDED.import_bemerkung
    OR import_foto_url IS DISTINCT FROM EXCLUDED.import_foto_url
;