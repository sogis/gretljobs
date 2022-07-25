SELECT
    CASE
        WHEN konsultationsbereich = 'm_100'
            THEN ST_Multi(ST_Union(ST_intersection(ST_Buffer(durchgangsstrasse.geometrie, 100), kantonsgrenze.geometrie)))
        WHEN konsultationsbereich = 'm_300'
            THEN ST_Multi(ST_Union(ST_intersection(ST_Buffer(durchgangsstrasse.geometrie, 300), kantonsgrenze.geometrie)))
    END AS geometrie,
    'Durchgangsstrasse' AS typ
FROM
    afu_stoerfallverordnung_v1.durchgangsstrasse AS durchgangsstrasse,
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze kantonsgrenze
WHERE
    durchgangsstrasse.geometrie && kantonsgrenze.geometrie
AND
    NOT ST_IsEmpty(ST_intersection(durchgangsstrasse.geometrie, kantonsgrenze.geometrie))
AND
    NOT ST_Disjoint(ST_intersection(durchgangsstrasse.geometrie, kantonsgrenze.geometrie), kantonsgrenze.geometrie)
AND
    durchgangsstrasse.konsultationsbereich <> 'm_0'
GROUP BY
    konsultationsbereich
;
