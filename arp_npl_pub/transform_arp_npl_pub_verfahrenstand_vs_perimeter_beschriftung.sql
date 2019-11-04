SELECT
    --vspos.t_id,
    vspos.t_ili_tid,
    vsperim.verfahrensstufe,
    vsperim.name_nummer,
    vspos.pos,
    vspos.ori AS pos_ori,
    vspos.hali AS pos_hali,
    vspos.vali AS pos_vali,
    vspos.groesse AS pos_groesse,
    vsperim.t_datasetname::int4 AS bfs_nr        
FROM
    arp_npl.verfahrenstand_vs_perimeter_pos vspos
    LEFT JOIN arp_npl.verfahrenstand_vs_perimeter_verfahrensstand vsperim
      ON vspos.vs_perimeter_verfahrensstand = vsperim.t_id
;
