SELECT  -- ohne t_basket, weil in Zieltabelle nicht vorhanden
	t_id, t_ili_tid, geometrie, nbident, nummer, art_txt, flaechenmass, egrid, bfs_nr, orientierung, hali, vali, importdatum, nachfuehrung, grundbuch, gemeinde, posx, posy
FROM agi_mopublic_pub.mopublic_grundstueck;