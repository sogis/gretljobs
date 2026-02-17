DELETE FROM grundstueck;

INSERT INTO grundstueck
	SELECT
		basket.t_id AS t_basket,
		ww.t_datasetname,
		ww.egrid,
		mop.gemeinde AS gemeinde,
		wkfb.aname AS forstbetrieb,
		ww.forstkreis,
		fk.dispname AS forstkreis_txt,
		wfr.aname AS forstrevier,
		ww.wirtschaftszone,
		wz.dispname AS wirtschaftszone_txt,
		mop.nummer AS grundstuecknummer,
		mop.flaechenmass::INTEGER,
		CONCAT_WS(' ', wet.dispname, ww.zusatzinformation) AS eigentuemerinformation,
		ww.eigentuemer,
		wet.dispname AS eigentuemer_txt,
		mop.grundbuch AS grundbuch,
		ww.ausserkantonal,
		CASE
			WHEN ausserkantonal IS TRUE 
				THEN 'Ja'
			ELSE 'Nein'
		END AS ausserkantonal_txt,
		mop.geometrie,
		ww.bemerkung
	FROM
		awjf_waldplan_v2.waldplan_waldeigentum AS ww
	LEFT JOIN agi_mopublic_pub.mopublic_grundstueck AS mop
		ON ww.egrid = mop.egrid
	LEFT JOIN awjf_waldplan_v2.waldeigentuemer AS wet
		ON ww.eigentuemer = wet.ilicode
	LEFT JOIN awjf_waldplan_v2.wirtschaftszonen AS wz 
		ON ww.wirtschaftszone = wz.ilicode
	LEFT JOIN awjf_waldplan_v2.waldplankatalog_forstrevier AS wfr
		ON ww.forstrevier = wfr.t_id
	LEFT JOIN awjf_waldplan_v2.forstkreise AS fk 
		ON ww.forstkreis = fk.ilicode
	LEFT JOIN awjf_waldplan_v2.waldplankatalog_forstbetrieb AS wkfb 
		ON ww.forstbetrieb = wkfb.t_id
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
		ON ww.t_datasetname = dataset.datasetname
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_basket AS basket
		ON dataset.t_id = basket.dataset
	WHERE
		ww.t_datasetname::int4 = ${bfsnr_param}
;

CREATE INDEX 
	ON grundstueck
	USING gist (geometrie)
;