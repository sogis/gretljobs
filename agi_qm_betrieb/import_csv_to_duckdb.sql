LOAD spatial;

CREATE TABLE geo_doppelte_schemas AS 
SELECT 
    *
FROM 
    '/tmp/qmbetrieb/geo_doppelte_schemas.csv'
;

CREATE TABLE simi_schema_ohne_tabelle AS 
SELECT 
    *
FROM 
    '/tmp/qmbetrieb/simi_schema_ohne_tabelle.csv'
;

CREATE TABLE simi_raster_ohne_datasetview AS 
SELECT 
    *
FROM 
    '/tmp/qmbetrieb/simi_raster_ohne_datasetview.csv'
;

CREATE TABLE simi_table_ohne_tableview AS 
SELECT 
    *
FROM 
    '/tmp/qmbetrieb/simi_table_ohne_tableview.csv'
;

CREATE TABLE diff_kennung_simi_datenabgabe AS 
SELECT 
    *
FROM 
    '/tmp/qmbetrieb/diff_kennung_simi_datenabgabe.csv'
;

CREATE TABLE superflous_publication_formats AS 
SELECT 
    *
FROM 
    '/tmp/qmbetrieb/superflous_publication_formats.csv'
;

CREATE TABLE count_simple_publication_formats AS 
SELECT 
    *
FROM 
    '/tmp/qmbetrieb/count_simple_publication_formats.csv'
;



