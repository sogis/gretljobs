DROP TABLE IF EXISTS public.poly_cleanup;
/* 
Zentrale Bearbeitungstabelle, in welcher die Unterscheidung Gross-Kleinpolgon, 
das Mapping Kleinpolygon -> Grosspolygon und das Geometrieupdate für die
entsprechenden Grosspolygone stattfindet.
*/
CREATE TABLE public.poly_cleanup (
    id int4 NOT NULL, -- ID des features in der Quelltabelle. Ueblicherweise die t_id.
    geom public.geometry(multipolygon, 2056) NOT NULL, -- Geometrie des Features nach der Kleinstflaechenbereinigung
    hazard_level int4 NOT NULL, -- Gemappte Gefahrenstufe. Siehe Insert-Sql bezüglich der Mapping-Systematik
    g_area float8 NOT NULL, -- Flaeche des Polygons
    is_small bool NOT NULL DEFAULT false, -- Unterscheidung zwischen Gross- und Kleinpolygonen. Berechnet aus g_max_diameter.
    g_max_diameter float8 NULL, -- Durchmesser des groessten in das Polygon einpassbaren Kreises. Wird wegen Performanz nur fuer Polygone mit kleiner Flaeche berechnet.
    merge_big_id int4 NULL, -- ID des Ziel-Grosspolygons, in welches dieses Kleinpolygon aufgelöst wird.
    merge_level_diff int4 NULL, -- Unterschied der Gefahrenstufe zwischen Kleinpolygon und Ziel-Grosspolygon. Nur zwecks Verifikation enthalten.
    CONSTRAINT poly_cleanup_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_poly_cleanup_geom ON public.poly_cleanup USING gist (geom);