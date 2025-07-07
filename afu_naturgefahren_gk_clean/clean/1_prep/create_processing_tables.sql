DROP TABLE IF EXISTS public.poly_cleanup;
/* 
Zentrale Bearbeitungstabelle, in welcher die Unterscheidung Gross-Kleinpolgon, 
das Mapping Kleinpolygon -> Kleinpolygon -> Grosspolygon und das Geometrieupdate für die
entsprechenden Grosspolygone stattfindet.
*/
CREATE TABLE public.poly_cleanup (
    id int4 NOT NULL, -- Generierte ID des singlepart Polygon
    multipoly_id_ref int4 NOT NULL, -- Referenz auf ID des Features in der Quelltabelle. Ueblicherweise die t_id.
    singlepoly public.geometry(polygon, 2056) NOT NULL, -- Geometrie des Teil-Polygons nach der Kleinstflaechenbereinigung
    hazard_level int4 NOT NULL, -- Gemappte Gefahrenstufe. Siehe Insert-Sql bezüglich der Mapping-Systematik
    g_area float8 NOT NULL, -- Flaeche des Polygons
    g_max_diameter float8 NULL, -- Durchmesser des groessten in das Polygon einpassbaren Kreises. Wird wegen Performanz nur fuer Polygone mit kleiner Flaeche berechnet.
    is_big bool NOT NULL DEFAULT false, -- Unterscheidung zwischen Gross- und Kleinpolygonen. Berechnet aus g_max_diameter.
    parent_id_ref int4 NULL, -- Id des unmittelbaren Nachbarpolygons. NULL für Root-Polygone und Klein-Polygone, für die kein Nachbar gefunden wurde.
    parent_level_diff int4 NULL, -- Unterschied in Gefahrenstufe zum Nachbarpolygon (parent_id_ref). Zwecks Information / Debugging
    root_id_ref int4 NULL, -- Id des referenzierten Root-Polygon, in welches dieses Kleinpolygon aufgelöst wird. NULL für Root-Polygone und Klein-Polygone, für die kein Merge-Nachbar gefunden wurde.
    root_merged_poly public.geometry(multipolygon, 2056) NULL, -- Aus merge mit Kleinstflächen resultierende neue Geometrie der Root-Polygone
    CONSTRAINT poly_cleanup_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_poly_cleanup_geom ON public.poly_cleanup USING gist (singlepoly);

DROP TABLE IF EXISTS public.interface_table;

/*
Schnittstellen-Tabelle, in welche die zu bearbeitenden Multipolygone kopiert werden
und ab welcher die notwendigen Updates und Deletes in der Originaltabelle mithilfe
der "out_" Attribute angewendet werden. 
*/
CREATE TABLE public.interface_table (
    id int4 NOT NULL, -- Original-ID. Ueblicherweise die t_id.
    geometrie public.geometry(multipolygon, 2056) NOT NULL, 
    gefahrenstufe varchar(255) NOT NULL,
    out_center_geom public.geometry(multipolygon, 2056) NULL,
    out_small_clean_result varchar(50) NULL, -- Angabe für Kleinpolygone, ob vollständig (=complete), teilweise (=partial), oder nicht (=not_cleaned) gemerged wurde.
    out_small_agglo_geom public.geometry(multipolygon, 2056) NULL, -- Neue Kleinspolygon Geometrie bei teilweisem Merge.
    CONSTRAINT multipoly_pkey PRIMARY KEY (id)
);