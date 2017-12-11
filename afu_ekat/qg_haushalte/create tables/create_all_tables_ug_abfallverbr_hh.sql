CREATE TABLE if not exists ekat2015.ug_abfallverbr_hh_eq_abfallverbr(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision, 
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_so2 double precision, 
  emiss_nmvoc double precision, 
  emiss_ch4 double precision, 
  emiss_pm10 double precision, 
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_abfallverbr_hh_eq_abfallverbr_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_abfallverbr_hh_eq_abfallverbr
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_abfallverbr_hh_eq_abfallverbr TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_abfallverbr_hh_eq_abfallverbr TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_abfallverbr_hh_eq_abfallverbr TO public;
COMMENT ON TABLE ekat2015.ug_abfallverbr_hh_eq_abfallverbr
  IS 'Emissionen der Emissionsquelle Abfallverbrennung(illegal) aus der Untergruppe Abfallverbrennung Haushalte';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.emiss_co IS 'CO-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.emiss_co2 IS 'CO2-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.emiss_so2 IS 'SO2-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.emiss_ch4 IS 'CH4-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.emiss_pm10 IS 'PM10-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_abfallverbr.emiss_n2o IS 'N2O-Emissionen in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_abfallverbr_hh_eq_feuwer(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision, 
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_so2 double precision, 
  emiss_pm10 double precision, 
  CONSTRAINT ekat2015_ug_abfallverbr_hh_eq_feuwer_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_abfallverbr_hh_eq_feuwer
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_abfallverbr_hh_eq_feuwer TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_abfallverbr_hh_eq_feuwer TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_abfallverbr_hh_eq_feuwer TO public;
COMMENT ON TABLE ekat2015.ug_abfallverbr_hh_eq_feuwer
  IS 'Emissionen der Emissionsquelle Abfallverbrennung(illegal) aus der Untergruppe Abfallverbrennung Haushalte';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_feuwer.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_feuwer.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_feuwer.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_feuwer.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_feuwer.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_feuwer.emiss_co IS 'CO-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_feuwer.emiss_co2 IS 'CO2-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_feuwer.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_feuwer.emiss_so2 IS 'SO2-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_eq_feuwer.emiss_pm10 IS 'PM10-Emissionen in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_abfallverbr_hh_gesamt(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision, 
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_so2 double precision, 
  emiss_nmvoc double precision, 
  emiss_ch4 double precision, 
  emiss_pm10 double precision, 
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_abfallverbr_hh_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_abfallverbr_hh_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_abfallverbr_hh_gesamt TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_abfallverbr_hh_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_abfallverbr_hh_gesamt TO mspublic;
COMMENT ON TABLE ekat2015.ug_abfallverbr_hh_gesamt
  IS 'Emissionen der Untergruppe Abfallverbrennung';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_abfallverbr_hh_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_co double precision, 
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_so2 double precision, 
  emiss_nmvoc double precision, 
  emiss_ch4 double precision, 
  emiss_pm10 double precision, 
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_abfallverbr_hh_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_abfallverbr_hh_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_abfallverbr_hh_gesamt_gem TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_abfallverbr_hh_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_abfallverbr_hh_gesamt_gem TO public;
COMMENT ON TABLE ekat2015.ug_abfallverbr_hh_gesamt_gem 
  IS 'Emissionen der Untergruppe Abfallverbrennung';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt_gem.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt_gem.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt_gem.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt_gem.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt_gem.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt_gem.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt_gem.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt_gem.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_abfallverbr_hh_gesamt_gem.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';



