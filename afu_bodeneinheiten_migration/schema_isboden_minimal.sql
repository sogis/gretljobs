-- Minimal schema/tables-only export for afu_isboden

-- Source: schema_isboden.sql (filtered: removed roles, grants, comments, functions, triggers, views)

-- Requirements: PostgreSQL + PostGIS (CREATE EXTENSION postgis)



CREATE EXTENSION IF NOT EXISTS postgis;

CREATE SCHEMA IF NOT EXISTS afu_isboden;



CREATE DOMAIN afu_isboden.d_0_or_neg_1 AS integer
	CONSTRAINT d_0_or_neg_1_check CHECK (VALUE = 0 OR VALUE = '-1'::integer);

CREATE DOMAIN afu_isboden.d_ge_1_or_le_4_or_null AS integer
	CONSTRAINT d_ge_1_or_le_4_or_null CHECK (VALUE > 0 OR VALUE < 5 OR VALUE IS NULL);

CREATE DOMAIN afu_isboden.d_gt_0_le_100 AS integer
	CONSTRAINT d_gt_0_le_100_check CHECK (VALUE > 0 AND VALUE <= 100);

CREATE DOMAIN afu_isboden.d_gt_0_lt_100 AS integer
	CONSTRAINT d_gt_0_lt_100_check CHECK (VALUE > 0 AND VALUE < 100);

CREATE DOMAIN afu_isboden.d_gt_2_lt_9 AS smallint
	CONSTRAINT d_gt_2_lt_9_check CHECK (VALUE > 2 AND VALUE < 9);



CREATE SEQUENCE afu_isboden.begelfor_t_pk_begelfor_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 28
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.bodeneinheit_auspraegung_t_pk_bodeneinheit_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.bodeneinheit_historische_nummer_pk_historische_nummerierung_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.bodeneinheit_t_pk_ogc_fid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.bodentyp_t_pk_bodentyp_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 27
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.csv_import_t_ogc_fid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.druckmodul_ausschnitte_t_pk_ogc_fid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.erosionsgefahr_qgis_server_client_ogc_fid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.gefuegeform_t_pk_gefuegeform_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 16
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.gefueggr_t_pk_gefueggr_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 8
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_ogc_fid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.humusform_wa_t_pk_humusform_wa_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 22
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.kalkgehalt_t_pk_kalkgehalt_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 7
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.koernkl_t_pk_koernkl_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 26
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.skelett_t_pk_skelett_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.untertyp_t_pk_untertyp_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 86
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.wasserhhgr_t_pk_wasserhhgr_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 26
	CACHE 1
	NO CYCLE;

CREATE SEQUENCE afu_isboden.zw_bodeneinheit_untertyp_pk_zw_bodeneinheit_untertyp_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;



CREATE TABLE afu_isboden.begelfor_t ( pk_begelfor int4 DEFAULT nextval('afu_isboden.begelfor_t_pk_begelfor_seq'::regclass) NOT NULL, code varchar(2) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_begelfor_t PRIMARY KEY (pk_begelfor), CONSTRAINT cons_unique_code_begelfor_t UNIQUE (code));

