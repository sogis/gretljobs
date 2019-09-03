SELECT 
    row_number() OVER ()::integer AS t_id, 
    knoten.lage AS geometrie, 
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
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_normschacht normschacht ON bauwerk.t_id::text = normschacht.superclass::text
;
