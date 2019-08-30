SELECT 
    row_number() OVER (ORDER BY anlagen.name_nummer) AS t_id, 
    anlagen.name_nummer, 
    anlagen.art, 
    anlagen.geometrie
FROM 
    (((
    SELECT 
        anlage.name_nummer, 
        anlage.art, 
        leitungsknoten.geometrie
    FROM agi_leitungskataster_was.sia405_wasser_wi_anlage anlage
        LEFT JOIN agi_leitungskataster_was.sia405_wasser_wi_leitungsknoten leitungsknoten ON leitungsknoten.t_id::text = anlage.leitungsknotenref::text
    WHERE leitungsknoten.geometrie::text <> ''::text
    UNION 
        SELECT 
            foerderanlage.name_nummer, 
            foerderanlage.art, 
            leitungsknoten.geometrie
        FROM agi_leitungskataster_was.sia405_wasser_wi_foerderanlage foerderanlage
            LEFT JOIN agi_leitungskataster_was.sia405_wasser_wi_leitungsknoten leitungsknoten ON leitungsknoten.t_id::text = foerderanlage.leitungsknotenref::text
        WHERE leitungsknoten.geometrie::text <> ''::text
        )
        UNION 
            SELECT 
                wasserbehaelter.name_nummer, 
                wasserbehaelter.art, 
                leitungsknoten.geometrie
            FROM agi_leitungskataster_was.sia405_wasser_wi_wasserbehaelter wasserbehaelter
                LEFT JOIN agi_leitungskataster_was.sia405_wasser_wi_leitungsknoten leitungsknoten ON leitungsknoten.t_id::text = wasserbehaelter.leitungsknotenref::text
            WHERE leitungsknoten.geometrie::text <> ''::text
            )
            UNION 
                SELECT 
                    wassergewinnungsanlage.name_nummer, 
                    wassergewinnungsanlage.art, 
                    leitungsknoten.geometrie
                FROM agi_leitungskataster_was.sia405_wasser_wi_wassergewinnungsanlage wassergewinnungsanlage
                    LEFT JOIN agi_leitungskataster_was.sia405_wasser_wi_leitungsknoten leitungsknoten ON leitungsknoten.t_id::text = wassergewinnungsanlage.leitungsknotenref::text
                WHERE leitungsknoten.geometrie::text <> ''::text
                ) anlagen
;