CREATE TABLE afu_isboden.bodeneinheit_lw_qgis_server_client_t ( pk_ogc_fid int8 NOT NULL, gemnr int2 NULL, objnr int4 NULL, wasserhhgr varchar(2) NULL, wasserhhgr_beschreibung varchar(255) NULL, wasserhhgr_qgis_txt varchar NULL, bodentyp varchar(2) NULL, bodentyp_beschreibung varchar(255) NULL, gelform varchar(2) NULL, gelform_beschreibung varchar(255) NULL, geologie varchar(30) NULL, untertyp_e text NULL, untertyp_k text NULL, untertyp_i text NULL, untertyp_g text NULL, untertyp_r text NULL, untertyp_p text NULL, untertyp_div text NULL, skelett_ob int4 NULL, skelett_ob_beschreibung varchar(255) NULL, skelett_ub int4 NULL, skelett_ub_beschreibung varchar(255) NULL, koernkl_ob int4 NULL, koernkl_ob_beschreibung varchar(255) NULL, koernkl_ub int4 NULL, koernkl_ub_beschreibung varchar(255) NULL, ton_ob int4 NULL, ton_ub int4 NULL, schluff_ob int4 NULL, schluff_ub int4 NULL, karbgrenze int4 NULL, kalkgeh_ob int4 NULL, kalkgeh_ob_beschreibung varchar(255) NULL, kalkgeh_ub int4 NULL, kalkgeh_ub_beschreibung varchar(255) NULL, ph_ob float8 NULL, ph_ob_qgis_txt text NULL, ph_ub float8 NULL, ph_ub_qgis_txt text NULL, maechtigk_ah int2 NULL, humusgeh_ah float8 NULL, humusgeh_ah_qgis_txt text NULL, humusform_wa varchar(3) NULL, humusform_wa_beschreibung varchar(255) NULL, humusform_wa_qgis_txt text NULL, maechtigk_ahh float8 NULL, gefuegeform_ob varchar(3) NULL, gefuegeform_ob_beschreibung varchar(255) NULL, gefuegeform_t_ob_qgis_int int4 NULL, gefuegeform_ub varchar(3) NULL, gefuegeform_ub_beschreibung varchar(255) NULL, gefueggr_ob int4 NULL, gefueggr_ob_beschreibung varchar(255) NULL, gefueggr_ub int4 NULL, gefueggr_ub_beschreibung varchar(255) NULL, pflngr int4 NULL, pflngr_qgis_int int4 NULL, bodpktzahl int4 NULL, bodpktzahl_qgis_txt text NULL, bemerkungen varchar(300) NULL, los varchar(25) NULL, kartierjahr int2 NULL, kartierer int8 NULL, kartierquartal afu_isboden.d_ge_1_or_le_4_or_null NULL, is_wald bool NULL, bindst_cd float8 NULL, bindst_zn float8 NULL, bindst_cu float8 NULL, bindst_pb float8 NULL, nfkapwe_ob float8 NULL, nfkapwe_ub float8 NULL, nfkapwe float8 NULL, nfkapwe_qgis_txt text NULL, verdempf int2 NULL, drain_wel float8 NULL, wassastoss float8 NULL, is_hauptauspraegung bool NULL, gewichtung_auspraegung afu_isboden.d_gt_0_le_100 NULL, wkb_geometry public.geometry NULL, archive int4 NULL, CONSTRAINT pk_bodeneinheit_lw_qgis_server_client_t PRIMARY KEY (pk_ogc_fid));

CREATE TABLE afu_isboden.bodeneinheit_onlinedata_t ( pk_isboden int8 NOT NULL, gemnr int2 NULL, objnr int4 NULL, wasserhhgr varchar(2) NULL, bodentyp varchar(2) NULL, gelform varchar(2) NULL, geologie varchar(30) NULL, ut_e text NULL, ut_k text NULL, ut_i text NULL, ut_g text NULL, ut_r text NULL, ut_p text NULL, ut_div text NULL, skelett_ob int4 NULL, skelett_ub int4 NULL, koernkl_ob int4 NULL, koernkl_ub int4 NULL, ton_ob int4 NULL, ton_ub int4 NULL, schluff_ob int4 NULL, schluff_ub int4 NULL, karbgrenze int4 NULL, kalkgeh_ob int4 NULL, kalkgeh_ub int4 NULL, ph_ob float8 NULL, ph_ub float8 NULL, maecht_ah int2 NULL, humus_ah float8 NULL, hmform_wa varchar(3) NULL, maecht_ahh float8 NULL, gefform_ob varchar(3) NULL, gefform_ub varchar(3) NULL, gefgr_ob int4 NULL, gefgr_ub int4 NULL, pflngr int4 NULL, bodpktzahl int4 NULL, bemerkung varchar(300) NULL, los varchar(25) NULL, kjahr int2 NULL, is_wald bool NULL, bindst_cd float8 NULL, bindst_zn float8 NULL, bindst_cu float8 NULL, bindst_pb float8 NULL, nfkapwe_ob float8 NULL, nfkapwe_ub float8 NULL, nfkapwe float8 NULL, verdempf int2 NULL, is_haupt bool NULL, gewichtung afu_isboden.d_gt_0_le_100 NULL, geom public.geometry NULL, archive int2 DEFAULT 0 NOT NULL, new_date date NULL, archive_date date NULL, CONSTRAINT pk_bodeneinheit_onlinedata_t PRIMARY KEY (pk_isboden));

CREATE TABLE afu_isboden.bodeneinheit_overlap_t ( pk_ogc_fid int8 NULL, objnr int4 NULL, gemnr int4 NULL, los varchar(25) NULL, wkb_geometry public.geometry NULL, archive int4 NULL);

