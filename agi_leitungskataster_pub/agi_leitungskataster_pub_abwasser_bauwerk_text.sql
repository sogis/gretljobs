SELECT 
    row_number() over(order by schacht.t_id) AS t_id, 
    abw_bauwerktext.bauwerktext, 
    schacht.lage
FROM 
    (SELECT 
        abw_bauwerk.abwasserbauwerkref, 
        array_to_string(array_agg(abw_bauwerk.textinhalt), ''::text) AS bauwerktext
    FROM 
        (SELECT 
            sia405_abwassr_wi_abwasserbauwerk_text.textinhalt, 
            sia405_abwassr_wi_abwasserbauwerk_text.abwasserbauwerkref
        FROM agi_leitungskataster_abw.sia405_abwassr_wi_abwasserbauwerk_text
        ORDER BY sia405_abwassr_wi_abwasserbauwerk_text.abwasserbauwerkref,st_y(sia405_abwassr_wi_abwasserbauwerk_text.textpos) DESC) abw_bauwerk
    GROUP BY abw_bauwerk.abwasserbauwerkref) abw_bauwerktext, 
    (SELECT
        row_number() OVER ()::integer AS ogc_fid,
        bauwerk.t_id AS t_id,
        knoten.lage,
        bauwerk.baujahr,
        bauwerk.bezeichnung,
        bauwerk.baulicherzustand AS baulicherzustand,
        organisation.bezeichnung AS eigentuemer,
        bauwerk.status AS status,
        bauwerk.zugaenglichkeit AS zugaenglichkeit,
        deckel.kote AS deckelkote,
        round(st_x(knoten.lage)::numeric, 2) AS xkoord,
        round(st_y(knoten.lage)::numeric, 2) AS ykoord,
        deckel.lagegenauigkeit AS lagegenauigkeit,
        normschacht.funktion AS funktion,
        vorfluter.hochwasserkote
    FROM agi_leitungskataster_abw.sia405_abwassr_wi_abwasserbauwerk bauwerk
        LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_abwassernetzelement netzelement ON bauwerk.t_id::text = netzelement.abwasserbauwerk::text
        LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_bauwerksteil bauwerksteil ON bauwerk.t_id::text = bauwerksteil.abwasserbauwerk::text
        LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_deckel deckel ON bauwerksteil.t_id::text = deckel.superclass::text
        RIGHT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_abwasserknoten knoten ON netzelement.t_id::text = knoten.superclass::text
        LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_organisation organisation ON organisation.t_id::text = bauwerk.eigentuemer::text
        LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_vorflutereinlauf vorfluter ON bauwerk.t_id::text = vorfluter.superclass::text
        LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_normschacht normschacht ON bauwerk.t_id::text = normschacht.superclass::text) schacht 
WHERE abw_bauwerktext.abwasserbauwerkref::text = schacht.t_id::text
;
