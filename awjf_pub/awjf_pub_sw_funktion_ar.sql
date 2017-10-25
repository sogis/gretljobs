SELECT ogc_fid,fk,fr,name,sturz,rutsch,grs,lawine,anderekt,obj_kat,schaden_po,h_gef_pot,igef_pot,bemerkunge,flaeche,st_multi(wkb_geometry) as wkb_geometry,status,name_2,gem_name,gem_bfs
FROM awjf.sw_funktion_ar
WHERE archive = 0;
