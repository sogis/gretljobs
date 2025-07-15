-- TRIGRAMM SUCHINDEX: DELETE FEATURES for LAYER

DELETE FROM ${db_schema}.feature
WHERE layer_ident = ${layername}
