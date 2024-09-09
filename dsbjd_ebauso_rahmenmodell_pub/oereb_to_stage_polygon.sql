SELECT 
    ST_Multi(g.flaeche) AS geometrie,
    l.artcode,
    l.legendetext_de AS beschreibung,
    l.thema,
    e.rechtsstatus,
    CASE 
        WHEN e.rechtsstatus = 'inKraft' THEN 'in Kraft'
        WHEN e.rechtsstatus = 'AenderungMitVorwirkung' THEN 'Änderung mit Vorwirkung'
        WHEN e.rechtsstatus = 'AenderungOhneVorwirkung' THEN 'Änderung ohne Vorwirkung'
    END AS rechtsstatus_txt
FROM 
    live.oerbkrmfr_v2_0transferstruktur_eigentumsbeschraenkung AS e
    LEFT JOIN live.oerbkrmfr_v2_0transferstruktur_legendeeintrag AS l 
    ON e.legende = l.t_id
    LEFT JOIN live.oerbkrmfr_v2_0transferstruktur_geometrie AS g 
    ON g.eigentumsbeschraenkung = e.t_id 
WHERE 
    l.thema = 'ch.BelasteteStandorte'
    OR 
    l.thema = 'ch.Grundwasserschutzzonen'
    OR 
    l.thema = 'ch.Grundwasserschutzareale'
;