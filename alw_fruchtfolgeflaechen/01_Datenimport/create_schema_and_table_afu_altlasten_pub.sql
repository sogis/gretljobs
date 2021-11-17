DROP SCHEMA if exists afu_altlasten_pub cascade;

CREATE SCHEMA afu_altlasten_pub AUTHORIZATION "gretl";

DROP TABLE if exists afu_altlasten_pub.belastete_standorte_altlast4web;

CREATE TABLE afu_altlasten_pub.belastete_standorte_altlast4web (
	t_id int4 NOT NULL,
	geometrie geometry(MULTIPOLYGON, 2056) NULL,
	bezeichnung varchar NULL,
	vflz_combined_id_kt varchar(50) NULL,
	c_vflz_bearbstand text NULL,
	c_bere_res_abwbewe varchar(8) NULL,
	c_bere_res_abwbewe_txt text NULL,
	c_vflz_unterstand text NULL,
	c_vflz_vftyp text NULL,
	CONSTRAINT afu_altlasten_pub_belastete_standorte_altlast4web_pkey PRIMARY KEY (t_id)
);
