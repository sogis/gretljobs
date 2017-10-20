 SELECT 
 	aww_gszoar.ogc_fid, 
 	aww_gszoar.wkb_geometry, 
 	aww_gszoar.zone, 
    aww_gszoar.new_date, 
    aww_gszoar.archive_date, 
    aww_gszoar.archive, 
    aww_gszoar.rrbnr, 
    aww_gszoar.rrb_date
  FROM 
  	public.aww_gszoar
  WHERE 
  	aww_gszoar.archive = 0;
  
  
