SELECT
    ogc_fid_old,
    ST_Multi(wkb_geometry) AS geometrie,
    nummer,
    fffart_text,
    fffart,
    gem_bfs,
    datum_erst,
    area,
    bk,
    erfassung,
    datum_rrb,
    area_aren,
    gewichtung,
    aren_gew,
    id,
    ogc_fid AS t_id,
    anrechenbar
FROM
    alw_grundlagen.fruchtfolgeflaechen_tab
WHERE 
    archive = 0
;