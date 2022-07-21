SELECT
    CASE
        WHEN konsultationsbereich = 'm_100'
            THEN ST_Multi(ST_intersection(ST_Buffer(nationalstrasse.geometrie, 100), kantonsgrenze.geometrie))
        WHEN konsultationsbereich = 'm_300'
            THEN ST_Multi(ST_intersection(ST_Buffer(nationalstrasse.geometrie, 300), kantonsgrenze.geometrie))
    END AS geometrie,
    'Nationalstrasse' AS typ         
FROM
    afu_stoerfallverordnung_v1.nationalstrasse AS nationalstrasse,
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze kantonsgrenze
WHERE
    nationalstrasse.geometrie && kantonsgrenze.geometrie
AND
    NOT ST_IsEmpty(ST_intersection(nationalstrasse.geometrie, kantonsgrenze.geometrie))
AND
    NOT ST_Disjoint(ST_intersection(nationalstrasse.geometrie, kantonsgrenze.geometrie), kantonsgrenze.geometrie)
AND
    nationalstrasse.konsultationsbereich <> 'm_0'
;
