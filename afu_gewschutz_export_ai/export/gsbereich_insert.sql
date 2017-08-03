WITH gszustr as
(
	SELECT aww_gszustr.ogc_fid, aww_gszustr.wkb_geometry, aww_gszustr.typ, aww_gszustr.name
	FROM aww_gszustr where archive = 0
),
singlepoly_gszu as
(
	select
		ogc_fid,
		coalesce((((dump).path)[1]),0) as partindex,
		ST_AsBinary((dump).geom) as singlepoly_wkb
	from
	(
		select ST_DUMP(wkb_geometry) as dump, ogc_fid
		from gszustr
	) as dump
),
fields_gszustr as -- gwsbereich felder gemappt aus aww_gszoar
(
	select
		ogc_fid,
		case
			when trim(typ) = 'Zo' then 'Zo'
			when trim(typ) = 'Zu' then 'Zu'
			else 'Umbauproblem: Nicht behandelte Codierung von Attibut [typ]'
		end as typ,
		concat('Name: ', name) as bemerkungen,
		typ as kantonale_bezeichnung
	from gszustr
),
gsab as
(
	SELECT aww_gsab.ogc_fid, aww_gsab.wkb_geometry, aww_gsab.zone, aww_gsab.erfasser
	FROM aww_gsab where archive = 0
),
singlepoly_gsab as
(
	select
		ogc_fid,
		coalesce((((dump).path)[1]),0) as partindex,
		ST_AsBinary((dump).geom) as singlepoly_wkb
	from
	(
		select ST_DUMP(wkb_geometry) as dump, ogc_fid
		from gsab
	) as dump
),
fields_gsab as -- gwsbereich felder gemappt aus aww_gszoar
(
	select
		ogc_fid,
		case
			when trim(zone) = 'B' then 'UB'
			when trim(zone) = 'O' then 'Ao'
			when trim(zone) = 'U' then 'Au'
			else 'Umbauproblem: Nicht behandelte Codierung von Attibut [zone]'
		end as typ,
		concat('Erfasser: ', erfasser) as bemerkungen,
		zone as kantonale_bezeichnung
	from gsab
),
unionall as
(
	select fields_gszustr.ogc_fid, typ, bemerkungen, kantonale_bezeichnung,partindex, singlepoly_wkb
	from fields_gszustr
	inner join singlepoly_gszu on fields_gszustr.ogc_fid = singlepoly_gszu.ogc_fid
	union all
	select fields_gsab.ogc_fid, typ, bemerkungen, kantonale_bezeichnung, partindex, singlepoly_wkb
	from fields_gsab
	inner join singlepoly_gsab on fields_gsab.ogc_fid = singlepoly_gsab.ogc_fid
),
gwsbereich as
(
	select
		nextval('afu_gewaesserschutz_export.t_ili2db_seq') as tid,
		concat(ogc_fid,'-',partindex) as identifier,
		ogc_fid,
		typ,
		bemerkungen,
		kantonale_bezeichnung,
		singlepoly_wkb
	from unionall
)


INSERT INTO afu_gewaesserschutz_export.gsbereich(t_id, identifikator, typ, geometrie)
(
        SELECT
                tid,
                identifier,
                typ,
                ST_GeomFromWKB(singlepoly_wkb, 2056)
        FROM gwsbereich
);
