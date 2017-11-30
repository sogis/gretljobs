CREATE TABLE if not exists ekat2015.ug_gewaesser_eq_feuchtgebiete(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_ug_gewaesser_eq_feuchtgebiete_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_gewaesser_eq_feuchtgebiete
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_gewaesser_eq_feuchtgebiete TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_gewaesser_eq_feuchtgebiete TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_gewaesser_eq_feuchtgebiete TO public;
COMMENT ON TABLE ekat2015.ug_gewaesser_eq_feuchtgebiete
   IS 'Emissionen der Emissionsquelle Feuchtgebiete aus der Untergruppe Gewässer';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_feuchtgebiete.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_feuchtgebiete.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_feuchtgebiete.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_feuchtgebiete.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_feuchtgebiete.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_feuchtgebiete.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_feuchtgebiete.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_feuchtgebiete.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_gewaesser_eq_fluesse(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_ug_gewaesser_eq_fluesse_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_gewaesser_eq_fluesse
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_gewaesser_eq_fluesse TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_gewaesser_eq_fluesse TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_gewaesser_eq_fluesse TO public;
COMMENT ON TABLE ekat2015.ug_gewaesser_eq_fluesse
   IS 'Emissionen der Emissionsquelle Flüsse aus der Untergruppe Gewässer';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_fluesse.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_fluesse.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_fluesse.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_fluesse.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_fluesse.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_fluesse.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_fluesse.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_fluesse.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_gewaesser_eq_seen(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_ug_gewaesser_eq_seen_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_gewaesser_eq_seen
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_gewaesser_eq_seen TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_gewaesser_eq_seen TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_gewaesser_eq_seen TO public;
COMMENT ON TABLE ekat2015.ug_gewaesser_eq_seen
   IS 'Emissionen der Emissionsquelle Seen aus der Untergruppe Gewässer';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_seen.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_seen.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_seen.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_seen.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_seen.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_seen.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_seen.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_gewaesser_eq_seen.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_gewaesser_gesamt(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_ug_gewaesser_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_gewaesser_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_gewaesser_gesamt TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_gewaesser_gesamt TO mspublic;
COMMENT ON TABLE ekat2015.ug_gewaesser_gesamt
  IS 'Emissionen der Untergruppe Gewässer';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_gewaesser_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_nox double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_ug_gewaesser_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_gewaesser_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_gewaesser_gesamt_gem TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_gewaesser_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_gewaesser_gesamt_gem TO mspublic;
COMMENT ON TABLE ekat2015.ug_gewaesser_gesamt_gem
  IS 'Emissionen der Untergruppe Gewässer je Gemeinde';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt_gem.gmde IS 'Gemeinde';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt_gem.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt_gem.emiss_ch4 IS 'CH4-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_gewaesser_gesamt_gem.emiss_n2o IS 'N2O-Emissionen in kg/a je Ha-Raster';
