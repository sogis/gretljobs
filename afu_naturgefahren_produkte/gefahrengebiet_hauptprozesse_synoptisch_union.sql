with

multipoly as (
	select
		st_union(poly) as mpoly,
		gef_max,
		charakterisierung
	from 
		splited
	group by
		gef_max,
		charakterisierung
)

,singlepoly as (
	select 
		(st_dump(mpoly)).geom as spoly,
		gef_max,
		charakterisierung
	from 
		multipoly
)

,ins_merged as (
	insert into splited(
		id, 
		poly, 
		point, 
		gef_max, 
		charakterisierung
	)
	select 
		-(row_number() over()) as new_id,
		spoly,
		st_pointonsurface(spoly),
		gef_max,
		charakterisierung
	from 
		singlepoly
)

-- delete old polygons
delete from 
	splited
where 
	id >= 0
;
