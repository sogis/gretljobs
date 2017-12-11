CREATE TABLE if not exists ekat2015.ug_lachgas_hh_gesamt(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_lachgas_hh_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_lachgas_hh_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_lachgas_hh_gesamt TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_lachgas_hh_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_lachgas_hh_gesamt TO mspublic;
COMMENT ON TABLE ekat2015.ug_lachgas_hh_gesamt
  IS 'Emissionen der Emissionsquelle Lachgasanwendung aus der Untergruppe Lachgasanwendung ';
COMMENT ON COLUMN ekat2015.ug_lachgas_hh_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_lachgas_hh_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_lachgas_hh_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_lachgas_hh_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_lachgas_hh_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_lachgas_hh_gesamt.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_lachgas_hh_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_lachgas_hh_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_lachgas_hh_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_lachgas_hh_gesamt_gem TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_lachgas_hh_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_lachgas_hh_gesamt_gem TO public;
COMMENT ON TABLE ekat2015.ug_lachgas_hh_gesamt_gem 
  IS 'Emissionen der Untergruppe Lachgasanwendung Haushalte';
COMMENT ON COLUMN ekat2015.ug_lachgas_hh_gesamt_gem.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2015.ug_lachgas_hh_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_lachgas_hh_gesamt_gem.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