CREATE TABLE afu_isboden.bodeneinheit_t ( pk_ogc_fid int8 DEFAULT nextval('afu_isboden.bodeneinheit_t_pk_ogc_fid_seq'::regclass) NOT NULL, objnr int4 NOT NULL, gemnr int2 NOT NULL, is_wald bool NOT NULL, wkb_geometry public.geometry NULL, kuerzel varchar(5) NULL, los varchar(25) NULL, kartierdate varchar(7) NULL, fk_kartierer int8 NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, label_x float8 NULL, label_y float8 NULL, kartierjahr int2 NULL, kartierquartal afu_isboden.d_ge_1_or_le_4_or_null NULL, vali varchar(25) DEFAULT 'half'::character varying NULL, hali varchar(25) DEFAULT 'center'::character varying NULL, gemnr_aktuell int2 NULL, CONSTRAINT bodeneinheit_t_gemnr_objnr_archive_key UNIQUE (gemnr, objnr, archive), CONSTRAINT check_objnr CHECK ((((objnr)::text ~ '^\d{3}$'::text) OR ((objnr)::text ~ '^\d{4}$'::text))), CONSTRAINT cons_enforce_dims_geometrie CHECK ((st_ndims(wkb_geometry) = 2)), CONSTRAINT cons_enforce_geotype_the_geom CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))), CONSTRAINT cons_enforce_srid_geometrie CHECK ((st_srid(wkb_geometry) = 2056)), CONSTRAINT cons_pk_bodeneinheit_t PRIMARY KEY (pk_ogc_fid));

CREATE TABLE afu_isboden.bodeneinheit_wald_qgis_server_client_t ( pk_ogc_fid int8 NOT NULL, gemnr int2 NULL, objnr int4 NULL, wasserhhgr varchar(2) NULL, wasserhhgr_beschreibung varchar(255) NULL, wasserhhgr_qgis_txt varchar NULL, bodentyp varchar(2) NULL, bodentyp_beschreibung varchar(255) NULL, gelform varchar(2) NULL, gelform_beschreibung varchar(255) NULL, geologie varchar(30) NULL, untertyp_e text NULL, untertyp_k text NULL, untertyp_i text NULL, untertyp_g text NULL, untertyp_r text NULL, untertyp_p text NULL, untertyp_div text NULL, skelett_ob int4 NULL, skelett_ob_beschreibung varchar(255) NULL, skelett_ub int4 NULL, skelett_ub_beschreibung varchar(255) NULL, koernkl_ob int4 NULL, koernkl_ob_beschreibung varchar(255) NULL, koernkl_ub int4 NULL, koernkl_ub_beschreibung varchar(255) NULL, ton_ob int4 NULL, ton_ub int4 NULL, schluff_ob int4 NULL, schluff_ub int4 NULL, karbgrenze int4 NULL, kalkgeh_ob int4 NULL, kalkgeh_ob_beschreibung varchar(255) NULL, kalkgeh_ub int4 NULL, kalkgeh_ub_beschreibung varchar(255) NULL, ph_ob float8 NULL, ph_ob_qgis_txt text NULL, ph_ub float8 NULL, ph_ub_qgis_txt text NULL, maechtigk_ah int2 NULL, humusgeh_ah float8 NULL, humusgeh_ah_qgis_txt text NULL, humusform_wa varchar(3) NULL, humusform_wa_beschreibung varchar(255) NULL, humusform_wa_qgis_txt text NULL, maechtigk_ahh float8 NULL, gefuegeform_ob varchar(3) NULL, gefuegeform_ob_beschreibung varchar(255) NULL, gefuegeform_t_ob_qgis_int int4 NULL, gefuegeform_ub varchar(3) NULL, gefuegeform_ub_beschreibung varchar(255) NULL, gefueggr_ob int4 NULL, gefueggr_ob_beschreibung varchar(255) NULL, gefueggr_ub int4 NULL, gefueggr_ub_beschreibung varchar(255) NULL, pflngr int4 NULL, pflngr_qgis_int int4 NULL, bodpktzahl int4 NULL, bodpktzahl_qgis_txt text NULL, bemerkungen varchar(300) NULL, los varchar(25) NULL, kartierjahr int2 NULL, kartierer int8 NULL, kartierquartal afu_isboden.d_ge_1_or_le_4_or_null NULL, is_wald bool NULL, bindst_cd float8 NULL, bindst_zn float8 NULL, bindst_cu float8 NULL, bindst_pb float8 NULL, nfkapwe_ob float8 NULL, nfkapwe_ub float8 NULL, nfkapwe float8 NULL, nfkapwe_qgis_txt text NULL, verdempf int2 NULL, drain_wel float8 NULL, wassastoss float8 NULL, is_hauptauspraegung bool NULL, gewichtung_auspraegung afu_isboden.d_gt_0_le_100 NULL, wkb_geometry public.geometry NULL, archive int4 NULL, CONSTRAINT pk_bodeneinheit_wald_qgis_server_client_t PRIMARY KEY (pk_ogc_fid));

