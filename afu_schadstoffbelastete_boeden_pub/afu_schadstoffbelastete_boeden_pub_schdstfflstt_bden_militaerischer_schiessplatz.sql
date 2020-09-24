WITH dokumente AS (
    SELECT
        schdstfflstt_bden_dokument.t_id,
        schdstfflstt_bden_dokument.t_ili_tid,
        schdstfflstt_bden_dokument.dokumentname,
        schdstfflstt_bden_dokument.dateipfad,
        schdstfflstt_bden_militaerischer_schiessplatz.t_id AS militaerischer_schiessplatz
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument_militaerischer_schiessplatz
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_militaerischer_schiessplatz
            ON schdstfflstt_bden_militaerischer_schiessplatz.t_id = schdstfflstt_bden_dokument_militaerischer_schiessplatz.militaerischer_schiessplatz
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument
            ON schdstfflstt_bden_dokument.t_id = schdstfflstt_bden_dokument_militaerischer_schiessplatz.dokument
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
        militaerischer_schiessplatz
    FROM
        dokumente
    GROUP BY
        militaerischer_schiessplatz
), schadstoffe AS (
    SELECT
        schdstfflstt_bden_schadstoff.t_id,
        schdstfflstt_bden_schadstoff.t_ili_tid,
        schdstfflstt_bden_schadstoff.schadstoffname,
        schdstfflstt_bden_schadstoff.kuerzel,
        schdstfflstt_bden_militaerischer_schiessplatz.t_id AS militaerischer_schiessplatz
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff_militaerischer_schiessplatz
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_militaerischer_schiessplatz
            ON schdstfflstt_bden_militaerischer_schiessplatz.t_id = schdstfflstt_bden_schadstoff_militaerischer_schiessplatz.militaerischer_schiessplatz
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff
            ON schdstfflstt_bden_schadstoff.t_id = schdstfflstt_bden_schadstoff_militaerischer_schiessplatz.schadstoff
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
        militaerischer_schiessplatz
    FROM
        schadstoffe
    GROUP BY
        militaerischer_schiessplatz
), gemeinden AS (
    SELECT
        schdstfflstt_bden_militaerischer_schiessplatz.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_militaerischer_schiessplatz
    WHERE
        ST_DWithin(schdstfflstt_bden_militaerischer_schiessplatz.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_militaerischer_schiessplatz.t_id
), bfs_nummern AS (
    SELECT
        schdstfflstt_bden_militaerischer_schiessplatz.t_id,
        string_agg(DISTINCT CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar), ', ' ORDER BY CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar) ASC) AS bfs_nummern
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_militaerischer_schiessplatz
    WHERE
        ST_DWithin(schdstfflstt_bden_militaerischer_schiessplatz.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_militaerischer_schiessplatz.t_id
), parzellennummern AS (
    SELECT
        schdstfflstt_bden_militaerischer_schiessplatz.t_id,
        string_agg(DISTINCT liegen.nummer || '(' || liegen.bfs_nr|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.bfs_nr || ')') AS grundbuchnummern
    FROM
        (SELECT liegenschaften_grundstueck.nummer, 
		         liegenschaften_grundstueck.t_datasetname AS bfs_nr,
		         liegenschaften_liegenschaft.geometrie 
		 FROM agi_dm01avso24.liegenschaften_grundstueck 
		 LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft 
		     ON liegenschaften_liegenschaft.liegenschaft_von = liegenschaften_grundstueck.t_id
		) liegen,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_militaerischer_schiessplatz
    WHERE
        ST_DWithin(schdstfflstt_bden_militaerischer_schiessplatz.geometrie, liegen.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_militaerischer_schiessplatz.t_id
), flurnamen AS (
    SELECT
        schdstfflstt_bden_militaerischer_schiessplatz.t_id,
        string_agg(DISTINCT flurname.flurname, ', ' ORDER BY flurname.flurname) AS flurname
    FROM
        ( SELECT 
		     aname AS flurname, 
		     geometrie 
		 FROM 
		     agi_dm01avso24.nomenklatur_flurname
		 ) flurname,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_militaerischer_schiessplatz
    WHERE
        ST_DWithin(schdstfflstt_bden_militaerischer_schiessplatz.geometrie, flurname.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_militaerischer_schiessplatz.t_id
)

SELECT
    schdstfflstt_bden_militaerischer_schiessplatz.t_ili_tid,
    schdstfflstt_bden_militaerischer_schiessplatz.name_schiessanlage,
    schdstfflstt_bden_militaerischer_schiessplatz.baujahr,
    schdstfflstt_bden_militaerischer_schiessplatz.stilllegungsjahr,
    schdstfflstt_bden_militaerischer_schiessplatz.betriebsstatus,
    schdstfflstt_bden_militaerischer_schiessplatz.waffe,
    schdstfflstt_bden_militaerischer_schiessplatz.kbs_nummer_so,
    schdstfflstt_bden_militaerischer_schiessplatz.kbs_nummer_vbs,
    schdstfflstt_bden_militaerischer_schiessplatz.bezeichnung,
    schdstfflstt_bden_militaerischer_schiessplatz.astatus,
    schdstfflstt_bden_militaerischer_schiessplatz.aktiv,
    schdstfflstt_bden_militaerischer_schiessplatz.erfassungsdatum,
    schdstfflstt_bden_militaerischer_schiessplatz.datenerfasser,
    schdstfflstt_bden_militaerischer_schiessplatz.begruendung_aus_vsb_entlassen,
    schdstfflstt_bden_militaerischer_schiessplatz.datum_aus_vsb_entlassen,
    schdstfflstt_bden_militaerischer_schiessplatz.bemerkung,
    schdstfflstt_bden_militaerischer_schiessplatz.nutzungseinschraenkung,
	schdstfflstt_bden_militaerischer_schiessplatz.nutzungsverbot,
    dokumente_json.dokumente,
    schadstoffe_json.schadstoffe,
    schdstfflstt_bden_militaerischer_schiessplatz.geometrie,
    bfs_nummern.bfs_nummern AS bfs_gemeindenummern,
    gemeinden.gemeinden AS gemeindenamen,
    parzellennummern.grundbuchnummern,
    flurnamen.flurname AS flurnamen,
    schiessplatz_betriebsstatus.description AS betriebsstatus_txt,
    status.description AS status_txt,
    begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
FROM
    afu_schadstoffbelastete_boeden.schdstfflstt_bden_militaerischer_schiessplatz
    LEFT JOIN dokumente_json
        ON dokumente_json.militaerischer_schiessplatz = schdstfflstt_bden_militaerischer_schiessplatz.t_id
    LEFT JOIN schadstoffe_json
        ON schadstoffe_json.militaerischer_schiessplatz = schdstfflstt_bden_militaerischer_schiessplatz.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = schdstfflstt_bden_militaerischer_schiessplatz.t_id
    LEFT JOIN bfs_nummern
        ON bfs_nummern.t_id = schdstfflstt_bden_militaerischer_schiessplatz.t_id
    LEFT JOIN parzellennummern
        ON parzellennummern.t_id = schdstfflstt_bden_militaerischer_schiessplatz.t_id
    LEFT JOIN flurnamen
        ON flurnamen.t_id = schdstfflstt_bden_militaerischer_schiessplatz.t_id
    LEFT JOIN afu_schadstoffbelastete_boeden.schdstfstt_bden_militaerischer_schiessplatz_betriebsstatus schiessplatz_betriebsstatus
        ON schiessplatz_betriebsstatus.ilicode = schdstfflstt_bden_militaerischer_schiessplatz.betriebsstatus
    LEFT JOIN afu_schadstoffbelastete_boeden.schadstoffbelasteter_boden_status status
        ON status.ilicode = schdstfflstt_bden_militaerischer_schiessplatz.astatus
    LEFT JOIN afu_schadstoffbelastete_boeden.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen begruendung_vsb_entlassen
        ON begruendung_vsb_entlassen.ilicode = schdstfflstt_bden_militaerischer_schiessplatz.begruendung_aus_vsb_entlassen
;

