SELECT ogc_fid,st_force_2d(wkb_geometry) as wkb_geometry,objectid,shape_length,nutzen,bemerkung
FROM gewisso.abschnnutzen_gdbsigmas
WHERE archive=0;
