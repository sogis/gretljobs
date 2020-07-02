WITH dokumente AS (
    SELECT
        schdstfflstt_bden_dokument.t_id,
        schdstfflstt_bden_dokument.t_ili_tid,
        schdstfflstt_bden_dokument.dokumentname,
        schdstfflstt_bden_dokument.dateipfad,
        schdstfflstt_bden_siedlungsgebiet.t_id AS siedlungsgebiet
    FROM
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_dokument_siedlungsgebiet
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_siedlungsgebiet
            ON schdstfflstt_bden_siedlungsgebiet.t_id = schdstfflstt_bden_dokument_siedlungsgebiet.siedlungsgebiet
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_dokument
            ON schdstfflstt_bden_dokument.t_id = schdstfflstt_bden_dokument_siedlungsgebiet.dokument
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
        siedlungsgebiet
    FROM
        dokumente
    GROUP BY
        siedlungsgebiet
), schadstoffe AS (
    SELECT
        schdstfflstt_bden_schadstoff.t_id,
        schdstfflstt_bden_schadstoff.t_ili_tid,
        schdstfflstt_bden_schadstoff.schadstoffname,
        schdstfflstt_bden_schadstoff.kuerzel,
        schdstfflstt_bden_siedlungsgebiet.t_id AS siedlungsgebiet
    FROM
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff_siedlungsgebiet
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_siedlungsgebiet
            ON schdstfflstt_bden_siedlungsgebiet.t_id = schdstfflstt_bden_schadstoff_siedlungsgebiet.siedlungsgebiet
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff
            ON schdstfflstt_bden_schadstoff.t_id = schdstfflstt_bden_schadstoff_siedlungsgebiet.schadstoff
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
        siedlungsgebiet
    FROM
        schadstoffe
    GROUP BY
        siedlungsgebiet
), gemeinden AS (
    SELECT
        schdstfflstt_bden_siedlungsgebiet.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_siedlungsgebiet
    WHERE
        ST_DWithin(schdstfflstt_bden_siedlungsgebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_siedlungsgebiet.t_id
), bfs_nummern AS (
    SELECT
        schdstfflstt_bden_siedlungsgebiet.t_id,
        string_agg(DISTINCT CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar), ', ' ORDER BY CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar) ASC) AS bfs_nummern
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_siedlungsgebiet
    WHERE
        ST_DWithin(schdstfflstt_bden_siedlungsgebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_siedlungsgebiet.t_id
), parzellennummern AS (
    SELECT
        schdstfflstt_bden_siedlungsgebiet.t_id,
       string_agg(DISTINCT liegen.nummer || '(' || liegen.bfs_nr|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.bfs_nr || ')') AS grundbuchnummern
    FROM
        agi_mopublic_pub.mopublic_grundstueck liegen,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_siedlungsgebiet
    WHERE
        ST_DWithin(schdstfflstt_bden_siedlungsgebiet.geometrie, liegen.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_siedlungsgebiet.t_id
), flurnamen AS (
    SELECT
        schdstfflstt_bden_siedlungsgebiet.t_id,
        string_agg(DISTINCT flurname.flurname, ', ' ORDER BY flurname.flurname) AS flurname
    FROM
        agi_mopublic_pub.mopublic_flurname AS flurname,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_siedlungsgebiet
    WHERE
        ST_DWithin(schdstfflstt_bden_siedlungsgebiet.geometrie, flurname.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_siedlungsgebiet.t_id
)

SELECT
    schdstfflstt_bden_siedlungsgebiet.t_ili_tid,
    schdstfflstt_bden_siedlungsgebiet.bezeichnung,
    schdstfflstt_bden_siedlungsgebiet.astatus,
    schdstfflstt_bden_siedlungsgebiet.aktiv,
    schdstfflstt_bden_siedlungsgebiet.erfassungsdatum,
    schdstfflstt_bden_siedlungsgebiet.datenerfasser,
    schdstfflstt_bden_siedlungsgebiet.begruendung_aus_vsb_entlassen,
    schdstfflstt_bden_siedlungsgebiet.datum_aus_vsb_entlassen,
    schdstfflstt_bden_siedlungsgebiet.bemerkung,
    schdstfflstt_bden_siedlungsgebiet.nutzungseinschraenkung,
    dokumente_json.dokumente,
    schadstoffe_json.schadstoffe,
    schdstfflstt_bden_siedlungsgebiet.geometrie,
    bfs_nummern.bfs_nummern AS bfs_gemeindenummern,
    gemeinden.gemeinden AS gemeindenamen,
    parzellennummern.grundbuchnummern,
    flurnamen.flurname AS flurnamen
FROM
    afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_siedlungsgebiet
    LEFT JOIN dokumente_json
        ON dokumente_json.siedlungsgebiet = schdstfflstt_bden_siedlungsgebiet.t_id
    LEFT JOIN schadstoffe_json
        ON schadstoffe_json.siedlungsgebiet = schdstfflstt_bden_siedlungsgebiet.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = schdstfflstt_bden_siedlungsgebiet.t_id
    LEFT JOIN bfs_nummern
        ON bfs_nummern.t_id = schdstfflstt_bden_siedlungsgebiet.t_id
    LEFT JOIN parzellennummern
        ON parzellennummern.t_id = schdstfflstt_bden_siedlungsgebiet.t_id
    LEFT JOIN flurnamen
        ON flurnamen.t_id = schdstfflstt_bden_siedlungsgebiet.t_id
;