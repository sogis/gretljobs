SELECT 
	st_setsrid(st_point(geocoorde, geocoordn),2056) AS geometrie,
	statdate::date, 
	record,
	statyear,
	populationtype,
	classagefiveyears,
	nationalitycategory,
	geocoorde AS geocorde,
	geocoordn  AS geocordn,
	bfs_gemeindenummer AS gem_bfs,
	COALESCE(azone::text,'aBz') AS azone
FROM 
    arp_statpop_statent_staging_v1.statpop statpop
LEFT JOIN 
    arp_statpop_statent_staging_v1.nutzungszonen grundnutzung  
    ON 
    st_dwithin(st_setsrid(st_point(geocoorde, geocoordn),2056), grundnutzung.geometrie,0)
LEFT JOIN 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gemeinde 
    ON 
    st_dwithin(st_setsrid(st_point(geocoorde, geocoordn),2056), gemeinde.geometrie,0)
