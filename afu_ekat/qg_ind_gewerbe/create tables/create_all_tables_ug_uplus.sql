CREATE TABLE if not exists ekat2015.ug_uplus_eq_flaeche(
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
  emiss_xkw double precision, 
  CONSTRAINT ekat2015_ug_uplus_eq_flaeche_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_uplus_eq_flaeche
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_uplus_eq_flaeche TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_uplus_eq_flaeche TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_uplus_eq_flaeche TO public;
COMMENT ON TABLE ekat2015.ug_uplus_eq_flaeche
  IS 'Emissionen aus der Untergruppe UPlus Emissionsquelle Baumaschinen Fläche (Die Gesamtfläche der Maske intersec_bdbed_wohnzone_landw_ha_raster wurde ermittelt und statisch eingetragen. Grund: Die dynamische Ermittlung dauert 7 Sekunden. Dadurch wird die Performance des Views unbrauchbar. ';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_flaeche.emiss_xkw IS 'XKW-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_uplus_eq_punktemiss(
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
  emiss_xkw double precision, 
  CONSTRAINT ekat2015_ug_uplus_eq_punktemiss_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_uplus_eq_punktemiss
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_uplus_eq_punktemiss TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_uplus_eq_punktemiss TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_uplus_eq_punktemiss TO public;
COMMENT ON TABLE ekat2015.ug_uplus_eq_punktemiss
  IS 'Emissionen aus der Untergruppe UPlus';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_eq_punktemiss.emiss_xkw IS 'XKW-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_uplus_gesamt(
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
  emiss_xkw double precision, 
  CONSTRAINT ekat2015_ug_uplus_gesamt_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_uplus_gesamt
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_uplus_gesamt TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_uplus_gesamt TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_uplus_gesamt TO public;
COMMENT ON TABLE ekat2015.ug_uplus_gesamt
  IS 'Emissionen der Untergruppe UPlus';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt.emiss_xkw IS 'XKW-Emission in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_uplus_gesamt_gem(
  gmde integer, 
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
  emiss_xkw double precision, 
  CONSTRAINT ekat2015_ug_uplus_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_uplus_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_uplus_gesamt_gem TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_uplus_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_uplus_gesamt_gem TO public;
COMMENT ON TABLE ekat2015.ug_uplus_gesamt_gem
  IS 'Emissionen der Untergruppe UPlus aufaddiert auf Gemeinden';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.emiss_co IS 'CO-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.emiss_co2 IS 'CO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.emiss_nox IS 'NOx-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.emiss_so2 IS 'SO2-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.emiss_nmvoc IS 'NMVOC-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.emiss_ch4 IS 'CH4-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.emiss_pm10 IS 'PM10-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.emiss_nh3 IS 'NH3-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.emiss_n2o IS 'N2O-Emission in kg/a je Ha-Raster';
COMMENT ON COLUMN ekat2015.ug_uplus_gesamt_gem.emiss_xkw IS 'XKW-Emission in kg/a je Ha-Raster';

