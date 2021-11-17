CREATE SCHEMA IF NOT EXISTS alw_fff_uebersteuerung;
CREATE SEQUENCE alw_fff_uebersteuerung.t_ili2db_seq;;
-- SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung
CREATE TABLE alw_fff_uebersteuerung.uebersteuerung_uebersteuerung (
  T_Id bigint PRIMARY KEY DEFAULT nextval('alw_fff_uebersteuerung.t_ili2db_seq')
  ,T_basket bigint NOT NULL
  ,T_datasetname varchar(200) NOT NULL
  ,T_Ili_Tid uuid NULL DEFAULT uuid_generate_v4()
  ,geometrie geometry(POLYGON,2056) NOT NULL
  ,spezialfall varchar(255) NOT NULL
  ,bezeichnung varchar(255) NOT NULL
  ,beschreibung varchar(250) NULL
  ,datenstand date NOT NULL
  ,anrechenbar decimal(3,2) NOT NULL
  ,erfassung varchar(20) NULL
  ,fall varchar(255) NOT NULL
)
;
CREATE INDEX uebersteuerung_ueberstrung_t_basket_idx ON alw_fff_uebersteuerung.uebersteuerung_uebersteuerung ( t_basket );
CREATE INDEX uebersteuerung_ueberstrung_t_datasetname_idx ON alw_fff_uebersteuerung.uebersteuerung_uebersteuerung ( t_datasetname );
CREATE INDEX uebersteuerung_ueberstrung_geometrie_idx ON alw_fff_uebersteuerung.uebersteuerung_uebersteuerung USING GIST ( geometrie );
COMMENT ON TABLE alw_fff_uebersteuerung.uebersteuerung_uebersteuerung IS 'Objekte, welche die automatisch berechneten FFF übersteuern können.';
COMMENT ON COLUMN alw_fff_uebersteuerung.uebersteuerung_uebersteuerung.geometrie IS 'Geometrie';
COMMENT ON COLUMN alw_fff_uebersteuerung.uebersteuerung_uebersteuerung.spezialfall IS 'Bezeichnung des Spezialfalls';
COMMENT ON COLUMN alw_fff_uebersteuerung.uebersteuerung_uebersteuerung.bezeichnung IS 'Fruchtfolgeflächekategorie';
COMMENT ON COLUMN alw_fff_uebersteuerung.uebersteuerung_uebersteuerung.beschreibung IS 'Beschreibung zum Spezialfall. Hinweise auf beschränkte Gültigkeit.';
COMMENT ON COLUMN alw_fff_uebersteuerung.uebersteuerung_uebersteuerung.datenstand IS 'Stand der letzten Änderung';
COMMENT ON COLUMN alw_fff_uebersteuerung.uebersteuerung_uebersteuerung.anrechenbar IS 'Gewichtungsfaktor der FFF gemäss Bund. Bei FFF, die nicht zu 100% anrechenbar sind, wird ein Gewichtungsfaktor festgelegt.';
COMMENT ON COLUMN alw_fff_uebersteuerung.uebersteuerung_uebersteuerung.erfassung IS 'Kürzel, der für die Erfassung zuständige Person.';
COMMENT ON COLUMN alw_fff_uebersteuerung.uebersteuerung_uebersteuerung.fall IS 'Übersteuerungsfall';
CREATE TABLE alw_fff_uebersteuerung.T_ILI2DB_BASKET (
  T_Id bigint PRIMARY KEY
  ,dataset bigint NULL
  ,topic varchar(200) NOT NULL
  ,T_Ili_Tid varchar(200) NULL
  ,attachmentKey varchar(200) NOT NULL
  ,domains varchar(1024) NULL
)
;
CREATE INDEX T_ILI2DB_BASKET_dataset_idx ON alw_fff_uebersteuerung.t_ili2db_basket ( dataset );
CREATE TABLE alw_fff_uebersteuerung.T_ILI2DB_DATASET (
  T_Id bigint PRIMARY KEY
  ,datasetName varchar(200) NULL
)
;
CREATE TABLE alw_fff_uebersteuerung.T_ILI2DB_INHERITANCE (
  thisClass varchar(1024) PRIMARY KEY
  ,baseClass varchar(1024) NULL
)
;
CREATE TABLE alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (
  tag varchar(60) PRIMARY KEY
  ,setting varchar(1024) NULL
)
;
CREATE TABLE alw_fff_uebersteuerung.T_ILI2DB_TRAFO (
  iliname varchar(1024) NOT NULL
  ,tag varchar(1024) NOT NULL
  ,setting varchar(1024) NOT NULL
)
;
CREATE TABLE alw_fff_uebersteuerung.T_ILI2DB_MODEL (
  filename varchar(250) NOT NULL
  ,iliversion varchar(3) NOT NULL
  ,modelName text NOT NULL
  ,content text NOT NULL
  ,importDate timestamp NOT NULL
  ,PRIMARY KEY (iliversion,modelName)
)
;
CREATE TABLE alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_bezeichnung (
  itfCode integer PRIMARY KEY
  ,iliCode varchar(1024) NOT NULL
  ,seq integer NULL
  ,inactive boolean NOT NULL
  ,dispName varchar(250) NOT NULL
  ,description varchar(1024) NULL
)
;
CREATE TABLE alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_spezialfall (
  itfCode integer PRIMARY KEY
  ,iliCode varchar(1024) NOT NULL
  ,seq integer NULL
  ,inactive boolean NOT NULL
  ,dispName varchar(250) NOT NULL
  ,description varchar(1024) NULL
)
;
CREATE TABLE alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_fall (
  itfCode integer PRIMARY KEY
  ,iliCode varchar(1024) NOT NULL
  ,seq integer NULL
  ,inactive boolean NOT NULL
  ,dispName varchar(250) NOT NULL
  ,description varchar(1024) NULL
)
;
CREATE TABLE alw_fff_uebersteuerung.T_ILI2DB_CLASSNAME (
  IliName varchar(1024) PRIMARY KEY
  ,SqlName varchar(1024) NOT NULL
)
;
CREATE TABLE alw_fff_uebersteuerung.T_ILI2DB_ATTRNAME (
  IliName varchar(1024) NOT NULL
  ,SqlName varchar(1024) NOT NULL
  ,ColOwner varchar(1024) NOT NULL
  ,Target varchar(1024) NULL
  ,PRIMARY KEY (ColOwner,SqlName)
)
;
CREATE TABLE alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (
  tablename varchar(255) NOT NULL
  ,subtype varchar(255) NULL
  ,columnname varchar(255) NOT NULL
  ,tag varchar(1024) NOT NULL
  ,setting varchar(1024) NOT NULL
)
;
CREATE TABLE alw_fff_uebersteuerung.T_ILI2DB_TABLE_PROP (
  tablename varchar(255) NOT NULL
  ,tag varchar(1024) NOT NULL
  ,setting varchar(1024) NOT NULL
)
;
CREATE TABLE alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (
  ilielement varchar(255) NOT NULL
  ,attr_name varchar(1024) NOT NULL
  ,attr_value varchar(1024) NOT NULL
)
;
ALTER TABLE alw_fff_uebersteuerung.uebersteuerung_uebersteuerung ADD CONSTRAINT uebersteuerung_ueberstrung_T_basket_fkey FOREIGN KEY ( T_basket ) REFERENCES alw_fff_uebersteuerung.T_ILI2DB_BASKET DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE alw_fff_uebersteuerung.uebersteuerung_uebersteuerung ADD CONSTRAINT uebersteuerung_uebrstrung_anrechenbar_check CHECK( anrechenbar BETWEEN 0.0 AND 1.0);
ALTER TABLE alw_fff_uebersteuerung.T_ILI2DB_BASKET ADD CONSTRAINT T_ILI2DB_BASKET_dataset_fkey FOREIGN KEY ( dataset ) REFERENCES alw_fff_uebersteuerung.T_ILI2DB_DATASET DEFERRABLE INITIALLY DEFERRED;
CREATE UNIQUE INDEX T_ILI2DB_DATASET_datasetName_key ON alw_fff_uebersteuerung.T_ILI2DB_DATASET (datasetName)
;
CREATE UNIQUE INDEX T_ILI2DB_MODEL_iliversion_modelName_key ON alw_fff_uebersteuerung.T_ILI2DB_MODEL (iliversion,modelName)
;
CREATE UNIQUE INDEX T_ILI2DB_ATTRNAME_ColOwner_SqlName_key ON alw_fff_uebersteuerung.T_ILI2DB_ATTRNAME (ColOwner,SqlName)
;
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Bezeichnung','uebersteuerung_uebersteuerung_bezeichnung');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Fall','uebersteuerung_uebersteuerung_fall');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung','uebersteuerung_uebersteuerung');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Spezialfall','uebersteuerung_uebersteuerung_spezialfall');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Erfassung','erfassung','uebersteuerung_uebersteuerung',NULL);
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Spezialfall','spezialfall','uebersteuerung_uebersteuerung',NULL);
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Beschreibung','beschreibung','uebersteuerung_uebersteuerung',NULL);
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Datenstand','datenstand','uebersteuerung_uebersteuerung',NULL);
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Fall','fall','uebersteuerung_uebersteuerung',NULL);
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.anrechenbar','anrechenbar','uebersteuerung_uebersteuerung',NULL);
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Bezeichnung','bezeichnung','uebersteuerung_uebersteuerung',NULL);
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Geometrie','geometrie','uebersteuerung_uebersteuerung',NULL);
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung','ch.ehi.ili2db.inheritance','newClass');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_INHERITANCE (thisClass,baseClass) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung',NULL);
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_bezeichnung (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'keine_FFF',0,'keine FFF',FALSE,'keine FFF');
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_bezeichnung (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'geeignete_FFF',1,'geeignete FFF',FALSE,'geeignete FFF');
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_bezeichnung (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'bedingt_geeignete_FFF',2,'bedingt geeignete FFF',FALSE,'bedingt geeignete FFF');
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_spezialfall (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'Golfplatz',0,'Golfplatz',FALSE,NULL);
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_spezialfall (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'Gewaesserraum',1,'Gewässerraum',FALSE,NULL);
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_spezialfall (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'Reserverzone',2,'Reservezone',FALSE,NULL);
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_spezialfall (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'GSZ2',3,'Gewässerschutzzone S2',FALSE,NULL);
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_spezialfall (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'Kiesgrube_Abbaugebiet',4,'Kiesgrube / Abbaugebiet',FALSE,NULL);
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_spezialfall (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'VSB',5,'VSB',FALSE,NULL);
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_spezialfall (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'uebriger_Spezialfall',6,'übriger Spezialfall',FALSE,NULL);
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_fall (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ausschneiden',0,'ausschneiden',FALSE,'Fläche erscheint nicht mehr im FFF-Inventar');
INSERT INTO alw_fff_uebersteuerung.uebersteuerung_uebersteuerung_fall (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ersetzen',1,'ersetzen',FALSE,'Fläche übersteuer bisherige Fläche im FFF-Inventar');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'bezeichnung','ch.ehi.ili2db.dispName','Bezeichnung');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'erfassung','ch.ehi.ili2db.dispName','Erfassung');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'fall','ch.ehi.ili2db.dispName','Fall');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'spezialfall','ch.ehi.ili2db.dispName','Spezialfall');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'beschreibung','ch.ehi.ili2db.dispName','Beschreibung');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'anrechenbar','ch.ehi.ili2db.dispName','anrechenbar');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'geometrie','ch.ehi.ili2db.coordDimension','2');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'geometrie','ch.ehi.ili2db.c1Max','2870000.000');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'geometrie','ch.ehi.ili2db.c2Max','1310000.000');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'geometrie','ch.ehi.ili2db.geomType','POLYGON');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'geometrie','ch.ehi.ili2db.c1Min','2460000.000');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'geometrie','ch.ehi.ili2db.c2Min','1045000.000');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'geometrie','ch.ehi.ili2db.srid','2056');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'geometrie','ch.ehi.ili2db.dispName','Geometrie');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('uebersteuerung_uebersteuerung',NULL,'datenstand','ch.ehi.ili2db.dispName','Datenstand');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('uebersteuerung_uebersteuerung_bezeichnung','ch.ehi.ili2db.tableKind','ENUM');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('uebersteuerung_uebersteuerung_fall','ch.ehi.ili2db.tableKind','ENUM');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('uebersteuerung_uebersteuerung','ch.ehi.ili2db.tableKind','CLASS');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('uebersteuerung_uebersteuerung','ch.ehi.ili2db.dispName','Übersteuerung');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('uebersteuerung_uebersteuerung_spezialfall','ch.ehi.ili2db.tableKind','ENUM');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('CHBase_Part1_GEOMETRY_V1.ili','2.3','GeometryCHLV03_V1{ CoordSys Units INTERLIS} GeometryCHLV95_V1{ CoordSys Units INTERLIS}','/* ########################################################################
   CHBASE - BASE MODULES OF THE SWISS FEDERATION FOR MINIMAL GEODATA MODELS
   ======
   BASISMODULE DES BUNDES           MODULES DE BASE DE LA CONFEDERATION
   FÜR MINIMALE GEODATENMODELLE     POUR LES MODELES DE GEODONNEES MINIMAUX
   
   PROVIDER: GKG/KOGIS - GCS/COSIG             CONTACT: models@geo.admin.ch
   PUBLISHED: 2011-0830
   ########################################################################
*/

INTERLIS 2.3;

/* ########################################################################
   ########################################################################
   PART I -- GEOMETRY
   - Package GeometryCHLV03
   - Package GeometryCHLV95
*/

!! ########################################################################

!! Version    | Who   | Modification
!!------------------------------------------------------------------------------
!! 2015-02-20 | KOGIS | WITHOUT OVERLAPS added (line 57, 58, 65 and 66)
!! 2015-11-12 | KOGIS | WITHOUT OVERLAPS corrected (line 57 and 58)
!! 2017-11-27 | KOGIS | Meta-Attributes @furtherInformation adapted and @CRS added (line 31, 44 and 50)
!! 2017-12-04 | KOGIS | Meta-Attribute @CRS corrected

!!@technicalContact=models@geo.admin.ch
!!@furtherInformation=https://www.geo.admin.ch/de/geoinformation-schweiz/geobasisdaten/geodata-models.html
TYPE MODEL GeometryCHLV03_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2017-12-04" =

  IMPORTS UNQUALIFIED INTERLIS;
  IMPORTS Units;
  IMPORTS CoordSys;

  REFSYSTEM BASKET BCoordSys ~ CoordSys.CoordsysTopic
    OBJECTS OF GeoCartesian2D: CHLV03
    OBJECTS OF GeoHeight: SwissOrthometricAlt;

  DOMAIN
    !!@CRS=EPSG:21781
    Coord2 = COORD
      460000.000 .. 870000.000 [m] {CHLV03[1]},
       45000.000 .. 310000.000 [m] {CHLV03[2]},
      ROTATION 2 -> 1;

    !!@CRS=EPSG:21781
    Coord3 = COORD
      460000.000 .. 870000.000 [m] {CHLV03[1]},
       45000.000 .. 310000.000 [m] {CHLV03[2]},
        -200.000 ..   5000.000 [m] {SwissOrthometricAlt[1]},
      ROTATION 2 -> 1;

    Surface = SURFACE WITH (STRAIGHTS, ARCS) VERTEX Coord2 WITHOUT OVERLAPS > 0.001;
    Area = AREA WITH (STRAIGHTS, ARCS) VERTEX Coord2 WITHOUT OVERLAPS > 0.001;
    Line = POLYLINE WITH (STRAIGHTS, ARCS) VERTEX Coord2;
    DirectedLine EXTENDS Line = DIRECTED POLYLINE;
    LineWithAltitude = POLYLINE WITH (STRAIGHTS, ARCS) VERTEX Coord3;
    DirectedLineWithAltitude = DIRECTED POLYLINE WITH (STRAIGHTS, ARCS) VERTEX Coord3;
    
    /* minimal overlaps only (2mm) */
    SurfaceWithOverlaps2mm = SURFACE WITH (STRAIGHTS, ARCS) VERTEX Coord2 WITHOUT OVERLAPS > 0.002;
    AreaWithOverlaps2mm = AREA WITH (STRAIGHTS, ARCS) VERTEX Coord2 WITHOUT OVERLAPS > 0.002;

    Orientation = 0.00000 .. 359.99999 CIRCULAR [Units.Angle_Degree] <Coord2>;

    Accuracy = (cm, cm50, m, m10, m50, vague);
    Method = (measured, sketched, calculated);

    STRUCTURE LineStructure = 
      Line: Line;
    END LineStructure;

    STRUCTURE DirectedLineStructure =
      Line: DirectedLine;
    END DirectedLineStructure;

    STRUCTURE MultiLine =
      Lines: BAG {1..*} OF LineStructure;
    END MultiLine;

    STRUCTURE MultiDirectedLine =
      Lines: BAG {1..*} OF DirectedLineStructure;
    END MultiDirectedLine;

    STRUCTURE SurfaceStructure =
      Surface: Surface;
    END SurfaceStructure;

    STRUCTURE MultiSurface =
      Surfaces: BAG {1..*} OF SurfaceStructure;
    END MultiSurface;

END GeometryCHLV03_V1.

!! ########################################################################

!! Version    | Who   | Modification
!!------------------------------------------------------------------------------
!! 2015-02-20 | KOGIS | WITHOUT OVERLAPS added (line 135, 136, 143 and 144)
!! 2015-11-12 | KOGIS | WITHOUT OVERLAPS corrected (line 135 and 136)
!! 2017-11-27 | KOGIS | Meta-Attributes @furtherInformation adapted and @CRS added (line 109, 122 and 128)
!! 2017-12-04 | KOGIS | Meta-Attribute @CRS corrected

!!@technicalContact=models@geo.admin.ch
!!@furtherInformation=https://www.geo.admin.ch/de/geoinformation-schweiz/geobasisdaten/geodata-models.html
TYPE MODEL GeometryCHLV95_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2017-12-04" =

  IMPORTS UNQUALIFIED INTERLIS;
  IMPORTS Units;
  IMPORTS CoordSys;

  REFSYSTEM BASKET BCoordSys ~ CoordSys.CoordsysTopic
    OBJECTS OF GeoCartesian2D: CHLV95
    OBJECTS OF GeoHeight: SwissOrthometricAlt;

  DOMAIN
    !!@CRS=EPSG:2056
    Coord2 = COORD
      2460000.000 .. 2870000.000 [m] {CHLV95[1]},
      1045000.000 .. 1310000.000 [m] {CHLV95[2]},
      ROTATION 2 -> 1;

    !!@CRS=EPSG:2056
    Coord3 = COORD
      2460000.000 .. 2870000.000 [m] {CHLV95[1]},
      1045000.000 .. 1310000.000 [m] {CHLV95[2]},
         -200.000 ..   5000.000 [m] {SwissOrthometricAlt[1]},
      ROTATION 2 -> 1;

    Surface = SURFACE WITH (STRAIGHTS, ARCS) VERTEX Coord2 WITHOUT OVERLAPS > 0.001;
    Area = AREA WITH (STRAIGHTS, ARCS) VERTEX Coord2 WITHOUT OVERLAPS > 0.001;
    Line = POLYLINE WITH (STRAIGHTS, ARCS) VERTEX Coord2;
    DirectedLine EXTENDS Line = DIRECTED POLYLINE;
    LineWithAltitude = POLYLINE WITH (STRAIGHTS, ARCS) VERTEX Coord3;
    DirectedLineWithAltitude = DIRECTED POLYLINE WITH (STRAIGHTS, ARCS) VERTEX Coord3;
    
    /* minimal overlaps only (2mm) */
    SurfaceWithOverlaps2mm = SURFACE WITH (STRAIGHTS, ARCS) VERTEX Coord2 WITHOUT OVERLAPS > 0.002;
    AreaWithOverlaps2mm = AREA WITH (STRAIGHTS, ARCS) VERTEX Coord2 WITHOUT OVERLAPS > 0.002;

    Orientation = 0.00000 .. 359.99999 CIRCULAR [Units.Angle_Degree] <Coord2>;

    Accuracy = (cm, cm50, m, m10, m50, vague);
    Method = (measured, sketched, calculated);

    STRUCTURE LineStructure = 
      Line: Line;
    END LineStructure;

    STRUCTURE DirectedLineStructure =
      Line: DirectedLine;
    END DirectedLineStructure;

    STRUCTURE MultiLine =
      Lines: BAG {1..*} OF LineStructure;
    END MultiLine;

    STRUCTURE MultiDirectedLine =
      Lines: BAG {1..*} OF DirectedLineStructure;
    END MultiDirectedLine;

    STRUCTURE SurfaceStructure =
      Surface: Surface;
    END SurfaceStructure;

    STRUCTURE MultiSurface =
      Surfaces: BAG {1..*} OF SurfaceStructure;
    END MultiSurface;

END GeometryCHLV95_V1.

!! ########################################################################
','2021-08-17 16:55:12.992');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.ili','2.3','SO_ALW_FFF_Uebersteuerung_20210528{ GeometryCHLV95_V1 CHAdminCodes_V1}','INTERLIS 2.3;

/** !!------------------------------------------------------------------------------
 *  !! Version    | wer | Änderung
 *  !!------------------------------------------------------------------------------
 *  !! 2021-05-28 | sz  | Ersterfassung
 *  !!==============================================================================
 */
!!@ technicalContact="mailto:agi@bd.so.ch"
!!@ furtherInformation="http://geo.so.ch/models/ALW/SO_ALW_FFF_Uebersteuerung_20210528.uml"
MODEL SO_ALW_FFF_Uebersteuerung_20210528 (de)
AT "https://alw.so.ch"
VERSION "2021-05-28"  =
  IMPORTS GeometryCHLV95_V1,CHAdminCodes_V1;

  TOPIC Uebersteuerung =
    OID AS INTERLIS.UUIDOID;

    /** Objekte, welche die automatisch berechneten FFF übersteuern können.
     */
    !!@ ili2db.dispName = "Übersteuerung"
    CLASS Uebersteuerung =
      /** Geometrie
       */
      !!@ ili2db.dispName = "Geometrie"
      Geometrie : MANDATORY GeometryCHLV95_V1.AreaWithOverlaps2mm;
      /** Bezeichnung des Spezialfalls
       */
      !!@ ili2db.dispName = "Spezialfall"
      Spezialfall : MANDATORY (
        !!@ ili2db.dispName = "Golfplatz"
        Golfplatz,
        !!@ ili2db.dispName = "Gewässerraum"
        Gewaesserraum,
        !!@ ili2db.dispName = "Reservezone"
        Reserverzone,
        !!@ ili2db.dispName = "Gewässerschutzzone S2"
        GSZ2,
        !!@ ili2db.dispName = "Kiesgrube / Abbaugebiet"
        Kiesgrube_Abbaugebiet,
        !!@ ili2db.dispName = "VSB"
        VSB,
        !!@ ili2db.dispName = "übriger Spezialfall"
        uebriger_Spezialfall
      );
      /** Fruchtfolgeflächekategorie
       */
      !!@ ili2db.dispName = "Bezeichnung"
      Bezeichnung : MANDATORY (
        /** keine FFF
         */
        !!@ ili2db.dispName = "keine FFF"
        keine_FFF,
        /** geeignete FFF
         */
        !!@ ili2db.dispName = "geeignete FFF"
        geeignete_FFF,
        /** bedingt geeignete FFF
         */
        !!@ ili2db.dispName = "bedingt geeignete FFF"
        bedingt_geeignete_FFF
      );
      /** Beschreibung zum Spezialfall. Hinweise auf beschränkte Gültigkeit.
       */
      !!@ ili2db.dispName = "Beschreibung"
      Beschreibung : TEXT*250;
      /** Stand der letzten Änderung
       */
      !!@ ili2db.dispName = "Datenstand"
      Datenstand : MANDATORY INTERLIS.XMLDate;
      /** Gewichtungsfaktor der FFF gemäss Bund. Bei FFF, die nicht zu 100% anrechenbar sind, wird ein Gewichtungsfaktor festgelegt.
       */
      !!@ ili2db.dispName = "anrechenbar"
      anrechenbar : MANDATORY 0.00 .. 1.00;
      /** Kürzel, der für die Erfassung zuständige Person.
       */
      !!@ ili2db.dispName = "Erfassung"
      Erfassung : TEXT*20;
      /** Übersteuerungsfall
       */
      !!@ ili2db.dispName = "Fall"
      Fall : MANDATORY (
        /** Fläche erscheint nicht mehr im FFF-Inventar
         */
        !!@ ili2db.dispName = "ausschneiden"
        ausschneiden,
        /** Fläche übersteuer bisherige Fläche im FFF-Inventar
         */
        !!@ ili2db.dispName = "ersetzen"
        ersetzen
      );
    END Uebersteuerung;

  END Uebersteuerung;

END SO_ALW_FFF_Uebersteuerung_20210528.
','2021-08-17 16:55:12.992');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('CoordSys-20151124.ili','2.3','CoordSys','!! File CoordSys.ili Release 2015-11-24

INTERLIS 2.3;

!! 2015-11-24 Cardinalities adapted (line 122, 123, 124, 132, 133, 134, 142, 143,
!!                                   148, 149, 163, 164, 168, 169, 206 and 207)
!!@precursorVersion = 2005-06-16

REFSYSTEM MODEL CoordSys (en) AT "http://www.interlis.ch/models"
  VERSION "2015-11-24" =

  UNIT
    Angle_Degree = 180 / PI [INTERLIS.rad];
    Angle_Minute = 1 / 60 [Angle_Degree];
    Angle_Second = 1 / 60 [Angle_Minute];

  STRUCTURE Angle_DMS_S =
    Degrees: -180 .. 180 CIRCULAR [Angle_Degree];
    CONTINUOUS SUBDIVISION Minutes: 0 .. 59 CIRCULAR [Angle_Minute];
    CONTINUOUS SUBDIVISION Seconds: 0.000 .. 59.999 CIRCULAR [Angle_Second];
  END Angle_DMS_S;

  DOMAIN
    Angle_DMS = FORMAT BASED ON Angle_DMS_S (Degrees ":" Minutes ":" Seconds);
    Angle_DMS_90 EXTENDS Angle_DMS = "-90:00:00.000" .. "90:00:00.000";


  TOPIC CoordsysTopic =

    !! Special space aspects to be referenced
    !! **************************************

    CLASS Ellipsoid EXTENDS INTERLIS.REFSYSTEM =
      EllipsoidAlias: TEXT*70;
      SemiMajorAxis: MANDATORY 6360000.0000 .. 6390000.0000 [INTERLIS.m];
      InverseFlattening: MANDATORY 0.00000000 .. 350.00000000;
      !! The inverse flattening 0 characterizes the 2-dim sphere
      Remarks: TEXT*70;
    END Ellipsoid;

    CLASS GravityModel EXTENDS INTERLIS.REFSYSTEM =
      GravityModAlias: TEXT*70;
      Definition: TEXT*70;
    END GravityModel;

    CLASS GeoidModel EXTENDS INTERLIS.REFSYSTEM =
      GeoidModAlias: TEXT*70;
      Definition: TEXT*70;
    END GeoidModel;


    !! Coordinate systems for geodetic purposes
    !! ****************************************

    STRUCTURE LengthAXIS EXTENDS INTERLIS.AXIS =
      ShortName: TEXT*12;
      Description: TEXT*255;
    PARAMETER
      Unit (EXTENDED): NUMERIC [INTERLIS.LENGTH];
    END LengthAXIS;

    STRUCTURE AngleAXIS EXTENDS INTERLIS.AXIS =
      ShortName: TEXT*12;
      Description: TEXT*255;
    PARAMETER
      Unit (EXTENDED): NUMERIC [INTERLIS.ANGLE];
    END AngleAXIS;

    CLASS GeoCartesian1D EXTENDS INTERLIS.COORDSYSTEM =
      Axis (EXTENDED): LIST {1} OF LengthAXIS;
    END GeoCartesian1D;

    CLASS GeoHeight EXTENDS GeoCartesian1D =
      System: MANDATORY (
        normal,
        orthometric,
        ellipsoidal,
        other);
      ReferenceHeight: MANDATORY -10000.000 .. +10000.000 [INTERLIS.m];
      ReferenceHeightDescr: TEXT*70;
    END GeoHeight;

    ASSOCIATION HeightEllips =
      GeoHeightRef -- {*} GeoHeight;
      EllipsoidRef -- {1} Ellipsoid;
    END HeightEllips;

    ASSOCIATION HeightGravit =
      GeoHeightRef -- {*} GeoHeight;
      GravityRef -- {1} GravityModel;
    END HeightGravit;

    ASSOCIATION HeightGeoid =
      GeoHeightRef -- {*} GeoHeight;
      GeoidRef -- {1} GeoidModel;
    END HeightGeoid;

    CLASS GeoCartesian2D EXTENDS INTERLIS.COORDSYSTEM =
      Definition: TEXT*70;
      Axis (EXTENDED): LIST {2} OF LengthAXIS;
    END GeoCartesian2D;

    CLASS GeoCartesian3D EXTENDS INTERLIS.COORDSYSTEM =
      Definition: TEXT*70;
      Axis (EXTENDED): LIST {3} OF LengthAXIS;
    END GeoCartesian3D;

    CLASS GeoEllipsoidal EXTENDS INTERLIS.COORDSYSTEM =
      Definition: TEXT*70;
      Axis (EXTENDED): LIST {2} OF AngleAXIS;
    END GeoEllipsoidal;

    ASSOCIATION EllCSEllips =
      GeoEllipsoidalRef -- {*} GeoEllipsoidal;
      EllipsoidRef -- {1} Ellipsoid;
    END EllCSEllips;


    !! Mappings between coordinate systems
    !! ***********************************

    ASSOCIATION ToGeoEllipsoidal =
      From -- {0..*} GeoCartesian3D;
      To -- {0..*} GeoEllipsoidal;
      ToHeight -- {0..*} GeoHeight;
    MANDATORY CONSTRAINT
      ToHeight -> System == #ellipsoidal;
    MANDATORY CONSTRAINT
      To -> EllipsoidRef -> Name == ToHeight -> EllipsoidRef -> Name;
    END ToGeoEllipsoidal;

    ASSOCIATION ToGeoCartesian3D =
      From2 -- {0..*} GeoEllipsoidal;
      FromHeight-- {0..*} GeoHeight;
      To3 -- {0..*} GeoCartesian3D;
    MANDATORY CONSTRAINT
      FromHeight -> System == #ellipsoidal;
    MANDATORY CONSTRAINT
      From2 -> EllipsoidRef -> Name == FromHeight -> EllipsoidRef -> Name;
    END ToGeoCartesian3D;

    ASSOCIATION BidirectGeoCartesian2D =
      From -- {0..*} GeoCartesian2D;
      To -- {0..*} GeoCartesian2D;
    END BidirectGeoCartesian2D;

    ASSOCIATION BidirectGeoCartesian3D =
      From -- {0..*} GeoCartesian3D;
      To2 -- {0..*} GeoCartesian3D;
      Precision: MANDATORY (
        exact,
        measure_based);
      ShiftAxis1: MANDATORY -10000.000 .. 10000.000 [INTERLIS.m];
      ShiftAxis2: MANDATORY -10000.000 .. 10000.000 [INTERLIS.m];
      ShiftAxis3: MANDATORY -10000.000 .. 10000.000 [INTERLIS.m];
      RotationAxis1: Angle_DMS_90;
      RotationAxis2: Angle_DMS_90;
      RotationAxis3: Angle_DMS_90;
      NewScale: 0.000001 .. 1000000.000000;
    END BidirectGeoCartesian3D;

    ASSOCIATION BidirectGeoEllipsoidal =
      From4 -- {0..*} GeoEllipsoidal;
      To4 -- {0..*} GeoEllipsoidal;
    END BidirectGeoEllipsoidal;

    ASSOCIATION MapProjection (ABSTRACT) =
      From5 -- {0..*} GeoEllipsoidal;
      To5 -- {0..*} GeoCartesian2D;
      FromCo1_FundPt: MANDATORY Angle_DMS_90;
      FromCo2_FundPt: MANDATORY Angle_DMS_90;
      ToCoord1_FundPt: MANDATORY -10000000 .. +10000000 [INTERLIS.m];
      ToCoord2_FundPt: MANDATORY -10000000 .. +10000000 [INTERLIS.m];
    END MapProjection;

    ASSOCIATION TransverseMercator EXTENDS MapProjection =
    END TransverseMercator;

    ASSOCIATION SwissProjection EXTENDS MapProjection =
      IntermFundP1: MANDATORY Angle_DMS_90;
      IntermFundP2: MANDATORY Angle_DMS_90;
    END SwissProjection;

    ASSOCIATION Mercator EXTENDS MapProjection =
    END Mercator;

    ASSOCIATION ObliqueMercator EXTENDS MapProjection =
    END ObliqueMercator;

    ASSOCIATION Lambert EXTENDS MapProjection =
    END Lambert;

    ASSOCIATION Polyconic EXTENDS MapProjection =
    END Polyconic;

    ASSOCIATION Albus EXTENDS MapProjection =
    END Albus;

    ASSOCIATION Azimutal EXTENDS MapProjection =
    END Azimutal;

    ASSOCIATION Stereographic EXTENDS MapProjection =
    END Stereographic;

    ASSOCIATION HeightConversion =
      FromHeight -- {0..*} GeoHeight;
      ToHeight -- {0..*} GeoHeight;
      Definition: TEXT*70;
    END HeightConversion;

  END CoordsysTopic;

END CoordSys.

','2021-08-17 16:55:12.992');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('Units-20120220.ili','2.3','Units','!! File Units.ili Release 2012-02-20

INTERLIS 2.3;

!! 2012-02-20 definition of "Bar [bar]" corrected
!!@precursorVersion = 2005-06-06

CONTRACTED TYPE MODEL Units (en) AT "http://www.interlis.ch/models"
  VERSION "2012-02-20" =

  UNIT
    !! abstract Units
    Area (ABSTRACT) = (INTERLIS.LENGTH*INTERLIS.LENGTH);
    Volume (ABSTRACT) = (INTERLIS.LENGTH*INTERLIS.LENGTH*INTERLIS.LENGTH);
    Velocity (ABSTRACT) = (INTERLIS.LENGTH/INTERLIS.TIME);
    Acceleration (ABSTRACT) = (Velocity/INTERLIS.TIME);
    Force (ABSTRACT) = (INTERLIS.MASS*INTERLIS.LENGTH/INTERLIS.TIME/INTERLIS.TIME);
    Pressure (ABSTRACT) = (Force/Area);
    Energy (ABSTRACT) = (Force*INTERLIS.LENGTH);
    Power (ABSTRACT) = (Energy/INTERLIS.TIME);
    Electric_Potential (ABSTRACT) = (Power/INTERLIS.ELECTRIC_CURRENT);
    Frequency (ABSTRACT) = (INTERLIS.DIMENSIONLESS/INTERLIS.TIME);

    Millimeter [mm] = 0.001 [INTERLIS.m];
    Centimeter [cm] = 0.01 [INTERLIS.m];
    Decimeter [dm] = 0.1 [INTERLIS.m];
    Kilometer [km] = 1000 [INTERLIS.m];

    Square_Meter [m2] EXTENDS Area = (INTERLIS.m*INTERLIS.m);
    Cubic_Meter [m3] EXTENDS Volume = (INTERLIS.m*INTERLIS.m*INTERLIS.m);

    Minute [min] = 60 [INTERLIS.s];
    Hour [h] = 60 [min];
    Day [d] = 24 [h];

    Kilometer_per_Hour [kmh] EXTENDS Velocity = (km/h);
    Meter_per_Second [ms] = 3.6 [kmh];
    Newton [N] EXTENDS Force = (INTERLIS.kg*INTERLIS.m/INTERLIS.s/INTERLIS.s);
    Pascal [Pa] EXTENDS Pressure = (N/m2);
    Joule [J] EXTENDS Energy = (N*INTERLIS.m);
    Watt [W] EXTENDS Power = (J/INTERLIS.s);
    Volt [V] EXTENDS Electric_Potential = (W/INTERLIS.A);

    Inch [in] = 2.54 [cm];
    Foot [ft] = 0.3048 [INTERLIS.m];
    Mile [mi] = 1.609344 [km];

    Are [a] = 100 [m2];
    Hectare [ha] = 100 [a];
    Square_Kilometer [km2] = 100 [ha];
    Acre [acre] = 4046.873 [m2];

    Liter [L] = 1 / 1000 [m3];
    US_Gallon [USgal] = 3.785412 [L];

    Angle_Degree = 180 / PI [INTERLIS.rad];
    Angle_Minute = 1 / 60 [Angle_Degree];
    Angle_Second = 1 / 60 [Angle_Minute];

    Gon = 200 / PI [INTERLIS.rad];

    Gram [g] = 1 / 1000 [INTERLIS.kg];
    Ton [t] = 1000 [INTERLIS.kg];
    Pound [lb] = 0.4535924 [INTERLIS.kg];

    Calorie [cal] = 4.1868 [J];
    Kilowatt_Hour [kWh] = 0.36E7 [J];

    Horsepower = 746 [W];

    Techn_Atmosphere [at] = 98066.5 [Pa];
    Atmosphere [atm] = 101325 [Pa];
    Bar [bar] = 100000 [Pa];
    Millimeter_Mercury [mmHg] = 133.3224 [Pa];
    Torr = 133.3224 [Pa]; !! Torr = [mmHg]

    Decibel [dB] = FUNCTION // 10**(dB/20) * 0.00002 // [Pa];

    Degree_Celsius [oC] = FUNCTION // oC+273.15 // [INTERLIS.K];
    Degree_Fahrenheit [oF] = FUNCTION // (oF+459.67)/1.8 // [INTERLIS.K];

    CountedObjects EXTENDS INTERLIS.DIMENSIONLESS;

    Hertz [Hz] EXTENDS Frequency = (CountedObjects/INTERLIS.s);
    KiloHertz [KHz] = 1000 [Hz];
    MegaHertz [MHz] = 1000 [KHz];

    Percent = 0.01 [CountedObjects];
    Permille = 0.001 [CountedObjects];

    !! ISO 4217 Currency Abbreviation
    USDollar [USD] EXTENDS INTERLIS.MONEY;
    Euro [EUR] EXTENDS INTERLIS.MONEY;
    SwissFrancs [CHF] EXTENDS INTERLIS.MONEY;

END Units.

','2021-08-17 16:55:12.992');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('CHBase_Part2_LOCALISATION_V1.ili','2.3','InternationalCodes_V1 Localisation_V1{ InternationalCodes_V1} LocalisationCH_V1{ InternationalCodes_V1 Localisation_V1} Dictionaries_V1{ InternationalCodes_V1} DictionariesCH_V1{ InternationalCodes_V1 Dictionaries_V1}','/* ########################################################################
   CHBASE - BASE MODULES OF THE SWISS FEDERATION FOR MINIMAL GEODATA MODELS
   ======
   BASISMODULE DES BUNDES           MODULES DE BASE DE LA CONFEDERATION
   FÜR MINIMALE GEODATENMODELLE     POUR LES MODELES DE GEODONNEES MINIMAUX
   
   PROVIDER: GKG/KOGIS - GCS/COSIG             CONTACT: models@geo.admin.ch
   PUBLISHED: 2011-08-30
   ########################################################################
*/

INTERLIS 2.3;

/* ########################################################################
   ########################################################################
   PART II -- LOCALISATION
   - Package InternationalCodes
   - Packages Localisation, LocalisationCH
   - Packages Dictionaries, DictionariesCH
*/

!! ########################################################################
!!@technicalContact=models@geo.admin.ch
!!@furtherInformation=http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html
TYPE MODEL InternationalCodes_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2011-08-30" =

  DOMAIN
    LanguageCode_ISO639_1 = (de,fr,it,rm,en,
      aa,ab,af,am,ar,as,ay,az,ba,be,bg,bh,bi,bn,bo,br,ca,co,cs,cy,da,dz,el,
      eo,es,et,eu,fa,fi,fj,fo,fy,ga,gd,gl,gn,gu,ha,he,hi,hr,hu,hy,ia,id,ie,
      ik,is,iu,ja,jw,ka,kk,kl,km,kn,ko,ks,ku,ky,la,ln,lo,lt,lv,mg,mi,mk,ml,
      mn,mo,mr,ms,mt,my,na,ne,nl,no,oc,om,or,pa,pl,ps,pt,qu,rn,ro,ru,rw,sa,
      sd,sg,sh,si,sk,sl,sm,sn,so,sq,sr,ss,st,su,sv,sw,ta,te,tg,th,ti,tk,tl,
      tn,to,tr,ts,tt,tw,ug,uk,ur,uz,vi,vo,wo,xh,yi,yo,za,zh,zu);

    CountryCode_ISO3166_1 = (CHE,
      ABW,AFG,AGO,AIA,ALA,ALB,AND_,ANT,ARE,ARG,ARM,ASM,ATA,ATF,ATG,AUS,
      AUT,AZE,BDI,BEL,BEN,BFA,BGD,BGR,BHR,BHS,BIH,BLR,BLZ,BMU,BOL,BRA,
      BRB,BRN,BTN,BVT,BWA,CAF,CAN,CCK,CHL,CHN,CIV,CMR,COD,COG,COK,COL,
      COM,CPV,CRI,CUB,CXR,CYM,CYP,CZE,DEU,DJI,DMA,DNK,DOM,DZA,ECU,EGY,
      ERI,ESH,ESP,EST,ETH,FIN,FJI,FLK,FRA,FRO,FSM,GAB,GBR,GEO,GGY,GHA,
      GIB,GIN,GLP,GMB,GNB,GNQ,GRC,GRD,GRL,GTM,GUF,GUM,GUY,HKG,HMD,HND,
      HRV,HTI,HUN,IDN,IMN,IND,IOT,IRL,IRN,IRQ,ISL,ISR,ITA,JAM,JEY,JOR,
      JPN,KAZ,KEN,KGZ,KHM,KIR,KNA,KOR,KWT,LAO,LBN,LBR,LBY,LCA,LIE,LKA,
      LSO,LTU,LUX,LVA,MAC,MAR,MCO,MDA,MDG,MDV,MEX,MHL,MKD,MLI,MLT,MMR,
      MNE,MNG,MNP,MOZ,MRT,MSR,MTQ,MUS,MWI,MYS,MYT,NAM,NCL,NER,NFK,NGA,
      NIC,NIU,NLD,NOR,NPL,NRU,NZL,OMN,PAK,PAN,PCN,PER,PHL,PLW,PNG,POL,
      PRI,PRK,PRT,PRY,PSE,PYF,QAT,REU,ROU,RUS,RWA,SAU,SDN,SEN,SGP,SGS,
      SHN,SJM,SLB,SLE,SLV,SMR,SOM,SPM,SRB,STP,SUR,SVK,SVN,SWE,SWZ,SYC,
      SYR,TCA,TCD,TGO,THA,TJK,TKL,TKM,TLS,TON,TTO,TUN,TUR,TUV,TWN,TZA,
      UGA,UKR,UMI,URY,USA,UZB,VAT,VCT,VEN,VGB,VIR,VNM,VUT,WLF,WSM,YEM,
      ZAF,ZMB,ZWE);

END InternationalCodes_V1.

!! ########################################################################
!!@technicalContact=models@geo.admin.ch
!!@furtherInformation=http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html
TYPE MODEL Localisation_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2011-08-30" =

  IMPORTS UNQUALIFIED InternationalCodes_V1;

  STRUCTURE LocalisedText =
    Language: LanguageCode_ISO639_1;
    Text: MANDATORY TEXT;
  END LocalisedText;
  
  STRUCTURE LocalisedMText =
    Language: LanguageCode_ISO639_1;
    Text: MANDATORY MTEXT;
  END LocalisedMText;

  STRUCTURE MultilingualText =
    LocalisedText : BAG {1..*} OF LocalisedText;
    UNIQUE (LOCAL) LocalisedText:Language;
  END MultilingualText;  
  
  STRUCTURE MultilingualMText =
    LocalisedText : BAG {1..*} OF LocalisedMText;
    UNIQUE (LOCAL) LocalisedText:Language;
  END MultilingualMText;

END Localisation_V1.

!! ########################################################################
!!@technicalContact=models@geo.admin.ch
!!@furtherInformation=http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html
TYPE MODEL LocalisationCH_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2011-08-30" =

  IMPORTS UNQUALIFIED InternationalCodes_V1;
  IMPORTS Localisation_V1;

  STRUCTURE LocalisedText EXTENDS Localisation_V1.LocalisedText =
  MANDATORY CONSTRAINT
    Language == #de OR
    Language == #fr OR
    Language == #it OR
    Language == #rm OR
    Language == #en;
  END LocalisedText;
  
  STRUCTURE LocalisedMText EXTENDS Localisation_V1.LocalisedMText =
  MANDATORY CONSTRAINT
    Language == #de OR
    Language == #fr OR
    Language == #it OR
    Language == #rm OR
    Language == #en;
  END LocalisedMText;

  STRUCTURE MultilingualText EXTENDS Localisation_V1.MultilingualText =
    LocalisedText(EXTENDED) : BAG {1..*} OF LocalisedText;
  END MultilingualText;  
  
  STRUCTURE MultilingualMText EXTENDS Localisation_V1.MultilingualMText =
    LocalisedText(EXTENDED) : BAG {1..*} OF LocalisedMText;
  END MultilingualMText;

END LocalisationCH_V1.

!! ########################################################################
!!@technicalContact=models@geo.admin.ch
!!@furtherInformation=http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html
MODEL Dictionaries_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2011-08-30" =

  IMPORTS UNQUALIFIED InternationalCodes_V1;

  TOPIC Dictionaries (ABSTRACT) =

    STRUCTURE Entry (ABSTRACT) =
      Text: MANDATORY TEXT;
    END Entry;
      
    CLASS Dictionary =
      Language: MANDATORY LanguageCode_ISO639_1;
      Entries: LIST OF Entry;
    END Dictionary;

  END Dictionaries;

END Dictionaries_V1.

!! ########################################################################
!!@technicalContact=models@geo.admin.ch
!!@furtherInformation=http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html
MODEL DictionariesCH_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2011-08-30" =

  IMPORTS UNQUALIFIED InternationalCodes_V1;
  IMPORTS Dictionaries_V1;

  TOPIC Dictionaries (ABSTRACT) EXTENDS Dictionaries_V1.Dictionaries =

    CLASS Dictionary (EXTENDED) =
    MANDATORY CONSTRAINT
      Language == #de OR
      Language == #fr OR
      Language == #it OR
      Language == #rm OR
      Language == #en;
    END Dictionary;

  END Dictionaries;

END DictionariesCH_V1.

!! ########################################################################
','2021-08-17 16:55:12.992');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('CHBase_Part4_ADMINISTRATIVEUNITS_V1.ili','2.3','CHAdminCodes_V1 AdministrativeUnits_V1{ CHAdminCodes_V1 InternationalCodes_V1 Dictionaries_V1 Localisation_V1 INTERLIS} AdministrativeUnitsCH_V1{ CHAdminCodes_V1 InternationalCodes_V1 LocalisationCH_V1 AdministrativeUnits_V1 INTERLIS}','/* ########################################################################
   CHBASE - BASE MODULES OF THE SWISS FEDERATION FOR MINIMAL GEODATA MODELS
   ======
   BASISMODULE DES BUNDES           MODULES DE BASE DE LA CONFEDERATION
   FÜR MINIMALE GEODATENMODELLE     POUR LES MODELES DE GEODONNEES MINIMAUX
   
   PROVIDER: GKG/KOGIS - GCS/COSIG             CONTACT: models@geo.admin.ch
   PUBLISHED: 2011-08-30
   ########################################################################
*/

INTERLIS 2.3;

/* ########################################################################
   ########################################################################
   PART IV -- ADMINISTRATIVE UNITS
   - Package CHAdminCodes
   - Package AdministrativeUnits
   - Package AdministrativeUnitsCH
*/

!! Version    | Who   | Modification
!!------------------------------------------------------------------------------
!! 2018-02-19 | KOGIS | Enumeration CHCantonCode adapted (FL and CH added)
!! 2020-04-24 | KOGIS | Constraint in Association Hierarchy in Model AdministrativeUnitsCH_V1 corrected (#CHE)
!! 2020-08-25 | KOGIS | Classes AdministrativeUnit and AdministrativeUnion declared as not abstract.

!! ########################################################################
!!@technicalContact=mailto:models@geo.admin.ch
!!@furtherInformation=https://www.geo.admin.ch/de/geoinformation-schweiz/geobasisdaten/geodata-models.html
TYPE MODEL CHAdminCodes_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2018-02-19" =

  DOMAIN
    CHCantonCode = (ZH,BE,LU,UR,SZ,OW,NW,GL,ZG,FR,SO,BS,BL,SH,AR,AI,SG,
                    GR,AG,TG,TI,VD,VS,NE,GE,JU,FL,CH);

    CHMunicipalityCode = 1..9999;  !! BFS-Nr

END CHAdminCodes_V1.

!! ########################################################################
!!@technicalContact=mailto:models@geo.admin.ch
!!@furtherInformation=https://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html
MODEL AdministrativeUnits_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2020-08-25" =

  IMPORTS UNQUALIFIED INTERLIS;
  IMPORTS UNQUALIFIED CHAdminCodes_V1;
  IMPORTS UNQUALIFIED InternationalCodes_V1;
  IMPORTS Localisation_V1;
  IMPORTS Dictionaries_V1;

  TOPIC AdministrativeUnits (ABSTRACT) =

    CLASS AdministrativeElement (ABSTRACT) =
    END AdministrativeElement;

    CLASS AdministrativeUnit EXTENDS AdministrativeElement =
    END AdministrativeUnit;

    ASSOCIATION Hierarchy =
      UpperLevelUnit (EXTERNAL) -<> {0..1} AdministrativeUnit;
      LowerLevelUnit -- AdministrativeUnit;
    END Hierarchy;

    CLASS AdministrativeUnion EXTENDS AdministrativeElement =
    END AdministrativeUnion;

    ASSOCIATION UnionMembers =
      Union -<> AdministrativeUnion;
      Member -- AdministrativeElement; 
    END UnionMembers;

  END AdministrativeUnits;

  TOPIC Countries EXTENDS AdministrativeUnits =

    CLASS Country EXTENDS AdministrativeUnit =
      Code: MANDATORY CountryCode_ISO3166_1;
    UNIQUE Code;
    END Country;

  END Countries;

  TOPIC CountryNames EXTENDS Dictionaries_V1.Dictionaries =
    DEPENDS ON AdministrativeUnits_V1.Countries;

    STRUCTURE CountryName EXTENDS Entry =
      Code: MANDATORY CountryCode_ISO3166_1;
    END CountryName;
      
    CLASS CountryNamesTranslation EXTENDS Dictionary  =
      Entries(EXTENDED): LIST OF CountryName;
    UNIQUE Entries->Code;
    EXISTENCE CONSTRAINT
      Entries->Code REQUIRED IN AdministrativeUnits_V1.Countries.Country: Code;
    END CountryNamesTranslation;

  END CountryNames;

  TOPIC Agencies (ABSTRACT) =
    DEPENDS ON AdministrativeUnits_V1.AdministrativeUnits;

    CLASS Agency (ABSTRACT) =
    END Agency;

    ASSOCIATION Authority =
      Supervisor (EXTERNAL) -<> {1..1} Agency OR AdministrativeUnits_V1.AdministrativeUnits.AdministrativeElement;
      Agency -- Agency;
    END Authority;

    ASSOCIATION Organisation =
      Orderer (EXTERNAL) -- Agency OR AdministrativeUnits_V1.AdministrativeUnits.AdministrativeElement;
      Executor -- Agency;
    END Organisation;

  END Agencies;

END AdministrativeUnits_V1.

!! ########################################################################
!!@technicalContact=mailto:models@geo.admin.ch
!!@furtherInformation=https://www.geo.admin.ch/de/geoinformation-schweiz/geobasisdaten/geodata-models.html
MODEL AdministrativeUnitsCH_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2020-04-24" =

  IMPORTS UNQUALIFIED INTERLIS;
  IMPORTS UNQUALIFIED CHAdminCodes_V1;
  IMPORTS UNQUALIFIED InternationalCodes_V1;
  IMPORTS LocalisationCH_V1;
  IMPORTS AdministrativeUnits_V1;

  TOPIC CHCantons EXTENDS AdministrativeUnits_V1.AdministrativeUnits =
    DEPENDS ON AdministrativeUnits_V1.Countries;

    CLASS CHCanton EXTENDS AdministrativeUnit =
      Code: MANDATORY CHCantonCode;
      Name: LocalisationCH_V1.MultilingualText;
      Web: URI;
    UNIQUE Code;
    END CHCanton;

    ASSOCIATION Hierarchy (EXTENDED) =
      UpperLevelUnit (EXTENDED, EXTERNAL) -<> {1..1} AdministrativeUnits_V1.Countries.Country;
      LowerLevelUnit (EXTENDED) -- CHCanton;
    MANDATORY CONSTRAINT
      UpperLevelUnit->Code == #CHE;
    END Hierarchy;

  END CHCantons;

  TOPIC CHDistricts EXTENDS AdministrativeUnits_V1.AdministrativeUnits =
    DEPENDS ON AdministrativeUnitsCH_V1.CHCantons;

    CLASS CHDistrict EXTENDS AdministrativeUnit =
      ShortName: MANDATORY TEXT*20;
      Name: LocalisationCH_V1.MultilingualText;
      Web: MANDATORY URI;
    END CHDistrict;

    ASSOCIATION Hierarchy (EXTENDED) =
      UpperLevelUnit (EXTENDED, EXTERNAL) -<> {1..1} AdministrativeUnitsCH_V1.CHCantons.CHCanton;
      LowerLevelUnit (EXTENDED) -- CHDistrict;
    UNIQUE UpperLevelUnit->Code, LowerLevelUnit->ShortName;
    END Hierarchy;

  END CHDistricts;

  TOPIC CHMunicipalities EXTENDS AdministrativeUnits_V1.AdministrativeUnits =
    DEPENDS ON AdministrativeUnitsCH_V1.CHCantons;
    DEPENDS ON AdministrativeUnitsCH_V1.CHDistricts;

    CLASS CHMunicipality EXTENDS AdministrativeUnit =
      Code: MANDATORY CHMunicipalityCode;
      Name: LocalisationCH_V1.MultilingualText;
      Web: URI;
    UNIQUE Code;
    END CHMunicipality;

    ASSOCIATION Hierarchy (EXTENDED) =
      UpperLevelUnit (EXTENDED, EXTERNAL) -<> {1..1} AdministrativeUnitsCH_V1.CHCantons.CHCanton
      OR AdministrativeUnitsCH_V1.CHDistricts.CHDistrict;
      LowerLevelUnit (EXTENDED) -- CHMunicipality;
    END Hierarchy;

  END CHMunicipalities;

  TOPIC CHAdministrativeUnions EXTENDS AdministrativeUnits_V1.AdministrativeUnits =
    DEPENDS ON AdministrativeUnits_V1.Countries;
    DEPENDS ON AdministrativeUnitsCH_V1.CHCantons;
    DEPENDS ON AdministrativeUnitsCH_V1.CHDistricts;
    DEPENDS ON AdministrativeUnitsCH_V1.CHMunicipalities;

    CLASS AdministrativeUnion (EXTENDED) =
    OID AS UUIDOID;
      Name: LocalisationCH_V1.MultilingualText;
      Web: URI;
      Description: LocalisationCH_V1.MultilingualMText;
    END AdministrativeUnion;

  END CHAdministrativeUnions;

  TOPIC CHAgencies EXTENDS AdministrativeUnits_V1.Agencies =
    DEPENDS ON AdministrativeUnits_V1.Countries;
    DEPENDS ON AdministrativeUnitsCH_V1.CHCantons;
    DEPENDS ON AdministrativeUnitsCH_V1.CHDistricts;
    DEPENDS ON AdministrativeUnitsCH_V1.CHMunicipalities;

    CLASS Agency (EXTENDED) =
    OID AS UUIDOID;
      Name: LocalisationCH_V1.MultilingualText;
      Web: URI;
      Description: LocalisationCH_V1.MultilingualMText;
    END Agency;

  END CHAgencies;

END AdministrativeUnitsCH_V1.

!! ########################################################################
','2021-08-17 16:55:12.992');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.createMetaInfo','True');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.beautifyEnumDispName','underscore');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.arrayTrafo','coalesce');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.nameOptimization','topic');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.localisedTrafo','expand');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.numericCheckConstraints','create');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.sender','ili2pg-4.3.1-23b1f79e8ad644414773bb9bd1a97c8c265c5082');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.createForeignKey','yes');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.sqlgen.createGeomIndex','True');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.defaultSrsAuthority','EPSG');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.defaultSrsCode','2056');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.uuidDefaultValue','uuid_generate_v4()');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.StrokeArcs','enable');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.multiLineTrafo','coalesce');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.interlis.ili2c.ilidirs','%ILI_FROM_DB;%XTF_DIR;http://models.interlis.ch/;%JAR_DIR');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.TidHandling','property');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.createForeignKeyIndex','yes');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.createDatasetCols','addDatasetCol');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.jsonTrafo','coalesce');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.BasketHandling','readWrite');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.createEnumDefs','multiTable');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.maxSqlNameLength','60');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.inheritanceTrafo','smart1');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.catalogueRefTrafo','coalesce');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.multiPointTrafo','coalesce');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.multiSurfaceTrafo','coalesce');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.multilingualTrafo','expand');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Bezeichnung','ili2db.dispName','Bezeichnung');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('DictionariesCH_V1','furtherInformation','http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('DictionariesCH_V1','technicalContact','models@geo.admin.ch');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('Dictionaries_V1','furtherInformation','http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('Dictionaries_V1','technicalContact','models@geo.admin.ch');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung','ili2db.dispName','Übersteuerung');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('AdministrativeUnits_V1','furtherInformation','https://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('AdministrativeUnits_V1','technicalContact','mailto:models@geo.admin.ch');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.anrechenbar','ili2db.dispName','anrechenbar');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('AdministrativeUnitsCH_V1','furtherInformation','https://www.geo.admin.ch/de/geoinformation-schweiz/geobasisdaten/geodata-models.html');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('AdministrativeUnitsCH_V1','technicalContact','mailto:models@geo.admin.ch');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Spezialfall','ili2db.dispName','Spezialfall');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528','furtherInformation','http://geo.so.ch/models/ALW/SO_ALW_FFF_Uebersteuerung_20210528.uml');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528','technicalContact','mailto:agi@bd.so.ch');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Fall','ili2db.dispName','Fall');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Geometrie','ili2db.dispName','Geometrie');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Beschreibung','ili2db.dispName','Beschreibung');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Erfassung','ili2db.dispName','Erfassung');
INSERT INTO alw_fff_uebersteuerung.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('SO_ALW_FFF_Uebersteuerung_20210528.Uebersteuerung.Uebersteuerung.Datenstand','ili2db.dispName','Datenstand');
