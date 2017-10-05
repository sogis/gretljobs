SELECT ogc_fid,st_force_2d(wkb_geometry) as wkb_geometry,gnrso,location,abschnr,abstnr,absttyp,abstmat,absthoeh,erhebungsdatum
FROM gewisso.oeko_abstuerze
WHERE archive=0;
