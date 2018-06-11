CREATE SCHEMA 
    agi_grundbuchplan_pub
;

CREATE TABLE agi_grundbuchplan_pub.bodenbedeckung_boflaechesymbol (
	t_id int4 NOT NULL,
	art int4 NULL,
	art_txt varchar NULL,
	pos geometry NULL,
	ori float8 NULL,
	rot float8 NULL,
	gem_bfs int4 NULL,
	los int4 NULL,
	lieferdatum date NULL,
	CONSTRAINT bodenbedeckung_boflaechesymbol_pkey PRIMARY KEY (t_id)
)
WITH (
	OIDS=FALSE
) ;
CREATE INDEX idx_liegenschaften_liegenschaft_geometrie ON agi_grundbuchplan_pub.bodenbedeckung_boflaechesymbol USING gist (pos) ;

CREATE TABLE agi_grundbuchplan_pub.liegenschaften_grenzpunkt (
	t_id serial NOT NULL,
	bfsnr int4 NULL,
	gueltigkeit varchar NULL,
	punktzeichen varchar NULL,
	geometrie geometry NULL,
	mutation bool NULL DEFAULT false,
	CONSTRAINT agi_grundbuchplan_pub_liegenschaften_grenzpunkt_pkey PRIMARY KEY (t_id)
)
WITH (
	OIDS=FALSE
) ;
CREATE INDEX idx_liegenschaften_grenzpunkt_bfsnr ON agi_grundbuchplan_pub.liegenschaften_grenzpunkt USING btree (bfsnr) ;
CREATE INDEX idx_liegenschaften_grenzpunkt_geometrie ON agi_grundbuchplan_pub.liegenschaften_grenzpunkt USING gist (geometrie) ;

CREATE TABLE agi_grundbuchplan_pub.liegenschaften_grundstueckpos (
	t_id serial NOT NULL,
	tid varchar NULL,
	grundstueckpos_von varchar NULL,
	pos geometry NULL,
	ori float8 NULL,
	hali int4 NULL,
	hali_txt varchar NULL,
	vali int4 NULL,
	vali_txt varchar NULL,
	groesse int4 NULL,
	groesse_txt varchar NULL,
	hilfslinie geometry NULL,
	gem_bfs int4 NULL,
	los int4 NULL,
	lieferdatum date NULL,
	y float8 NULL,
	x float8 NULL,
	rot float8 NULL,
	nummer varchar NULL,
	art int4 NULL,
	mutation bool NULL DEFAULT false,
	CONSTRAINT liegenschaften_grundstueckpos_pkey PRIMARY KEY (t_id)
)
WITH (
	OIDS=FALSE
) ;
CREATE INDEX idx_liegenschaften_grundstueckpos_gem_bfs ON agi_grundbuchplan_pub.liegenschaften_grundstueckpos USING btree (gem_bfs) ;
CREATE INDEX idx_liegenschaften_grundstueckpos_hilfslinie ON agi_grundbuchplan_pub.liegenschaften_grundstueckpos USING gist (hilfslinie) ;
CREATE INDEX idx_liegenschaften_grundstueckpos_pos ON agi_grundbuchplan_pub.liegenschaften_grundstueckpos USING gist (pos) ;

CREATE TABLE agi_grundbuchplan_pub.liegenschaften_liegenschaft (
	t_id serial NOT NULL,
	tid varchar NULL,
	liegenschaft_von varchar NULL,
	nummerteilgrundstueck varchar NULL,
	geometrie geometry NULL,
	flaechenmass float8 NULL,
	gem_bfs int4 NULL,
	los int4 NULL,
	lieferdatum date NULL,
	numpos text NULL,
	nummer varchar NULL,
	mutation bool NULL DEFAULT false,
	CONSTRAINT liegenschaften_liegenschaft_pkey PRIMARY KEY (t_id)
)
WITH (
	OIDS=FALSE
) ;
CREATE INDEX idx_gbp_liegenschaften_liegenschaft_geometrie ON agi_grundbuchplan_pub.liegenschaften_liegenschaft USING gist (geometrie) ;
