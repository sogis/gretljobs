CREATE TABLE if not exists ekat2015.ug_waelder_eq_laub(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision, 
  emiss_nmvoc double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_ug_waelder_eq_laub_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_waelder_eq_laub
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_waelder_eq_laub TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_waelder_eq_laub TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_waelder_eq_laub TO public;
COMMENT ON TABLE ekat2015.ug_waelder_eq_laub
   IS 'Emissionen der Emissionsquelle Laubwald aus der Untergruppe Wälder';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laub.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laub.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laub.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laub.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laub.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laub.emiss_nox IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laub.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laub.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laub.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_waelder_eq_laubmisch(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision, 
  emiss_nmvoc double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_ug_waelder_eq_laubmisch_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_waelder_eq_laubmisch
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_waelder_eq_laubmisch TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_waelder_eq_laubmisch TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_waelder_eq_laubmisch TO public;
COMMENT ON TABLE ekat2015.ug_waelder_eq_laubmisch
   IS 'Emissionen der Emissionsquelle Laubmischwald aus der Untergruppe Wälder';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laubmisch.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laubmisch.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laubmisch.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laubmisch.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laubmisch.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laubmisch.emiss_nox IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laubmisch.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laubmisch.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_laubmisch.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_waelder_eq_nadel(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision, 
  emiss_nmvoc double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_ug_waelder_eq_nadel_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_waelder_eq_nadel
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_waelder_eq_nadel TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_waelder_eq_nadel TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_waelder_eq_nadel TO public;
COMMENT ON TABLE ekat2015.ug_waelder_eq_nadel
   IS 'Emissionen der Emissionsquelle Nadelwald aus der Untergruppe Wälder';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadel.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadel.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadel.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadel.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadel.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadel.emiss_nox IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadel.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadel.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadel.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_waelder_eq_nadelmisch(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision, 
  emiss_nmvoc double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_ug_waelder_eq_nadelmisch_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_waelder_eq_nadelmisch
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_waelder_eq_nadelmisch TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_waelder_eq_nadelmisch TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_waelder_eq_nadelmisch TO public;
COMMENT ON TABLE ekat2015.ug_waelder_eq_nadelmisch
   IS 'Emissionen der Emissionsquelle Nadelmischwald aus der Untergruppe Wälder';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadelmisch.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadelmisch.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadelmisch.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadelmisch.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadelmisch.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadelmisch.emiss_nox IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadelmisch.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadelmisch.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_eq_nadelmisch.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_waelder_gesamt(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision,
  emiss_nmvoc double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_ug_waelder_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_waelder_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_waelder_gesamt TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_waelder_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_waelder_gesamt TO mspublic;
COMMENT ON TABLE ekat2015.ug_waelder_gesamt
  IS 'Emissionen der Untergruppe Wälder';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt.emiss_ch4 IS 'CH4-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt.emiss_n2o IS 'N2O-Emissionen in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_waelder_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_nox double precision,
  emiss_nmvoc double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_ug_waelder_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_waelder_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_waelder_gesamt_gem TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_waelder_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_waelder_gesamt_gem TO mspublic;
COMMENT ON TABLE ekat2015.ug_waelder_gesamt_gem
  IS 'Emissionen der Untergruppe Gewässer je Gemeinde';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt_gem.gmde IS 'Gemeinde';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt_gem.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt_gem.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Gemeinde';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt_gem.emiss_ch4 IS 'CH4-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt_gem.emiss_n2o IS 'N2O-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_waelder_gesamt_gem.emiss_n2o IS 'N2O-Emissionen in kg/a je Ha-Raster';

