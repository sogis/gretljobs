SELECT
    ST_Force2D(ST_RemoveRepeatedPoints(ageometry,0.001)) AS geometrie,
    surface.aname_de AS oberflaeche,
    hiking_segment_type.aname_de AS wanderweg_typ
FROM
    arp_wanderwege_v1.hpm_walk_lv95_hiking_way AS hiking_way
    LEFT JOIN arp_wanderwege_v1.hpm_catalogues_surface AS surface
    ON surface.t_id = hiking_way.surface
    LEFT JOIN arp_wanderwege_v1.hpm_catalogues_hiking_segment_type AS hiking_segment_type
    ON hiking_segment_type.t_id = hiking_way.hiking_segment_type
;
