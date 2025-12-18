DELETE FROM agi_av_gwr_abgleich_pub_v1.av_gwr_differnzen_av_gwr_differenzen
    WHERE issue = 'A10: Gebäude hat keinen EGID'
;
-- in der CSV Datei fehlen die Fehler "in AV fehlt der EGID". Deshalb diese Ergänzung. 
INSERT INTO agi_av_gwr_abgleich_pub_v1.av_gwr_differnzen_av_gwr_differenzen
SELECT 
    nextval('agi_av_gwr_abgleich_pub_v1.t_ili2db_seq'::regclass) AS t_id,
	g.bfs_nr AS com_fosnr,
	NULL AS bdg_egid,
	NULL AS bdg_geomsrc,
	NULL AS bdg_category,
	NULL AS bdg_gklas,
	CASE 
       WHEN g.astatus  = 'real'
            THEN 'bestehend'
        WHEN g.astatus  = 'projektiert'
            THEN 'projektiert'
        ELSE NULL
    END AS bdg_gstat,
	NULL AS av_source,
	'Gebaeude' AS av_type,
	'A10: Gebäude hat keinen EGID' AS issue,
	'Gebäude hat keinen EGID' AS issue_category,
	NULL AS bdg_e,
	NULL AS bdg_n,
	NULL AS link,
	'Korrektur Geometer' AS agi_klasse,
	'EGID gemäss GWR erfassen' agi_text,
	NULL agi_index,
	g.t_ili_tid AS agi_id,
	st_pointonsurface(g.geometrie) AS geometrie
FROM
    agi_gebaeudeinformationen_pub_v1.gebaeude_gebaeude AS g
WHERE
    g.egid IS NULL
;    