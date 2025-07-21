/* tbd remove - for dev only

create table individuals as select * EXCLUDE(geom), ST_AsWKB(geom) as wkb from st_read('individuals.geojson');

create table nests as select * EXCLUDE(geom), ST_AsWKB(geom) as wkb from st_read('active_nests.geojson') union select * EXCLUDE(geom), ST_AsWKB(geom) as wkb from st_read('unactive_nests.geojson');

*/

select
	occurence_id,
	nid_unique_id,
	null::text as bienenstand_id,				-- noch nicht verfügbar
	null::int as import_vor_10_uhr,				-- noch nicht verfügbar
	null::int as import_zwischen_10_und_13_uhr,	-- noch nicht verfügbar
	null::int as import_zwischen_13_und_17_uhr,	-- noch nicht verfügbar
	null::int as import_nach_17_uhr,			-- noch nicht verfügbar
	-- massnahmenstatus,  --tbd remove
	-- bemerkung_massnahme, --tbd remove
	wkb
from individuals;


