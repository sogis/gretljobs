SELECT 
	t_id, 
	geometrie, 
	name, 
	im_kanton, 
	typ, 
	typ_text
FROM 
	afu_gewaesserschutz_pub.aww_gszustr
WHERE
	im_kanton = 0
;
