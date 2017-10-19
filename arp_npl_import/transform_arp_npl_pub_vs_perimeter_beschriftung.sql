WITH verfahrensstand_pos AS 
(
    SELECT 
        pos.t_id,
        pos.t_datasetname,
        perimeter.verfahrensstufe,
        perimeter.name_nummer,
        pos.pos, 
        pos.ori,
        pos.hali,
        pos.vali,
        pos.groesse,
        'Verfahrenstand_Perimeter' AS  beschriftung_fuer
    FROM 
        arp_npl.verfahrenstand_vs_perimeter_pos AS pos
        LEFT JOIN arp_npl.verfahrenstand_vs_perimeter_verfahrensstand as perimeter
        ON perimeter.t_id = pos.vs_perimeter_verfahrensstand
)   
SELECT  
    pos.t_datasetname::int4 AS bfs_nr,
    pos.t_id,
    pos.verfahrensstufe,
    pos.name_nummer,
    pos.pos, 
    pos.ori AS pos_ori,
    pos.hali AS pos_hali,
    pos.vali AS pos_vali,
    pos.groesse AS pos_groesse
    --pos.beschriftung_fuer
FROM 
    verfahrensstand_pos AS pos;