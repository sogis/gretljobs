DROP TABLE if exists alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung;

CREATE TABLE alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung (
	geometrie geometry NULL,
	bfs_nr int4 NULL,
	anrechenbar int4 NULL
);
