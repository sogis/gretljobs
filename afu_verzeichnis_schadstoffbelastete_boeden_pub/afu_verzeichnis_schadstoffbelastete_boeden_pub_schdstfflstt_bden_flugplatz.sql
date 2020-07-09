WITH dokumente AS (
    SELECT
        schdstfflstt_bden_dokument.t_id,
        schdstfflstt_bden_dokument.t_ili_tid,
        schdstfflstt_bden_dokument.dokumentname,
        schdstfflstt_bden_dokument.dateipfad,
        schdstfflstt_bden_flugplatz.t_id AS flugplatz
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument_flugplatz
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_flugplatz
            ON schdstfflstt_bden_flugplatz.t_id = schdstfflstt_bden_dokument_flugplatz.flugplatz
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument
            ON schdstfflstt_bden_dokument.t_id = schdstfflstt_bden_dokument_flugplatz.dokument
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
        flugplatz
    FROM
        dokumente
    GROUP BY
        flugplatz
), schadstoffe AS (
    SELECT
        schdstfflstt_bden_schadstoff.t_id,
        schdstfflstt_bden_schadstoff.t_ili_tid,
        schdstfflstt_bden_schadstoff.schadstoffname,
        schdstfflstt_bden_schadstoff.kuerzel,
        schdstfflstt_bden_flugplatz.t_id AS flugplatz
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff_flugplatz
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_flugplatz
            ON schdstfflstt_bden_flugplatz.t_id = schdstfflstt_bden_schadstoff_flugplatz.flugplatz
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff
            ON schdstfflstt_bden_schadstoff.t_id = schdstfflstt_bden_schadstoff_flugplatz.schadstoff
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
        flugplatz
    FROM
        schadstoffe
    GROUP BY
        flugplatz
), gemeinden AS (
    SELECT
        schdstfflstt_bden_flugplatz.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_flugplatz
    WHERE
        ST_DWithin(schdstfflstt_bden_flugplatz.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_flugplatz.t_id
), bfs_nummern AS (
    SELECT
        schdstfflstt_bden_flugplatz.t_id,
        string_agg(DISTINCT CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar), ', ' ORDER BY CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar) ASC) AS bfs_nummern
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_flugplatz
    WHERE
        ST_DWithin(schdstfflstt_bden_flugplatz.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_flugplatz.t_id
), parzellennummern AS (
    SELECT
        schdstfflstt_bden_flugplatz.t_id,
        string_agg(DISTINCT liegen.nummer || '(' || liegen.bfs_nr|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.bfs_nr || ')') AS grundbuchnummern
    FROM
        (SELECT liegenschaften_grundstueck.nummer, 
		         liegenschaften_grundstueck.t_datasetname AS bfs_nr,
		         liegenschaften_liegenschaft.geometrie 
		 FROM agi_dm01avso24.liegenschaften_grundstueck 
		 LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft 
		     ON liegenschaften_liegenschaft.liegenschaft_von = liegenschaften_grundstueck.t_id
		) liegen,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_flugplatz
    WHERE
        ST_DWithin(schdstfflstt_bden_flugplatz.geometrie, liegen.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_flugplatz.t_id
), flurnamen AS (
    SELECT
        schdstfflstt_bden_flugplatz.t_id,
        string_agg(DISTINCT flurname.flurname, ', ' ORDER BY flurname.flurname) AS flurname
    FROM
        ( SELECT 
		     aname AS flurname, 
		     geometrie 
		 FROM 
		     agi_dm01avso24.nomenklatur_flurname
		 ) flurname,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_flugplatz
    WHERE
        ST_DWithin(schdstfflstt_bden_flugplatz.geometrie, flurname.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_flugplatz.t_id
)

SELECT
    schdstfflstt_bden_flugplatz.t_ili_tid,
    schdstfflstt_bden_flugplatz.flugplatzname,
    schdstfflstt_bden_flugplatz.bezeichnung,
    schdstfflstt_bden_flugplatz.astatus,
    schdstfflstt_bden_flugplatz.aktiv,
    schdstfflstt_bden_flugplatz.erfassungsdatum,
    schdstfflstt_bden_flugplatz.datenerfasser,
    schdstfflstt_bden_flugplatz.begruendung_aus_vsb_entlassen,
    schdstfflstt_bden_flugplatz.datum_aus_vsb_entlassen,
    schdstfflstt_bden_flugplatz.bemerkung,
    schdstfflstt_bden_flugplatz.nutzungseinschraenkung,
    schdstfflstt_bden_flugplatz.nutzungsverbot,
    dokumente_json.dokumente,
    schadstoffe_json.schadstoffe,
    schdstfflstt_bden_flugplatz.geometrie,
    bfs_nummern.bfs_nummern AS bfs_gemeindenummern,
    gemeinden.gemeinden AS gemeindenamen,
    parzellennummern.grundbuchnummern,
    flurnamen.flurname AS flurnamen,
    status.description AS status_txt,
    begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
FROM
    afu_schadstoffbelastete_boeden.schdstfflstt_bden_flugplatz
    LEFT JOIN dokumente_json
        ON dokumente_json.flugplatz = schdstfflstt_bden_flugplatz.t_id
    LEFT JOIN schadstoffe_json
        ON schadstoffe_json.flugplatz = schdstfflstt_bden_flugplatz.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = schdstfflstt_bden_flugplatz.t_id
    LEFT JOIN bfs_nummern
        ON bfs_nummern.t_id = schdstfflstt_bden_flugplatz.t_id
    LEFT JOIN parzellennummern
        ON parzellennummern.t_id = schdstfflstt_bden_flugplatz.t_id
    LEFT JOIN flurnamen
        ON flurnamen.t_id = schdstfflstt_bden_flugplatz.t_id
    LEFT JOIN afu_schadstoffbelastete_boeden.schadstoffbelasteter_boden_status status
        ON status.ilicode = schdstfflstt_bden_flugplatz.astatus
    LEFT JOIN afu_schadstoffbelastete_boeden.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen begruendung_vsb_entlassen
        ON begruendung_vsb_entlassen.ilicode = schdstfflstt_bden_flugplatz.begruendung_aus_vsb_entlassen
;
