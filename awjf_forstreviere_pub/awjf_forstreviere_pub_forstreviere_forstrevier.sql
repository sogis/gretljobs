SELECT
    ST_Multi(ST_Union(geometrie)) AS geometrie,
    forstreviere_forstrevier.aname AS forstrevier,
    forstreviere_forstkreis.aname AS forstkreis
FROM
    awjf_forstreviere.forstreviere_forstreviergeometrie
    LEFT JOIN awjf_forstreviere.forstreviere_forstrevier
        ON forstreviere_forstrevier.t_id = forstreviere_forstreviergeometrie.forstrevier
    LEFT JOIN awjf_forstreviere.forstreviere_forstkreis
        ON forstreviere_forstkreis.t_id = forstreviere_forstreviergeometrie.forstkreis
GROUP BY
    forstreviere_forstkreis.t_id,
    forstreviere_forstrevier.aname
;
