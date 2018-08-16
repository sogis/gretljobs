SELECT 
    symb.ogc_fid AS t_id, 
    bb.art, 
    bb.art_txt, 
    symb.pos, 
    symb.ori, 
    symb.ori * 0.9::double precision AS rot, 
    symb.gem_bfs, 
    symb.los, 
    symb.lieferdatum
FROM 
    av_avdpool_ng.bodenbedeckung_boflaeche bb, 
    av_avdpool_ng.bodenbedeckung_boflaechesymbol symb
WHERE 
    bb.tid::text = symb.boflaechesymbol_von::text
;