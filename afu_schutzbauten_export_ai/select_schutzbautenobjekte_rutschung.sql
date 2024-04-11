INSERT INTO
    afu_schutzbauten_mgdm_v1.schutzbautenobjekt
    (
        geometrie_punkt,
        geometrie_linie,
        geometrie_polygon,
        datenherr,
        schutzbauten_id,
        aggregierung,
        hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        weiterer_prozess_lawine,
        werksart,
        material,
        laenge,
        breite,
        hoehe,
        hoehe_zum_umland,
        flaeche,
        rueckhaltevolumen,
        anzahl,
        gesamtlaenge,
        gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
        -- bemerkungen  wir übertragen keine Bemerkungen ins MGDM
    )
(
--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Schutz vor Anriss
-- Hangstützwerk
--
--------------------------------------------------------------------------------
    SELECT
        NULL::geometry AS geometrie_punkt,
        geometrie_linie,
        NULL::geometry AS geometrie_polygon,
        'Kantone.SO' AS datenherr,
        CASE WHEN geom_anzahl > 1 THEN
            schutzbauten_id || '-' || geom_idx
        ELSE
            schutzbauten_id
        END AS schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Rutschung' AS hauptprozess,
        weiterer_prozess_wasser,
        false AS weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Rutschung.Schutz_vor_Anriss.Hangstuetzwerk' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite, 
        NULL::NUMERIC AS hoehe, 
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen,
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.rutschung_hangstuetzwerk_entwaesserung_palisade t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.rutschung_hangstuetzwerk_entwaesserung_palisade
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Hangstuetzwerk'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Schutz vor Anriss
-- Abdeckung
--
--------------------------------------------------------------------------------
    SELECT
        NULL::geometry AS geometrie_punkt,
        NULL::geometry AS geometrie_linie,
        geometrie_polygon,
        'Kantone.SO' AS datenherr,
        CASE WHEN geom_anzahl > 1 THEN
            schutzbauten_id || '-' || geom_idx
        ELSE
            schutzbauten_id
        END AS schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Rutschung' AS hauptprozess,
        weiterer_prozess_wasser,
        false AS weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Rutschung.Schutz_vor_Anriss.Abdeckung' AS werksart,
        material,
        NULL::NUMERIC AS laenge,
        NULL::NUMERIC AS breite, 
        NULL::NUMERIC AS hoehe, 
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        flaeche,
        NULL::NUMERIC AS rueckhaltevolumen,
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.rutschung_abdeckung_ingmassnahme t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.rutschung_abdeckung_ingmassnahme
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Abdeckung'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Schutz vor Anriss
-- ingenieurbiologische Massnahme
--
--------------------------------------------------------------------------------
    SELECT
        NULL::geometry AS geometrie_punkt,
        NULL::geometry AS geometrie_linie,
        geometrie_polygon,
        'Kantone.SO' AS datenherr,
        CASE WHEN geom_anzahl > 1 THEN
            schutzbauten_id || '-' || geom_idx
        ELSE
            schutzbauten_id
        END AS schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Rutschung' AS hauptprozess,
        weiterer_prozess_wasser,
        false AS weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Rutschung.Schutz_vor_Anriss.ingenieurbiologische_Massnahme' AS werksart,
        material,
        NULL::NUMERIC AS laenge,
        NULL::NUMERIC AS breite, 
        NULL::NUMERIC AS hoehe, 
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        flaeche,
        NULL::NUMERIC AS rueckhaltevolumen,
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.rutschung_abdeckung_ingmassnahme t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.rutschung_abdeckung_ingmassnahme
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'ingenieurbiologische_Massnahme'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Schutz vor Anriss
-- Entwässerung
--
--------------------------------------------------------------------------------
    SELECT
        NULL::geometry AS geometrie_punkt,
        geometrie_linie,
        NULL::geometry AS geometrie_polygon,
        'Kantone.SO' AS datenherr,
        CASE WHEN geom_anzahl > 1 THEN
            schutzbauten_id || '-' || geom_idx
        ELSE
            schutzbauten_id
        END AS schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Rutschung' AS hauptprozess,
        weiterer_prozess_wasser,
        false AS weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Rutschung.Schutz_vor_Anriss.Entwaesserung' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite, 
        NULL::NUMERIC AS hoehe, 
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen,
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.rutschung_hangstuetzwerk_entwaesserung_palisade t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.rutschung_hangstuetzwerk_entwaesserung_palisade
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Entwaesserung'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Schutz vor Anriss
-- Entwässerung
--
--------------------------------------------------------------------------------
    SELECT
        NULL::geometry AS geometrie_punkt,
        geometrie_linie,
        NULL::geometry AS geometrie_polygon,
        'Kantone.SO' AS datenherr,
        CASE WHEN geom_anzahl > 1 THEN
            schutzbauten_id || '-' || geom_idx
        ELSE
            schutzbauten_id
        END AS schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Rutschung' AS hauptprozess,
        weiterer_prozess_wasser,
        false AS weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Rutschung.Schutz_vor_Anriss.Palisade' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite, 
        NULL::NUMERIC AS hoehe, 
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen,
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.rutschung_hangstuetzwerk_entwaesserung_palisade t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.rutschung_hangstuetzwerk_entwaesserung_palisade
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Palisade'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Ablenkung und Auffangen
-- Damm
--
--------------------------------------------------------------------------------
    SELECT
        NULL::geometry AS geometrie_punkt,
        NULL::geometry AS geometrie_linie,
        geometrie_polygon,
        'Kantone.SO' AS datenherr,
        CASE WHEN geom_anzahl > 1 THEN
            schutzbauten_id || '-' || geom_idx
        ELSE
            schutzbauten_id
        END AS schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Rutschung' AS hauptprozess,
        weiterer_prozess_wasser,
        false AS weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Rutschung.Ablenkung_und_Auffangen.Damm' AS werksart,
        material,
        laenge,
        breite, 
        NULL::NUMERIC AS hoehe, 
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen,
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.rutschung_damm t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.rutschung_damm
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Ablenkung und Auffangen
-- Auffangnetz
--
--------------------------------------------------------------------------------
    SELECT
        NULL::geometry AS geometrie_punkt,
        geometrie_linie,
        NULL::geometry AS geometrie_polygon,
        'Kantone.SO' AS datenherr,
        CASE WHEN geom_anzahl > 1 THEN
            schutzbauten_id || '-' || geom_idx
        ELSE
            schutzbauten_id
        END AS schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Rutschung' AS hauptprozess,
        weiterer_prozess_wasser,
        false AS weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Rutschung.Ablenkung_und_Auffangen.Auffangnetz' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite, 
        NULL::NUMERIC AS hoehe, 
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen,
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.rutschung_auffangnetz t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.rutschung_auffangnetz
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Diverse
-- andere Werksart Punkte
--
--------------------------------------------------------------------------------
    SELECT
        geometrie AS geometrie_punkt,
        NULL::geometry AS geometrie_linie,
        NULL::geometry AS geometrie_polygon,
        'Kantone.SO' AS datenherr,
        schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Rutschung' AS hauptprozess,
        weiterer_prozess_wasser,
        false AS weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Rutschung.Diverse.andere_Werksart' AS werksart,
        material,
        laenge,
        breite, 
        hoehe, 
        hoehe_zum_umland,
        flaeche,
        rueckhaltevolumen,
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.rutschung_andere_werksart_punkt t

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Diverse
-- andere Werksart Linie
--
--------------------------------------------------------------------------------
    SELECT
        NULL::geometry AS geometrie_punkt,
        geometrie_linie,
        NULL::geometry AS geometrie_polygon,
        'Kantone.SO' AS datenherr,
        CASE WHEN geom_anzahl > 1 THEN
            schutzbauten_id || '-' || geom_idx
        ELSE
            schutzbauten_id
        END AS schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Rutschung' AS hauptprozess,
        weiterer_prozess_wasser,
        false AS weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Rutschung.Diverse.andere_Werksart' AS werksart,
        material,
        laenge,
        breite, 
        hoehe, 
        hoehe_zum_umland,
        flaeche,
        rueckhaltevolumen,
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.rutschung_andere_werksart_linie t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.rutschung_andere_werksart_linie
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Rutschung
-- Diverse
-- andere Werksart Polygon
--
--------------------------------------------------------------------------------
    SELECT
        NULL::geometry AS geometrie_punkt,
        NULL::geometry AS geometrie_linie,
        geometrie_polygon,
        'Kantone.SO' AS datenherr,
        CASE WHEN geom_anzahl > 1 THEN
            schutzbauten_id || '-' || geom_idx
        ELSE
            schutzbauten_id
        END AS schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Rutschung' AS hauptprozess,
        weiterer_prozess_wasser,
        false AS weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Rutschung.Diverse.andere_Werksart' AS werksart,
        material,
        laenge,
        breite, 
        hoehe, 
        hoehe_zum_umland, -- nicht vorhanden
        flaeche,
        rueckhaltevolumen,
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.rutschung_andere_werksart_flaeche t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.rutschung_andere_werksart_flaeche
        ) AS t_dump
        ON t.t_id = t_dump.t_id
);
