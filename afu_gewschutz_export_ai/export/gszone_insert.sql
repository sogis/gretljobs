-- Skript welches die Gewaesserschutzzonen vom Solothurner Schema ins MGDM-Schema umbaut (ili2pg). Dokumente (Oereb) sind im Skript nicht beruecksichtigt
--
-- afu_gszoar selektiert die zutreffenden Zeilen und Spalten für den Umbau ins MGDM
-- singlepolygon löst so vorhanden multipolygone auf. partindex 0 --> war schon singlepolygon. partindex 1-x index des parts innerhalb multipolygon
-- zone_fields baut die Attribute um auf die vom MGDM verlangten Werte
-- gwszone umfasst die notwendigen Informationen für die Befuellung der Klassen GWSAreal und des jeweiligen zugeordneten Status
-- insert_status fuellt die Informationen in die Tabelle "status"
-- insert_gwszone fuellt die Informationen in die Tabelle "gwszone"
with 
afu_gszoar as
(
	 SELECT aww_gszoar.ogc_fid, aww_gszoar."zone", aww_gszoar.rrbnr, 
	    aww_gszoar.rrb_date, aww_gszoar.wkb_geometry
	   FROM aww_gszoar
	  WHERE aww_gszoar.archive = 0 and "zone" != 'SARE'
),
singlepolygon as 
(
	select
		ogc_fid,
		coalesce((((dump).path)[1]),0) as partindex,
		ST_AsBinary((dump).geom) as geo_wkb
	from 
	(
		select ST_DUMP(wkb_geometry) as dump, ogc_fid 
		from afu_gszoar
	) as dump
),
zone_fields as -- gwszone felder gemappt aus aww_gszoar
(
	select 
		ogc_fid, 
		case
			when trim("zone") = 'GZ1' then 'S1'
			when trim("zone") = 'GZ2' then 'S2'
			when trim("zone") = 'GZ2B' then 'S2'
			when trim("zone") = 'GZ3' then 'S3'
			else 'Umbauproblem: Nicht behandelte Codierung von Attibut [zone]'
		end as typ,
		false as ist_altrechtlich, 
		concat('RRB: ', rrbnr) as bemerkungen,
		'inKraft' as stat_rechtsstatus,
		rrb_date as stat_rechtskraftsdatum
	from afu_gszoar
),
gwszone as
(
	select 
		nextval('afu_gewaesserschutz_export.t_ili2db_seq') as tid_gwszone,
		nextval('afu_gewaesserschutz_export.t_ili2db_seq') as tid_status,
		concat(singlepolygon.ogc_fid,'-',partindex) as identifier, 
		typ,
		ist_altrechtlich,
		bemerkungen,
		stat_rechtsstatus,
		stat_rechtskraftsdatum,
		geo_wkb as singlepoly_wkb
	from zone_fields
	inner join singlepolygon on zone_fields.ogc_fid = singlepolygon.ogc_fid
),
insert_status as
(
	insert into afu_gewaesserschutz_export.status(t_id, rechtsstatus, rechtskraftdatum)
	(
		select tid_status, stat_rechtsstatus, stat_rechtskraftsdatum from gwszone
	)
)


insert into afu_gewaesserschutz_export.gwszone(t_id, identifikator, typ, istaltrechtlich, status, geometrie)
(
	select tid_gwszone, identifier, typ, ist_altrechtlich, tid_status, ST_GeomFromWKB(singlepoly_wkb, 2056) from gwszone
);
