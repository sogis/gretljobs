DROP TABLE IF EXISTS public.poly_cleanup;
/* 
Zentrale Bearbeitungstabelle, in welcher die Unterscheidung Gross-Kleinpolgon, 
das Mapping Kleinpolygon -> Kleinpolygon -> Grosspolygon und das Geometrieupdate für die
entsprechenden Grosspolygone stattfindet.
*/
CREATE TABLE public.poly_cleanup (
    id int4 NOT NULL, -- ID des features in der Quelltabelle. Ueblicherweise die t_id.
    geom public.geometry(multipolygon, 2056) NOT NULL, -- Geometrie des Features nach der Kleinstflaechenbereinigung
    geom_updated bool NOT NULL DEFAULT false, -- Flag, ob die Geometrie des Polygons durch den Merge aktualisiert wurde. True für Root-Polygone.
    hazard_level int4 NOT NULL, -- Gemappte Gefahrenstufe. Siehe Insert-Sql bezüglich der Mapping-Systematik
    g_area float8 NOT NULL, -- Flaeche des Polygons
    g_max_diameter float8 NULL, -- Durchmesser des groessten in das Polygon einpassbaren Kreises. Wird wegen Performanz nur fuer Polygone mit kleiner Flaeche berechnet.
    is_big bool NOT NULL DEFAULT false, -- Unterscheidung zwischen Gross- und Kleinpolygonen. Berechnet aus g_max_diameter.
    parent_id int4 NULL, -- Id des unmittelbaren Nachbarpolygons. NULL für Root-Polygone und Klein-Polygone, für die kein Nachbar gefunden wurde.
    parent_level_diff int4 NULL, -- Unterschied in Gefahrenstufe zum Nachbarpolygon (parent_id). Zwecks Information / Debugging
    root_id int4 NULL, -- Id des referenzierten Root-Polygon, in welches dieses Kleinpolygon aufgelöst wird. NULL für Root-Polygone und Klein-Polygone, für die kein Merge-Nachbar gefunden wurde.
    root_level_diff int4 NULL, -- Unterschied in Gefahrenstufe zum Root-Polygon. Zwecks Information / Debugging
    
    CONSTRAINT poly_cleanup_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_poly_cleanup_geom ON public.poly_cleanup USING gist (geom);