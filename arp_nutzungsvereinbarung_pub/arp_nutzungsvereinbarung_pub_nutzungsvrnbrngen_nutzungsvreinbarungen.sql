WITH
    nutzungsvereinbarung AS (
        SELECT
            nutzungsvereinbarungen.t_ili_tid,
            nutzungsvereinbarungen.nummer,
            nutzungsvereinbarungen.vertrag,
            nutzungsvereinbarungen.datum,
            nutzungsvereinbarungen.flaechenart,
            mjp_person.vorname || ' ' || mjp_person.aname || ', ' || mjp_person.ortschaft AS bewirtschafter,
            projekte.aname AS projekt,
            nutzungsvereinbarungen.geometrie
        FROM
            arp_nutzungsvereinbarung.nutzungsvrnbrngen_nutzungsvereinbarungen AS nutzungsvereinbarungen
            LEFT JOIN arp_nutzungsvereinbarung.nutzungsvrnbrngen_projekte AS projekte
                ON projekte.t_id = nutzungsvereinbarungen.projekt_vereinbarung
            LEFT JOIN arp_mehrjahresprogramm.mehrjahresprgramm_person AS mjp_person
                ON mjp_person.personenid = nutzungsvereinbarungen.bewirtschafter_persid   
    ),
    grundstueck AS (
        SELECT
            grundstueck.nummer,
            liegenschaft.geometrie,
            gemeinde.aname AS name
        FROM
            agi_dm01avso24.liegenschaften_liegenschaft AS liegenschaft
            JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
                ON liegenschaft.liegenschaft_von = grundstueck.t_id
            LEFT JOIN agi_dm01avso24.gemeindegrenzen_gemeinde AS gemeinde
                ON gemeinde.t_datasetname = grundstueck.t_datasetname
    ),
    flurname AS (
        SELECT
            flurname.geometrie,
            flurname.aname AS name
        FROM
            agi_dm01avso24.nomenklatur_flurname AS flurname
  )

SELECT
    nutzungsvereinbarung.t_ili_tid,
    nutzungsvereinbarung.nummer,
    nutzungsvereinbarung.vertrag,
    nutzungsvereinbarung.datum,
    nutzungsvereinbarung.flaechenart,
    nutzungsvereinbarung.bewirtschafter AS bewirtschafter_name,
    nutzungsvereinbarung.projekt AS projekte,
    string_agg(DISTINCT grundstueck.name , ', ' ORDER BY grundstueck.name) AS gemeinde,
    string_agg(DISTINCT grundstueck.nummer, ', ' ORDER BY grundstueck.nummer) AS grundstueck_nr,
    string_agg(DISTINCT flurname.name, ', ' ORDER BY flurname.name) AS flurname,
    nutzungsvereinbarung.geometrie
FROM
    grundstueck AS grundstueck,
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