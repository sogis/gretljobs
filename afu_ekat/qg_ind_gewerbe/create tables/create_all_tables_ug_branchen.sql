CREATE TABLE if not exists ekat2015.ug_branchen_eq_benz_um_tklag(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_co2 double precision,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_branchen_eq_benz_um_tklag_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_branchen_eq_benz_um_tklag
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_branchen_eq_benz_um_tklag TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_benz_um_tklag TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_benz_um_tklag TO public;
COMMENT ON TABLE ekat2015.ug_branchen_eq_benz_um_tklag
   IS 'Emissionen der Emissionsquelle Benzinumschlag; Tanklager  aus der Untergruppe Branchen ';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_benz_um_tklag.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_benz_um_tklag.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_benz_um_tklag.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_benz_um_tklag.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_benz_um_tklag.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_benz_um_tklag.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_benz_um_tklag.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_branchen_eq_coiff_salons(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_branchen_eq_coiff_salons_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_branchen_eq_coiff_salons
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_branchen_eq_coiff_salons TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_coiff_salons TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_coiff_salons TO public;
COMMENT ON TABLE ekat2015.ug_branchen_eq_coiff_salons
   IS 'Emissionen der Emissionsquelle Coiffeursalons aus der Untergruppe Branchen ';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_coiff_salons.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_coiff_salons.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_coiff_salons.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_coiff_salons.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_coiff_salons.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_coiff_salons.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_branchen_eq_farbanw_bau(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_branchen_eq_farbanw_bau_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_branchen_eq_farbanw_bau
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_branchen_eq_farbanw_bau TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_farbanw_bau TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_farbanw_bau TO public;
COMMENT ON TABLE ekat2015.ug_branchen_eq_farbanw_bau
   IS 'Emissionen der Emissionsquelle Farbanwendung Bau aus der Untergruppe Branchen ';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_farbanw_bau.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_farbanw_bau.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_farbanw_bau.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_farbanw_bau.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_farbanw_bau.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_farbanw_bau.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_branchen_eq_holzbearb(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_pm10 double precision, 
  CONSTRAINT ekat2015_ug_branchen_eq_holzbearb_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_branchen_eq_holzbearb
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_branchen_eq_holzbearb TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_holzbearb TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_holzbearb TO public;
COMMENT ON TABLE ekat2015.ug_branchen_eq_holzbearb
   IS 'Emissionen der Emissionsquelle Holzbearbeitung aus der Untergruppe Branchen ';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_holzbearb.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_holzbearb.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_holzbearb.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_holzbearb.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_holzbearb.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_holzbearb.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_branchen_eq_klebst_prod(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_branchen_eq_klebst_prod_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_branchen_eq_klebst_prod
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_branchen_eq_klebst_prod TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_klebst_prod TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_klebst_prod TO public;
COMMENT ON TABLE ekat2015.ug_branchen_eq_klebst_prod
   IS 'Emissionen der Emissionsquelle Klebstoff-Produktion aus der Untergruppe Branchen ';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_klebst_prod.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_klebst_prod.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_klebst_prod.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_klebst_prod.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_klebst_prod.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_klebst_prod.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_branchen_eq_kosm_inst(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_branchen_eq_kosm_inst_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_branchen_eq_kosm_inst
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_branchen_eq_kosm_inst TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_kosm_inst TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_kosm_inst TO public;
COMMENT ON TABLE ekat2015.ug_branchen_eq_kosm_inst
   IS 'Emissionen der Emissionsquelle Kosmetik-Institute aus der Untergruppe Branchen ';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_kosm_inst.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_kosm_inst.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_kosm_inst.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_kosm_inst.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_kosm_inst.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_kosm_inst.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_branchen_eq_str_bel_arb(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_branchen_eq_str_bel_arb_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_branchen_eq_str_bel_arb
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_branchen_eq_str_bel_arb TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_str_bel_arb TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_str_bel_arb TO public;
COMMENT ON TABLE ekat2015.ug_branchen_eq_str_bel_arb
   IS 'Emissionen der Emissionsquelle Strassenbelagsarbeiten aus der Untergruppe Branchen ';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_str_bel_arb.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_str_bel_arb.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_str_bel_arb.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_str_bel_arb.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_str_bel_arb.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_str_bel_arb.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_branchen_eq_uebr_ges_wes(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  CONSTRAINT ekat2015_ug_branchen_eq_uebr_ges_wes_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_branchen_eq_uebr_ges_wes
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_branchen_eq_uebr_ges_wes TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_uebr_ges_wes TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_branchen_eq_uebr_ges_wes TO public;
COMMENT ON TABLE ekat2015.ug_branchen_eq_uebr_ges_wes
   IS 'Emissionen der Emissionsquelle Gesundheitswesen, übrige aus der Untergruppe Branchen ';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_uebr_ges_wes.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_uebr_ges_wes.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_uebr_ges_wes.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_uebr_ges_wes.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_uebr_ges_wes.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_branchen_eq_uebr_ges_wes.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';


CREATE TABLE if not exists ekat2015.ug_branchen_gesamt(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nmvoc double precision, 
  emiss_pm10 double precision,
  emiss_co2 double precision,
  CONSTRAINT ekat2015_ug_branchen_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_branchen_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_branchen_gesamt TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_branchen_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_branchen_gesamt TO public;
COMMENT ON TABLE ekat2015.ug_branchen_gesamt
   IS 'Emissionen der Untergruppe Branchen';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_branchen_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_nmvoc double precision, 
  emiss_pm10 double precision,
  emiss_co2 double precision,
  CONSTRAINT ekat2015_ug_branchen_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_branchen_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_branchen_gesamt_gem TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_branchen_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_branchen_gesamt_gem TO public;
COMMENT ON TABLE ekat2015.ug_branchen_gesamt_gem
   IS 'Emissionen der Untergruppe Branchen aufaddiert auf Gemeinden';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt_gem.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt_gem.wkb_geometry IS 'Geometrie des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt_gem.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt_gem.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_branchen_gesamt_gem.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';