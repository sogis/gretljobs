SELECT 
    abw_bauwerk.bw_tid AS t_id, 
    abw_bauwerk.detailgeometrie AS geometrie, 
    abw_bauwerk.baujahr, 
    abw_bauwerk.bw_bezeichnung AS bezeichnung, 
    abw_bauwerk.baulicherzustand, 
    abw_bauwerk.o_bezeichnung AS eigentuemer, 
    abw_bauwerk.status AS status, 
    abw_bauwerk.zugaenglichkeit AS zugaenglichkeit, 
    abw_bauwerk.rueckstaukote, 
    abw_bauwerk.sohlenkote, 
    abw_bauwerk.funktion AS funktion, 
    abw_bauwerk.hochwasserkote, 
    spezialbauwerk.funktion AS sbw_funktion
FROM 
    (SELECT 
        bauwerk.t_id AS bw_tid, 
        bauwerk.detailgeometrie, 
        bauwerk.baujahr, 
        bauwerk.bezeichnung AS bw_bezeichnung, 
        bauwerk.baulicherzustand, 
        organisation.bezeichnung AS o_bezeichnung, 
        bauwerk.status, 
        bauwerk.zugaenglichkeit, 
        k.rueckstaukote, 
        k.sohlenkote, 
        normschacht.funktion, 
        vorfluter.hochwasserkote
    FROM agi_leitungskataster_abw.sia405_abwassr_wi_abwasserbauwerk bauwerk
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_organisation organisation ON organisation.t_id::text = bauwerk.eigentuemer::text
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_abwassernetzelement netzelement ON bauwerk.t_id::text = netzelement.abwasserbauwerk::text
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_abwasserknoten k ON netzelement.t_id::text = k.superclass::text
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_normschacht normschacht ON bauwerk.t_id::text = normschacht.superclass::text
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_vorflutereinlauf vorfluter ON bauwerk.t_id::text = vorfluter.superclass::text
    WHERE bauwerk.detailgeometrie IS NOT null) abw_bauwerk
RIGHT JOIN 
    (SELECT DISTINCT ON (sia405_abwassr_wi_spezialbauwerk.superclass) 
        sia405_abwassr_wi_spezialbauwerk.t_id, 
        sia405_abwassr_wi_spezialbauwerk.obj_id, 
        sia405_abwassr_wi_spezialbauwerk.superclass, 
        sia405_abwassr_wi_spezialbauwerk.bypass, 
        sia405_abwassr_wi_spezialbauwerk.funktion, 
        sia405_abwassr_wi_spezialbauwerk.t_datasetname
   FROM agi_leitungskataster_abw.sia405_abwassr_wi_spezialbauwerk) spezialbauwerk ON abw_bauwerk.bw_tid::text = spezialbauwerk.superclass::text
;
