DROP VIEW IF EXISTS public._poly_cleanup_v;
DROP TABLE IF EXISTS public.poly_cleanup;
/* 
Zentrale Bearbeitungstabelle, in welcher die Unterscheidung Gross-Kleinpolgon, 
das Mapping Kleinpolygon -> Kleinpolygon -> Grosspolygon und das Geometrieupdate für die
entsprechenden Grosspolygone stattfindet.
NN im Attribut-Kommentar bedeutet, dass nach Berechnung des Felds keine NULL-Werte vorkommen.
*/
CREATE TABLE public.poly_cleanup (
    id int4 NOT NULL, -- Original-ID. Ueblicherweise die t_id.
    geometrie public.geometry(multipolygon, 2056) NOT NULL, -- Geometrie des Features
    gefahrenstufe varchar(255) NOT NULL, -- Gefahrenstufe gemäss Modell (restgefaehrdung, erheblich, ...)
    _hazard_level int2 NULL, -- NN. Gemappte Gefahrenstufe.
    _is_big bool NULL, -- NN. Unterscheidung zwischen Gross- und Kleinpolygonen. "False", falls Poly.area < cleanMaxArea und ST_MaximumInscribedCircle(Poly).radius < (cleanMaxDiameter/2)
    _center_geom public.geometry(multipolygon, 2056) NULL, -- Aktualisierte Zentrums-Geometrie, in welche die benachbarten Kleinstpolygone integriert wurden
    _parent_id_ref int4 NULL, -- Id des Polygons der Vor-Generation, mit den verschmolzen wird. NULL für alle Gross-Polygone. NULL für Klein-Polygone, die "isoliert" sind und nicht verschmolzen werden können.
    _parent_level_diff int4 NULL, -- Unterschied in Gefahrenstufe zum Polygeon der Vor-Generation (_parent_id_ref). "Nur" zwecks Information / Debugging
    _intersect_bbox_length float NULL, -- Länge der bbox als Mass für die Ausdehnung der Intersection. "Nur" zwecks Information / Debugging
    _root_id_ref int4 NULL, -- Id des referenzierten Root-Nodes (= Gross-Polygon), in welches dieses Kleinpolygon aufgelöst wird. NULL für Root-Polygone und Klein-Polygone, für die kein Merge-Nachbar gefunden wurde.
    _node_generation int4 NULL, -- Ab den Root-Nodes (= Gross-Polygone) hochzählender Identifikator der Node-Generation (0,1, ...).
    
    CONSTRAINT poly_cleanup_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_poly_cleanup_geom ON public.poly_cleanup USING gist (geometrie);

/* "Nur" zwecks Verifikation während der Erstellung der Bereinigung - Nicht zu übernehemen in Job "afu_naturgefahren_produkte" */
CREATE VIEW public._poly_cleanup_v AS
SELECT 
    id, 
    COALESCE(_center_geom, geometrie) AS geometrie,
    (_center_geom IS NOT NULL) AS geometrie_aktualisiert,
    gefahrenstufe, 
    _hazard_level,
    _is_big,
    _parent_id_ref,
    _parent_level_diff,
    _intersect_bbox_length,
    _root_id_ref,
    _node_generation
FROM 
    public.poly_cleanup
;