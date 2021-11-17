-- alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung definition

-- Drop table

-- DROP TABLE alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung;

CREATE TABLE alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung (
	geometrie geometry NULL,
	bfs_nr int4 NULL,
	anrechenbar int4 NULL
);

-- Permissions

ALTER TABLE alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung OWNER TO postgres;
GRANT ALL ON TABLE alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung TO postgres;
