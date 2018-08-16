CREATE SCHEMA 
    agi_hoheitsgrenzen_pub
;


CREATE TABLE 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze 
    (
        t_id bigserial NOT NULL,
        t_ili_tid uuid NULL DEFAULT uuid_generate_v4(),
        kantonsname varchar(255) NOT NULL,
        kantonskuerzel varchar(255) NOT NULL,
        kantonsnummer int4 NOT NULL,
        geometrie geometry NULL,
        CONSTRAINT hoheitsgrenzen_kantonsgrenze_pkey PRIMARY KEY (t_id),
        CONSTRAINT hoheitsgrenzen_kntnsgrnze_kantonsnummer_check CHECK (((kantonsnummer >= 11) AND (kantonsnummer <= 11)))
    )
WITH 
(
	OIDS=FALSE
)
;
CREATE INDEX 
    hoheitsgrenzen_kantnsgrnze_geometrie_idx 
    ON agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze 
    USING gist (geometrie)
;
