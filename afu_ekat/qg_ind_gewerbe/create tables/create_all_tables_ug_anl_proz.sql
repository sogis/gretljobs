CREATE TABLE if not exists ekat2015.ug_anl_proz_eq_baumasch_aufw(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_pm10 double precision,
  CONSTRAINT ekat2015_ug_anl_proz_eq_baumasch_aufw_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_anl_proz_eq_baumasch_aufw
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_anl_proz_eq_baumasch_aufw TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_eq_baumasch_aufw TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_eq_baumasch_aufw TO public;
COMMENT ON TABLE ekat2015.ug_anl_proz_eq_baumasch_aufw
   IS 'Emissionen der Emissionsquelle Baumaschinen Aufwirbelung, Kupplungsabrieb, Reifenabrieb aus der Untergruppe Anlagen und Prozesse';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_baumasch_aufw.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_baumasch_aufw.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_baumasch_aufw.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_baumasch_aufw.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_baumasch_aufw.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_baumasch_aufw.emiss_pm10 IS 'PM10-Emissionen in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_anl_proz_eq_dachpa_verl(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_anl_proz_eq_dachpa_verl_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_anl_proz_eq_dachpa_verl
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_anl_proz_eq_dachpa_verl TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_eq_dachpa_verl TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_eq_dachpa_verl TO public;
COMMENT ON TABLE ekat2015.ug_anl_proz_eq_dachpa_verl
   IS 'Emissionen der Emissionsquelle Dachpappenverlegung aus der Untergruppe Anlagen und Prozesse';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_dachpa_verl.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_dachpa_verl.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_dachpa_verl.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_dachpa_verl.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_dachpa_verl.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_dachpa_verl.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_anl_proz_eq_ind_aufw(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_pm10 double precision,
  CONSTRAINT ekat2015_ug_anl_proz_eq_ind_aufw_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_anl_proz_eq_ind_aufw
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_anl_proz_eq_ind_aufw TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_eq_ind_aufw TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_eq_ind_aufw TO public;
COMMENT ON TABLE ekat2015.ug_anl_proz_eq_ind_aufw
   IS 'Emissionen der Emissionsquelle Industrie Aufwirbelung, Bremsabrieb, Reifenabrieb aus der Untergruppe Anlagen und Prozesse';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_ind_aufw.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_ind_aufw.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_ind_aufw.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_ind_aufw.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_ind_aufw.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_ind_aufw.emiss_pm10 IS 'PM10-Emissionen in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_anl_proz_eq_met_rein(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_anl_proz_eq_met_rein_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_anl_proz_eq_met_rein
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_anl_proz_eq_met_rein TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_eq_met_rein TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_eq_met_rein TO public;
COMMENT ON TABLE ekat2015.ug_anl_proz_eq_met_rein
   IS 'Emissionen der Emissionsquelle Metallreinigung  aus der Untergruppe Anlagen und Prozesse ';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_met_rein.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_met_rein.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_met_rein.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_met_rein.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_met_rein.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_anl_proz_eq_met_rein.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_anl_proz_gesamt(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision,
  emiss_pm10 double precision,
  CONSTRAINT ekat2015_ug_anl_proz_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_anl_proz_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_anl_proz_gesamt TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_gesamt TO public;
COMMENT ON TABLE ekat2015.ug_anl_proz_gesamt
   IS 'Emissionen der Untergruppe Industrie und Gewerbe';
COMMENT ON COLUMN ekat2015.ug_anl_proz_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_anl_proz_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_anl_proz_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_anl_proz_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_anl_proz_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_anl_proz_gesamt.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2010.ug_anl_proz_gesamt.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_anl_proz_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_nmvoc double precision,
  emiss_pm10 double precision,
  CONSTRAINT ekat2015_ug_anl_proz_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_anl_proz_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_anl_proz_gesamt_gem TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_anl_proz_gesamt_gem TO public;
COMMENT ON TABLE ekat2015.ug_anl_proz_gesamt_gem
   IS 'Emissionen der Untergruppe Industrie und Gewerbe aufaddiert auf Gemeinden';
COMMENT ON COLUMN ekat2010.ug_anl_proz_gesamt_gem.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2010.ug_anl_proz_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2010.ug_anl_proz_gesamt_gem.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2010.ug_anl_proz_gesamt_gem.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';

