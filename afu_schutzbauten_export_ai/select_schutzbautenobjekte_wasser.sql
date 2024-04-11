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
-- Hauptprozess Wasser
-- Schutz vor Überflutung, Übersarung
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Schutz_vor_Ueberflutung_Uebersarung.Damm' AS werksart,
        material,
        laenge,
        breite,
        NULL::NUMERIC AS hoehe, -- nicht vorhanden
        hoehe_zum_umland,
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_damm t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_damm 
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Schutz vor Überflutung, Übersarung
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Schutz_vor_Ueberflutung_Uebersarung.Mauer' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite, -- nicht vorhanden
        NULL::NUMERIC AS hoehe, -- nicht vorhanden
        hoehe_zum_umland,
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_mauer t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_mauer 
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Gewährung der Sohlenstabilität
-- Sperre
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Gewaehrung_der_Sohlenstabilitaet.Sperre' AS werksart,
        material,
        NULL::NUMERIC AS laenge,
        breite,
        hoehe,
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_sperre_schwelle t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_sperre_schwelle 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Sperre'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Gewährung der Sohlenstabilität
-- Sperre
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Gewaehrung_der_Sohlenstabilitaet.Schwelle' AS werksart,
        material,
        NULL::NUMERIC AS laenge,
        breite,
        hoehe,
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_sperre_schwelle t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_sperre_schwelle 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Schwelle'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Gewährung der Sohlenstabilität
-- Rampe
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Gewaehrung_der_Sohlenstabilitaet.Rampe' AS werksart,
        material,
        laenge,
        breite,
        NULL::NUMERIC AS hoehe,
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_rampe_sohlensicherung t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_rampe_sohlensicherung 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Rampe'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Gewährung der Sohlenstabilität
-- flächenhafte Sohlensicherung
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Gewaehrung_der_Sohlenstabilitaet.flaechenhafte_Sohlensicherung' AS werksart,
        material,
        laenge,
        breite,
        NULL::NUMERIC AS hoehe,
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_rampe_sohlensicherung t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_rampe_sohlensicherung 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'flaechenhafte_Sohlensicherung'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Schutz vor Seitenerosion
-- Buhne
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Schutz_vor_Seitenerosion.Buhne' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite,
        NULL::NUMERIC AS hoehe,
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_buhne t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_buhne 
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Schutz vor Seitenerosion
-- Uferdeckwerk
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Schutz_vor_Seitenerosion.Uferdeckwerk' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite,
        hoehe,
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_uferdeckwerk_ufermauer_lebendverbau t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_uferdeckwerk_ufermauer_lebendverbau 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Uferdeckwerk'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Schutz vor Seitenerosion
-- Uferdeckwerk
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Schutz_vor_Seitenerosion.Ufermauer_Holzlaengsverbau' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite,
        hoehe,
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_uferdeckwerk_ufermauer_lebendverbau t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_uferdeckwerk_ufermauer_lebendverbau 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Ufermauer_Holzlaengsverbau'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Schutz vor Seitenerosion
-- Uferdeckwerk
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Schutz_vor_Seitenerosion.Lebendverbau' AS werksart,
        material,
        laenge,
        NULL::NUMERIC AS breite,
        hoehe,
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_uferdeckwerk_ufermauer_lebendverbau t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_uferdeckwerk_ufermauer_lebendverbau 
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Lebendverbau'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Rückhalt
-- Hochwasserrückhaltebauwerk
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Rueckhalt.Hochwasserrueckhaltebauwerk' AS werksart,
        material,
        NULL::NUMERIC AS laenge, -- nicht vorhanden
        breite, 
        hoehe, 
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_rueckhaltebauwerk t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_rueckhaltebauwerk
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Hochwasserrueckhaltebauwerk'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Rückhalt
-- Geschiebe oder Murgangrückhaltebauwerk
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Rueckhalt.Geschiebe_oder_Murgangrueckhaltebauwerk' AS werksart,
        material,
        NULL::NUMERIC AS laenge, -- nicht vorhanden
        breite, 
        hoehe, 
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_rueckhaltebauwerk t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_rueckhaltebauwerk
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Geschiebe_oder_Murgangrueckhaltebauwerk'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Rückhalt
-- Schwemmholzrückhaltebauwerk
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Rueckhalt.Schwemmholzrueckhaltebauwerk' AS werksart,
        material,
        NULL::NUMERIC AS laenge, -- nicht vorhanden
        breite, 
        hoehe, 
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_rueckhaltebauwerk t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_rueckhaltebauwerk
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Schwemmholzrueckhaltebauwerk'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Rückhalt
-- Schwemmholzrückhaltebauwerk
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Rueckhalt.Eisrueckhaltebauwerk' AS werksart,
        material,
        NULL::NUMERIC AS laenge, -- nicht vorhanden
        breite, 
        hoehe, 
        NULL::NUMERIC AS hoehe_zum_umland, -- nicht vorhanden
        NULL::NUMERIC AS flaeche, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_rueckhaltebauwerk t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_rueckhaltebauwerk
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Eisrueckhaltebauwerk'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Rückhalt
-- Schwemmholzrückhaltebauwerk
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Rueckhalt.bewirtschafteter_Geschiebeablagerungsplatz_strecke' AS werksart,
        material,
        NULL::NUMERIC AS laenge, -- nicht vorhanden
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
        afu_schutzbauten_v1.wasser_geschiebeablagerungsplatz t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_geschiebeablagerungsplatz
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Entlastung
-- Entlastungsbauwerk
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Entlastung.Entlastungsbauwerk' AS werksart,
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
        afu_schutzbauten_v1.wasser_entlastungsbauwerk t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_entlastungsbauwerk
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Entlastung
-- Umleit-/Entlastungsstollen
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Entlastung.Umleit_Entlastungsstollen' AS werksart,
        material,
        laenge,
        breite, 
        hoehe, 
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
        afu_schutzbauten_v1.wasser_entlastungsstollen_kanal t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_entlastungsstollen_kanal
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Umleit_Entlastungsstollen'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Entlastung
-- Entlastungsgerinne, Entlastungskanal
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Entlastung.Entlastungsgerinne_kanal' AS werksart,
        material,
        laenge,
        breite, 
        hoehe, 
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
        afu_schutzbauten_v1.wasser_entlastungsstollen_kanal t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_entlastungsstollen_kanal
        ) AS t_dump
        ON t.t_id = t_dump.t_id
    WHERE
        t.art = 'Entlastungsgerinne_kanal'

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Diverse
-- Eindolung
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Diverse.Eindolung' AS werksart,
        material,
        laenge,
        breite, 
        hoehe, 
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
        afu_schutzbauten_v1.wasser_eindolung t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_eindolung
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Diverse
-- Murbrecher, Murbremse
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Diverse.Murbrecher_Murbremse' AS werksart,
        material,
        NULL::NUMERIC AS laenge,
        breite, 
        hoehe, 
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
        afu_schutzbauten_v1.wasser_murbrecher_murbremse t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_murbrecher_murbremse
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Diverse
-- Brücke, Steg
--
--------------------------------------------------------------------------------
    SELECT
        geometrie AS geometrie_punkt,
        NULL::geometry AS geometrie_linie,
        NULL::geometry AS geometrie_polygon,
        'Kantone.SO' AS datenherr,
        schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Diverse.andere_Werksart' AS werksart,
        material,
        laenge,
        breite, 
        hoehe, 
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
        afu_schutzbauten_v1.wasser_bruecke_steg t

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Diverse
-- Furt
--
--------------------------------------------------------------------------------
    SELECT
        geometrie AS geometrie_punkt,
        NULL::geometry AS geometrie_linie,
        NULL::geometry AS geometrie_polygon,
        'Kantone.SO' AS datenherr,
        schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Diverse.andere_Werksart' AS werksart,
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
        afu_schutzbauten_v1.wasser_furt t

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Diverse
-- andere Werksart Punkt
--
--------------------------------------------------------------------------------
    SELECT
        geometrie AS geometrie_punkt,
        NULL::geometry AS geometrie_linie,
        NULL::geometry AS geometrie_polygon,
        'Kantone.SO' AS datenherr,
        schutzbauten_id,
        'Einzelwerk' AS aggregierung,
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Diverse.andere_Werksart' AS werksart,
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
        afu_schutzbauten_v1.wasser_andere_werksart_punkt t

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Diverse.andere_Werksart' AS werksart,
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
        afu_schutzbauten_v1.wasser_andere_werksart_linie t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_linie,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_andere_werksart_linie
        ) AS t_dump
        ON t.t_id = t_dump.t_id

    UNION

--------------------------------------------------------------------------------
--
-- Hauptprozess Wasser
-- Diverse
-- andere Werksart Fläche
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
        'Wasser' AS hauptprozess,
        false AS weiterer_prozess_wasser,
        weiterer_prozess_rutschung,
        weiterer_prozess_sturz,
        false AS weiterer_prozess_lawine,
        'Wasser.Diverse.andere_Werksart' AS werksart,
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
        afu_schutzbauten_v1.wasser_andere_werksart_flaeche t
    JOIN
        (
            SELECT
                t_id,
                (ST_Dump(geometrie)).geom AS geometrie_polygon,
                (ST_Dump(geometrie)).path[1] AS geom_idx,
                ST_NumGeometries(geometrie) AS geom_anzahl
            FROM
                afu_schutzbauten_v1.wasser_andere_werksart_flaeche
        ) AS t_dump
        ON t.t_id = t_dump.t_id
);