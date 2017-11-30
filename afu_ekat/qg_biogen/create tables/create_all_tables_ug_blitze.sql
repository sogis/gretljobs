CREATE TABLE if not exists ekat2015.ug_blitze(
  ogc_fid integer, 
  xkoord integer,
  ykoord integer,
  wkb_geometry geometry,
  gem_bfs integer,
  emiss_nox double precision,
  CONSTRAINT ekat2015_ug_blitze_pkey_ogc_fid PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_blitze
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_blitze TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_blitze TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_blitze TO public;
COMMENT ON TABLE ekat2015.ug_blitze
   IS 'Emissionen aus der Untergruppe Blitze';
COMMENT ON COLUMN ekat2015.ug_blitze.ogc_fid IS 'OGC Feature ID';
COMMENT ON COLUMN ekat2015.ug_blitze.xkoord IS 'X-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_blitze.ykoord IS 'Y-Koordinate SW-Ecke des ha-Rasters';
COMMENT ON COLUMN ekat2015.ug_blitze.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_blitze.gem_bfs IS 'BfS-Nummer der Gemeinde';
COMMENT ON COLUMN ekat2015.ug_blitze.emiss_nox IS 'NOx-Emissionen in kg/a je Ha-Raster';

CREATE TABLE if not exists ekat2015.ug_blitze_gesamt_gem(
  gmde integer, 
  wkb_geometry geometry,
  emiss_nox double precision,
  CONSTRAINT ekat2015_ug_blitze_gesamt_gem_pkey_ogc_fid PRIMARY KEY (gmde)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE ekat2015.ug_blitze_gesamt_gem
  OWNER TO sogis_admin;
GRANT ALL ON TABLE ekat2015.ug_blitze_gesamt_gem TO bjsvwsch;
GRANT SELECT ON TABLE ekat2015.ug_blitze_gesamt_gem TO ekat;
GRANT SELECT ON TABLE ekat2015.ug_blitze_gesamt_gem TO public;
COMMENT ON TABLE ekat2015.ug_blitze_gesamt_gem 
  IS 'Emissionen aus der Untergruppe Blitze je Gemeinde';
COMMENT ON COLUMN ekat2015.ug_blitze_gesamt_gem.gmde IS 'Gemeinde BFS';
COMMENT ON COLUMN ekat2015.ug_blitze_gesamt_gem.wkb_geometry IS 'OGC WKB Geometrie';
COMMENT ON COLUMN ekat2015.ug_blitze_gesamt_gem.emiss_nox IS 'NOx-Emission in kg/a je Gemeinde';


