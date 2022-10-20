WITH grundnutzung AS (
    SELECT
        typ.bezeichnung AS typ_bezeichnung,
        typ.typ_kt,
        typ.code_kommunal AS typ_code_kommunal,
        grundnutzung.geometrie,
        substring(typ.typ_kt,2,3)::int4 AS typ_code_kt,
        substring(typ.typ_kt,2,2)::int4  AS typ_code_ch
    FROM
        arp_nutzungsplanung_v1.nutzungsplanung_grundnutzung AS grundnutzung
        LEFT JOIN arp_nutzungsplanung_v1.nutzungsplanung_typ_grundnutzung AS typ
        ON grundnutzung.typ_grundnutzung = typ.t_id
    WHERE
        grundnutzung.publiziertbis IS NULL
)

SELECT 
	st_point(meter_x, meter_y) AS geometrie,
	empfte,
	emptot,
	meter_x,
	meter_y,
	typ_kt AS azone,
	bfs_gemeindenummer AS gem_bfs,
	noga08_cd AS noga08
FROM 
    arp_statpop_statent_staging_v1.statent statent
LEFT JOIN 
    grundnutzung  
    ON 
    st_dwithin(st_setsrid(st_point(meter_x, meter_y),2056), grundnutzung.geometrie,0)
LEFT JOIN 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gemeinde 
    ON 
    st_dwithin(st_setsrid(st_point(meter_x, meter_y),2056), gemeinde.geometrie,0)