CREATE TABLE afu_isboden.bodentyp_t ( pk_bodentyp int4 DEFAULT nextval('afu_isboden.bodentyp_t_pk_bodentyp_seq'::regclass) NOT NULL, code varchar(2) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_bodentyp_t PRIMARY KEY (pk_bodentyp), CONSTRAINT cons_unique_code_bodentyp_t_code UNIQUE (code));

CREATE TABLE afu_isboden.csv_import_t ( ogc_fid int4 DEFAULT nextval('afu_isboden.csv_import_t_ogc_fid_seq'::regclass) NOT NULL, gemnr varchar NULL, objnr varchar NULL, wasserhhgr varchar NULL, bodentyp varchar NULL, gelform varchar NULL, geologie varchar NULL, untertyp_e varchar NULL, untertyp_k varchar NULL, untertyp_i varchar NULL, untertyp_g varchar NULL, untertyp_r varchar NULL, untertyp_p varchar NULL, untertyp_div varchar NULL, skelett_ob varchar NULL, skelett_ub varchar NULL, koernkl_ob varchar NULL, koernkl_ub varchar NULL, ton_ob varchar NULL, schluff_ob varchar NULL, ton_ub varchar NULL, schluff_ub varchar NULL, karbgrenze varchar NULL, kalkgeh_ob varchar NULL, kalkgeh_ub varchar NULL, ph_ob varchar NULL, ph_ub varchar NULL, maechtigk_ah varchar NULL, humusgeh_ah varchar NULL, humusform_wa varchar NULL, maechtigk_ahh varchar NULL, gefuegeform_ob varchar NULL, gefueggr_ob varchar NULL, gefuegeform_ub varchar NULL, gefueggr_ub varchar NULL, pflngr varchar NULL, bodpktzahl varchar NULL, bemerkungen varchar NULL, los varchar NULL, kartierjahr varchar NULL, kartierer varchar NULL, kartierquartal varchar NULL, is_wald varchar NULL, is_hauptauspraegung varchar NULL, gewichtung_auspraegung varchar NULL, CONSTRAINT csv_import_t_pkey PRIMARY KEY (ogc_fid));

CREATE TABLE afu_isboden.druckmodul_ausschnitte_t ( pk_ogc_fid int4 DEFAULT nextval('afu_isboden.druckmodul_ausschnitte_t_pk_ogc_fid_seq'::regclass) NOT NULL, bezeichnung text NOT NULL, x_minimum numeric(10, 3) NOT NULL, y_minimum numeric(10, 3) NOT NULL, x_maximum numeric(10, 3) NOT NULL, y_maximum numeric(10, 3) NOT NULL, CONSTRAINT druckmodul_ausschnitte_t_pkey PRIMARY KEY (pk_ogc_fid));

CREATE TABLE afu_isboden.erosionsgefahr_qgis_server_client_t ( ogc_fid int4 DEFAULT nextval('afu_isboden.erosionsgefahr_qgis_server_client_ogc_fid_seq'::regclass) NOT NULL, wkb_geometry public.geometry NULL, grid_code int4 NULL, new_date date DEFAULT 'now'::text::date NULL, archive_date date DEFAULT '9999-01-01'::date NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT "$2" CHECK (((geometrytype(wkb_geometry) = 'POLYGON'::text) OR (wkb_geometry IS NULL))), CONSTRAINT cons_enforce_srid_geometrie CHECK ((st_srid(wkb_geometry) = 2056)), CONSTRAINT erosionsgefahr_qgis_server_client_pkey PRIMARY KEY (ogc_fid));

CREATE TABLE afu_isboden.gefuegeform_t ( pk_gefuegeform int4 DEFAULT nextval('afu_isboden.gefuegeform_t_pk_gefuegeform_seq'::regclass) NOT NULL, code varchar(3) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_gefuegeform_t PRIMARY KEY (pk_gefuegeform), CONSTRAINT cons_unique_code_gefuegeform_t UNIQUE (code));

CREATE TABLE afu_isboden.gefueggr_t ( pk_gefueggr int4 DEFAULT nextval('afu_isboden.gefueggr_t_pk_gefueggr_seq'::regclass) NOT NULL, code int4 NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_gefueggr_t PRIMARY KEY (pk_gefueggr), CONSTRAINT cons_unique_code_gefueggr_t UNIQUE (code));

