SELECT 
	st_point(meter_x, meter_y) AS geometrie,
	empfte,
	emptot,
	meter_x,
	meter_y,
	COALESCE(typ_code_kt::text,'aBz') AS azone, --Wenn auserhalb Bauzonen, dann aBz
	bfs_gemeindenummer AS gem_bfs,
	noga08_cd AS noga08
FROM 
    arp_statpop_statent_staging_v1.statent statent
LEFT JOIN 
    arp_statpop_statent_staging_v1.nutzungszonen grundnutzung  
    ON 
    st_dwithin(st_setsrid(st_point(meter_x, meter_y),2056), grundnutzung.geometrie,0)
LEFT JOIN 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gemeinde 
    ON 
    st_dwithin(st_setsrid(st_point(meter_x, meter_y),2056), gemeinde.geometrie,0)
