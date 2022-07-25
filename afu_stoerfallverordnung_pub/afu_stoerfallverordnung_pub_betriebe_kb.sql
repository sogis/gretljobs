SELECT
    CASE
        WHEN konsultationsbereich = 'm_100'
            THEN ST_Union(ST_intersection(ST_Buffer(betriebsareal.geometrie, 100), kantonsgrenze.geometrie))
        WHEN konsultationsbereich = 'm_300'
            THEN ST_Union(ST_intersection(ST_Buffer(betriebsareal.geometrie, 300), kantonsgrenze.geometrie))
    END AS geometrie,
    'Betriebsareal' AS typ
FROM
    afu_stoerfallverordnung_v1.betriebsareal as betriebsareal,
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze kantonsgrenze
WHERE
    betriebsareal.geometrie && kantonsgrenze.geometrie
AND
    NOT ST_IsEmpty(ST_intersection(betriebsareal.geometrie, kantonsgrenze.geometrie))
AND
    NOT ST_Disjoint(ST_intersection(betriebsareal.geometrie, kantonsgrenze.geometrie), kantonsgrenze.geometrie)
AND
    betriebsareal.konsultationsbereich <> 'm_0'
GROUP BY
    konsultationsbereich, betriebsname
;