CREATE TABLE afu_isboden.gemeindeteil_t ( ogc_fid int4 NOT NULL, gem_bfs_aktuell int4 NULL, gem_bfs int4 NULL, name_aktuell varchar NULL, "name" varchar NULL, gmde_name_aktuell varchar NULL, gmde_name varchar NULL, gmde_nr_aktuell int4 NULL, gmde_nr int4 NULL, bzrk_nr_aktuell int4 NULL, bzrk_nr int4 NULL, eg_nr_aktuell int4 NULL, eg_nr int4 NULL, plz_aktuell int4 NULL, plz int4 NULL, ktn_nr_aktuell int2 NULL, ktn_nr int2 NULL, wkb_geometry_aktuell public.geometry NULL, wkb_geometry public.geometry NULL, CONSTRAINT gemeindeteil_t_pkey PRIMARY KEY (ogc_fid));

CREATE TABLE afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t ( ogc_fid int4 DEFAULT nextval('afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_ogc_fid_seq'::regclass) NOT NULL, risk_final int4 NULL, verdempf_t varchar(254) NULL, wkb_geometry public.geometry NULL, CONSTRAINT enforce_dims_wkb_geometry CHECK ((st_ndims(wkb_geometry) = 2)), CONSTRAINT enforce_srid_wkb_geometry CHECK ((st_srid(wkb_geometry) = 2056)), CONSTRAINT hinweiskarte_bodenverdichtung_qgis_server_client_pkey PRIMARY KEY (ogc_fid));

CREATE TABLE afu_isboden.humusform_wa_t ( pk_humusform_wa int4 DEFAULT nextval('afu_isboden.humusform_wa_t_pk_humusform_wa_seq'::regclass) NOT NULL, code varchar(3) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_humusform_wa_t PRIMARY KEY (pk_humusform_wa), CONSTRAINT cons_unique_humusform_wa_t UNIQUE (code));

CREATE TABLE afu_isboden.kalkgehalt_t ( pk_kalkgehalt int4 DEFAULT nextval('afu_isboden.kalkgehalt_t_pk_kalkgehalt_seq'::regclass) NOT NULL, code int4 NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_kalkgehalt_t PRIMARY KEY (pk_kalkgehalt), CONSTRAINT cons_unique_code_kalkgehalt_t UNIQUE (code));

CREATE TABLE afu_isboden.kartiererin_v_sc ( pk_kartiererin int4 NOT NULL, "name" varchar(200) NULL, kuerzel varchar(100) NULL, CONSTRAINT kartiererin_v_pk PRIMARY KEY (pk_kartiererin));

CREATE TABLE afu_isboden.koernkl_t ( pk_koernkl int4 DEFAULT nextval('afu_isboden.koernkl_t_pk_koernkl_seq'::regclass) NOT NULL, code int4 NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_koernkl_t PRIMARY KEY (pk_koernkl), CONSTRAINT cons_unique_code_koernkl_t UNIQUE (code));

CREATE TABLE afu_isboden.skelett_t ( pk_skelett int4 DEFAULT nextval('afu_isboden.skelett_t_pk_skelett_seq'::regclass) NOT NULL, code int4 NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, is_wald bool NULL, CONSTRAINT cons_pk_skelett_t PRIMARY KEY (pk_skelett));

CREATE TABLE afu_isboden.untertyp_t ( pk_untertyp int4 DEFAULT nextval('afu_isboden.untertyp_t_pk_untertyp_seq'::regclass) NOT NULL, code varchar(2) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_untertyp_t PRIMARY KEY (pk_untertyp), CONSTRAINT cons_unique_code_untertyp_t UNIQUE (code));

CREATE TABLE afu_isboden.wasserhhgr_t ( pk_wasserhhgr int4 DEFAULT nextval('afu_isboden.wasserhhgr_t_pk_wasserhhgr_seq'::regclass) NOT NULL, code varchar(2) NOT NULL, beschreibung varchar(255) NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_wasserhhgr_t PRIMARY KEY (pk_wasserhhgr), CONSTRAINT cons_unique_wasserhhgr_t_code UNIQUE (code));

CREATE TABLE afu_isboden.wt_bodart ( bodart varchar(5) NULL, ton_v float8 NULL, ton_b float8 NULL, schl_v float8 NULL, schl_b float8 NULL);

CREATE TABLE afu_isboden.wt_gefueg ( lagdi varchar(5) NULL, begeffor varchar(5) NULL);

CREATE TABLE afu_isboden.wt_nutzbfk ( bodart varchar(5) NULL, ld1_2 float8 NULL, ld3 float8 NULL, ld4_5 float8 NULL);

CREATE TABLE afu_isboden.wt_pfnugr ( bewashgr varchar(5) NULL, png_w int4 NULL);

