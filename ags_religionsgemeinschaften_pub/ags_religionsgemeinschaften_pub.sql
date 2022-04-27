SELECT 
    gemeinschaft.aname,
    CONCAT(strasse || ' ', hausnummer || ', ', plz || ' ', ortschaft) AS adresse,
    ansaessig_seit,
    geometrie,
    bemerkungen,
    tradition.aname AS religioese_tradition
FROM
    ags_religionsgemeinschaften_v1.religionsgemeinschaft AS gemeinschaft
    LEFT JOIN ags_religionsgemeinschaften_v1.religioese_tradition AS tradition
    ON gemeinschaft.r_tradition = tradition.t_id
;