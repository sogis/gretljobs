CREATE SCHEMA IF NOT EXISTS swisstopo_gebaeudeadressen;
CREATE SEQUENCE swisstopo_gebaeudeadressen.t_ili2db_seq;;
-- Localisation_V1.LocalisedText
CREATE TABLE swisstopo_gebaeudeadressen.localisedtext (
  T_Id bigint PRIMARY KEY DEFAULT nextval('swisstopo_gebaeudeadressen.t_ili2db_seq')
  ,T_Type varchar(60) NOT NULL
  ,T_Seq bigint NULL
  ,alanguage varchar(255) NULL
  ,atext text NOT NULL
  ,multilingualtext_localisedtext bigint NULL
)
;
CREATE INDEX localisedtext_multilingualtext_lclsdtext_idx ON swisstopo_gebaeudeadressen.localisedtext ( multilingualtext_localisedtext );
-- Localisation_V1.MultilingualText
CREATE TABLE swisstopo_gebaeudeadressen.multilingualtext (
  T_Id bigint PRIMARY KEY DEFAULT nextval('swisstopo_gebaeudeadressen.t_ili2db_seq')
  ,T_Type varchar(60) NOT NULL
  ,T_Seq bigint NULL
)
;
-- WithLatestModification_V1.ModInfo
CREATE TABLE swisstopo_gebaeudeadressen.modinfo (
  T_Id bigint PRIMARY KEY DEFAULT nextval('swisstopo_gebaeudeadressen.t_ili2db_seq')
  ,T_Type varchar(60) NOT NULL
  ,T_Seq bigint NULL
  ,validfrom timestamp NULL
  ,validuntil timestamp NULL
  ,latestmodification timestamp NOT NULL
  ,offclndxfddrsss_ddress_adr_modified bigint NULL
)
;
CREATE INDEX modinfo_offclndxfddrsrss_dr_mdfied_idx ON swisstopo_gebaeudeadressen.modinfo ( offclndxfddrsss_ddress_adr_modified );
-- OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.ZIP6
CREATE TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_zip6 (
  T_Id bigint PRIMARY KEY DEFAULT nextval('swisstopo_gebaeudeadressen.t_ili2db_seq')
  ,T_Seq bigint NULL
  ,zip_zip4 integer NOT NULL
  ,zip_zipa integer NOT NULL
  ,zip_name varchar(40) NOT NULL
  ,offclndxfddrsss_ddress_adr_zip bigint NULL
)
;
CREATE INDEX officlndxfddrsses_zip6_offclndxfddrs_ddrss_dr_zip_idx ON swisstopo_gebaeudeadressen.officlndxfddrsses_zip6 ( offclndxfddrsss_ddress_adr_zip );
-- OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.LocalisationName
CREATE TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_localisationname (
  T_Id bigint PRIMARY KEY DEFAULT nextval('swisstopo_gebaeudeadressen.t_ili2db_seq')
  ,T_Seq bigint NULL
  ,stn_text text NULL
  ,stn_text_de text NULL
  ,stn_text_fr text NULL
  ,stn_text_rm text NULL
  ,stn_text_it text NULL
  ,stn_text_en text NULL
  ,stn_short text NULL
  ,stn_short_de text NULL
  ,stn_short_fr text NULL
  ,stn_short_rm text NULL
  ,stn_short_it text NULL
  ,stn_short_en text NULL
  ,stn_index text NULL
  ,stn_index_de text NULL
  ,stn_index_fr text NULL
  ,stn_index_rm text NULL
  ,stn_index_it text NULL
  ,stn_index_en text NULL
  ,offclndxfddrsss_ddress_stn_name bigint NULL
)
;
CREATE INDEX offclndxfddrsss_lclstnname_offclndxfddrsdrss_stn_name_idx ON swisstopo_gebaeudeadressen.officlndxfddrsses_localisationname ( offclndxfddrsss_ddress_stn_name );
-- OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address
CREATE TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_address (
  T_Id bigint PRIMARY KEY DEFAULT nextval('swisstopo_gebaeudeadressen.t_ili2db_seq')
  ,T_Ili_Tid uuid NULL DEFAULT uuid_generate_v4()
  ,adr_egaid integer NOT NULL
  ,str_esid integer NOT NULL
  ,bdg_egid integer NOT NULL
  ,adr_edid integer NOT NULL
  ,adr_number varchar(12) NULL
  ,bdg_name varchar(50) NULL
  ,com_fosnr integer NOT NULL
  ,adr_status varchar(255) NOT NULL
  ,adr_official boolean NOT NULL
  ,adr_reliable boolean NOT NULL
  ,pnt_shape geometry(POINT,2056) NOT NULL
)
;
CREATE INDEX officlndxfddrsses_address_pnt_shape_idx ON swisstopo_gebaeudeadressen.officlndxfddrsses_address USING GIST ( pnt_shape );
CREATE TABLE swisstopo_gebaeudeadressen.T_ILI2DB_BASKET (
  T_Id bigint PRIMARY KEY
  ,dataset bigint NULL
  ,topic varchar(200) NOT NULL
  ,T_Ili_Tid varchar(200) NULL
  ,attachmentKey varchar(200) NOT NULL
  ,domains varchar(1024) NULL
)
;
CREATE INDEX T_ILI2DB_BASKET_dataset_idx ON swisstopo_gebaeudeadressen.t_ili2db_basket ( dataset );
CREATE TABLE swisstopo_gebaeudeadressen.T_ILI2DB_DATASET (
  T_Id bigint PRIMARY KEY
  ,datasetName varchar(200) NULL
)
;
CREATE TABLE swisstopo_gebaeudeadressen.T_ILI2DB_INHERITANCE (
  thisClass varchar(1024) PRIMARY KEY
  ,baseClass varchar(1024) NULL
)
;
CREATE TABLE swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (
  tag varchar(60) PRIMARY KEY
  ,setting varchar(1024) NULL
)
;
CREATE TABLE swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (
  iliname varchar(1024) NOT NULL
  ,tag varchar(1024) NOT NULL
  ,setting varchar(1024) NOT NULL
)
;
CREATE TABLE swisstopo_gebaeudeadressen.T_ILI2DB_MODEL (
  filename varchar(250) NOT NULL
  ,iliversion varchar(3) NOT NULL
  ,modelName text NOT NULL
  ,content text NOT NULL
  ,importDate timestamp NOT NULL
  ,PRIMARY KEY (modelName,iliversion)
)
;
CREATE TABLE swisstopo_gebaeudeadressen.languagecode_iso639_1 (
  itfCode integer PRIMARY KEY
  ,iliCode varchar(1024) NOT NULL
  ,seq integer NULL
  ,inactive boolean NOT NULL
  ,dispName varchar(250) NOT NULL
  ,description varchar(1024) NULL
)
;
CREATE TABLE swisstopo_gebaeudeadressen.offclndfddrsses_address_adr_status (
  itfCode integer PRIMARY KEY
  ,iliCode varchar(1024) NOT NULL
  ,seq integer NULL
  ,inactive boolean NOT NULL
  ,dispName varchar(250) NOT NULL
  ,description varchar(1024) NULL
)
;
CREATE TABLE swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (
  IliName varchar(1024) PRIMARY KEY
  ,SqlName varchar(1024) NOT NULL
)
;
CREATE TABLE swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (
  IliName varchar(1024) NOT NULL
  ,SqlName varchar(1024) NOT NULL
  ,ColOwner varchar(1024) NOT NULL
  ,Target varchar(1024) NULL
  ,PRIMARY KEY (SqlName,ColOwner)
)
;
CREATE TABLE swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (
  tablename varchar(255) NOT NULL
  ,subtype varchar(255) NULL
  ,columnname varchar(255) NOT NULL
  ,tag varchar(1024) NOT NULL
  ,setting varchar(1024) NOT NULL
)
;
CREATE TABLE swisstopo_gebaeudeadressen.T_ILI2DB_TABLE_PROP (
  tablename varchar(255) NOT NULL
  ,tag varchar(1024) NOT NULL
  ,setting varchar(1024) NOT NULL
)
;
CREATE TABLE swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (
  ilielement varchar(255) NOT NULL
  ,attr_name varchar(1024) NOT NULL
  ,attr_value varchar(1024) NOT NULL
)
;
ALTER TABLE swisstopo_gebaeudeadressen.localisedtext ADD CONSTRAINT localisedtext_multilingualtext_lclsdtext_fkey FOREIGN KEY ( multilingualtext_localisedtext ) REFERENCES swisstopo_gebaeudeadressen.multilingualtext DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE swisstopo_gebaeudeadressen.modinfo ADD CONSTRAINT modinfo_offclndxfddrsrss_dr_mdfied_fkey FOREIGN KEY ( offclndxfddrsss_ddress_adr_modified ) REFERENCES swisstopo_gebaeudeadressen.officlndxfddrsses_address DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_zip6 ADD CONSTRAINT officlndxfddrsses_zip6_zip_zip4_check CHECK( zip_zip4 BETWEEN 1000 AND 9999);
ALTER TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_zip6 ADD CONSTRAINT officlndxfddrsses_zip6_zip_zipa_check CHECK( zip_zipa BETWEEN 0 AND 99);
ALTER TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_zip6 ADD CONSTRAINT officlndxfddrsses_zip6_offclndxfddrs_ddrss_dr_zip_fkey FOREIGN KEY ( offclndxfddrsss_ddress_adr_zip ) REFERENCES swisstopo_gebaeudeadressen.officlndxfddrsses_address DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_localisationname ADD CONSTRAINT offclndxfddrsss_lclstnname_offclndxfddrsdrss_stn_name_fkey FOREIGN KEY ( offclndxfddrsss_ddress_stn_name ) REFERENCES swisstopo_gebaeudeadressen.officlndxfddrsses_address DEFERRABLE INITIALLY DEFERRED;
CREATE UNIQUE INDEX officlndxfddrsses_address_adr_egaid_key ON swisstopo_gebaeudeadressen.officlndxfddrsses_address (adr_egaid)
;
CREATE UNIQUE INDEX offclnddress_adr_edid_str_esid_bdg_egid_key ON swisstopo_gebaeudeadressen.officlndxfddrsses_address (adr_edid,str_esid,bdg_egid)
;
ALTER TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_address ADD CONSTRAINT officlndxfddrsses_address_adr_egaid_check CHECK( adr_egaid BETWEEN 100000000 AND 900000000);
ALTER TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_address ADD CONSTRAINT officlndxfddrsses_address_str_esid_check CHECK( str_esid BETWEEN 0 AND 90000000);
ALTER TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_address ADD CONSTRAINT officlndxfddrsses_address_bdg_egid_check CHECK( bdg_egid BETWEEN 1 AND 900000000);
ALTER TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_address ADD CONSTRAINT officlndxfddrsses_address_adr_edid_check CHECK( adr_edid BETWEEN 0 AND 99);
ALTER TABLE swisstopo_gebaeudeadressen.officlndxfddrsses_address ADD CONSTRAINT officlndxfddrsses_address_com_fosnr_check CHECK( com_fosnr BETWEEN 1 AND 9999);
ALTER TABLE swisstopo_gebaeudeadressen.T_ILI2DB_BASKET ADD CONSTRAINT T_ILI2DB_BASKET_dataset_fkey FOREIGN KEY ( dataset ) REFERENCES swisstopo_gebaeudeadressen.T_ILI2DB_DATASET DEFERRABLE INITIALLY DEFERRED;
CREATE UNIQUE INDEX T_ILI2DB_DATASET_datasetName_key ON swisstopo_gebaeudeadressen.T_ILI2DB_DATASET (datasetName)
;
CREATE UNIQUE INDEX T_ILI2DB_MODEL_modelName_iliversion_key ON swisstopo_gebaeudeadressen.T_ILI2DB_MODEL (modelName,iliversion)
;
CREATE UNIQUE INDEX T_ILI2DB_ATTRNAME_SqlName_ColOwner_key ON swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (SqlName,ColOwner)
;
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('Localisation_V1.MultilingualText','multilingualtext');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('WithModificationObjects_V1.ModInfo','withmodificationobjects_v1_modinfo');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('InternationalCodes_V1.LanguageCode_ISO639_1','languagecode_iso639_1');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('LocalisationCH_V1.MultilingualText','localisationch_v1_multilingualtext');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('LocalisationCH_V1.LocalisedText','localisationch_v1_localisedtext');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('Localisation_V1.LocalisedText','localisedtext');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.ZIP6','officlndxfddrsses_zip6');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.LocalisationName','officlndxfddrsses_localisationname');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('WithLatestModification_V1.ModInfo','modinfo');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address','officlndxfddrsses_address');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_CLASSNAME (IliName,SqlName) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.ADR_STATUS','offclndfddrsses_address_adr_status');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('Localisation_V1.MultilingualText.LocalisedText','multilingualtext_localisedtext','localisedtext','multilingualtext');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.ZIP6.ZIP_ZIPA','zip_zipa','officlndxfddrsses_zip6',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.LocalisationName.STN_INDEX','stn_index','officlndxfddrsses_localisationname',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.ADR_EGAID','adr_egaid','officlndxfddrsses_address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.BDG_EGID','bdg_egid','officlndxfddrsses_address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.ADR_MODIFIED','offclndxfddrsss_ddress_adr_modified','modinfo','officlndxfddrsses_address');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.ADR_NUMBER','adr_number','officlndxfddrsses_address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.ZIP6.ZIP_NAME','zip_name','officlndxfddrsses_zip6',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.STR_ESID','str_esid','officlndxfddrsses_address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('WithLatestModification_V1.ModInfo.ValidFrom','validfrom','modinfo',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.ADR_ZIP','offclndxfddrsss_ddress_adr_zip','officlndxfddrsses_zip6','officlndxfddrsses_address');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('Localisation_V1.LocalisedText.Text','atext','localisedtext',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.BDG_NAME','bdg_name','officlndxfddrsses_address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.ADR_OFFICIAL','adr_official','officlndxfddrsses_address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('WithLatestModification_V1.ModInfo.LatestModification','latestmodification','modinfo',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.STN_NAME','offclndxfddrsss_ddress_stn_name','officlndxfddrsses_localisationname','officlndxfddrsses_address');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.ZIP6.ZIP_ZIP4','zip_zip4','officlndxfddrsses_zip6',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.LocalisationName.STN_TEXT','stn_text','officlndxfddrsses_localisationname',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.ADR_STATUS','adr_status','officlndxfddrsses_address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.ADR_EDID','adr_edid','officlndxfddrsses_address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('WithLatestModification_V1.ModInfo.ValidUntil','validuntil','modinfo',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.ADR_RELIABLE','adr_reliable','officlndxfddrsses_address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('Localisation_V1.LocalisedText.Language','alanguage','localisedtext',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.PNT_SHAPE','pnt_shape','officlndxfddrsses_address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.LocalisationName.STN_SHORT','stn_short','officlndxfddrsses_localisationname',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_ATTRNAME (IliName,SqlName,ColOwner,Target) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address.COM_FOSNR','com_fosnr','officlndxfddrsses_address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('Localisation_V1.MultilingualText','ch.ehi.ili2db.inheritance','newClass');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.LocalisationName.STN_INDEX','ch.ehi.ili2db.multilingualTrafo','expand');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('LocalisationCH_V1.MultilingualText','ch.ehi.ili2db.inheritance','superClass');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('LocalisationCH_V1.LocalisedText','ch.ehi.ili2db.inheritance','superClass');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.LocalisationName.STN_TEXT','ch.ehi.ili2db.multilingualTrafo','expand');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('Localisation_V1.LocalisedText','ch.ehi.ili2db.inheritance','newClass');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.ZIP6','ch.ehi.ili2db.inheritance','newClass');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.LocalisationName','ch.ehi.ili2db.inheritance','newClass');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('WithLatestModification_V1.ModInfo','ch.ehi.ili2db.inheritance','newClass');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.LocalisationName.STN_SHORT','ch.ehi.ili2db.multilingualTrafo','expand');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TRAFO (iliname,tag,setting) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address','ch.ehi.ili2db.inheritance','newClass');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_INHERITANCE (thisClass,baseClass) VALUES ('LocalisationCH_V1.LocalisedText','Localisation_V1.LocalisedText');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_INHERITANCE (thisClass,baseClass) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.LocalisationName',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_INHERITANCE (thisClass,baseClass) VALUES ('LocalisationCH_V1.MultilingualText','Localisation_V1.MultilingualText');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_INHERITANCE (thisClass,baseClass) VALUES ('Localisation_V1.LocalisedText',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_INHERITANCE (thisClass,baseClass) VALUES ('Localisation_V1.MultilingualText',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_INHERITANCE (thisClass,baseClass) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.Address',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_INHERITANCE (thisClass,baseClass) VALUES ('OfficialIndexOfAddresses_V1.OfficialIndexOfAddresses.ZIP6',NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_INHERITANCE (thisClass,baseClass) VALUES ('WithLatestModification_V1.ModInfo',NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'de',0,'de',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'fr',1,'fr',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'it',2,'it',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'rm',3,'rm',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'en',4,'en',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'aa',5,'aa',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ab',6,'ab',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'af',7,'af',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'am',8,'am',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ar',9,'ar',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'as',10,'as',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ay',11,'ay',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'az',12,'az',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ba',13,'ba',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'be',14,'be',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'bg',15,'bg',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'bh',16,'bh',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'bi',17,'bi',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'bn',18,'bn',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'bo',19,'bo',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'br',20,'br',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ca',21,'ca',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'co',22,'co',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'cs',23,'cs',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'cy',24,'cy',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'da',25,'da',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'dz',26,'dz',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'el',27,'el',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'eo',28,'eo',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'es',29,'es',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'et',30,'et',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'eu',31,'eu',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'fa',32,'fa',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'fi',33,'fi',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'fj',34,'fj',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'fo',35,'fo',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'fy',36,'fy',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ga',37,'ga',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'gd',38,'gd',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'gl',39,'gl',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'gn',40,'gn',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'gu',41,'gu',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ha',42,'ha',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'he',43,'he',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'hi',44,'hi',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'hr',45,'hr',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'hu',46,'hu',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'hy',47,'hy',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ia',48,'ia',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'id',49,'id',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ie',50,'ie',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ik',51,'ik',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'is',52,'is',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'iu',53,'iu',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ja',54,'ja',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'jw',55,'jw',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ka',56,'ka',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'kk',57,'kk',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'kl',58,'kl',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'km',59,'km',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'kn',60,'kn',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ko',61,'ko',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ks',62,'ks',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ku',63,'ku',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ky',64,'ky',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'la',65,'la',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ln',66,'ln',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'lo',67,'lo',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'lt',68,'lt',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'lv',69,'lv',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'mg',70,'mg',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'mi',71,'mi',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'mk',72,'mk',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ml',73,'ml',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'mn',74,'mn',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'mo',75,'mo',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'mr',76,'mr',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ms',77,'ms',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'mt',78,'mt',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'my',79,'my',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'na',80,'na',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ne',81,'ne',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'nl',82,'nl',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'no',83,'no',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'oc',84,'oc',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'om',85,'om',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'or',86,'or',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'pa',87,'pa',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'pl',88,'pl',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ps',89,'ps',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'pt',90,'pt',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'qu',91,'qu',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'rn',92,'rn',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ro',93,'ro',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ru',94,'ru',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'rw',95,'rw',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sa',96,'sa',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sd',97,'sd',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sg',98,'sg',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sh',99,'sh',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'si',100,'si',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sk',101,'sk',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sl',102,'sl',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sm',103,'sm',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sn',104,'sn',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'so',105,'so',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sq',106,'sq',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sr',107,'sr',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ss',108,'ss',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'st',109,'st',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'su',110,'su',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sv',111,'sv',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'sw',112,'sw',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ta',113,'ta',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'te',114,'te',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'tg',115,'tg',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'th',116,'th',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ti',117,'ti',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'tk',118,'tk',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'tl',119,'tl',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'tn',120,'tn',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'to',121,'to',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'tr',122,'tr',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ts',123,'ts',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'tt',124,'tt',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'tw',125,'tw',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ug',126,'ug',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'uk',127,'uk',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'ur',128,'ur',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'uz',129,'uz',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'vi',130,'vi',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'vo',131,'vo',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'wo',132,'wo',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'xh',133,'xh',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'yi',134,'yi',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'yo',135,'yo',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'za',136,'za',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'zh',137,'zh',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.languagecode_iso639_1 (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'zu',138,'zu',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.offclndfddrsses_address_adr_status (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'planned',0,'planned',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.offclndfddrsses_address_adr_status (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'real',1,'real',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.offclndfddrsses_address_adr_status (seq,iliCode,itfCode,dispName,inactive,description) VALUES (NULL,'outdated',2,'outdated',FALSE,NULL);
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('localisedtext',NULL,'T_Type','ch.ehi.ili2db.types','["localisationch_v1_localisedtext","localisedtext"]');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('officlndxfddrsses_address',NULL,'pnt_shape','ch.ehi.ili2db.coordDimension','2');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('officlndxfddrsses_address',NULL,'pnt_shape','ch.ehi.ili2db.c1Max','2870000.000');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('officlndxfddrsses_address',NULL,'pnt_shape','ch.ehi.ili2db.c2Max','1310000.000');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('officlndxfddrsses_address',NULL,'pnt_shape','ch.ehi.ili2db.geomType','POINT');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('officlndxfddrsses_address',NULL,'pnt_shape','ch.ehi.ili2db.c1Min','2460000.000');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('officlndxfddrsses_address',NULL,'pnt_shape','ch.ehi.ili2db.c2Min','1045000.000');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('officlndxfddrsses_address',NULL,'pnt_shape','ch.ehi.ili2db.srid','2056');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('multilingualtext',NULL,'T_Type','ch.ehi.ili2db.types','["localisationch_v1_multilingualtext","multilingualtext"]');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('officlndxfddrsses_zip6',NULL,'offclndxfddrsss_ddress_adr_zip','ch.ehi.ili2db.foreignKey','officlndxfddrsses_address');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('modinfo',NULL,'offclndxfddrsss_ddress_adr_modified','ch.ehi.ili2db.foreignKey','officlndxfddrsses_address');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('officlndxfddrsses_localisationname',NULL,'offclndxfddrsss_ddress_stn_name','ch.ehi.ili2db.foreignKey','officlndxfddrsses_address');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('localisedtext',NULL,'multilingualtext_localisedtext','ch.ehi.ili2db.foreignKey','multilingualtext');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_COLUMN_PROP (tablename,subtype,columnname,tag,setting) VALUES ('modinfo',NULL,'T_Type','ch.ehi.ili2db.types','["modinfo","withmodificationobjects_v1_modinfo"]');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('officlndxfddrsses_localisationname','ch.ehi.ili2db.tableKind','STRUCTURE');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('modinfo','ch.ehi.ili2db.tableKind','STRUCTURE');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('languagecode_iso639_1','ch.ehi.ili2db.tableKind','ENUM');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('officlndxfddrsses_address','ch.ehi.ili2db.tableKind','CLASS');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('localisedtext','ch.ehi.ili2db.tableKind','STRUCTURE');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('officlndxfddrsses_zip6','ch.ehi.ili2db.tableKind','STRUCTURE');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('multilingualtext','ch.ehi.ili2db.tableKind','STRUCTURE');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_TABLE_PROP (tablename,tag,setting) VALUES ('offclndfddrsses_address_adr_status','ch.ehi.ili2db.tableKind','ENUM');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('CHBase_Part5_MODIFICATIONINFO_20110830.ili','2.3','WithOneState_V1 WithLatestModification_V1{ INTERLIS} WithModificationObjects_V1{ WithLatestModification_V1 INTERLIS}','/* ########################################################################
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
   PART V -- MODIFICATION INFORMATION
   - Package WithOneState
   - Package WithLatestModification
   - Package WithModificationObjects
*/

!! Version    | Who   | Modification
!!------------------------------------------------------------------------------
!! 2018-02-19 | KOGIS | MANDATORY CONSTRAINT adapted (line 50)

!! ########################################################################
!!@technicalContact=models@geo.admin.ch
!!@furtherInformation=http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html
MODEL WithOneState_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2011-08-30" =

  STRUCTURE ModInfo =
  END ModInfo;

END WithOneState_V1.

!! ########################################################################
!!@technicalContact=models@geo.admin.ch
!!@furtherInformation=https://www.geo.admin.ch/de/geoinformation-schweiz/geobasisdaten/geodata-models.html
MODEL WithLatestModification_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2018-02-19" =

  IMPORTS UNQUALIFIED INTERLIS;

  STRUCTURE ModInfo =
    ValidFrom: XMLDateTime;
    ValidUntil: XMLDateTime;
    LatestModification: MANDATORY XMLDateTime;
  MANDATORY CONSTRAINT
    NOT (DEFINED(ValidUntil)) OR (LatestModification < ValidUntil);
  END ModInfo;

END WithLatestModification_V1.

!! ########################################################################
!!@technicalContact=models@geo.admin.ch
!!@furtherInformation=http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html
MODEL WithModificationObjects_V1 (en)
  AT "http://www.geo.admin.ch" VERSION "2011-08-30" =

  IMPORTS UNQUALIFIED INTERLIS;
  IMPORTS WithLatestModification_V1;

  TOPIC Modifications (ABSTRACT) =

    CLASS Modification (ABSTRACT) =
      ModificationTime: MANDATORY XMLDateTime;
    END Modification;

  END Modifications;

  STRUCTURE ModificationReference =
    Reference: MANDATORY REFERENCE TO (EXTERNAL)
      WithModificationObjects_V1.Modifications.Modification;
  END ModificationReference;

  STRUCTURE ModInfo EXTENDS WithLatestModification_V1.ModInfo =
    Modifications: LIST OF ModificationReference;
	 /* Order: descending ModificationTime of referenced Modifications */
  END ModInfo;

END WithModificationObjects_V1.

!! ########################################################################
','2020-09-17 20:03:39.869');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('CHBase_Part1_GEOMETRY_20110830.ili','2.3','GeometryCHLV03_V1{ CoordSys Units INTERLIS} GeometryCHLV95_V1{ CoordSys Units INTERLIS}','/* ########################################################################
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
','2020-09-17 20:03:39.869');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('CoordSys-20151124.ili','2.3','CoordSys','!! File CoordSys.ili Release 2015-11-24

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

','2020-09-17 20:03:39.869');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('Units-20120220.ili','2.3','Units','!! File Units.ili Release 2012-02-20

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

','2020-09-17 20:03:39.869');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('CHBase_Part2_LOCALISATION_20110830.ili','2.3','InternationalCodes_V1 Localisation_V1{ InternationalCodes_V1} LocalisationCH_V1{ InternationalCodes_V1 Localisation_V1} Dictionaries_V1{ InternationalCodes_V1} DictionariesCH_V1{ InternationalCodes_V1 Dictionaries_V1}','/* ########################################################################
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
','2020-09-17 20:03:39.869');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_MODEL (filename,iliversion,modelName,content,importDate) VALUES ('OfficialIndexOfAddresses_V1.ili','2.3','OfficialIndexOfAddresses_V1{ GeometryCHLV95_V1 LocalisationCH_V1 WithLatestModification_V1}','INTERLIS 2.3;

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!
!! Minimal Geodata Model for Official Index of Addresses (Art. 26b GeoNV)
!! INTERLIS Version 2.3 (SN 612031).
!!
!! Federal Office of Topography (swisstopo)
!! Seftigenstrasse 264
!! CH-3084 Wabern
!!
!! Filename: OfficialIndexOfAddresses_V1.ili
!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!!@ IDGeoIV = 197.1
!!@ technicalContact = mailto:info@swisstopo.ch
!!@ furtherInformation = https://www.swisstopo.ch

CONTRACTED MODEL OfficialIndexOfAddresses_V1 (en) AT "https://models.geo.admin.ch/Swisstopo/" VERSION "2019-12-01" =

  IMPORTS GeometryCHLV95_V1;
  IMPORTS LocalisationCH_V1;
  IMPORTS WithLatestModification_V1;

  TOPIC OfficialIndexOfAddresses =
    OID AS INTERLIS.UUIDOID;

    STRUCTURE ZIP6 =
      ZIP_ZIP4: MANDATORY 1000 .. 9999;  !! postal code, e.g. 8580
      ZIP_ZIPA: MANDATORY 0 .. 99;  !! additional number, e.g. 05
      ZIP_NAME: MANDATORY TEXT*40;  !! locality, e.g. Hagenwil b. Amriswil
    END ZIP6;

    STRUCTURE LocalisationName =
      STN_TEXT: MANDATORY LocalisationCH_V1.MultilingualText;  !! e.g. Conrad-Ferdinand-Meyer-Strasse
      STN_SHORT: LocalisationCH_V1.MultilingualText;  !! e.g. CF Meyer Str
      STN_INDEX: LocalisationCH_V1.MultilingualText;  !! e.g. Meyer CF Str
    END LocalisationName;

    CLASS Address =
      ADR_EGAID: MANDATORY 100000000 .. 900000000;
      STR_ESID: MANDATORY 0 .. 90000000;
      BDG_EGID: MANDATORY 1 .. 900000000;
      ADR_EDID: MANDATORY 0 .. 99;
      STN_NAME: LocalisationName;
      ADR_NUMBER: TEXT*12;  !! house number, e.g. 12a
      BDG_NAME: TEXT*50;  !! building name, e.g. Haus Steindach
      ADR_ZIP: ZIP6;
      COM_FOSNR: MANDATORY 1 .. 9999;
      ADR_STATUS: MANDATORY (
        planned,
        real,
        outdated: FINAL);
      ADR_OFFICIAL: MANDATORY BOOLEAN;
      ADR_RELIABLE: MANDATORY BOOLEAN;
      ADR_MODIFIED: MANDATORY WithLatestModification_V1.ModInfo;
      PNT_SHAPE: MANDATORY GeometryCHLV95_V1.Coord2;
    UNIQUE ADR_EGAID;
    UNIQUE STR_ESID, BDG_EGID, ADR_EDID;

    !! Every address must have either house number or building name
    MANDATORY CONSTRAINT
      DEFINED (ADR_NUMBER) OR DEFINED (BDG_NAME);

    END Address;

  END OfficialIndexOfAddresses;

END OfficialIndexOfAddresses_V1.','2020-09-17 20:03:39.869');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.createMetaInfo','True');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.beautifyEnumDispName','underscore');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.arrayTrafo','coalesce');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.nameOptimization','topic');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.localisedTrafo','expand');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.numericCheckConstraints','create');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.sender','ili2pg-4.3.1-23b1f79e8ad644414773bb9bd1a97c8c265c5082');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.createForeignKey','yes');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.sqlgen.createGeomIndex','True');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.defaultSrsAuthority','EPSG');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.defaultSrsCode','2056');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.uuidDefaultValue','uuid_generate_v4()');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.StrokeArcs','enable');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.multiLineTrafo','coalesce');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.interlis.ili2c.ilidirs','%ILI_FROM_DB;%XTF_DIR;http://models.interlis.ch/;%JAR_DIR');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.createForeignKeyIndex','yes');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.jsonTrafo','coalesce');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.createEnumDefs','multiTable');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.uniqueConstraints','create');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.maxSqlNameLength','60');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.inheritanceTrafo','smart1');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.catalogueRefTrafo','coalesce');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.multiPointTrafo','coalesce');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.multiSurfaceTrafo','coalesce');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_SETTINGS (tag,setting) VALUES ('ch.ehi.ili2db.multilingualTrafo','expand');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('DictionariesCH_V1','furtherInformation','http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('DictionariesCH_V1','technicalContact','models@geo.admin.ch');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('Dictionaries_V1','furtherInformation','http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('Dictionaries_V1','technicalContact','models@geo.admin.ch');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('WithOneState_V1','furtherInformation','http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('WithOneState_V1','technicalContact','models@geo.admin.ch');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('WithLatestModification_V1','furtherInformation','https://www.geo.admin.ch/de/geoinformation-schweiz/geobasisdaten/geodata-models.html');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('WithLatestModification_V1','technicalContact','models@geo.admin.ch');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('WithModificationObjects_V1','furtherInformation','http://www.geo.admin.ch/internet/geoportal/de/home/topics/geobasedata/models.html');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('WithModificationObjects_V1','technicalContact','models@geo.admin.ch');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('OfficialIndexOfAddresses_V1','furtherInformation','https://www.swisstopo.ch');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('OfficialIndexOfAddresses_V1','IDGeoIV','197.1');
INSERT INTO swisstopo_gebaeudeadressen.T_ILI2DB_META_ATTRS (ilielement,attr_name,attr_value) VALUES ('OfficialIndexOfAddresses_V1','technicalContact','mailto:info@swisstopo.ch');
