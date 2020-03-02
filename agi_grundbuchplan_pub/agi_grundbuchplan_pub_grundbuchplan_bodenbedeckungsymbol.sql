SELECT
    symbol.t_id, 
    bb.art AS art_txt, 
    symbol.pos, 
    symbol.ori * 0.9::double precision AS rot, 
    CAST(symbol.t_datasetname AS INTEGER) AS bfs_nr
FROM agi_dm01avso24.bodenbedeckung_boflaeche AS bb
    RIGHT JOIN agi_dm01avso24.bodenbedeckung_boflaechesymbol AS symbol
    ON symbol.boflaechesymbol_von = bb.t_id
;