CREATE TABLE afu_isboden.wt_tab70_1 ( metall varchar(5) NULL, von float8 NULL, bis float8 NULL, wert1 float8 NULL);

CREATE TABLE afu_isboden.wt_tab70_2 ( metall varchar(5) NULL, grenz_ph float8 NULL, humus float8 NULL, ton float8 NULL);

CREATE TABLE afu_isboden.wt_tab70_3 ( hum_von int4 NULL, hum_bis int4 NULL, bind_st float8 NULL, wert2 float8 NULL);

CREATE TABLE afu_isboden.wt_tab70_4 ( ton_von int4 NULL, ton_bis int4 NULL, bind_st int4 NULL, wert3 float8 NULL);

CREATE TABLE afu_isboden.wt_tab70_4sk ( skelett text NULL, minuswert float8 NULL);

CREATE TABLE afu_isboden.wt_znutzbfk ( bodart varchar(5) NULL, hugeah_v float8 NULL, hugeah_b float8 NULL, znutzbfk float8 NULL);

CREATE TABLE afu_isboden.bodeneinheit_auspraegung_t ( pk_bodeneinheit int8 DEFAULT nextval('afu_isboden.bodeneinheit_auspraegung_t_pk_bodeneinheit_seq'::regclass) NOT NULL, fk_bodeneinheit int8 NOT NULL, is_hauptauspraegung bool NOT NULL, gewichtung_auspraegung afu_isboden.d_gt_0_le_100 NOT NULL, fk_wasserhhgr int4 NULL, fk_bodentyp int4 NULL, fk_begelfor int4 NULL, fk_skelett_ob int4 NULL, fk_skelett_ub int4 NULL, fk_koernkl_ob int4 NULL, fk_koernkl_ub int4 NULL, ton_ob int4 NULL, ton_ub int4 NULL, schluff_ob int4 NULL, schluff_ub int4 NULL, karbgrenze int4 NULL, fk_kalkgehalt_ob int4 NULL, fk_kalkgehalt_ub int4 NULL, ph_ob float8 NULL, ph_ub float8 NULL, maechtigk_ah int2 NULL, humusgeh_ah float8 NULL, fk_humusform_wa int4 NULL, fk_gefuegeform_ob int4 NULL, fk_gefuegeform_ub int4 NULL, fk_gefueggr_ob int4 NULL, fk_gefueggr_ub int4 NULL, bemerkungen varchar(300) NULL, bodpktzahl int4 NULL, pflngr int4 NULL, maechtigk_ahh float8 NULL, bindst_cd float8 NULL, bindst_zn float8 NULL, bindst_cu float8 NULL, bindst_pb float8 NULL, nfkapwe_ob float8 NULL, nfkapwe_ub float8 NULL, nfkapwe float8 NULL, verdempf int2 NULL, drain_wel float8 NULL, wassastoss float8 NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, geologie varchar(30) NULL, CONSTRAINT pk_bodeneinheit_auspraegung_t PRIMARY KEY (pk_bodeneinheit), CONSTRAINT cons_fk_begelfor_t FOREIGN KEY (fk_begelfor) REFERENCES afu_isboden.begelfor_t(pk_begelfor), CONSTRAINT cons_fk_bodeneinheit_t FOREIGN KEY (fk_bodeneinheit) REFERENCES afu_isboden.bodeneinheit_t(pk_ogc_fid) ON DELETE CASCADE, CONSTRAINT cons_fk_gefuegeform_t_ob FOREIGN KEY (fk_gefuegeform_ob) REFERENCES afu_isboden.gefuegeform_t(pk_gefuegeform), CONSTRAINT cons_fk_gefuegeform_t_ub FOREIGN KEY (fk_gefuegeform_ub) REFERENCES afu_isboden.gefuegeform_t(pk_gefuegeform), CONSTRAINT cons_fk_gefueggr_t_ob FOREIGN KEY (fk_gefueggr_ob) REFERENCES afu_isboden.gefueggr_t(pk_gefueggr), CONSTRAINT cons_fk_humusform_wa_t FOREIGN KEY (fk_humusform_wa) REFERENCES afu_isboden.humusform_wa_t(pk_humusform_wa), CONSTRAINT cons_fk_kalkgehalt_t_ub FOREIGN KEY (fk_kalkgehalt_ub) REFERENCES afu_isboden.kalkgehalt_t(pk_kalkgehalt), CONSTRAINT cons_fk_koernkl_t_ob FOREIGN KEY (fk_koernkl_ob) REFERENCES afu_isboden.koernkl_t(pk_koernkl), CONSTRAINT cons_fk_koernkl_t_ub FOREIGN KEY (fk_koernkl_ub) REFERENCES afu_isboden.koernkl_t(pk_koernkl), CONSTRAINT cons_fk_skelett_t_ob FOREIGN KEY (fk_skelett_ob) REFERENCES afu_isboden.skelett_t(pk_skelett), CONSTRAINT cons_fk_skelett_t_ub FOREIGN KEY (fk_skelett_ub) REFERENCES afu_isboden.skelett_t(pk_skelett), CONSTRAINT cons_fk_wasserhhgr_t FOREIGN KEY (fk_wasserhhgr) REFERENCES afu_isboden.wasserhhgr_t(pk_wasserhhgr), CONSTRAINT fk_kalkgehalt_t_ob FOREIGN KEY (fk_kalkgehalt_ob) REFERENCES afu_isboden.kalkgehalt_t(pk_kalkgehalt), CONSTRAINT fk_ub_gefueggr FOREIGN KEY (fk_gefueggr_ub) REFERENCES afu_isboden.gefueggr_t(pk_gefueggr));

