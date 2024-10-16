SELECT 
    gemeinschaft.aname,
    CONCAT(strasse || ' ', hausnummer || ', ', plz || ' ', ortschaft) AS adresse,
    ansaessig_seit,
    geometrie,
    CONCAT('Kontaktname: ', kontaktperson ,E'\n', 'eMail: ', kontaktmail ,E'\n', 'Homepage: ', homepage, E'\n', bemerkungen) AS bemerkungen,
    tradition.aname AS religioese_tradition
FROM
    ags_religionsgemeinschaften_v2.religionsgemeinschaft AS gemeinschaft
    LEFT JOIN ags_religionsgemeinschaften_v2.religioese_tradition AS tradition
    ON gemeinschaft.r_tradition = tradition.t_id
;
