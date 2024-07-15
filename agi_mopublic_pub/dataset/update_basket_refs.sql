SET search_path TO ${dbSchema};

UPDATE 
    mopublic_bodenbedeckung t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_bodenbedeckung_proj t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_einzelobjekt_flaeche t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_einzelobjekt_linie t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_einzelobjekt_punkt t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_fixpunkt t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_flurname t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_gebaeudeadresse t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_gelaendename t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_gemeindegrenze t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_gemeindegrenze_proj t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_grenzpunkt t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_grundstueck t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_grundstueck_linie t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_grundstueck_proj t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_grundstueck_proj_linie t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_hoheitsgrenzpunkt t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_objektname_pos t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_ortsname t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_rohrleitung t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_strassenachse t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;

UPDATE 
    mopublic_strassenname_pos t
SET 
    t_basket = b.t_id
FROM 
    t_ili2db_basket b
WHERE 
    t.bfs_nr = b.t_ili_tid::int
;
