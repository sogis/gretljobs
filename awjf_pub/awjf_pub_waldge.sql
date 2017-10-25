SELECT ogc_fid,wkb_geometry,area,perimeter,waldge_,waldge_id,massstab,autor,kartierung,ges_alt,ges_neu,bezirk,wald,
ges_neu_ber,grundeinheit,legende,farbcode,verband,ertragsklasse,zuwachs,min_lbh_ant
FROM awjf.waldge
WHERE archive = 0;
