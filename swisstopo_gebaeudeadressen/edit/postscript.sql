COMMENT ON SCHEMA
   swisstopo_gebaeudeadressen
IS
   'Dieses Schema wird für den Import des amtlichen Verzeichnisses der Gebäudeadressen verwendet. Fragen: stefan.ziegler@bd.so.ch.'
;
GRANT USAGE ON SCHEMA swisstopo_gebaeudeadressen TO public, ogc_server, sogis_service, gretl
;
GRANT SELECT ON ALL TABLES IN SCHEMA swisstopo_gebaeudeadressen TO public, ogc_server, sogis_service
;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA swisstopo_gebaeudeadressen TO gretl
;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA swisstopo_gebaeudeadressen TO gretl
;