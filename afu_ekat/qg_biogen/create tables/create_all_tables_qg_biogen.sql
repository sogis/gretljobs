CREATE TABLE if not exists ekat2015.qg_biogen(
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
  emiss_pm10 double precision, 
  emiss_nh3 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_qg_biogen_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.qg_biogen
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.qg_biogen TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.qg_biogen TO ekat;
GRANT SELECT ON TABLE ekat2015.qg_biogen TO public;
COMMENT ON TABLE ekat2015.qg_biogen
  IS 'Emissionen der Quellengruppe Biogene Quellen';
COMMENT ON COLUMN ekat2015.qg_biogen.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.qg_biogen.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.qg_biogen.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.qg_biogen.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.qg_biogen.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.qg_biogen.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.qg_biogen_gemeinde(
  gmde integer, 
  bezirk integer, 
  wkb_geometry geometry,
  emiss_co double precision, 
  emiss_co2 double precision, 
  emiss_nox double precision, 
  emiss_so2 double precision, 
  emiss_nmvoc double precision,
  emiss_ch4 double precision, 
  emiss_pm10 double precision, 
  emiss_nh3 double precision, 
  emiss_n2o double precision, 
  CONSTRAINT ekat2015_qg_biogen_gemeinde_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.qg_biogen_gemeinde
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.qg_biogen_gemeinde TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.qg_biogen_gemeinde TO ekat;
GRANT SELECT ON TABLE ekat2015.qg_biogen_gemeinde TO public;
COMMENT ON TABLE ekat2015.qg_biogen_gemeinde
  IS 'Emissionen der Quellengruppe Biogene Quellen aufaddiert auf Gemeinden';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.bezirk IS 'Bezirk-Nr';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.qg_biogen_gemeinde.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';

