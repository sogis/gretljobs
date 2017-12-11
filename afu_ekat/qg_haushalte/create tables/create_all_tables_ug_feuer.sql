CREATE TABLE if not exists ekat2015.ug_feuer_eq_alle_nmvoc_nh3(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nh3 double precision, 
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_feuer_eq_alle_nmvoc_nh3_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_feuer_eq_alle_nmvoc_nh3
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_feuer_eq_alle_nmvoc_nh3 TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_alle_nmvoc_nh3 TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_alle_nmvoc_nh3 TO public;
COMMENT ON TABLE ekat2015.ug_feuer_eq_alle_nmvoc_nh3
  IS 'Emissionen der Emissionsquelle Feuerungen Gas und Heizoel für die Schadstoffe NMVOC und NH3 aus der Untergruppe Feuerungen';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_alle_nmvoc_nh3.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_alle_nmvoc_nh3.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_alle_nmvoc_nh3.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_alle_nmvoc_nh3.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_alle_nmvoc_nh3.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_alle_nmvoc_nh3.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_alle_nmvoc_nh3.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_feuer_eq_gas_nach93(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision, 
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_so2 double precision, 
  emiss_n2o double precision,
  emiss_pm10 double precision,
  emiss_ch4 double precision,  
  CONSTRAINT ekat2015_ug_feuer_eq_gas_nach93_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_feuer_eq_gas_nach93
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_feuer_eq_gas_nach93 TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_gas_nach93 TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_gas_nach93 TO public;
COMMENT ON TABLE ekat2015.ug_feuer_eq_gas_nach93
  IS 'Emissionen der Emissionsquelle Feuerungen Gas Brenner nach 1993(Erdgas LowNOx) aus der Untergruppe Feuerungen';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_nach93.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_feuer_eq_gas_vor93(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision, 
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_so2 double precision, 
  emiss_n2o double precision,
  emiss_pm10 double precision,
  emiss_ch4 double precision,  
  CONSTRAINT ekat2015_ug_feuer_eq_gas_vor93_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_feuer_eq_gas_vor93
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_feuer_eq_gas_vor93 TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_gas_vor93 TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_gas_vor93 TO public;
COMMENT ON TABLE ekat2015.ug_feuer_eq_gas_vor93
  IS 'Emissionen der Emissionsquelle Feuerungen Gas Brenner vor 1993(Erdgas LowNOx) aus der Untergruppe Feuerungen';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_gas_vor93.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_feuer_eq_holz_haus(
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
  emiss_ch4 double precision, 
  emiss_nmvoc double precision, 
  emiss_nh3 double precision, 
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_feuer_eq_holz_haus_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_feuer_eq_holz_haus
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_feuer_eq_holz_haus TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_holz_haus TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_holz_haus TO public;
COMMENT ON TABLE ekat2015.ug_feuer_eq_holz_haus
  IS 'Emissionen der Emissionsquelle Feuerungen Holz Hausfeuerungen (HH/DL und LW zusammen) aus der Untergruppe Feuerungen';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_haus.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_feuer_eq_holz_klein(
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
  emiss_ch4 double precision, 
  emiss_nmvoc double precision, 
  emiss_nh3 double precision, 
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_feuer_eq_holz_klein_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_feuer_eq_holz_klein
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_feuer_eq_holz_klein TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_holz_klein TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_holz_klein TO public;
COMMENT ON TABLE ekat2015.ug_feuer_eq_holz_klein
  IS 'Emissionen der Emissionsquelle Feuerungen Holz Kleinfeuerungen (Kachelöfen, Cheminees,etc.) aus der Untergruppe Feuerungen';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_holz_klein.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_feuer_eq_oel_nach93(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision, 
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_so2 double precision, 
  emiss_n2o double precision,
  emiss_pm10 double precision,
  emiss_ch4 double precision, 
  CONSTRAINT ekat2015_ug_feuer_eq_oel_nach93_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_feuer_eq_oel_nach93
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_feuer_eq_oel_nach93 TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_oel_nach93 TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_oel_nach93 TO public;
COMMENT ON TABLE ekat2015.ug_feuer_eq_oel_nach93
  IS 'Emissionen der Emissionsquelle Feuerungen Öl Brenner nach 1993(Heizöl LowNOx) aus der Untergruppe Feuerungen';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_nach93.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_feuer_eq_oel_vor93(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision, 
  emiss_co2 double precision, 
  emiss_nox double precision,
  emiss_so2 double precision, 
  emiss_n2o double precision,
  emiss_pm10 double precision,
  emiss_ch4 double precision, 
  CONSTRAINT ekat2015_ug_feuer_eq_oel_vor93_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_feuer_eq_oel_vor93
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_feuer_eq_oel_vor93 TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_oel_vor93 TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_feuer_eq_oel_vor93 TO public;
COMMENT ON TABLE ekat2015.ug_feuer_eq_oel_vor93
  IS 'Emissionen der Emissionsquelle Feuerungen Öl Brenner vor 1993(Heizöl LowNOx) aus der Untergruppe Feuerungen';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_eq_oel_vor93.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_feuer_gesamt(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision, 
  emiss_nox double precision,
  emiss_n2o double precision,
  emiss_pm10 double precision,
  emiss_co2 double precision, 
  emiss_ch4 double precision, 
  emiss_so2 double precision, 
  emiss_nh3 double precision, 
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_feuer_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_feuer_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_feuer_gesamt TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_feuer_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_feuer_gesamt TO mspublic;
COMMENT ON TABLE ekat2015.ug_feuer_gesamt
  IS 'Emissionen der Untergruppe Feuerungen';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_feuer_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_co double precision, 
  emiss_nox double precision,
  emiss_n2o double precision,
  emiss_pm10 double precision,
  emiss_co2 double precision, 
  emiss_ch4 double precision, 
  emiss_so2 double precision, 
  emiss_nh3 double precision, 
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_feuer_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_feuer_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_feuer_gesamt_gem TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_feuer_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_feuer_gesamt_gem TO mspublic;
COMMENT ON TABLE ekat2015.ug_feuer_gesamt_gem
  IS 'Emissionen der Untergruppe Feuerungen';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt_gem.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt_gem.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt_gem.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt_gem.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt_gem.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt_gem.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt_gem.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt_gem.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt_gem.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_feuer_gesamt_gem.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
