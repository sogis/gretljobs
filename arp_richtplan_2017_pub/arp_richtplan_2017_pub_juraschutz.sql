SELECT
    typ,
    CASE
        WHEN typ = 3
            THEN 'Juraschutzzone/Gebiet von besonderer Schönheit und Eigenart: dem Wald überlagert'
        WHEN typ = 5
            THEN 'Juraschutzzone/Gebiet von besonderer Schönheit und Eigenart: dem Landwirtschaftsgebiet überlagert'
    END AS typ_txt,
    gid AS t_id,
    flaeche,
    ST_Multi(geometrie) AS geometrie
FROM
    arp_richtplan_2017.juraschutz
;