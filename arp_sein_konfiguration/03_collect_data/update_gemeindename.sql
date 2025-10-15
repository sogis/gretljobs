/*
Da gewisse Themen direkt in die Tabelle eingefügt werden und die Gemeindenamen aus deren Quellen stammen,
müssen diese noch an die effektiv verwendeten Gemeindenamen angepasst werden
*/

UPDATE main.sein_sammeltabelle_filtered AS s
	SET gemeindename = g.aname 
FROM
	arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS g
WHERE 
	s.bfsnr = g.bfsnr;