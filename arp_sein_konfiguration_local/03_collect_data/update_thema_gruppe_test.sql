/*
 * Zuerst werden alle Werte auf NULL gesetzt.
 * Wo kein Match durchgeführt werden kann, bleibt NULL bestehen
 */

UPDATE sein.main.sein_sammeltabelle_filtered
SET
	thema = NULL,
	gruppe = NULL
;

/*
 * Um die korrekten Gruppen- und Themenbezeichnungen zu verwenden, werden diese
 * über die Beziehungen bzw. Namensabgleich rausgelesen.
 */
UPDATE sein.main.sein_sammeltabelle_filtered
SET
	thema = gt.aname,
	gruppe = gg.aname
FROM 
	sein.main.sein_sammeltabelle_filtered AS target
LEFT JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_thema AS gt
	ON target.thema_sql = gt.aname
LEFT JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gruppe AS gg 
	ON gt.gruppe_r = gg.T_Id
WHERE 
	target.thema IS NULL