CREATE TABLE afu_isboden.bodeneinheit_historische_nummerierung_t ( pk_historische_nummerierung int8 DEFAULT nextval('afu_isboden.bodeneinheit_historische_nummer_pk_historische_nummerierung_seq'::regclass) NOT NULL, fk_bodeneinheit int8 NOT NULL, objnr int4 NULL, gemnr int2 NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT pk_historische_nummerierung PRIMARY KEY (pk_historische_nummerierung), CONSTRAINT cons_fk_bodeneinheit_t FOREIGN KEY (fk_bodeneinheit) REFERENCES afu_isboden.bodeneinheit_t(pk_ogc_fid) ON DELETE CASCADE);

CREATE TABLE afu_isboden.zw_bodeneinheit_untertyp ( pk_zw_bodeneinheit_untertyp int8 DEFAULT nextval('afu_isboden.zw_bodeneinheit_untertyp_pk_zw_bodeneinheit_untertyp_seq'::regclass) NOT NULL, fk_bodeneinheit int4 NOT NULL, fk_untertyp int4 NOT NULL, new_date timestamp DEFAULT now() NULL, archive_date timestamp DEFAULT '9999-01-01 00:00:00'::timestamp without time zone NULL, archive int4 DEFAULT 0 NULL, CONSTRAINT cons_pk_zw_bodeneinheit_untertyp PRIMARY KEY (pk_zw_bodeneinheit_untertyp), CONSTRAINT fk_bodentyp_auspraegung FOREIGN KEY (fk_bodeneinheit) REFERENCES afu_isboden.bodeneinheit_auspraegung_t(pk_bodeneinheit) ON DELETE CASCADE, CONSTRAINT fk_untertyp FOREIGN KEY (fk_untertyp) REFERENCES afu_isboden.untertyp_t(pk_untertyp));



CREATE INDEX idx_begelfor_t_code ON afu_isboden.begelfor_t USING btree (code) WHERE (archive = 0);

CREATE INDEX idx_afu_isboden_bodeneinheit_lw_qgis_server_client_t_wkb_gemetr ON afu_isboden.bodeneinheit_lw_qgis_server_client_t USING gist (wkb_geometry);

CREATE INDEX idx_afu_isboden_bodeneinheit_onlinedata_t_bodentyp ON afu_isboden.bodeneinheit_onlinedata_t USING btree (bodentyp);

CREATE INDEX idx_afu_isboden_bodeneinheit_onlinedata_t_geom ON afu_isboden.bodeneinheit_onlinedata_t USING gist (geom);

CREATE INDEX idx_afu_isboden_bodeneinheit_onlinedata_t_wasserhhgr ON afu_isboden.bodeneinheit_onlinedata_t USING btree (wasserhhgr);

CREATE INDEX afu_isboden_bodeneinheit_overlap_t_gemnr ON afu_isboden.bodeneinheit_overlap_t USING btree (gemnr);

CREATE INDEX afu_isboden_bodeneinheit_overlap_t_objnr ON afu_isboden.bodeneinheit_overlap_t USING btree (objnr);

CREATE INDEX afu_isboden_bodeneinheit_overlap_t_pk_ogc_fid ON afu_isboden.bodeneinheit_overlap_t USING btree (pk_ogc_fid);

CREATE INDEX afu_isboden_bodeneinheit_overlap_t_ueberlappung ON afu_isboden.bodeneinheit_overlap_t USING gist (wkb_geometry);

CREATE INDEX idx_bodeneinheit_t_gemnr ON afu_isboden.bodeneinheit_t USING btree (gemnr) WHERE (archive < 1);

