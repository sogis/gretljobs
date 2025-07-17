install spatial;

load spatial;

create table individuals as select * from st_read('individuals.geojson');

create table nests as select * from st_read('active_nests.geojson') union select * from st_read('unactive_nests.geojson');