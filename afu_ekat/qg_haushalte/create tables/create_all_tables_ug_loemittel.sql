CREATE TABLE if not exists ekat2015.ug_loemittel_eq_farbanw(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_loemittel_eq_farbanw_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_loemittel_eq_farbanw
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_loemittel_eq_farbanw TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_eq_farbanw TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_eq_farbanw TO mspublic;
COMMENT ON TABLE ekat2015.ug_loemittel_eq_farbanw
  IS 'Emissionen der Emissionsquelle Farbanwendung Haushalte aus der Untergruppe Lösungsmittel ';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_farbanw.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_farbanw.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_farbanw.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_farbanw.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_farbanw.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_farbanw.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_loemittel_eq_pharma(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_loemittel_eq_pharma_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_loemittel_eq_pharma
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_loemittel_eq_pharma TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_eq_pharma TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_eq_pharma TO mspublic;
COMMENT ON TABLE ekat2015.ug_loemittel_eq_pharma
  IS 'Emissionen der Emissionsquelle Pharma-Produkte im Haushalt aus der Untergruppe Lösungsmittel ';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_pharma.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_pharma.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_pharma.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_pharma.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_pharma.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_pharma.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_loemittel_eq_reiloe_mittel(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_loemittel_eq_reiloe_mittel_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_loemittel_eq_reiloe_mittel
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_loemittel_eq_reiloe_mittel TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_eq_reiloe_mittel TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_eq_reiloe_mittel TO mspublic;
COMMENT ON TABLE ekat2015.ug_loemittel_eq_reiloe_mittel
  IS 'Emissionen der Emissionsquelle Reinigungs- und Lösungsmittel Haushalte aus der Untergruppe Lösungsmittel ';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_reiloe_mittel.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_reiloe_mittel.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_reiloe_mittel.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_reiloe_mittel.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_reiloe_mittel.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_reiloe_mittel.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_loemittel_eq_spraydosen(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_loemittel_eq_spraydosen_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_loemittel_eq_spraydosen
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_loemittel_eq_spraydosen TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_eq_spraydosen TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_eq_spraydosen TO mspublic;
COMMENT ON TABLE ekat2015.ug_loemittel_eq_spraydosen
  IS 'Emissionen der Emissionsquelle Spraydosen Haushalte aus der Untergruppe Lösungsmittel ';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_spraydosen.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_spraydosen.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_spraydosen.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_spraydosen.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_spraydosen.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_loemittel_eq_spraydosen.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_loemittel_gesamt(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_loemittel_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_loemittel_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_loemittel_gesamt TO sogis_admin;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_gesamt TO mspublic;
COMMENT ON TABLE ekat2015.ug_loemittel_gesamt
  IS 'Emissionen der Untergruppe Lösungsmittel';
COMMENT ON COLUMN ekat2015.ug_loemittel_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_loemittel_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_loemittel_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_loemittel_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_loemittel_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_loemittel_gesamt.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_loemittel_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_nmvoc double precision,
  CONSTRAINT ekat2015_ug_loemittel_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_loemittel_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_loemittel_gesamt_gem TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_loemittel_gesamt_gem TO public;
COMMENT ON TABLE ekat2015.ug_loemittel_gesamt_gem 
  IS 'Emissionen der Untergruppe Lösungsmittel';
COMMENT ON COLUMN ekat2015.ug_loemittel_gesamt_gem.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2015.ug_loemittel_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_loemittel_gesamt_gem.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
