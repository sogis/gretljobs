DROP VIEW IF EXISTS public.poly_cleanup_v;
DROP TABLE IF EXISTS public.poly_cleanup;
/* 
Zentrale Bearbeitungstabelle, in welcher die Unterscheidung Gross-Kleinpolgon, 
das Mapping Kleinpolygon -> Kleinpolygon -> Grosspolygon und das Geometrieupdate für die
entsprechenden Grosspolygone stattfindet.
NN Im Kommentar bedeutet, dass nach Berechnung des Felds keine NULL-Werte vorkommen.
*/
CREATE TABLE public.poly_cleanup (
    id int4 NOT NULL, -- Original-ID. Ueblicherweise die t_id.
    geometrie public.geometry(multipolygon, 2056) NOT NULL, -- Geometrie des Features
    gefahrenstufe varchar(255) NOT NULL, -- Gefahrenstufe gemäss Modell (restgefaehrdung, erheblich, ...)
    _hazard_level int2 NULL, -- NN. Gemappte Gefahrenstufe.
    _is_big bool NULL, -- NN. Unterscheidung zwischen Gross- und Kleinpolygonen. Berechnet aus _small_max_diameter.
    _center_geom public.geometry(multipolygon, 2056) NULL, -- Aktualisierte Zentrums-Geometrie, in welche die benachbarten Kleinstpolygone integriert wurden
    _parent_id_ref int4 NULL, -- Id des unmittelbaren Nachbarpolygons. NULL für Root-Polygone und Klein-Polygone, für die kein Nachbar gefunden wurde.
    _parent_level_diff int4 NULL, -- Unterschied in Gefahrenstufe zum Nachbarpolygon (_parent_id_ref). Zwecks Information / Debugging
    _root_id_ref int4 NULL, -- Id des referenzierten Root-Polygon, in welches dieses Kleinpolygon aufgelöst wird. NULL für Root-Polygone und Klein-Polygone, für die kein Merge-Nachbar gefunden wurde.
    --_root_level_diff int4 NULL, -- Unterschied in Gefahrenstufe zum Root-Polygon. Zwecks Information / Debugging
    _node_position int4 NULL, -- Ab den Root-Nodes hochzählender Identifikator der Node-Generation.
    
    CONSTRAINT poly_cleanup_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_poly_cleanup_geom ON public.poly_cleanup USING gist (geometrie);

CREATE VIEW public.poly_cleanup_v AS
SELECT 
    id, 
    COALESCE(_center_geom, geometrie) AS geometrie,
    (_center_geom IS NOT NULL) AS geometrie_aktualisiert,
    gefahrenstufe, 
    _hazard_level,
    _is_big,
    _parent_id_ref,
    _parent_level_diff,
    _root_id_ref,
    _node_position
FROM 
    public.poly_cleanup
;