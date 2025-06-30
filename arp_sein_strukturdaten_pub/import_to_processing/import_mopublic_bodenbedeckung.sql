SELECT  -- ohne t_basket, weil in Zieltabelle nicht vorhanden
    t_id, t_ili_tid, art_txt, bfs_nr, egid, importdatum, nachfuehrung, geometrie
FROM agi_mopublic_pub.mopublic_bodenbedeckung;