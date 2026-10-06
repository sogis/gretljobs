ALTER TABLE
	temp_db.schema_objekte_historisch.bodenbedeckung
ADD COLUMN IF NOT EXISTS
	geometrie_wkt VARCHAR;

ALTER TABLE
	temp_db.schema_objekte_historisch.einzelobjekt_flaeche
ADD COLUMN IF NOT EXISTS
	geometrie_wkt VARCHAR;