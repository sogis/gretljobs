WITH dokumente AS (
    SELECT
        schdstfflstt_bden_dokument.t_id,
        schdstfflstt_bden_dokument.t_ili_tid,
        schdstfflstt_bden_dokument.dokumentname,
        schdstfflstt_bden_dokument.dateipfad,
        schdstfflstt_bden_anbaugebiet.t_id AS anbaugebiet
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument_anbaugebiet
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_anbaugebiet
            ON schdstfflstt_bden_anbaugebiet.t_id = schdstfflstt_bden_dokument_anbaugebiet.anbaugebiet
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument
            ON schdstfflstt_bden_dokument.t_id = schdstfflstt_bden_dokument_anbaugebiet.dokument
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
        anbaugebiet
    FROM
        dokumente
    GROUP BY
        anbaugebiet
), schadstoffe AS (
    SELECT
        schdstfflstt_bden_schadstoff.t_id,
        schdstfflstt_bden_schadstoff.t_ili_tid,
        schdstfflstt_bden_schadstoff.schadstoffname,
        schdstfflstt_bden_schadstoff.kuerzel,
        schdstfflstt_bden_anbaugebiet.t_id AS anbaugebiet
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff_anbaugebiet
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_anbaugebiet
            ON schdstfflstt_bden_anbaugebiet.t_id = schdstfflstt_bden_schadstoff_anbaugebiet.anbaugebiet
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff
            ON schdstfflstt_bden_schadstoff.t_id = schdstfflstt_bden_schadstoff_anbaugebiet.schadstoff
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
        anbaugebiet
    FROM
        schadstoffe
    GROUP BY
        anbaugebiet
), gemeinden AS (
    SELECT
        schdstfflstt_bden_anbaugebiet.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_anbaugebiet
    WHERE
        schdstfflstt_bden_anbaugebiet.geometrie && hoheitsgrenzen_gemeindegrenze.geometrie
        AND
        ST_DWithin(schdstfflstt_bden_anbaugebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_anbaugebiet.t_id
), bfs_nummern AS (
    SELECT
        schdstfflstt_bden_anbaugebiet.t_id,
        string_agg(DISTINCT CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar), ', ' ORDER BY CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar) ASC) AS bfs_nummern
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_anbaugebiet
    WHERE
        schdstfflstt_bden_anbaugebiet.geometrie && hoheitsgrenzen_gemeindegrenze.geometrie
        AND 
        ST_DWithin(schdstfflstt_bden_anbaugebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_anbaugebiet.t_id
), parzellennummern AS (
    SELECT
        schdstfflstt_bden_anbaugebiet.t_id,
        string_agg(DISTINCT liegen.nummer || '(' || liegen.bfs_nr|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.bfs_nr || ')') AS grundbuchnummern
    FROM
        (SELECT liegenschaften_grundstueck.nummer, 
		         liegenschaften_grundstueck.t_datasetname AS bfs_nr,
		         liegenschaften_liegenschaft.geometrie 
		 FROM agi_dm01avso24.liegenschaften_grundstueck 
		 LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft 
		     ON liegenschaften_liegenschaft.liegenschaft_von = liegenschaften_grundstueck.t_id
		) liegen,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_anbaugebiet
    WHERE
        schdstfflstt_bden_anbaugebiet.geometrie && liegen.geometrie
        AND 
        ST_DWithin(schdstfflstt_bden_anbaugebiet.geometrie, liegen.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_anbaugebiet.t_id
), flurnamen AS (
    SELECT
        schdstfflstt_bden_anbaugebiet.t_id,
        string_agg(DISTINCT flurname.flurname, ', ' ORDER BY flurname.flurname) AS flurname
    FROM
        ( SELECT 
		     aname AS flurname, 
		     geometrie 
		 FROM 
		     agi_dm01avso24.nomenklatur_flurname
		 ) flurname,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_anbaugebiet
    WHERE
        schdstfflstt_bden_anbaugebiet.geometrie && flurname.geometrie
        AND
        ST_DWithin(schdstfflstt_bden_anbaugebiet.geometrie, flurname.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_anbaugebiet.t_id
)

SELECT
    schdstfflstt_bden_anbaugebiet.t_ili_tid,
    schdstfflstt_bden_anbaugebiet.nutzungsbeginn,
    schdstfflstt_bden_anbaugebiet.nutzungsende,
    schdstfflstt_bden_anbaugebiet.geometrie,
    dokumente_json.dokumente,
    schadstoffe_json.schadstoffe,
    schdstfflstt_bden_anbaugebiet.bezeichnung,
    schdstfflstt_bden_anbaugebiet.astatus,
    schdstfflstt_bden_anbaugebiet.aktiv,
    schdstfflstt_bden_anbaugebiet.erfassungsdatum,
    schdstfflstt_bden_anbaugebiet.datenerfasser,
    schdstfflstt_bden_anbaugebiet.begruendung_aus_vsb_entlassen,
    schdstfflstt_bden_anbaugebiet.datum_aus_vsb_entlassen,
    schdstfflstt_bden_anbaugebiet.bemerkung,
    schdstfflstt_bden_anbaugebiet.nutzungseinschraenkung,
    bfs_nummern.bfs_nummern AS bfs_gemeindenummern,
    gemeinden.gemeinden AS gemeindenamen,
    parzellennummern.grundbuchnummern,
    flurnamen.flurname AS flurnamen, 
    schdstfflstt_bden_anbaugebiet.nutzungsverbot
FROM
    afu_schadstoffbelastete_boeden.schdstfflstt_bden_anbaugebiet
    LEFT JOIN dokumente_json
        ON dokumente_json.anbaugebiet = schdstfflstt_bden_anbaugebiet.t_id
    LEFT JOIN schadstoffe_json
        ON schadstoffe_json.anbaugebiet = schdstfflstt_bden_anbaugebiet.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = schdstfflstt_bden_anbaugebiet.t_id
    LEFT JOIN bfs_nummern
        ON bfs_nummern.t_id = schdstfflstt_bden_anbaugebiet.t_id
    LEFT JOIN parzellennummern
        ON parzellennummern.t_id = schdstfflstt_bden_anbaugebiet.t_id
    LEFT JOIN flurnamen
        ON flurnamen.t_id = schdstfflstt_bden_anbaugebiet.t_id
WHERE anbautyp = 'Hopfenbau'

;
