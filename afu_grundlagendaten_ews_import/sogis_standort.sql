SELECT 
    gis_standort.standort_id, 
    bezeichnung, 
    bemerkung, 
    --gemeinde, 
    gbnummer, 
    st_setsrid(standort.wkb_geometry,2056) AS wkb_geometry, 
    st_setsrid(standort.wkb_geometry95,2056) AS wkb_geometry95,
    new_date, 
    mut_date, 
    new_usr, 
    mut_usr
FROM 
    bohrung."GIS_standort" gis_standort
left join 
    (select distinct on (standort_id) 
         standort_id, 
         wkb_geometry,
         wkb_geometry as wkb_geometry95 
     from 
         bohrung.bohrung
     where 
         wkb_geometry is not null 
     ) standort 
     on 
     standort.standort_id = gis_standort.standort_id 
where 
    standort.wkb_geometry is not NULL
;
