WITH dokumente AS (
    SELECT
        schdstfflstt_bden_dokument.t_id,
        schdstfflstt_bden_dokument.t_ili_tid,
        schdstfflstt_bden_dokument.dokumentname,
        schdstfflstt_bden_dokument.dateipfad,
        schdstfflstt_bden_stahlbruecke.t_id AS stahlbruecke
    FROM
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_dokument_stahlbruecke
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_stahlbruecke
            ON schdstfflstt_bden_stahlbruecke.t_id = schdstfflstt_bden_dokument_stahlbruecke.stahlbruecke
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_dokument
            ON schdstfflstt_bden_dokument.t_id = schdstfflstt_bden_dokument_stahlbruecke.dokument
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
        stahlbruecke
    FROM
        dokumente
    GROUP BY
        stahlbruecke
), schadstoffe AS (
    SELECT
        schdstfflstt_bden_schadstoff.t_id,
        schdstfflstt_bden_schadstoff.t_ili_tid,
        schdstfflstt_bden_schadstoff.schadstoffname,
        schdstfflstt_bden_schadstoff.kuerzel,
        schdstfflstt_bden_stahlbruecke.t_id AS stahlbruecke
    FROM
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff_stahlbruecke
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_stahlbruecke
            ON schdstfflstt_bden_stahlbruecke.t_id = schdstfflstt_bden_schadstoff_stahlbruecke.stahlbruecke
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff
            ON schdstfflstt_bden_schadstoff.t_id = schdstfflstt_bden_schadstoff_stahlbruecke.schadstoff
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
        stahlbruecke
    FROM
        schadstoffe
    GROUP BY
        stahlbruecke
), gemeinden AS (
    SELECT
        schdstfflstt_bden_stahlbruecke.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_stahlbruecke
    WHERE
        ST_DWithin(schdstfflstt_bden_stahlbruecke.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_stahlbruecke.t_id
), bfs_nummern AS (
    SELECT
        schdstfflstt_bden_stahlbruecke.t_id,
        string_agg(DISTINCT CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar), ', ' ORDER BY CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar) ASC) AS bfs_nummern
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_stahlbruecke
    WHERE
        ST_DWithin(schdstfflstt_bden_stahlbruecke.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_stahlbruecke.t_id
), parzellennummern AS (
    SELECT
        schdstfflstt_bden_stahlbruecke.t_id,
      string_agg(DISTINCT liegen.nummer || '(' || liegen.bfs_nr|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.bfs_nr || ')') AS grundbuchnummern
    FROM
        agi_mopublic_pub.mopublic_grundstueck liegen,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_stahlbruecke
    WHERE
        ST_DWithin(schdstfflstt_bden_stahlbruecke.geometrie, liegen.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_stahlbruecke.t_id
), flurnamen AS (
    SELECT
        schdstfflstt_bden_stahlbruecke.t_id,
       string_agg(DISTINCT flurname.flurname, ', ' ORDER BY flurname.flurname) AS flurname
    FROM
        agi_mopublic_pub.mopublic_flurname AS flurname,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_stahlbruecke
    WHERE
        ST_DWithin(schdstfflstt_bden_stahlbruecke.geometrie, flurname.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_stahlbruecke.t_id
)

SELECT
    schdstfflstt_bden_stahlbruecke.t_ili_tid,
    schdstfflstt_bden_stahlbruecke.brueckenname,
    schdstfflstt_bden_stahlbruecke.eigentuemer,
    schdstfflstt_bden_stahlbruecke.brueckentyp,
    schdstfflstt_bden_stahlbruecke.betriebsstatus,
    schdstfflstt_bden_stahlbruecke.bezeichnung,
    schdstfflstt_bden_stahlbruecke.astatus,
    schdstfflstt_bden_stahlbruecke.aktiv,
    schdstfflstt_bden_stahlbruecke.erfassungsdatum,
    schdstfflstt_bden_stahlbruecke.datenerfasser,
    schdstfflstt_bden_stahlbruecke.begruendung_aus_vsb_entlassen,
    schdstfflstt_bden_stahlbruecke.datum_aus_vsb_entlassen,
    schdstfflstt_bden_stahlbruecke.bemerkung,
    schdstfflstt_bden_stahlbruecke.nutzungseinschraenkung,
    schdstfflstt_bden_stahlbruecke.nutzungsverbot,
    dokumente_json.dokumente,
    schadstoffe_json.schadstoffe,
    schdstfflstt_bden_stahlbruecke.geometrie,
    bfs_nummern.bfs_nummern AS bfs_gemeindenummern,
    gemeinden.gemeinden AS gemeindenamen,
    parzellennummern.grundbuchnummern,
    flurnamen.flurname AS flurnamen
FROM
    afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_stahlbruecke
    LEFT JOIN dokumente_json
        ON dokumente_json.stahlbruecke = schdstfflstt_bden_stahlbruecke.t_id
    LEFT JOIN schadstoffe_json
        ON schadstoffe_json.stahlbruecke = schdstfflstt_bden_stahlbruecke.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = schdstfflstt_bden_stahlbruecke.t_id
    LEFT JOIN bfs_nummern
        ON bfs_nummern.t_id = schdstfflstt_bden_stahlbruecke.t_id
    LEFT JOIN parzellennummern
        ON parzellennummern.t_id = schdstfflstt_bden_stahlbruecke.t_id
    LEFT JOIN flurnamen
        ON flurnamen.t_id = schdstfflstt_bden_stahlbruecke.t_id
;