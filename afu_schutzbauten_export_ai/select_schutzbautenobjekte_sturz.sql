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
        -- bemerkungen   wir übertragen keine Bemerkungen ins MGDM
    )
(
--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Ausbruch
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
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Schutz_vor_Ausbruch.Abdeckung' AS werksart,
        material,
        NULL::NUMERIC AS laenge,
        NULL::NUMERIC AS breite,
        NULL::NUMERIC AS hoehe, -- nicht vorhanden
        NULL::NUMERIC AS hoehe_zum_umland,
        flaeche,
        NULL::NUMERIC AS rueckhaltevolumen, -- nicht vorhanden
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.sturz_abdeckung_verankerung t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.sturz_abdeckung_verankerung 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Abdeckung'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Ausbruch
-- Verankerung
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
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Schutz_vor_Ausbruch.Verankerung' AS werksart,
        material,
        NULL::NUMERIC AS laenge,
        NULL::NUMERIC AS breite,
        NULL::NUMERIC AS hoehe, -- nicht vorhanden
        NULL::NUMERIC AS hoehe_zum_umland,
        flaeche,
        NULL::NUMERIC AS rueckhaltevolumen, -- nicht vorhanden
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.sturz_abdeckung_verankerung t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.sturz_abdeckung_verankerung 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Verankerung'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Ausbruch
-- Unterfangung
--
--------------------------------------------------------------------------------
    SELECT
        geometrie AS geometrie_punkt,
        NULL::geometry AS geometrie_linie,
        NULL::geometry AS geometrie_polygon,
        'Kantone.SO' AS datenherr,
        schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Schutz_vor_Ausbruch.Unterfangung' AS werksart,
        material,
        NULL::NUMERIC AS laenge,
        NULL::NUMERIC AS breite,
        NULL::NUMERIC AS hoehe, -- nicht vorhanden
        NULL::NUMERIC AS hoehe_zum_umland,
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen, -- nicht vorhanden
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.sturz_unterfangung t

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Aufprall
-- Schutznetz
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
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Schutz_vor_Aufprall.Schutznetz' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite,
        NULL::NUMERIC AS hoehe, -- nicht vorhanden
        hoehe_zum_umland,
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen, -- nicht vorhanden
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Schutznetz'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Aufprall
-- Palisade, Barrage
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
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Schutz_vor_Aufprall.Palisade_Barrage' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite,
        NULL::NUMERIC AS hoehe, -- nicht vorhanden
        hoehe_zum_umland,
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen, -- nicht vorhanden
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Palisade_Barrage'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Aufprall
-- Damm
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
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Schutz_vor_Aufprall.Damm' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite,
        NULL::NUMERIC AS hoehe, -- nicht vorhanden
        hoehe_zum_umland,
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen, -- nicht vorhanden
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Damm'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Aufprall
-- Schutzzaun
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
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Schutz_vor_Aufprall.Schutzzaun' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite,
        NULL::NUMERIC AS hoehe, -- nicht vorhanden
        hoehe_zum_umland,
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen, -- nicht vorhanden
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Schutzzaun'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Aufprall
-- Mauer
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
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Schutz_vor_Aufprall.Mauer' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite,
        NULL::NUMERIC AS hoehe, -- nicht vorhanden
        hoehe_zum_umland,
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen, -- nicht vorhanden
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.sturz_schutznetz_palisade_damm_schutzzaun_mauer 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Mauer'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
-- Schutz vor Aufprall
-- Galerie
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
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Schutz_vor_Aufprall.Galerie' AS werksart,
        material,
        laenge,
        breite,
        NULL::NUMERIC AS hoehe, -- nicht vorhanden
        NULL::NUMERIC AS hoehe_zum_umland,
        NULL::NUMERIC AS flaeche,
        NULL::NUMERIC AS rueckhaltevolumen, -- nicht vorhanden
        NULL::NUMERIC AS anzahl,
        NULL::NUMERIC AS gesamtlaenge,
        NULL::NUMERIC AS gesamtflaeche,
        erstellungsjahr,
        erhaltungsverantwortung_kategorie,
        erhaltungsverantwortung_name,
        zustand,
        zustandsbeurteilung_jahr
    FROM
        afu_schutzbauten_v1.sturz_galerie t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.sturz_galerie 
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
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
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Diverse.andere_Werksart' AS werksart,
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
        afu_schutzbauten_v1.sturz_andere_werksart_punkt t

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
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
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Diverse.andere_Werksart' AS werksart,
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
        afu_schutzbauten_v1.sturz_andere_werksart_linie t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.sturz_andere_werksart_linie
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Sturz
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
        'Sturz' AS hauptprozess,
        weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        false AS weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Sturz.Diverse.andere_Werksart' AS werksart,
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
        afu_schutzbauten_v1.sturz_andere_werksart_flaeche t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.sturz_andere_werksart_flaeche
        ) AS t_dump
        ON t.t_id = t_dump.t_id

);
