SELECT
    vsperim.t_id,
    vsperim.t_ili_tid,
    vsperim.geometrie,
    vsperim.planungsart,
    vsperim.verfahrensstufe,
    vsperim.name_nummer,
    vsperim.bemerkungen,
    vsperim.erfasser,
    vsperim.datum,
    vsperim.t_datasetname::int4 AS bfs_nr        
FROM
    arp_npl.verfahrenstand_vs_perimeter_verfahrensstand vsperim
;
