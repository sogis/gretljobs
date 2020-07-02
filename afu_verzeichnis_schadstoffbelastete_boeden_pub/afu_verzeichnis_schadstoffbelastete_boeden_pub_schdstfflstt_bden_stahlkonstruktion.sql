WITH dokumente AS (
    SELECT
        schdstfflstt_bden_dokument.t_id,
        schdstfflstt_bden_dokument.t_ili_tid,
        schdstfflstt_bden_dokument.dokumentname,
        schdstfflstt_bden_dokument.dateipfad,
        schdstfflstt_bden_stahlkonstruktion.t_id AS stahlkonstruktion
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument_stahlkonstruktion
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_stahlkonstruktion
            ON schdstfflstt_bden_stahlkonstruktion.t_id = schdstfflstt_bden_dokument_stahlkonstruktion.stahlkonstruktion
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument
            ON schdstfflstt_bden_dokument.t_id = schdstfflstt_bden_dokument_stahlkonstruktion.dokument
), dokumente_json AS (
    SELECT
        array_to_json(
            array_agg(
                row_to_json((
                    SELECT
                        docs
                    FROM 
                        (
                            SELECT
                                t_id,
                                t_ili_tid,
                                dokumentname,
                                dateipfad
                        ) docs
                ))
            )
        ) AS dokumente,
        stahlkonstruktion
    FROM
        dokumente
    GROUP BY
        stahlkonstruktion
), schadstoffe AS (
    SELECT
        schdstfflstt_bden_schadstoff.t_id,
        schdstfflstt_bden_schadstoff.t_ili_tid,
        schdstfflstt_bden_schadstoff.schadstoffname,
        schdstfflstt_bden_schadstoff.kuerzel,
        schdstfflstt_bden_stahlkonstruktion.t_id AS stahlkonstruktion
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff_stahlkonstruktion
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_stahlkonstruktion
            ON schdstfflstt_bden_stahlkonstruktion.t_id = schdstfflstt_bden_schadstoff_stahlkonstruktion.stahlkonstruktion
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff
            ON schdstfflstt_bden_schadstoff.t_id = schdstfflstt_bden_schadstoff_stahlkonstruktion.schadstoff
), schadstoffe_json AS (
    SELECT
        array_to_json(
            array_agg(
                row_to_json((
                    SELECT
                        schadstoffe
                    FROM 
                        (
                            SELECT
                                t_id,
                                t_ili_tid,
                                schadstoffname,
                                kuerzel
                        ) schadstoffe
                ))
            )
        ) AS schadstoffe,
        stahlkonstruktion
    FROM
        schadstoffe
    GROUP BY
        stahlkonstruktion
), gemeinden AS (
    SELECT
        schdstfflstt_bden_stahlkonstruktion.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_stahlkonstruktion
    WHERE
        ST_DWithin(schdstfflstt_bden_stahlkonstruktion.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_stahlkonstruktion.t_id
), bfs_nummern AS (
    SELECT
        schdstfflstt_bden_stahlkonstruktion.t_id,
        string_agg(DISTINCT CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar), ', ' ORDER BY CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar) ASC) AS bfs_nummern
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_stahlkonstruktion
    WHERE
        ST_DWithin(schdstfflstt_bden_stahlkonstruktion.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_stahlkonstruktion.t_id
), parzellennummern AS (
    SELECT
        schdstfflstt_bden_stahlkonstruktion.t_id,
       string_agg(DISTINCT liegen.nummer || '(' || liegen.bfs_nr|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.bfs_nr || ')') AS grundbuchnummern
    FROM
        (SELECT liegenschaften_grundstueck.nummer, 
		         liegenschaften_grundstueck.t_datasetname AS bfs_nr,
		         liegenschaften_liegenschaft.geometrie 
		 FROM agi_dm01avso24.liegenschaften_grundstueck 
		 LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft 
		     ON liegenschaften_liegenschaft.liegenschaft_von = liegenschaften_grundstueck.t_id
		) liegen,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_stahlkonstruktion
    WHERE
        ST_DWithin(schdstfflstt_bden_stahlkonstruktion.geometrie, liegen.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_stahlkonstruktion.t_id
), flurnamen AS (
    SELECT
        schdstfflstt_bden_stahlkonstruktion.t_id,
       string_agg(DISTINCT flurname.flurname, ', ' ORDER BY flurname.flurname) AS flurname
    FROM
        ( SELECT 
		     aname AS flurname, 
		     geometrie 
		 FROM 
		     agi_dm01avso24.nomenklatur_flurname
		 ) flurname,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_stahlkonstruktion
    WHERE
        ST_DWithin(schdstfflstt_bden_stahlkonstruktion.geometrie, flurname.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_stahlkonstruktion.t_id
)

SELECT
    schdstfflstt_bden_stahlkonstruktion.t_ili_tid,
    schdstfflstt_bden_stahlkonstruktion.stahlkonstruktionsname,
    schdstfflstt_bden_stahlkonstruktion.eigentuemer,
    konstruktionstyp.typ AS stahlkonstruktionstyp,
    schdstfflstt_bden_stahlkonstruktion.betriebsstatus,
    schdstfflstt_bden_stahlkonstruktion.baujahr,
    schdstfflstt_bden_stahlkonstruktion.bezeichnung,
    schdstfflstt_bden_stahlkonstruktion.astatus,
    schdstfflstt_bden_stahlkonstruktion.aktiv,
    schdstfflstt_bden_stahlkonstruktion.erfassungsdatum,
    schdstfflstt_bden_stahlkonstruktion.datenerfasser,
    schdstfflstt_bden_stahlkonstruktion.begruendung_aus_vsb_entlassen,
    schdstfflstt_bden_stahlkonstruktion.datum_aus_vsb_entlassen,
    schdstfflstt_bden_stahlkonstruktion.bemerkung,
    schdstfflstt_bden_stahlkonstruktion.nutzungseinschraenkung,
	schdstfflstt_bden_stahlkonstruktion.nutzungsverbot,
    dokumente_json.dokumente,
    schadstoffe_json.schadstoffe,
    schdstfflstt_bden_stahlkonstruktion.geometrie,
    bfs_nummern.bfs_nummern AS bfs_gemeindenummern,
    gemeinden.gemeinden AS gemeindenamen,
    parzellennummern.grundbuchnummern,
    flurnamen.flurname AS flurnamen
FROM
    afu_schadstoffbelastete_boeden.schdstfflstt_bden_stahlkonstruktion
    LEFT JOIN dokumente_json
        ON dokumente_json.stahlkonstruktion = schdstfflstt_bden_stahlkonstruktion.t_id
    LEFT JOIN schadstoffe_json
        ON schadstoffe_json.stahlkonstruktion = schdstfflstt_bden_stahlkonstruktion.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = schdstfflstt_bden_stahlkonstruktion.t_id
    LEFT JOIN bfs_nummern
        ON bfs_nummern.t_id = schdstfflstt_bden_stahlkonstruktion.t_id
    LEFT JOIN parzellennummern
        ON parzellennummern.t_id = schdstfflstt_bden_stahlkonstruktion.t_id
    LEFT JOIN flurnamen
        ON flurnamen.t_id = schdstfflstt_bden_stahlkonstruktion.t_id
	LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_stahlkonstruktionstyp konstruktionstyp 
	    ON schdstfflstt_bden_stahlkonstruktion.typ = konstruktionstyp.t_id
;