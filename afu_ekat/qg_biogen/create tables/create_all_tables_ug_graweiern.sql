CREATE TABLE if not exists ekat2015.ug_graweiern_eq_bodenemissionen(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_graweiern_eq_bodenemissionen_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_graweiern_eq_bodenemissionen
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_graweiern_eq_bodenemissionen TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_graweiern_eq_bodenemissionen TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_graweiern_eq_bodenemissionen TO public;
COMMENT ON TABLE ekat2015.ug_graweiern_eq_bodenemissionen
   IS 'Emissionen der Emissionsquelle Bodenemissionen aus der Untergruppe Natürliche Grasflächen, Weiden, natürliche Emissionen aus Ernteverlusten';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_bodenemissionen.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_bodenemissionen.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_bodenemissionen.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_bodenemissionen.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_bodenemissionen.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_bodenemissionen.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_graweiern_eq_gras(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  emiss_nh3 double precision, 
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_graweiern_eq_gras_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_graweiern_eq_gras
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_graweiern_eq_gras TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_graweiern_eq_gras TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_graweiern_eq_gras TO public;
COMMENT ON TABLE ekat2015.ug_graweiern_eq_gras
   IS 'Emissionen der Emissionsquelle Grasflächen aus der Untergruppe Natürliche Grasflächen, Weiden, natürliche Emissionen aus Ernteverlusten';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_gras.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_gras.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_gras.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_gras.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_gras.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_gras.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_gras.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_gras.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_gras.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_gras.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_graweiern_eq_weide(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  emiss_nh3 double precision, 
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_graweiern_eq_weide_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_graweiern_eq_weide
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_graweiern_eq_weide TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_graweiern_eq_weide TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_graweiern_eq_weide TO public;
COMMENT ON TABLE ekat2015.ug_graweiern_eq_weide
   IS 'Emissionen der Emissionsquelle Weiden aus der Untergruppe Natürliche Grasflächen, Weiden, natürliche Emissionen aus Ernteverlusten';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_weide.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_weide.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_weide.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_weide.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_weide.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_weide.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_weide.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_weide.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_weide.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_eq_weide.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_graweiern_gesamt(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  emiss_nh3 double precision, 
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_graweiern_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_graweiern_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_graweiern_gesamt TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_graweiern_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_graweiern_gesamt TO mspublic;
COMMENT ON TABLE ekat2015.ug_graweiern_gesamt
  IS 'Emissionen der  Untergruppe Natürliche Grasflächen, Weiden, natürliche Emissionen aus Ernteverlusten';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt.emiss_ch4 IS 'CH4-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt.emiss_nh3 IS 'NH3-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt.emiss_n2o IS 'N2O-Emissionen in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_graweiern_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_nox double precision,
  emiss_ch4 double precision, 
  emiss_n2o double precision, 
  emiss_nh3 double precision, 
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_graweiern_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_graweiern_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_graweiern_gesamt_gem TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_graweiern_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_graweiern_gesamt_gem TO mspublic;
COMMENT ON TABLE ekat2015.ug_graweiern_gesamt_gem
  IS 'Emissionen der Untergruppe Gewässer je Gemeinde';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt_gem.gmde IS 'Gemeinde';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt_gem.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt.emiss_nmvoc IS 'NMVOC-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt_gem.emiss_ch4 IS 'CH4-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt_gem.emiss_nh3 IS 'NH3-Emissionen in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_graweiern_gesamt_gem.emiss_n2o IS 'N2O-Emissionen in kg/a je Ha-Raster';

