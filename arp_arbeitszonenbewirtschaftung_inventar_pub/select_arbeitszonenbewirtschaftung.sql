-- Relevant sind alle Grundstücke, welche entweder eine Bewertung haben oder
-- innerhalb einer Arbeitszone liegen
WITH relevante_grundstuecke AS (
    SELECT
        mg.t_id,
        mg.geometrie,
        mg.nummer,
        mg.flaechenmass, -- soll das Flaechenmass aus der AV übernommen werden,
                         -- oder besser neu berechnen?
        mg.grundbuch,
        mg.bfs_nr, -- BFS Nummer
        mg.gemeinde, -- Gemeindename
        mg.egrid
    FROM
        agi_mopublic_pub.mopublic_grundstueck mg
    JOIN
        arp_arbeitszonenbewirtschaftung_staging_v1.bewertung_bewertung bb 
    ON
        ST_Within(bb.geometrie, mg.geometrie)

    UNION

    SELECT
        mg.t_id,
        mg.geometrie,
        mg.nummer,
        mg.flaechenmass, -- siehe oben
        mg.grundbuch,
        mg.bfs_nr, -- BFS Nummer
        mg.gemeinde, -- Gemeindename
        mg.egrid
    FROM
       agi_mopublic_pub.mopublic_grundstueck mg
    JOIN
       arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung ng 
    ON
        ST_Intersects(mg.geometrie, ng.geometrie)
    JOIN
        arp_arbeitszonenbewirtschaftung_staging_v1.bewertung_bewertung bb 
    ON
        NOT ST_Within(bb.geometrie, mg.geometrie)
    WHERE
        ng.typ_code_kt in ( 120, 121, 122, 130, 131, 132, 133, 134 )
    -- Füge nachfolgende Bedingung noch dazu, um mit dieser CTE die Anzahl der
    -- relevanten Grundstücke im DBeaver zu prüfen
    -- AND
    -- ST_Area(ST_Intersection(mg.geometrie, ng.geometrie)) >= 1.0
),
nutzungsplanungs_dokumente AS (
    SELECT
        titel,
        textimweb,
        bfs_nr -- die BFS Nummer
    FROM
    (
        SELECT
            jsonb_array_elements(dokumente)->>'Titel' AS titel,
            jsonb_array_elements(dokumente)->>'TextimWeb' AS textimweb,
            jsonb_array_elements(dokumente)->>'Gemeinde' AS bfs_nr -- das Attribut Gemeinde beinhaltet die BFS Nummer
        FROM
            arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
        WHERE
            jsonb_typeof(dokumente) = 'array' 
        UNION
        SELECT
            dokumente->>'Titel' AS titel,
            dokumente->>'TextimWeb' AS textimweb,
            dokumente->>'Gemeinde' AS bfs_nr -- das Attribut Gemeinde beinhaltet die BFS Nummer
        FROM
            arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
        WHERE
            jsonb_typeof(dokumente) != 'array'
    ) AS t
    GROUP BY
        t.titel,
        t.textimweb,
        t.bfs_nr
),
-- Sammle alle Baureglemente
-- Gibt es wirklich immer nur genau ein BR pro Gmde?
baureglemente AS (
    SELECT
        bfs_nr,
        -- Aggregiere die BR URL, falls es mehr als ein BR Dokument gäbe
        STRING_AGG(textimweb, ' ') AS textimweb
    FROM
        nutzungsplanungs_dokumente
    WHERE
        titel ILIKE '%Baureglement%'
    GROUP BY
        bfs_nr
),
-- Sammle alle Zonenreglemente pro Gemeinde
zonenreglemente AS (
    SELECT
        bfs_nr,
        -- Aggregiere die ZR URL, falls es mehr als ein BR Dokument gäbe
        STRING_AGG(textimweb, ' ') AS textimweb
    FROM
        nutzungsplanungs_dokumente
    WHERE
        titel ILIKE '%Zonenreglement%'
    GROUP BY
        bfs_nr
),
-- Sammle alle Gestaltungspläne
gestaltungsplaene AS (
    SELECT
        t.geometrie,
        STRING_AGG(t.textimweb, ' ') AS textimweb
    FROM
    (
        SELECT
            geometrie,
            typ_code_kt,
            titel,
            textimweb
        FROM
        (
            SELECT
                geometrie,
                typ_code_kt,
                jsonb_array_elements(dokumente)->>'Titel' AS titel,
                jsonb_array_elements(dokumente)->>'TextimWeb' AS textimweb
            FROM
                arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche nufv 
            WHERE
                jsonb_typeof(dokumente) = 'array' 

            UNION

            SELECT
                geometrie,
                typ_code_kt,
                dokumente->>'Titel' AS titel,
                dokumente->>'TextimWeb' AS textimweb
            FROM
                arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche nufv 
            WHERE
                jsonb_typeof(dokumente) != 'array'
        ) AS s
        WHERE
            s.titel ILIKE '%Gestaltungsplan%'
        AND
            s.typ_code_kt in (611, 620)
    ) AS t
    GROUP BY
        t.geometrie
),
-- Sammle alle befestigten Flächen aus der AV
befestigte_flaechen AS (
    SELECT
        geometrie
    FROM
        agi_mopublic_pub.mopublic_bodenbedeckung mb 
    WHERE
        mb.art_txt IN
        -- Liste der Bodenbedeckungsarten, welche als befestigt gelten
        (
            'Gebaeude',
            'Strasse_Weg',
            'Trottoir',
            'Verkehrsinsel',
            'Bahn',
            'Flugplatz',
            'Wasserbecken',
            'Sportanlage_befestigt',
            'Lagerplatz',
            'Boeschungsbauwerk',
            'Gebaeudeerschliessung',
            'Parkplatz',
            'uebrige_befestigte'
        )
),
-- Verschneide die relevanten Grundstücke mit den befestigten Flächen und
-- bestimme den Nutzungsgrad
grundstuecke_mit_nutzungsgrad AS (
    SELECT
        rg.t_id,
        rg.geometrie,
        rg.nummer,
        rg.flaechenmass,
        rg.grundbuch,
        rg.bfs_nr, -- BFS Nummer
        rg.gemeinde, -- Gemeindename
        rg.egrid,
        CASE WHEN
            SUM(ST_Area(ST_Intersection(rg.geometrie, bf.geometrie))) / rg.flaechenmass <= 0.1
                THEN 'ungenutzt_weniger_10Prozent'
        WHEN
            SUM(ST_Area(ST_Intersection(rg.geometrie, bf.geometrie))) / rg.flaechenmass > 0.3
                THEN 'genutzt_mehr_als_30Prozent'
        ELSE
            'teilgenutzt_zwischen_10_30Prozent'
        END AS nutzungsgrad
    FROM
        relevante_grundstuecke rg
    LEFT JOIN
        befestigte_flaechen bf
    ON
        ST_Intersects(rg.geometrie, bf.geometrie)
    GROUP BY
        rg.t_id,
        rg.geometrie,
        rg.nummer,
        rg.flaechenmass,
        rg.grundbuch,
        rg.bfs_nr, -- BFS Nummer
        rg.gemeinde, -- Gemeindename
        rg.egrid
),
 -- Sammle alle Grundstücke mit einer Bewertung
