SELECT 
	t_id, 
	geometrie, 
	name, 
	im_kanton, 
	typ, 
	typ_text
FROM	
	public.aww_gszustr
WHERE
	archive = 0	AND im_kanton = 0
;