 SELECT 
    afu_erosion_gbf20_p.ogc_fid AS t_id, 
    afu_erosion_gbf20_p.wkb_geometry AS geometrie, 
    afu_erosion_gbf20_p.grid_code, 
    afu_erosion_gbf20_p_code.bezeichnung
FROM 
    afu_erosion_gbf20_p
    LEFT JOIN afu_erosion_gbf20_p_code
        ON afu_erosion_gbf20_p.grid_code = afu_erosion_gbf20_p_code.code_id 
WHERE 
    afu_erosion_gbf20_p.archive = 0
;