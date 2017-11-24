CREATE TABLE if not exists ekat2015.ug_spez_branch_eq_deponien(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_ch4 double precision,
  CONSTRAINT ekat2015_ug_spez_branch_eq_deponien_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_branch_eq_deponien
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_branch_eq_deponien TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_eq_deponien TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_eq_deponien TO public;
COMMENT ON TABLE ekat2015.ug_spez_branch_eq_deponien
   IS 'Emissionen der Emissionsquelle Deponien aus der Untergruppe Spezielle Branchen';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_deponien.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_deponien.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_deponien.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_deponien.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_deponien.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_deponien.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_branch_eq_gas_vert(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision,
  emiss_ch4 double precision,
  emiss_co2 double precision,
  CONSTRAINT ekat2015_ug_spez_branch_eq_gas_vert_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_branch_eq_gas_vert
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_branch_eq_gas_vert TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_eq_gas_vert TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_eq_gas_vert TO public;
COMMENT ON TABLE ekat2015.ug_spez_branch_eq_gas_vert
   IS 'Emissionen der Emissionsquelle Gasverteilung Erdgas aus der Untergruppe Spezielle Branchen';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_gas_vert.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_gas_vert.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_gas_vert.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_gas_vert.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_gas_vert.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_gas_vert.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_gas_vert.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_gas_vert.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_branch_eq_klaeranl(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co double precision, 
  emiss_nox double precision,
  emiss_so2 double precision,
  emiss_nmvoc double precision,
  emiss_ch4 double precision,
  emiss_nh3 double precision,
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_spez_branch_eq_klaeranl_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_branch_eq_klaeranl
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_branch_eq_klaeranl TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_eq_klaeranl TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_eq_klaeranl TO public;
COMMENT ON TABLE ekat2015.ug_spez_branch_eq_klaeranl
   IS 'Emissionen der Emissionsquelle Kläranlagen aus der Untergruppe Spezielle Branchen';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_klaeranl.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_branch_eq_med_praxen(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_spez_branch_eq_med_praxen_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_branch_eq_med_praxen
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_branch_eq_med_praxen TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_eq_med_praxen TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_eq_med_praxen TO public;
COMMENT ON TABLE ekat2015.ug_spez_branch_eq_med_praxen
   IS 'Emissionen der Emissionsquelle Medizinische Praxen aus der Untergruppe Spezielle Branchen ';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_med_praxen.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_med_praxen.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_med_praxen.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_med_praxen.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_med_praxen.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_branch_eq_med_praxen.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_branch_gesamt(
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
  emiss_nh3 double precision,
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_spez_branch_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_branch_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_branch_gesamt TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_gesamt TO public;
COMMENT ON TABLE ekat2015.ug_spez_branch_gesamt
   IS 'Emissionen der Emissionsquelle Kläranlagen aus der Untergruppe Spezielle Branchen';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_branch_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_co double precision, 
  emiss_co2 double precision,
  emiss_nox double precision,
  emiss_so2 double precision,
  emiss_nmvoc double precision,
  emiss_ch4 double precision,
  emiss_nh3 double precision,
  emiss_n2o double precision,
  CONSTRAINT ekat2015_ug_spez_branch_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_branch_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_branch_gesamt_gem TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_branch_gesamt_gem TO public;
COMMENT ON TABLE ekat2015.ug_spez_branch_gesamt_gem
  IS 'Emissionen der Untergruppe spezielle Branchen aufaddiert auf Gemeinden';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt_gem.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt_gem.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt_gem.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt_gem.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt_gem.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt_gem.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt_gem.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt_gem.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_spez_branch_gesamt_gem.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
