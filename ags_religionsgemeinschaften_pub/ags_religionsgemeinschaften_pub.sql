SELECT 
    gemeinschaft.aname,
    CONCAT(strasse || ' ', hausnummer || ', ', plz || ' ', ortschaft) AS adresse,
    ansaessig_seit,
    geometrie,
    CASE
        WHEN kontaktperson IS NOT NULL AND kontaktmail IS NULL AND homepage IS NULL
            THEN CONCAT('Kontaktname: ' ,kontaktperson, ' | Bemerkungen: ', bemerkungen)
        WHEN kontaktperson IS NULL AND kontaktmail IS NOT NULL AND homepage IS NULL
            THEN CONCAT('Mailadresse: ' ,kontaktmail, ' | Bemerkungen: ', bemerkungen)
        WHEN kontaktperson IS NULL AND kontaktmail IS NULL AND homepage IS NOT NULL
            THEN CONCAT('Homepage: ' ,homepage, ' | Bemerkungen: ', bemerkungen)
        WHEN kontaktperson IS NOT NULL AND kontaktmail IS NOT NULL AND homepage IS NULL
            THEN CONCAT('Kontaktname: ' ,kontaktperson, ' | Mailadresse: ' ,kontaktmail,' | Bemerkungen: ', bemerkungen)
        WHEN kontaktperson IS NOT NULL AND kontaktmail IS NULL AND homepage IS NOT NULL
            THEN CONCAT('Kontaktname: ' ,kontaktperson, ' | Homepage: ' ,homepage, ' | Bemerkungen: ', bemerkungen)
        WHEN kontaktperson IS NULL AND kontaktmail IS NOT NULL AND homepage IS NOT NULL
            THEN CONCAT('Mailadresse: ' ,kontaktmail, ' | Homepage: ' ,homepage, ' | Bemerkungen: ', bemerkungen)
       ELSE bemerkungen
    END AS bemerkungen,
    tradition.aname AS religioese_tradition
FROM
    ags_religionsgemeinschaften_v2.religionsgemeinschaft AS gemeinschaft
    LEFT JOIN ags_religionsgemeinschaften_v2.religioese_tradition AS tradition
    ON gemeinschaft.r_tradition = tradition.t_id
;
