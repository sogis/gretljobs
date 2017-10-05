SELECT ogc_fid,st_force_2d(wkb_geometry) as wkb_geometry,gnrso,location,abschnr,bauwnr,bauwtyp,bauwhoeh,erhebungsdatum
FROM gewisso.oeko_bauwerke
WHERE archive=0;
