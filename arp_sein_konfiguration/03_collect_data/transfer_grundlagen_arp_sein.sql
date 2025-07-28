DELETE FROM sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde;
DELETE FROM sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_thema;
DELETE FROM sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gruppe;
DELETE FROM sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_objektinfo;
DELETE FROM sein.arp_sein_konfiguration_grundlagen_v2.gemeinde_objektinfo;

-- Grundlagen Gemeinde --
INSERT INTO
	sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde (
		t_id,
		aname,
		bfsnr,
		geometrie,
		bezirk,
		handlungsraum	
)

SELECT
	t_id,
	aname,
	bfsnr,
	CAST(geometrie AS GEOMETRY) AS geometrie,
	bezirk,
	handlungsraum	
FROM 
	editdb.arp_sein_konfiguration_grundlagen_v2.grundlagen_gemeinde
;

-- Grundlagen Gruppen --
INSERT INTO
	sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gruppe (
	t_id,
	aname
)

SELECT
	t_id,
	aname
FROM 
	editdb.arp_sein_konfiguration_grundlagen_v2.grundlagen_gruppe
;

-- Grundlagen Themen --
INSERT INTO
	sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_thema (
	t_id,
	gruppe_r,
	aname,
	layerid,
	layertransparenz
)

SELECT
	t_id,
	gruppe_r,
	aname,
	layerid,
	layertransparenz
FROM 
	editdb.arp_sein_konfiguration_grundlagen_v2.grundlagen_thema
;

-- Grundlagen Objektinfo --
INSERT INTO
	sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_objektinfo (
	t_id,
	thema_r,
	information,
	link
)

SELECT
	t_id,
	thema_r,
	information,
	link
FROM 
	editdb.arp_sein_konfiguration_grundlagen_v2.grundlagen_objektinfo 
;

-- Grundlagen Gemeinde_Objektinfo --
INSERT INTO
	sein.arp_sein_konfiguration_grundlagen_v2.gemeinde_objektinfo (
	t_id,
	objektinfo_r,
	gemeinde_r
)

SELECT
	t_id,
	objektinfo_r,
	gemeinde_r
FROM 
	editdb.arp_sein_konfiguration_grundlagen_v2.grundlagen_gemeinde_objektinfo
;