-- Relevant sind alle Grundstücke, die innerhalb einer Arbeitszone liegen mit Angabe zu Nutzungsplanung. Quelle Bauzonenstatistik
WITH relevante_grundstuecke_bauzonenstatistik AS (
    SELECT
        st.t_id,
        st.geometrie,
        st.nummer,
        CASE WHEN
            st.bebauungsstand = 'unbebaut'
                THEN 'unbebaut'
        WHEN
            st.bebauungsstand ILIKE  '%teilweise_bebaut%'
                THEN 'teilweise_bebaut'
        ELSE
            'bebaut'
        END AS bebauungsstand,
        NULL AS nutzungsgrad,
        st.grundnutzung_typ_kt,
        st.flaeche_beschnitten,
        st.flaeche_unbebaut,
        mg.flaechenmass,
        mg.grundbuch,
        mg.bfs_nr, -- BFS Nummer
        mg.gemeinde, -- Gemeindename
        mg.egrid      
    FROM
       arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_liegenschaft_nach_bebauungsstand st
    -- Wegen Attribut Grundbuch und Fläche mit AV noch verknüpfen
    JOIN
        agi_mopublic_pub.mopublic_grundstueck mg
    ON
        mg.egrid = st.egris_egrid 
    WHERE
        substring(st.grundnutzung_typ_kt from 1 for 4) in ( 'N120', 'N121', 'N122', 'N130', 'N131', 'N132', 'N133', 'N134')
),

-- Baureglement werden über die BFS-Nr zugewiesen. Achtung bei Fusionen gibt es theoretisch mehrere ZR und BR
baureglement AS (
    SELECT
    DISTINCT ON (titel, bfs_nr)
        titel,
        textimweb AS baureglement,
        rechtsstatus,
        bfs_nr -- die BFS Nummer
    FROM
    (
        SELECT
            jsonb_array_elements(dokumente)->>'Titel' AS titel,
            jsonb_array_elements(dokumente)->>'TextimWeb' AS textimweb,
            jsonb_array_elements(dokumente)->>'Rechtsstatus' AS rechtsstatus,
            jsonb_array_elements(dokumente)->>'Gemeinde' AS bfs_nr -- das Attribut Gemeinde beinhaltet die BFS Nummer
        FROM
            arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
        WHERE
            jsonb_typeof(dokumente) = 'array'       
        UNION
        SELECT
            dokumente->>'Titel' AS titel,
            dokumente->>'TextimWeb' AS textimweb,
            dokumente->>'Rechtsstatus' AS rechtsstatus,
            dokumente->>'Gemeinde' AS bfs_nr -- das Attribut Gemeinde beinhaltet die BFS Nummer
        FROM
            arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
        WHERE
            jsonb_typeof(dokumente) != 'array'    
    ) AS t
    WHERE
        titel ILIKE '%Baureglement%'  
        AND
            rechtsstatus ='inKraft'       
    GROUP BY
        t.titel,
        t.textimweb,
        rechtsstatus,
        t.bfs_nr
),

-- Zonenreglement werden über die BFS-Nr zugewiesen. Achtung bei Fusionen gibt es theoretisch mehrere ZR und BR
zonenreglement AS (
    SELECT
    DISTINCT ON (titel, bfs_nr)
        titel,
        textimweb AS zonenreglement,
        rechtsstatus,
        bfs_nr -- die BFS Nummer
    FROM
    (
        SELECT
            jsonb_array_elements(dokumente)->>'Titel' AS titel,
            jsonb_array_elements(dokumente)->>'TextimWeb' AS textimweb,
            jsonb_array_elements(dokumente)->>'Rechtsstatus' AS rechtsstatus,
            jsonb_array_elements(dokumente)->>'Gemeinde' AS bfs_nr -- das Attribut Gemeinde beinhaltet die BFS Nummer
        FROM
            arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
        WHERE
            jsonb_typeof(dokumente) = 'array'       
        UNION
        SELECT
            dokumente->>'Titel' AS titel,
            dokumente->>'TextimWeb' AS textimweb,
            dokumente->>'Rechtsstatus' AS rechtsstatus,
            dokumente->>'Gemeinde' AS bfs_nr -- das Attribut Gemeinde beinhaltet die BFS Nummer
        FROM
            arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
        WHERE
            jsonb_typeof(dokumente) != 'array'    
    ) AS t
    WHERE
        titel ILIKE '%Baureglement%'  
        AND
            rechtsstatus ='inKraft'       
    GROUP BY
        t.titel,
        t.textimweb,
        rechtsstatus,
        t.bfs_nr
),