grundstuecke_mit_bewertung AS (
    SELECT
        mg.t_id,
        mg.geometrie AS geometrie,
        bb.bebaut AS bewertung_bebaut,
        bb.potenzial AS bewertung_potenzial,
        bb.in_planung AS bewertung_in_planung,
        bb.unternutzte_arbeitszone AS bewertung_unternutzte_arbeitszone,
        bb.mietobjekt AS bewertung_mietobjekt,
        bb.erweiterbar_nachbargrundstueck AS bewertung_erweiterbar_nachbargrundstueck,
        bb.gebunden AS bewertung_gebunden,
        bb.zonierung_kontrollieren AS bewertung_zonierung_kontrollieren,
        bb.bemerkung AS bewertung_bemerkung,
        bb.watchlist AS bewertung_watchlist,
        bb.watchlist_grund AS bewertung_watchlist_grund,
        bb.watchlist_objekttyp AS bewertung_watchlist_objekttyp,
        bb.publizieren_oeffentlich AS bewertung_publizieren_oeffentlich,
        bb.dossier AS bewertung_dossier,
        mg.nummer AS grundstuecknummer,
        mg.bfs_nr,
        mg.grundbuch,
        mg.gemeinde,
        mg.egrid,
        mg.flaechenmass as grundstueckflaeche,
        'https://geo.so.ch/map/?property_egrid=' || mg.egrid as eigentuemer,
        mg.nutzungsgrad,
        array_to_json(
            array_agg(
                json_build_object(
                    '@type', 'SO_ARP_Arbeitszonenbewirtschaftung_Inventar_Publikation_20240517.Arbeitszonenbewirtschaftung_Inventar.Grundnutzung',
                    'Bezeichnung_Kanton', ng.typ_kt,
                    'Flaeche', ST_Area(ST_Intersection(mg.geometrie, ng.geometrie)),
                    'Bezeichnung_Gemeinde', ng.typ_bezeichnung
                )
            )
        )::jsonb AS grundnutzung,
        bb.mietflaeche AS bewertung_mietflaeche,
        bb.flaeche_erweiterbar AS bewertung_flaeche_erweiterbar,
        true AS bewertung_vorhanden
    FROM
        grundstuecke_mit_nutzungsgrad mg
    JOIN
        arp_arbeitszonenbewirtschaftung_staging_v1.bewertung_bewertung bb 
    ON
        ST_Within(bb.geometrie, mg.geometrie)
    JOIN
        arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung ng 
    ON
        ST_Intersects(mg.geometrie, ng.geometrie)
    WHERE
        ng.typ_code_kt in ( 120, 121, 122, 130, 131, 132, 133, 134 )
    AND
        -- Definiere eine Minimalfläche wie gross die Überlappung eines Grundstücks
        -- mit einer Arbeitszone ist. Dies dient dazu, dass Grundstücke bzw. Arbeitszonen
        -- mit geometrischen Ungenauigkeiten fälschlicherweise berücksichtigt werden.
        ST_Area(ST_Intersection(mg.geometrie, ng.geometrie)) >= 1.0
    GROUP BY
        mg.t_id,
        mg.geometrie,
        bewertung_bebaut,
        bewertung_potenzial,
        bewertung_in_planung,
        bewertung_unternutzte_arbeitszone,
        bewertung_mietobjekt,
        bewertung_erweiterbar_nachbargrundstueck,
        bewertung_gebunden,
        bewertung_zonierung_kontrollieren,
        bewertung_bemerkung,
        bewertung_watchlist,
        bewertung_watchlist_grund,
        bewertung_watchlist_objekttyp,
        bewertung_publizieren_oeffentlich,
        bewertung_dossier,
        grundstuecknummer,
        mg.grundbuch,
        mg.bfs_nr,
        mg.gemeinde,
        mg.egrid,
        grundstueckflaeche,
        eigentuemer,
        nutzungsgrad,
        bewertung_mietflaeche,
        bewertung_flaeche_erweiterbar,
        bewertung_vorhanden
),
-- Fasse die Grundstücke mit Bewertung mit denjenigen ohne Bewertung zusammen
grundstuecke_zusammengefasst AS (
    SELECT
        geometrie,
        bewertung_bebaut,
        bewertung_potenzial,
        bewertung_in_planung,
        bewertung_unternutzte_arbeitszone,
        bewertung_mietobjekt,
        bewertung_erweiterbar_nachbargrundstueck,
        bewertung_gebunden,
        bewertung_zonierung_kontrollieren,
        bewertung_bemerkung,
        bewertung_watchlist,
        bewertung_watchlist_grund,
        bewertung_watchlist_objekttyp,
        bewertung_publizieren_oeffentlich,
        bewertung_dossier,
        grundstuecknummer,
        bfs_nr,
        grundbuch,
        gemeinde,
        egrid,
        grundstueckflaeche,
        eigentuemer,
        nutzungsgrad,
        grundnutzung,
        bewertung_mietflaeche,
        bewertung_flaeche_erweiterbar,
        bewertung_vorhanden
    FROM
        grundstuecke_mit_bewertung

    UNION

    -- Sammle alle Grundstücke ohne Bewertung
    SELECT
        mg.geometrie,
        NULL::BOOLEAN AS bewertung_bebaut,
        NULL::BOOLEAN AS bewertung_potenzial,
        NULL::BOOLEAN AS bewertung_in_planung,
        NULL::BOOLEAN AS bewertung_unternutzte_arbeitszone,
        NULL::BOOLEAN AS bewertung_mietobjekt,
        NULL::BOOLEAN AS bewertung_erweiterbar_nachbargrundstueck,
        NULL::BOOLEAN AS bewertung_gebunden,
        NULL::BOOLEAN AS bewertung_zonierung_kontrollieren,
        NULL::text AS bewertung_bemerkung,
        NULL::BOOLEAN AS bewertung_watchlist,
        NULL::text AS bewertung_watchlist_grund,
        NULL::text AS bewertung_watchlist_objekttyp,
        NULL::BOOLEAN AS bewertung_publizieren_oeffentlich,
        NULL::text AS bewertung_dossier,
        mg.nummer AS grundstuecknummer,
        mg.bfs_nr,
        mg.grundbuch,
        mg.gemeinde,
        mg.egrid,
        mg.flaechenmass as grundstueckflaeche,
        'https://geo.so.ch/map/?property_egrid=' || mg.egrid as eigentuemer,
        mg.nutzungsgrad,
        array_to_json(
            array_agg(
                json_build_object(
                    '@type', 'SO_ARP_Arbeitszonenbewirtschaftung_Inventar_Publikation_20240517.Arbeitszonenbewirtschaftung_Inventar.Grundnutzung',
                    'Bezeichnung_Kanton', ng.typ_kt,
                    'Flaeche', ST_Area(ST_Intersection(mg.geometrie, ng.geometrie)),
                    'Bezeichnung_Gemeinde', ng.typ_bezeichnung
                )
            )
        )::jsonb AS grundnutzung,
        NULL::integer AS bewertung_mietflaeche,
        NULL::integer AS bewertung_flaeche_erweiterbar,
        false AS bewertung_vorhanden
    FROM
        grundstuecke_mit_nutzungsgrad mg
    JOIN
        arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung ng 
    ON
        ST_Intersects(mg.geometrie, ng.geometrie)
    WHERE
        ng.typ_code_kt in ( 120, 121, 122, 130, 131, 132, 133, 134 )
    AND
        -- Definiere eine Minimalfläche wie gross die Überlappung eines Grundstücks
        -- mit einer Arbeitszone ist. Dies dient dazu, dass Grundstücke bzw. Arbeitszonen
        -- mit geometrischen Ungenauigkeiten fälschlicherweise berücksichtigt werden.
        ST_Area(ST_Intersection(mg.geometrie, ng.geometrie)) >= 1.0
    AND
        mg.t_id NOT IN
        (
            SELECT t_id FROM grundstuecke_mit_bewertung
        )

    GROUP BY
        mg.geometrie,
        bewertung_bebaut,
        bewertung_potenzial,
        bewertung_in_planung,
        bewertung_unternutzte_arbeitszone,
        bewertung_mietobjekt,
        bewertung_erweiterbar_nachbargrundstueck,
        bewertung_gebunden,
        bewertung_zonierung_kontrollieren,
        bewertung_bemerkung,
        bewertung_watchlist,
        bewertung_watchlist_grund,
        bewertung_watchlist_objekttyp,
        bewertung_publizieren_oeffentlich,
        bewertung_dossier,
        grundstuecknummer,
        mg.grundbuch,
        mg.bfs_nr,
        mg.gemeinde,
        mg.egrid,
        grundstueckflaeche,
        eigentuemer,
        nutzungsgrad,
        bewertung_mietflaeche,
        bewertung_flaeche_erweiterbar,
        bewertung_vorhanden
)
-- Füge das Zonenreglement, Gestaltungspläne, Bauzonenstatistik, Baureglement
-- und die Region dazu
SELECT
    gbr.geometrie,
    gbr.bewertung_bebaut,
    gbr.bewertung_potenzial,
    gbr.bewertung_in_planung,
    gbr.bewertung_unternutzte_arbeitszone,
    gbr.bewertung_mietobjekt,
    gbr.bewertung_erweiterbar_nachbargrundstueck,
    gbr.bewertung_gebunden,
    gbr.bewertung_zonierung_kontrollieren,
    gbr.bewertung_bemerkung,
    gbr.bewertung_watchlist,
    gbr.bewertung_watchlist_grund,
    gbr.bewertung_watchlist_objekttyp,
    gbr.bewertung_publizieren_oeffentlich,
    gbr.bewertung_dossier,
    gbr.grundstuecknummer,
    gbr.grundbuch,
    gbr.gemeinde,
    gbr.egrid,
    gbr.grundstueckflaeche,
    gbr.eigentuemer,
    rr.aname AS region,
    gbr.nutzungsgrad,
    zr.textimweb AS zonenreglement,
    STRING_AGG(gp.textimweb, ' ') AS gestaltungsplan,
    (
        SELECT
            ST_Within
            (
                ST_PointOnSurface(gbr.geometrie),
                (
                    SELECT
                        ST_Collect(geometrie)
                    FROM
                        arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche
                    WHERE
                        -- Sind das die richtigen Codes?
                        typ_code_kt IN (611, 620)
                )
            )
    ) AS gestaltungsplanpflicht,
    lnb.bebauungsstand AS bauzonenstatistik,
    gbr.grundnutzung,
    br.textimweb AS baureglement,
    gbr.bewertung_mietflaeche,
    gbr.bewertung_flaeche_erweiterbar,
    gbr.bewertung_vorhanden
