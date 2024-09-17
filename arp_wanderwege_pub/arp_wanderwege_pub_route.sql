WITH metadata AS (
    SELECT 
        last_updated,
        contact_information
    FROM
        arp_wanderwege_v1.hpm_base_metadata
),

location_categories AS (
    SELECT
        base_route.t_id AS base_route_id,
        field_name||' '||aname_de::text AS location_category
    FROM
        arp_wanderwege_v1.hpm_base_route_signalisation AS route_signalisation
        LEFT JOIN arp_wanderwege_v1.hpm_walk_lv95_signalisation AS signalisation
        ON route_signalisation.each_rt_sgnstn_bs_ntry_hpm_walk_lv95_signalisation = signalisation.t_id
        LEFT JOIN arp_wanderwege_v1.hpm_catalogues_location_category AS category
        ON route_signalisation.location_category = category.t_id
        LEFT JOIN arp_wanderwege_v1.hpm_base_way_route AS way_route
        ON route_signalisation.each_route_signalisation_entry_has_one_route = way_route.t_id
        LEFT JOIN arp_wanderwege_v1.hpm_base_route AS base_route
        ON route_signalisation.each_route_signalisation_entry_has_one_route = base_route.t_id
WHERE
    ST_Within(
        signalisation.ageometry,
        (SELECT ST_Buffer(ST_Union(geometrie), 2000) FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze))
    ORDER BY
        base_route.t_id,
        position_number
),

routes AS (
    SELECT
        route.t_id,
        ST_Multi(ST_Union(ST_Force2D(ageometry))) AS geometrie,
        route.technical_route_name AS technischer_routenname,
        route.technical_route_number AS technische_routennummer,
        route.starting_point AS astart,
        route.destination AS ziel,
        catalogues_direction.aname_de AS signalisationsrichtung,
        regexp_replace(route.route_description, E'[\\n\\r]+', ' ', 'g' ) AS beschreibung,
        substr(metadata.last_updated, 1, 4)||'-'||substr(metadata.last_updated, 5, 2)||'-'||substr(metadata.last_updated, 7, 2) AS letzte_aktualisierung,
        '<a href="https://www.solothurner-wanderwege.ch/de/kontakt" target="_blank">Solothurner Wanderwege</a>' AS kontakt
    FROM
        arp_wanderwege_v1.hpm_base_route AS route
        LEFT JOIN arp_wanderwege_v1.hpm_base_way_route AS way_route
        ON route.t_id = way_route.each_way_route_entry_has_one_route_entry
        LEFT JOIN arp_wanderwege_v1.hpm_walk_lv95_hiking_way AS hiking_way
        ON way_route.each_wy_rt__wy_bs_ntry_hpm_walk_lv95_hiking_way = hiking_way.t_id
        LEFT JOIN arp_wanderwege_v1.hpm_catalogues_direction_of_signalisation AS catalogues_direction
        ON route.direction_of_signalisation = catalogues_direction.t_id,
        metadata
    GROUP BY
        route.t_id,
        route.technical_route_name,
        route.technical_route_number,
        route.starting_point,
        route.destination,
        catalogues_direction.aname_de,
        route.route_description,
        metadata.last_updated,
        metadata.contact_information
)

SELECT
    routes.t_id,
    routes.geometrie,
    routes.technischer_routenname,
    routes.technische_routennummer,
    routes.astart,
    routes.ziel,
    @ AS routenstandorte,
    routes.signalisationsrichtung,
    routes.beschreibung,
    routes.letzte_aktualisierung,
    routes.kontakt
FROM
    location_categories,
    routes
WHERE
    routes.t_id = location_categories.base_route_id
 GROUP BY
    routes.t_id,
    routes.geometrie,
    routes.technischer_routenname,
    routes.technische_routennummer,
    routes.astart,
    routes.ziel,
    routes.signalisationsrichtung,
    location_categories.base_route_id,
    routes.beschreibung,
    routes.letzte_aktualisierung,
    routes.kontakt
;
