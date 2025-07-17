DROP TABLE IF EXISTS public.poly_cleanup_gpkg;

CREATE TABLE public.poly_cleanup_gpkg (
    id int4 NOT NULL,
    geometrie public.geometry(multipolygon, 2056) NOT NULL,
    gefahrenstufe varchar(255) NOT NULL,
    _hazard_level int2 NULL,
    _is_big bool NULL,
    _parent_id_ref int4 NULL,
    _parent_level_diff int4 NULL, 
    _root_id_ref int4 NULL,
    _node_position int4 NULL,
    geometrie_aktualisiert bool NOT NULL,
    
    CONSTRAINT poly_cleanup_gpkg_pkey PRIMARY KEY (id)
);

INSERT INTO 
    public.poly_cleanup_gpkg (
        id,
        geometrie,
        gefahrenstufe,
        _hazard_level,
        _is_big,
        _parent_id_ref,
        _parent_level_diff,
        _root_id_ref,
        _node_position,
        geometrie_aktualisiert
    )
SELECT 
    id,
    COALESCE(_center_geom, geometrie) AS geometrie,
    gefahrenstufe,
    _hazard_level,
    _is_big,
    _parent_id_ref,
    _parent_level_diff,
    _root_id_ref,
    _node_position,
    (_center_geom IS NOT NULL) AS geometrie_aktualisiert
FROM 
    public.poly_cleanup
;

CREATE INDEX sidx_poly_cleanup_gpkg_geom ON public.poly_cleanup_gpkg USING gist (geometrie);