CREATE INDEX idx_bodeneinheit_t_objnr ON afu_isboden.bodeneinheit_t USING btree (objnr) WHERE (archive < 1);

CREATE INDEX idx_bodeneinheit_t_wkb_gemetry ON afu_isboden.bodeneinheit_t USING gist (wkb_geometry) WHERE (archive < 1);

CREATE UNIQUE INDEX unique_gemnr_objnr_imp_and_prod ON afu_isboden.bodeneinheit_t USING btree (gemnr, objnr) WHERE (archive < 1);

CREATE INDEX idx_bodeneinheit_wald_qgis_server_client_t_wkb_gemetry ON afu_isboden.bodeneinheit_wald_qgis_server_client_t USING gist (wkb_geometry);

CREATE INDEX idx_bodentyp_t_code ON afu_isboden.bodentyp_t USING btree (code) WHERE (archive = 0);

CREATE INDEX erosionsgefahr_qgis_server_client_idx ON afu_isboden.erosionsgefahr_qgis_server_client_t USING gist (wkb_geometry);

CREATE INDEX idx_gefuegeform_t_code ON afu_isboden.gefuegeform_t USING btree (code) WHERE (archive = 0);

CREATE INDEX idx_gefueggr_t_code ON afu_isboden.gefueggr_t USING btree (code) WHERE (archive = 0);

CREATE INDEX idx_gemeindeteil_t_gem_bfs ON afu_isboden.gemeindeteil_t USING btree (gem_bfs);

CREATE INDEX idx_gemeindeteil_t_gem_bfs_aktuell ON afu_isboden.gemeindeteil_t USING btree (gem_bfs_aktuell);

CREATE INDEX idx_gemeindeteil_t_name ON afu_isboden.gemeindeteil_t USING btree (name);

CREATE INDEX idx_gemeindeteil_t_name_aktuell ON afu_isboden.gemeindeteil_t USING btree (name_aktuell);

CREATE INDEX idx_gemeindeteil_t_wkb_gemetry ON afu_isboden.gemeindeteil_t USING gist (wkb_geometry);

CREATE INDEX idx_gemeindeteil_t_wkb_geometry_aktuell ON afu_isboden.gemeindeteil_t USING gist (wkb_geometry_aktuell);

CREATE INDEX hinweiskarte_bodenverdichtung_qgis_server_c_wkb_g_1425978861276 ON afu_isboden.hinweiskarte_bodenverdichtung_qgis_server_client_t USING gist (wkb_geometry);

CREATE INDEX humusform_wa_t_code_idx ON afu_isboden.humusform_wa_t USING btree (code) WHERE (archive = 0);

CREATE INDEX idx_kalkgehalt_t_code ON afu_isboden.kalkgehalt_t USING btree (code) WHERE (archive = 0);

CREATE INDEX idx_koernkl_t_code ON afu_isboden.koernkl_t USING btree (code) WHERE (archive = 0);

CREATE INDEX idx_skelett_t_code ON afu_isboden.skelett_t USING btree (code) WHERE (archive = 0);

CREATE UNIQUE INDEX unique_code_is_wald ON afu_isboden.skelett_t USING btree (code, is_wald) WHERE (archive < 1);

CREATE INDEX idx_untertyp_t_code ON afu_isboden.untertyp_t USING btree (code) WHERE (archive = 0);

CREATE INDEX idx_wasserhhgr_t_code ON afu_isboden.wasserhhgr_t USING btree (code) WHERE (archive = 0);

CREATE INDEX idx_bodeneinheit_auspraegung_t_fk_bodentyp ON afu_isboden.bodeneinheit_auspraegung_t USING btree (fk_bodentyp) WHERE (archive < 1);

CREATE INDEX idx_bodeneinheit_t_fk_wasserhhgr ON afu_isboden.bodeneinheit_auspraegung_t USING btree (fk_wasserhhgr) WHERE (archive < 1);

CREATE INDEX idx_bodeneinheit_historische_nummerierung_t_fk_bodeneinheit ON afu_isboden.bodeneinheit_historische_nummerierung_t USING btree (fk_bodeneinheit) WHERE (archive < 1);

CREATE INDEX idx_bodeneinheit_historische_nummerierung_t_gemnr ON afu_isboden.bodeneinheit_historische_nummerierung_t USING btree (gemnr) WHERE (archive < 1);

CREATE INDEX idx_bodeneinheit_historische_nummerierung_t_objnr ON afu_isboden.bodeneinheit_historische_nummerierung_t USING btree (objnr) WHERE (archive < 1);
