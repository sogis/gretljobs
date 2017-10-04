SELECT ogc_fid,st_force_2d(wkb_geometry) as wkb_geometry,revier_id,gnrso,von,bis,gewaesser,grenzen,eigentum,bonitierung,nutzung,fischbestand,fischerei
FROM gewisso.jfv_fischenz
WHERE archive = 0;
