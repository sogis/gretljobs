CREATE TABLE if not exists ekat2015.ug_masch_gh_eq_masch(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision,
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_masch_gh_eq_masch_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_masch_gh_eq_masch
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_masch_gh_eq_masch TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_masch_gh_eq_masch TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_masch_gh_eq_masch TO mspublic;
COMMENT ON TABLE ekat2015.ug_masch_gh_eq_masch
  IS 'Emissionen der Emissionsquelle Maschinen Garten und Hobby aus der Untergruppe Maschinen in Garten und Hobby';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_masch.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_masch.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_masch.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_masch.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_masch.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_masch.emiss_co IS 'CO-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_masch.emiss_co2 IS 'CO2-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_masch.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_masch.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_masch_gh_eq_mot_hh_dies(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision,
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_nmvoc double precision,
  emiss_pm10 double precision, 
  emiss_so2 double precision, 
  emiss_ch4 double precision, 
  emiss_nh3 double precision, 
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_masch_gh_eq_mot_hh_dies_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_masch_gh_eq_mot_hh_dies
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_masch_gh_eq_mot_hh_dies TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_masch_gh_eq_mot_hh_dies TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_masch_gh_eq_mot_hh_dies TO mspublic;
COMMENT ON TABLE ekat2015.ug_masch_gh_eq_mot_hh_dies
  IS 'Emissionen der Emissionsquelle Motoren Haushalte; Diesel aus der Untergruppe Maschinen in Garten und Hobby';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.emiss_co IS 'CO-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.emiss_co2 IS 'CO2-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.emiss_pm10 IS 'PM10-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.emiss_so2 IS 'SO2-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.emiss_ch4 IS 'CH4-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.emiss_nh3 IS 'NH3-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_dies.emiss_n2o IS 'N2O-Emissionen in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_masch_gh_eq_mot_hh_gas(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision,
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_nmvoc double precision,
  emiss_pm10 double precision, 
  emiss_so2 double precision, 
  emiss_ch4 double precision,  
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_masch_gh_eq_mot_hh_gas_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_masch_gh_eq_mot_hh_gas
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_masch_gh_eq_mot_hh_gas TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_masch_gh_eq_mot_hh_gas TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_masch_gh_eq_mot_hh_gas TO mspublic;
COMMENT ON TABLE ekat2015.ug_masch_gh_eq_mot_hh_gas
  IS 'Emissionen der Emissionsquelle Motoren Haushalte; Gas aus der Untergruppe Maschinen in Garten und Hobby';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.emiss_co IS 'CO-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.emiss_co2 IS 'CO2-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.emiss_pm10 IS 'PM10-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.emiss_so2 IS 'SO2-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.emiss_ch4 IS 'CH4-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_eq_mot_hh_gas.emiss_n2o IS 'N2O-Emissionen in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_masch_gh_gesamt(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision,
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_nmvoc double precision,
  emiss_pm10 double precision, 
  emiss_so2 double precision, 
  emiss_ch4 double precision, 
  emiss_nh3 double precision, 
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_masch_gh_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_masch_gh_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_masch_gh_gesamt TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_masch_gh_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_masch_gh_gesamt TO mspublic;
COMMENT ON TABLE ekat2015.ug_masch_gh_gesamt
  IS 'Emissionen der Untergruppe Maschinen in Garten und Hobby';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_masch_gh_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_co double precision,
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_nmvoc double precision,
  emiss_pm10 double precision, 
  emiss_so2 double precision, 
  emiss_ch4 double precision, 
  emiss_nh3 double precision, 
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_masch_gh_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_masch_gh_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_masch_gh_gesamt_gem TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_masch_gh_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_masch_gh_gesamt_gem TO public;
COMMENT ON TABLE ekat2015.ug_masch_gh_gesamt_gem 
  IS 'Emissionen der Untergruppe Maschinen in Garten und Hobby';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt_gem.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt_gem.emiss_co IS 'CO-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt_gem.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt_gem.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt_gem.emiss_pm10 IS 'PM10-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt_gem.emiss_co2 IS 'CO2-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt_gem.emiss_nh3 IS 'NH3-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt_gem.emiss_n2o IS 'N2O-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt_gem.emiss_ch4 IS 'CH4-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_masch_gh_gesamt_gem.emiss_so2 IS 'SO2-Emissionen in kg/a je Ha-Raster';
