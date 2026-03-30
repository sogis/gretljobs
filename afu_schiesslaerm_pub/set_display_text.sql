
UPDATE 
    afu_schiesslaerm_pub_v1.schiesslaerm    
SET
    empfindlichkeitsstufe_txt = (
    SELECT
        dispname
    FROM 
        afu_schiesslaerm_pub_v1.empfindlichkeitsstufe_tag 
    WHERE 
        empfindlichkeitsstufe_tag.ilicode = schiesslaerm.empfindlichkeitsstufe    
)