SELECT 
    ogc_fid, 
    geom AS geometrie, 
    id AS t_id,
    "name",
    gem_bfs,
    gmde_name,
    gmde_nr,
    bzrk_nr,
    eg_nr,
    plz,
    ktn_nr,
    ada_nr
FROM 
    ada_adagis_a.gemeindegrenzen_adagisa
;