-- Sammle alle Gestaltungspläne
gestaltungsplaene AS (
    SELECT
        t.geometrie,
        t.titel,
        STRING_AGG(t.textimweb, ' ') AS textimweb -- was machen mit mehreren URL's?
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
        t.geometrie, 
        t.titel
),

relevante_grundstueck_reglement AS (
    SELECT
        gr.geometrie,
        gr.nummer,
        gr.flaechenmass, -- Grundstücksfläche
        gr.bfs_nr, -- BFS Nummer
        gr.gemeinde, -- Gemeindename
        gr.grundbuch,
        gr.egrid,
        gr.bebauungsstand, 
        gr.nutzungsgrad,
        gr.grundnutzung_typ_kt,
        gr.flaeche_beschnitten, -- von Bauzonenstatistik
        gr.flaeche_unbebaut, -- von Bauzonenstatistik
        b.baureglement, 
        z.zonenreglement,
        STRING_AGG(gp.textimweb, ' ') AS gestaltungsplan,
        (
            SELECT
                ST_Within
                (
                    ST_PointOnSurface(gr.geometrie),
                    (
                        SELECT
                            ST_Collect(geometrie)
                        FROM
                            arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche
                        WHERE
                            typ_code_kt = 620)
                    )
                ) AS gestaltungsplanpflicht
    FROM
        relevante_grundstuecke_bauzonenstatistik gr
    -- Verknüpfe die Baureglemente pro Gemeinde Achtung bei Fusionen nicht immer korrekt 
    LEFT JOIN
        baureglement b
    ON
        b.bfs_nr=gr.bfs_nr::TEXT
    -- Verknüpfe die Zonenreglemente pro Gemeinde Achtung bei Fusionen nicht immer korrekt 
    LEFT JOIN
        zonenreglement z
    ON
        z.bfs_nr=gr.bfs_nr::TEXT
    -- Verknüpfe die Gestaltungspläne
    LEFT JOIN
        gestaltungsplaene gp
    ON
        ST_Within(ST_PointOnSurface(gr.geometrie), gp.geometrie)
    GROUP BY
        gr.t_id,
        gr.geometrie,
        gr.nummer,
        gr.grundbuch,
        gr.flaechenmass,
        gr.bfs_nr,
        gr.gemeinde,
        gr.bebauungsstand, 
        gr.nutzungsgrad,
        gr.egrid,
        b.baureglement,
        z.zonenreglement,
        gr.grundnutzung_typ_kt,
        gr.flaeche_beschnitten,
        gr.flaeche_unbebaut 
),

region AS (
    SELECT
        r.geometrie,
        r.typ,
        r.aname
    FROM
        arp_arbeitszonenbewirtschaftung_pub_v1.region_region r
    WHERE
        r.typ='Arbeitszonenbewirtschaftung'
)

--alles zusammengefügt
SELECT
    DISTINCT (gbr.geometrie),
    gbr.geometrie,
    gbr.nummer AS grundstuecknummer,
    gbr.grundbuch,
    gbr.gemeinde,
    gbr.egrid,
    gbr.flaechenmass AS grundstueckflaeche,
    'https://geo.so.ch/map/?property_egrid=' || gbr.egrid as eigentuemer,
    rr.aname AS region,
    gbr.nutzungsgrad,
    gbr.zonenreglement,
    gbr.gestaltungsplan,
    gbr.gestaltungsplanpflicht,
    gbr.bebauungsstand,
    gbr.baureglement,
    gbr.grundnutzung_typ_kt,
    gbr.flaeche_beschnitten,
    gbr.flaeche_unbebaut
FROM
    relevante_grundstueck_reglement gbr
-- Verknüpfe die Region mit dem Grundstück
LEFT JOIN
    region rr
ON
    ST_Within(ST_PointOnSurface(gbr.geometrie), rr.geometrie)
GROUP BY
    gbr.geometrie,
    gbr.nummer,
    gbr.grundbuch,
    gbr.flaechenmass,
    gbr.bfs_nr,
    gbr.gemeinde,
    gbr.bebauungsstand,
    gbr.nutzungsgrad,
    gbr.egrid,
    gbr.baureglement,
    gbr.zonenreglement,
    gbr.grundnutzung_typ_kt,
    gbr.flaeche_beschnitten,
    gbr.flaeche_unbebaut,
    gbr.gestaltungsplan,
    gbr.gestaltungsplanpflicht,
    rr.aname