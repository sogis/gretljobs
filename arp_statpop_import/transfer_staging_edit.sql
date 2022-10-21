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
	COALESCE(typ_code_kt::text,'aBz') AS azone
FROM 
    arp_statpop_statent_staging_v1.statpop statpop
LEFT JOIN 
    grundnutzung  
    ON 
    st_dwithin(st_setsrid(st_point(geocoorde, geocoordn),2056), grundnutzung.geometrie,0)
LEFT JOIN 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gemeinde 
    ON 
    st_dwithin(st_setsrid(st_point(geocoorde, geocoordn),2056), gemeinde.geometrie,0)