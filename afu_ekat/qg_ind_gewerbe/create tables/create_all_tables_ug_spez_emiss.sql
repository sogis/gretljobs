CREATE TABLE if not exists ekat2015.ug_spez_emiss_eq_geb_rein(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_spez_emiss_eq_geb_rein_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_emiss_eq_geb_rein
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_emiss_eq_geb_rein TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_geb_rein TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_geb_rein TO public;
COMMENT ON TABLE ekat2015.ug_spez_emiss_eq_geb_rein
   IS 'Emissionen der Emissionsquelle Gebäudereinigung Industrie/ Gewerbe/ Dienstleistung aus der Untergruppe Spezielle Emissionen ';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_geb_rein.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_geb_rein.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_geb_rein.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_geb_rein.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_geb_rein.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_geb_rein.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_emiss_eq_holzschutz_anw(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_spez_emiss_eq_holzschutz_anw_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_emiss_eq_holzschutz_anw
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_emiss_eq_holzschutz_anw TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_holzschutz_anw TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_holzschutz_anw TO public;
COMMENT ON TABLE ekat2015.ug_spez_emiss_eq_holzschutz_anw
   IS 'Emissionen der Emissionsquelle Holzschutzmittel-Anwendung aus der Untergruppe Spezielle Emissionen';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_holzschutz_anw.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_holzschutz_anw.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_holzschutz_anw.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_holzschutz_anw.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_holzschutz_anw.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_holzschutz_anw.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_emiss_eq_klebst_anw(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_spez_emiss_eq_klebst_anw_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_emiss_eq_klebst_anw
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_emiss_eq_klebst_anw TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_klebst_anw TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_klebst_anw TO public;
COMMENT ON TABLE ekat2015.ug_spez_emiss_eq_klebst_anw
   IS 'Emissionen der Emissionsquelle Klebstoffanwendung aus der Untergruppe Spezielle Emissionen ';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_klebst_anw.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_klebst_anw.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_klebst_anw.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_klebst_anw.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_klebst_anw.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_klebst_anw.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_spez_emiss_eq_loesmittel_ind_gew_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew TO public;
COMMENT ON TABLE ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew
   IS 'Emissionen der Emissionsquelle Lösungsmittel in Industrie und Gewerbe aus der Untergruppe Spezielle Emissionen ';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_loesmittel_ind_gew.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_emiss_eq_rein_ind_uebrige(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_spez_emiss_eq_rein_ind_uebrige_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_emiss_eq_rein_ind_uebrige
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_emiss_eq_rein_ind_uebrige TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_rein_ind_uebrige TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_rein_ind_uebrige TO public;
COMMENT ON TABLE ekat2015.ug_spez_emiss_eq_rein_ind_uebrige
   IS 'Emissionen der Emissionsquelle Reinigung Industrie übrige aus der Untergruppe Spezielle Emissionen ';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_rein_ind_uebrige.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_rein_ind_uebrige.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_rein_ind_uebrige.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_rein_ind_uebrige.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_rein_ind_uebrige.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_rein_ind_uebrige.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_emiss_eq_spray(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_spez_emiss_eq_spray_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_emiss_eq_spray
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_emiss_eq_spray TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_spray TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_eq_spray TO public;
COMMENT ON TABLE ekat2015.ug_spez_emiss_eq_spray
   IS 'Emissionen der Emissionsquelle Spraydosen Industrie/ Gewerbe aus der Untergruppe Spezielle Emissionen ';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_spray.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_spray.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_spray.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_spray.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_spray.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_eq_spray.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_emiss_gesamt(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_spez_emiss_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_emiss_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_emiss_gesamt TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_gesamt TO public;
COMMENT ON TABLE ekat2015.ug_spez_emiss_gesamt
   IS 'Emissionen der Untergruppe Spezielle Emissionen';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_gesamt.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_spez_emiss_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_spez_emiss_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_spez_emiss_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_spez_emiss_gesamt_gem TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_spez_emiss_gesamt_gem TO public;
COMMENT ON TABLE ekat2015.ug_spez_emiss_gesamt_gem
   IS 'Emissionen der Untergruppe Spezielle Emissionen aufaddiert auf Gemeinden';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_gesamt_gem.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_spez_emiss_gesamt_gem.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
