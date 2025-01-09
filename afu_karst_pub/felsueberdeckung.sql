SELECT 
    etm, 
    maechtigkeit, 
    maechtigkeit_list.dispname AS maechtigkeit_txt,
    geometrie, 
    innerhalb_so,
    CASE
        WHEN innerhalb_so IS TRUE 
        THEN 'Ja'
        ELSE 'Nein'
    END AS innerhalb_so_txt  
FROM 
    afu_karst_v1.karst_felsueberdeckung fels 
LEFT JOIN 
    afu_karst_v1.karst_maechtigkeit maechtigkeit_list 
    ON 
    fels.maechtigkeit = maechtigkeit_list.ilicode 
;
