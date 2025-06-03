/*
 * Zuerst werden alle Werte auf NULL gesetzt.
 * Wo kein Match durchgeführt werden kann, bleibt NULL bestehen
 */

UPDATE sein.main.objektinfos_sein_sammeltabelle
SET
	thema = NULL,
	gruppe = NULL
;

/*
 * Um die korrekten Gruppen- und Themenbezeichnungen zu verwenden, werden diese
 * über die Beziehungen bzw. Namensabgleich rausgelesen.
 */
UPDATE sein.main.objektinfos_sein_sammeltabelle
SET
	thema = gt.aname,
	gruppe = gg.aname
FROM 
	sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_thema AS gt
LEFT JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gruppe AS gg 
	ON gt.gruppe_r = gg.T_Id
WHERE 
	gt.aname = thema_sql