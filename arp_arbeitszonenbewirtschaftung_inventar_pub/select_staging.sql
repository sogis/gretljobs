-- Relevant sind alle Grundstücke, die innerhalb einer Arbeitszone liegen mit Angabe zu Nutzungsplanung
WITH relevante_grundstuecke AS (
    SELECT
        DISTINCT ON (mg.egrid)
        mg.t_id,
        mg.geometrie,
        mg.nummer,
        mg.flaechenmass,
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
    WHERE
        ng.typ_code_kt in ( 120, 121, 122, 130, 131, 132, 133, 134 )
        AND
            ST_Area(ST_Intersection(mg.geometrie, ng.geometrie)) >= 5.0
GROUP BY
        mg.t_id,
        mg.geometrie,
        mg.nummer,
        mg.grundbuch,
        mg.flaechenmass,
        mg.bfs_nr,
        mg.gemeinde,
        mg.egrid
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

--Berechung von Bauzonenstatistik kann übernommen werden       
bauzonenstatistik AS (
    SELECT
        st.egris_egrid AS egrid,
        st.flaeche,
        sum(st.flaeche_unbebaut) AS unbebaut_pro_grundstueck, -- Aggregieren der Aussage auf ein Grundstück. Die Grundstücke sind geschnitten
        STRING_AGG(st.bebauungsstand, ', ') AS agg_bebauungsstand
    FROM
        arp_auswertung_nutzungsplanung_pub_v1.bauzonenstatistik_liegenschaft_nach_bebauungsstand st
    GROUP BY
    st.egris_egrid,
    st.flaeche
),

--Verschnitt mit Grundnutzung für Teilflächen und join mit Bauzonenstatistik 
grundstueck_grundnutzung_bauzonenstatistik AS (
    SELECT
        gr.geometrie,
        gr.nummer,
        gr.flaechenmass, -- siehe oben
        gr.grundbuch,
        gr.bfs_nr, -- BFS Nummer
        gr.gemeinde, -- Gemeindename
        gr.egrid,
        b.baureglement,
        CASE WHEN
            CAST(bz.unbebaut_pro_grundstueck AS numeric) / CAST(bz.flaeche AS numeric) >= 0.9
                THEN 'ungenutzt_weniger_10Prozent'
        WHEN
             CAST(bz.unbebaut_pro_grundstueck AS numeric) / CAST(bz.flaeche AS numeric)  < 0.7
                THEN 'genutzt_mehr_als_30Prozent'
        ELSE
            'teilgenutzt_zwischen_10_30Prozent'
        END AS nutzungsgrad,
        CASE WHEN
            bz.agg_bebauungsstand = 'unbebaut'
                THEN 'unbebaut'
        WHEN
            bz.agg_bebauungsstand ILIKE  '%teilweise_bebaut%'
                THEN 'teilweise_bebaut'
        ELSE
            'bebaut'
        END AS bebauungsstand,        
        z.zonenreglement,
         array_to_json(
            array_agg(
                json_build_object(
                    '@type', 'SO_ARP_Arbeitszonenbewirtschaftung_Inventar_Staging_20241115.Arbeitszonenbewirtschaftung_Inventar.Grundnutzung',
                    'Bezeichnung_Kanton', ng.typ_kt,
                    'Flaeche', ROUND(ST_Area(ST_Intersection(gr.geometrie,ng.geometrie))),
                    'Bezeichnung_Gemeinde', ng.typ_bezeichnung
                )
            )
        )::jsonb AS grundnutzung
    FROM
        relevante_grundstuecke gr
    LEFT JOIN
       arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung ng 
    ON
        ST_Intersects(gr.geometrie, ng.geometrie)
    LEFT JOIN
    bauzonenstatistik bz
    ON  gr.egrid=bz.egrid
    LEFT JOIN
        baureglement b
    ON
        b.bfs_nr=gr.bfs_nr::TEXT
    LEFT JOIN
        zonenreglement z
    ON
        z.bfs_nr=gr.bfs_nr::TEXT
    WHERE
        ST_Area(ST_Intersection(gr.geometrie, ng.geometrie)) >= 1.0
    GROUP BY
        gr.t_id,
        gr.geometrie,
        gr.nummer,
        gr.grundbuch,
        gr.flaechenmass,
        gr.bfs_nr,
        gr.gemeinde,
        gr.egrid,
        b.baureglement,
        z.zonenreglement,
        bz.unbebaut_pro_grundstueck,
        bz.flaeche,
        bz.agg_bebauungsstand
        
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
    gbr.geometrie,
    gbr.nummer AS grundstuecknummer,
    gbr.grundbuch,
    gbr.gemeinde,
    gbr.egrid,
    gbr.flaechenmass AS grundstueckflaeche,
    'https://geo.so.ch/map/?property_egrid=' || gbr.egrid as eigentuemer,
    rr.aname AS region,
    gbr.nutzungsgrad,
    gbr.bebauungsstand AS bauzonenstatistik,
    gbr.zonenreglement,
    gbr.baureglement,
    gbr.grundnutzung,
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
                        typ_code_kt = 620)
                )
            ) AS gestaltungsplanpflicht
   
FROM
    grundstueck_grundnutzung_bauzonenstatistik gbr
-- Verknüpfe die Bauzonenstatistik
LEFT JOIN
    bauzonenstatistik lnb
ON
    gbr.egrid=lnb.egrid
-- Verknüpfe die Gestaltungspläne
LEFT JOIN
    gestaltungsplaene gp
ON
    ST_Within(ST_PointOnSurface(gbr.geometrie), gp.geometrie)
-- Verknüpfe die Region mit dem Grundstück
LEFT JOIN
    region rr
ON
    ST_Within(ST_PointOnSurface(gbr.geometrie), rr.geometrie)
GROUP BY
    gbr.geometrie,
    gbr.nummer,
    gbr.grundbuch,
    gbr.gemeinde,
    gbr.egrid,
    gbr.flaechenmass,
    rr.aname,
    gbr.nutzungsgrad,
    zonenreglement,
    gestaltungsplanpflicht,
    bauzonenstatistik,
    gbr.grundnutzung,
    baureglement