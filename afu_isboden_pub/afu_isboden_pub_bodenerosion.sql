 SELECT 
    afu_erosion_gbf20_p.ogc_fid AS t_id, 
    afu_erosion_gbf20_p.wkb_geometry AS geometrie, 
    afu_erosion_gbf20_p.grid_code, 
    CASE 
        WHEN grid_code = 1 OR grid_code = 4
            THEN 'geringe Erosionsgefährdung'
        WHEN grid_code = 7
            THEN 'mittlere Erosionsgefährdung'
        WHEN grid_code = 9
            THEN 'hohe Erosionsgefährdung'
        WHEN grid_code = 10
            THEN 'sehr hohe Erosionsgefährdung'
    END AS grid_code_txt,
    afu_erosion_gbf20_p_code.bezeichnung
FROM 
    afu_erosion_gbf20_p
    LEFT JOIN afu_erosion_gbf20_p_code
        ON afu_erosion_gbf20_p.grid_code = afu_erosion_gbf20_p_code.code_id 
WHERE 
    afu_erosion_gbf20_p.archive = 0
;