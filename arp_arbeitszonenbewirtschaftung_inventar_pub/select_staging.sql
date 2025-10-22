-- Relevant sind alle Grundstücke, die innerhalb einer Arbeitszone liegen mit Angabe zu Nutzungsplanung. Quelle Bauzonenstatistik
WITH relevante_liegenschaften_bauzonenstatistik AS (
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
        mg.egrid,
        mg.art_txt -- Grundstücksart
    FROM
        arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_liegenschaft_nach_bebauungsstand st
    -- Wegen Attribut Grundbuch und Fläche mit AV noch verknüpfen
        JOIN
        agi_mopublic_pub.mopublic_grundstueck mg
        ON
        mg.egrid = st.egris_egrid 
    WHERE
        substring(st.grundnutzung_typ_kt from 1 for 4) in ( 'N120', 'N121', 'N122', 'N130', 'N131', 'N132', 'N133', 'N134')
            AND
                 mg.art_txt = 'Liegenschaft'
),

relevante_sdr_bauzonenstatistik AS (
        
    -- Baurecht die in Arbeitszonen  sind
    
    SELECT
        li.t_id,
        mg.geometrie,
        mg.nummer,
        li.bebauungsstand,
        li.nutzungsgrad,
        li.grundnutzung_typ_kt, 
        li.flaeche_beschnitten, 
        li.flaeche_unbebaut,
        mg.flaechenmass,
        mg.grundbuch,
        mg.bfs_nr, -- BFS Nummer
        mg.gemeinde, -- Gemeindename
        mg.egrid,
        mg.art_txt, -- Grundstücksart
        CASE WHEN -- identisch zu liegenschaft? muss anders behandelt werden bezüglich verschnitt und join mit Bewertungs-Punkte
            li.flaechenmass = mg.flaechenmass
                THEN TRUE
        ELSE
            FALSE
        END AS identisch_liegenschaft,
        li.nummer AS liegt_auf_liegenschaft
    FROM
        agi_mopublic_pub.mopublic_grundstueck mg
        JOIN
        relevante_liegenschaften_bauzonenstatistik li
            ON
        ST_Within(ST_PointOnSurface(mg.geometrie), li.geometrie)
    WHERE
                mg.art_txt = 'SelbstRecht.Baurecht'
),

relevante_sdr_bauzonenstatistik_nicht_gleich_Liegenschaft AS (
        SELECT          
        sdr.t_id,
        sdr.geometrie,
        sdr.nummer,
        sdr.bebauungsstand, --kommt von der Liegenschaft. evtl. nicht ganz korrekt
        sdr.nutzungsgrad,
        sdr.grundnutzung_typ_kt, --kommt von der Liegenschaft. evtl. nicht ganz korrekt
        NULL AS flaeche_beschnitten,
        Round(ST_Area(ST_Intersection(sdr.geometrie,unbebaut_fl.geometrie,0.001))::numeric,0) AS flaeche_unbebaut,
        sdr.flaechenmass,
        sdr.grundbuch,
        sdr.bfs_nr, -- BFS Nummer
        sdr.gemeinde, -- Gemeindename
        sdr.egrid,
        sdr.art_txt
    FROM
        relevante_sdr_bauzonenstatistik sdr
        LEFT JOIN
        arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_bebauungsstand_mit_zonen_und_lsgrenzen unbebaut_fl
            ON
        ST_Within(ST_PointOnSurface(sdr.geometrie), unbebaut_fl.geometrie) AND unbebaut_fl.bebauungsstand = 'unbebaut'
    WHERE
        sdr.identisch_liegenschaft = FALSE
),

relevante_grundstuecke_bauzonenstatistik AS (
--Liegenschaften
    SELECT          
        li.t_id,
        li.geometrie,
        li.nummer,
        li.bebauungsstand,
        li.nutzungsgrad,
        li.grundnutzung_typ_kt,
        li.flaeche_beschnitten,
        li.flaeche_unbebaut,
        li.flaechenmass,
        li.grundbuch,
        li.bfs_nr, -- BFS Nummer
        li.gemeinde, -- Gemeindename
        li.egrid,
        li.art_txt
    FROM
        relevante_liegenschaften_bauzonenstatistik li
        
    UNION

-- SDR die gleich sind wie Liegenschaft   
    SELECT          
        sdr.t_id,
        sdr.geometrie,
        sdr.nummer,
        sdr.bebauungsstand,
        sdr.nutzungsgrad,
        sdr.grundnutzung_typ_kt, 
        sdr.flaeche_beschnitten,
        sdr.flaeche_unbebaut,
        sdr.flaechenmass,
        sdr.grundbuch,
        sdr.bfs_nr, -- BFS Nummer
        sdr.gemeinde, -- Gemeindename
        sdr.egrid,
        sdr.art_txt
    FROM
        relevante_sdr_bauzonenstatistik sdr  
    WHERE
        sdr.identisch_liegenschaft = TRUE
        
    UNION
    
-- SDR die nicht gleich sind mit Liegenschaft    
        SELECT          
        sdr.t_id,
        sdr.geometrie,
        sdr.nummer,
        sdr.bebauungsstand,
        sdr.nutzungsgrad,
        sdr.grundnutzung_typ_kt, 
        sdr.flaeche_beschnitten::numeric,
        sdr.flaeche_unbebaut,
        sdr.flaechenmass,
        sdr.grundbuch,
        sdr.bfs_nr, -- BFS Nummer
        sdr.gemeinde, -- Gemeindename
        sdr.egrid,
        sdr.art_txt
    FROM
        relevante_sdr_bauzonenstatistik_nicht_gleich_Liegenschaft sdr
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
        CASE
            WHEN 
                gr.art_txt = 'SelbstRecht.Baurecht'
                    THEN 'Baurecht'
            WHEN gr.art_txt = 'SelbstRecht.Quellenrecht'
                    THEN 'Quellenrecht'
            ELSE
                gr.art_txt
         END  AS grundstuecksart,
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
        gr.flaeche_unbebaut,
        gr.art_txt
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
    DISTINCT ON (gbr.geometrie)
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
    gbr.flaeche_unbebaut,
    gbr.grundstuecksart
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
    rr.aname,
    gbr.grundstuecksart