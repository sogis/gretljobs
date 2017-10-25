WITH verfahrensstand AS 
(
    SELECT 
        perimeter.t_datasetname,
        perimeter.t_id,
        perimeter.planungsart,
        perimeter.verfahrensstufe,
        perimeter.name_nummer,
        perimeter.bemerkungen,
        perimeter.erfasser,
        perimeter.datum,
        perimeter.geometrie
    FROM 
        arp_npl.verfahrenstand_vs_perimeter_verfahrensstand as perimeter    
)    
SELECT  
    v.t_datasetname::int4 AS bfs_nr,
    v.t_id,
    v.planungsart,
    v.verfahrensstufe,
    v.name_nummer,
    v.bemerkungen,
    v.erfasser,
    v.datum,
    v.geometrie
FROM 
    verfahrensstand AS v;