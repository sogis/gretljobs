load spatial;

create table individuals as 
    select 
        * EXCLUDE(geom), 
        ST_AsText(geom) as wkt 
    from st_read(${individuals_path})
;

create table nests as 
    select 
        * EXCLUDE(geom), 
        ST_AsText(geom) as wkt 
    from st_read(${active_nests_path})
    union 
    select 
        * EXCLUDE(geom), 
        ST_AsText(geom) as wkt 
    from st_read(${unactive_nests_path})
;