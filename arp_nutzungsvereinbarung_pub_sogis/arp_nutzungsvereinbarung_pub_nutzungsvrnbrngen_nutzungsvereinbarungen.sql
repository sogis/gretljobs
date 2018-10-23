WITH
    nutzungsvereinbarung AS (
        SELECT 
            nutzungsvereinbarung.t_ili_tid,
            nutzungsvereinbarung.nummer,
            nutzungsvereinbarung.vertrag,
            nutzungsvereinbarung.datum,
            nutzungsvereinbarung.flaechenart,
            personen.vorname || ' ' || personen.name || ', ' || personen.ort AS bewirtschafter,
            projekte.aname AS projekt,
            nutzungsvereinbarung.geometrie
        FROM 
            arp_nutzungsvereinbarung.nutzungsvrnbrngen_nutzungsvereinbarungen AS nutzungsvereinbarung
            LEFT JOIN arp_nutzungsvereinbarung.nutzungsvrnbrngen_projekte AS projekte
                ON projekte.t_id = nutzungsvereinbarung.projekt_vereinbarung
            LEFT JOIN mjpnatur.personen AS personen
                ON personen.persid = nutzungsvereinbarung.bewirtschafter_persid
        WHERE 
            personen.archive = 0
    ),

    grundstueck AS (
        SELECT 
            grundstueck.nummer,
            liegenschaft.geometrie,
            gemeinde.name
        FROM 
            av_avdpool_ng.liegenschaften_liegenschaft AS liegenschaft
            JOIN av_avdpool_ng.liegenschaften_grundstueck AS grundstueck
                ON liegenschaft.liegenschaft_von = grundstueck.tid
            LEFT JOIN av_avdpool_ng.gemeindegrenzen_gemeinde AS gemeinde
                ON gemeinde.gem_bfs = grundstueck.gem_bfs
    ),

    flurname AS (
        SELECT
            flurname.geometrie,
            flurname.name
        FROM 
        av_avdpool_ng.nomenklatur_flurname AS flurname
    )

SELECT  
    nutzungsvereinbarung.t_ili_tid,
    nutzungsvereinbarung.nummer,
    nutzungsvereinbarung.vertrag,
    nutzungsvereinbarung.datum,
    nutzungsvereinbarung.flaechenart,
    nutzungsvereinbarung.bewirtschafter AS bewirtschafter_name,
    nutzungsvereinbarung.projekt AS projekte,
    string_agg(DISTINCT grundstueck.name, ', ' ORDER BY grundstueck.name) AS gemeinde,
    string_agg(DISTINCT grundstueck.nummer, ', ' ORDER BY grundstueck.nummer) AS grundstueck_nr,
    string_agg(DISTINCT flurname.name, ', ' ORDER BY flurname.name) AS flurname,
    nutzungsvereinbarung.geometrie
FROM 
    grundstueck,
    nutzungsvereinbarung,
    flurname
WHERE
    grundstueck.geometrie && nutzungsvereinbarung.geometrie 
    AND 
    ST_Area(ST_Intersection(nutzungsvereinbarung.geometrie, grundstueck.geometrie)) > 5
    AND
    flurname.geometrie && nutzungsvereinbarung.geometrie 
    AND 
    ST_Area(ST_Intersection(nutzungsvereinbarung.geometrie, flurname.geometrie)) > 5
GROUP BY 
    nutzungsvereinbarung.t_ili_tid,
    nutzungsvereinbarung.nummer,
    nutzungsvereinbarung.vertrag,
    nutzungsvereinbarung.datum,
    nutzungsvereinbarung.flaechenart,
    nutzungsvereinbarung.bewirtschafter,
    nutzungsvereinbarung.projekt,
    nutzungsvereinbarung.geometrie
;