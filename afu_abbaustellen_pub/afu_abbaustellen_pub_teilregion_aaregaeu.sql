SELECT 
    teilregion_aaregaeu.ogc_fid AS t_id, 
    teilregion_aaregaeu.wkb_geometry AS geometrie, 
    teilregion_aaregaeu.id, 
    teilregion_aaregaeu.perityp,
    CASE
        WHEN teilregion_aaregaeu.perityp::text = 'Festsetzung neu'::text 
            THEN 1
        WHEN teilregion_aaregaeu.perityp::text = 'Erweiterung 2. Priorität'::text 
            THEN 2
        ELSE NULL::integer
    END AS perityp_int
FROM 
    abbaustellen.teilregion_aaregaeu
WHERE 
    teilregion_aaregaeu.archive = 0
;