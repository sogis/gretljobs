WITH dokumente AS (
    SELECT
        schdstfflstt_bden_dokument.t_id,
        schdstfflstt_bden_dokument.t_ili_tid,
        schdstfflstt_bden_dokument.dokumentname,
        schdstfflstt_bden_dokument.dateipfad,
        schdstfflstt_bden_geogene_bodenbelastung.t_id AS geogene_bodenbelastung
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument_geogene_bodenbelastung
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_geogene_bodenbelastung
            ON schdstfflstt_bden_geogene_bodenbelastung.t_id = schdstfflstt_bden_dokument_geogene_bodenbelastung.geogene_bodenbelastung
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument
            ON schdstfflstt_bden_dokument.t_id = schdstfflstt_bden_dokument_geogene_bodenbelastung.dokument
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
        geogene_bodenbelastung
    FROM
        dokumente
    GROUP BY
        geogene_bodenbelastung
), schadstoffe AS (
    SELECT
        schdstfflstt_bden_schadstoff.t_id,
        schdstfflstt_bden_schadstoff.t_ili_tid,
        schdstfflstt_bden_schadstoff.schadstoffname,
        schdstfflstt_bden_schadstoff.kuerzel,
        schdstfflstt_bden_geogene_bodenbelastung.t_id AS geogene_bodenbelastung
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff_geogene_bodenbelastung
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_geogene_bodenbelastung
            ON schdstfflstt_bden_geogene_bodenbelastung.t_id = schdstfflstt_bden_schadstoff_geogene_bodenbelastung.geogene_bodenbelastung
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff
            ON schdstfflstt_bden_schadstoff.t_id = schdstfflstt_bden_schadstoff_geogene_bodenbelastung.schadstoff
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
        geogene_bodenbelastung
    FROM
        schadstoffe
    GROUP BY
        geogene_bodenbelastung
), gemeinden AS (
    SELECT
        schdstfflstt_bden_geogene_bodenbelastung.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_geogene_bodenbelastung
    WHERE
        ST_DWithin(schdstfflstt_bden_geogene_bodenbelastung.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_geogene_bodenbelastung.t_id
), bfs_nummern AS (
    SELECT
        schdstfflstt_bden_geogene_bodenbelastung.t_id,
        string_agg(DISTINCT CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar), ', ' ORDER BY CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar) ASC) AS bfs_nummern
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_geogene_bodenbelastung
    WHERE
        ST_DWithin(schdstfflstt_bden_geogene_bodenbelastung.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_geogene_bodenbelastung.t_id
), parzellennummern AS (
    SELECT
        schdstfflstt_bden_geogene_bodenbelastung.t_id,
        string_agg(DISTINCT liegen.nummer || '(' || liegen.bfs_nr|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.bfs_nr || ')') AS grundbuchnummern
    FROM
        (SELECT liegenschaften_grundstueck.nummer, 
		         liegenschaften_grundstueck.t_datasetname AS bfs_nr,
		         liegenschaften_liegenschaft.geometrie 
		 FROM agi_dm01avso24.liegenschaften_grundstueck 
		 LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft 
		     ON liegenschaften_liegenschaft.liegenschaft_von = liegenschaften_grundstueck.t_id
		) liegen,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_geogene_bodenbelastung
    WHERE
        ST_DWithin(schdstfflstt_bden_geogene_bodenbelastung.geometrie, liegen.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_geogene_bodenbelastung.t_id
), flurnamen AS (
    SELECT
        schdstfflstt_bden_geogene_bodenbelastung.t_id,
        string_agg(DISTINCT flurname.flurname, ', ' ORDER BY flurname.flurname) AS flurname
    FROM
        ( SELECT 
		     aname AS flurname, 
		     geometrie 
		 FROM 
		     agi_dm01avso24.nomenklatur_flurname
		 ) flurname,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_geogene_bodenbelastung
    WHERE
        ST_DWithin(schdstfflstt_bden_geogene_bodenbelastung.geometrie, flurname.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_geogene_bodenbelastung.t_id
)

SELECT
    schdstfflstt_bden_geogene_bodenbelastung.t_ili_tid,
    schdstfflstt_bden_geogene_bodenbelastung.geologische_einheit,
    schdstfflstt_bden_geogene_bodenbelastung.bezeichnung,
    schdstfflstt_bden_geogene_bodenbelastung.astatus,
    schdstfflstt_bden_geogene_bodenbelastung.aktiv,
    schdstfflstt_bden_geogene_bodenbelastung.erfassungsdatum,
    schdstfflstt_bden_geogene_bodenbelastung.datenerfasser,
    schdstfflstt_bden_geogene_bodenbelastung.begruendung_aus_vsb_entlassen,
    schdstfflstt_bden_geogene_bodenbelastung.datum_aus_vsb_entlassen,
    schdstfflstt_bden_geogene_bodenbelastung.bemerkung,
    schdstfflstt_bden_geogene_bodenbelastung.nutzungseinschraenkung,
	schdstfflstt_bden_geogene_bodenbelastung.nutzungsverbot,
    dokumente_json.dokumente,
    schadstoffe_json.schadstoffe,
    schdstfflstt_bden_geogene_bodenbelastung.geometrie,
    bfs_nummern.bfs_nummern AS bfs_gemeindenummern,
    gemeinden.gemeinden AS gemeindenamen,
    parzellennummern.grundbuchnummern,
    flurnamen.flurname AS flurnamen
    status.description AS status_txt,
    begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
FROM
    afu_schadstoffbelastete_boeden.schdstfflstt_bden_geogene_bodenbelastung
    LEFT JOIN dokumente_json
        ON dokumente_json.geogene_bodenbelastung = schdstfflstt_bden_geogene_bodenbelastung.t_id
    LEFT JOIN schadstoffe_json
        ON schadstoffe_json. geogene_bodenbelastung = schdstfflstt_bden_geogene_bodenbelastung.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = schdstfflstt_bden_geogene_bodenbelastung.t_id
    LEFT JOIN bfs_nummern
        ON bfs_nummern.t_id = schdstfflstt_bden_geogene_bodenbelastung.t_id
    LEFT JOIN parzellennummern
        ON parzellennummern.t_id = schdstfflstt_bden_geogene_bodenbelastung.t_id
    LEFT JOIN flurnamen
        ON flurnamen.t_id = schdstfflstt_bden_geogene_bodenbelastung.t_id
    LEFT JOIN afu_schadstoffbelastete_boeden.schadstoffbelasteter_boden_status status
        ON status.ilicode = schdstfflstt_bden_geogene_bodenbelastung.astatus
    LEFT JOIN afu_schadstoffbelastete_boeden.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen begruendung_vsb_entlassen
        ON begruendung_vsb_entlassen.ilicode = schdstfflstt_bden_geogene_bodenbelastung.begruendung_aus_vsb_entlassen
;

