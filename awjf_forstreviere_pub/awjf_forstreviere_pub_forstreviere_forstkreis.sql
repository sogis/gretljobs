SELECT
    ST_Multi(ST_Buffer(ST_Buffer(ST_Union(geometrie),1),-1)) AS geometrie,
    forstreviere_forstkreis.aname AS forstkreis
FROM
    awjf_forstreviere.forstreviere_forstreviergeometrie
    JOIN awjf_forstreviere.forstreviere_forstrevier
        ON forstreviere_forstrevier.t_id=forstreviere_forstreviergeometrie.forstrevier
    JOIN awjf_forstreviere.forstreviere_forstkreis
        ON forstreviere_forstkreis.t_id=forstreviere_forstreviergeometrie.forstkreis
GROUP BY
    forstreviere_forstkreis.t_id
;