FROM
    grundstuecke_zusammengefasst gbr
-- Verknüpfe die Bauzonenstatistik
LEFT JOIN
    arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_liegenschaft_nach_bebauungsstand lnb
ON
    ST_Within(ST_PointOnSurface(gbr.geometrie), lnb.geometrie)
-- Verknüpfe die Baureglemente
LEFT JOIN
    baureglemente br
ON
    br.bfs_nr::INTEGER = gbr.bfs_nr::INTEGER
-- Verknüpfe die Zonenreglmente
LEFT JOIN
    zonenreglemente zr
ON
    zr.bfs_nr::INTEGER = gbr.bfs_nr::INTEGER
-- Verknüpfe die Gestaltungspläne
LEFT JOIN
    gestaltungsplaene gp
ON
    ST_Within(ST_PointOnSurface(gbr.geometrie), gp.geometrie)
-- Verknüpfe die Region mit dem Grundstück
LEFT JOIN
    (
        SELECT
            aname,
            ST_Collect(geometrie) AS geometrie
        FROM
            arp_arbeitszonenbewirtschaftung_staging_v1.regionen_region
        GROUP BY
            aname
    ) AS rr
ON
    ST_Within(ST_PointOnSurface(gbr.geometrie), rr.geometrie)
GROUP BY
    gbr.geometrie,
    gbr.bewertung_bebaut,
    gbr.bewertung_potenzial,
    gbr.bewertung_in_planung,
    gbr.bewertung_unternutzte_arbeitszone,
    gbr.bewertung_mietobjekt,
    gbr.bewertung_erweiterbar_nachbargrundstueck,
    gbr.bewertung_gebunden,
    gbr.bewertung_zonierung_kontrollieren,
    gbr.bewertung_bemerkung,
    gbr.bewertung_watchlist,
    gbr.bewertung_watchlist_grund,
    gbr.bewertung_watchlist_objekttyp,
    gbr.bewertung_publizieren_oeffentlich,
    gbr.bewertung_dossier,
    gbr.grundstuecknummer,
    gbr.grundbuch,
    gbr.gemeinde,
    gbr.egrid,
    gbr.grundstueckflaeche,
    gbr.eigentuemer,
    region,
    gbr.nutzungsgrad,
    zonenreglement,
    gestaltungsplanpflicht,
    bauzonenstatistik,
    gbr.grundnutzung,
    baureglement,
    bewertung_mietflaeche,
    bewertung_flaeche_erweiterbar,
    bewertung_vorhanden

;