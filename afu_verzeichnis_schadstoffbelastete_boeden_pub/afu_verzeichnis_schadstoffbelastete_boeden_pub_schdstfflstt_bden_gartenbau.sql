WITH dokumente AS (
    SELECT
        schdstfflstt_bden_dokument.t_id,
        schdstfflstt_bden_dokument.t_ili_tid,
        schdstfflstt_bden_dokument.dokumentname,
        schdstfflstt_bden_dokument.dateipfad,
        schdstfflstt_bden_gartenbau.t_id AS gartenbau
    FROM
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_dokument_gartenbau
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_gartenbau
            ON schdstfflstt_bden_gartenbau.t_id = schdstfflstt_bden_dokument_gartenbau.gartenbau
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_dokument
            ON schdstfflstt_bden_dokument.t_id = schdstfflstt_bden_dokument_gartenbau.dokument
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
        gartenbau
    FROM
        dokumente
    GROUP BY
        gartenbau
), schadstoffe AS (
    SELECT
        schdstfflstt_bden_schadstoff.t_id,
        schdstfflstt_bden_schadstoff.t_ili_tid,
        schdstfflstt_bden_schadstoff.schadstoffname,
        schdstfflstt_bden_schadstoff.kuerzel,
        schdstfflstt_bden_gartenbau.t_id AS gartenbau
    FROM
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff_gartenbau
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_gartenbau
            ON schdstfflstt_bden_gartenbau.t_id = schdstfflstt_bden_schadstoff_gartenbau.gartenbau
        LEFT JOIN afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff
            ON schdstfflstt_bden_schadstoff.t_id = schdstfflstt_bden_schadstoff_gartenbau.schadstoff
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
        gartenbau
    FROM
        schadstoffe
    GROUP BY
        gartenbau
), gemeinden AS (
    SELECT
        schdstfflstt_bden_gartenbau.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_gartenbau
    WHERE
        ST_DWithin(schdstfflstt_bden_gartenbau.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_gartenbau.t_id
), bfs_nummern AS (
    SELECT
        schdstfflstt_bden_gartenbau.t_id,
        string_agg(DISTINCT CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar), ', ' ORDER BY CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar) ASC) AS bfs_nummern
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_gartenbau
    WHERE
        ST_DWithin(schdstfflstt_bden_gartenbau.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_gartenbau.t_id
), parzellennummern AS (
    SELECT
        schdstfflstt_bden_gartenbau.t_id,
        string_agg(DISTINCT liegen.nummer || '(' || liegen.gem_bfs|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.gem_bfs || ')') AS grundbuchnummern
    FROM
        avdpool.liegen,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_gartenbau
    WHERE
        ST_DWithin(schdstfflstt_bden_gartenbau.geometrie, liegen.wkb_geometry, 0)
        AND 
        liegen.ARCHIVE = 0
    GROUP BY
        schdstfflstt_bden_gartenbau.t_id
), flurnamen AS (
    SELECT
        schdstfflstt_bden_gartenbau.t_id,
        string_agg(DISTINCT flurname.name, ', ' ORDER BY flurname.name) AS flurname
    FROM
        av_avdpool_ng.nomenklatur_flurname AS flurname,
        afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_gartenbau
    WHERE
        ST_DWithin(schdstfflstt_bden_gartenbau.geometrie, flurname.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_gartenbau.t_id
)

SELECT
    schdstfflstt_bden_gartenbau.t_ili_tid,
    schdstfflstt_bden_gartenbau.objektname,
    schdstfflstt_bden_gartenbau.nutzungsbeginn,
    schdstfflstt_bden_gartenbau.nutzungsende,
    schdstfflstt_bden_gartenbau.flaechentyp,
    schdstfflstt_bden_gartenbau.bezeichnung,
    schdstfflstt_bden_gartenbau.status,
    schdstfflstt_bden_gartenbau.aktiv,
    schdstfflstt_bden_gartenbau.erfassungsdatum,
    schdstfflstt_bden_gartenbau.datenerfasser,
    schdstfflstt_bden_gartenbau.begruendung_inaktiv,
    schdstfflstt_bden_gartenbau.datum_inaktiv,
    schdstfflstt_bden_gartenbau.bemerkung,
    schdstfflstt_bden_gartenbau.nutzungseinschraenkung_verfuegt,
    dokumente_json.dokumente,
    schadstoffe_json.schadstoffe,
    schdstfflstt_bden_gartenbau.geometrie,
    bfs_nummern.bfs_nummern AS bfs_gemeindenummern,
    gemeinden.gemeinden AS gemeindenamen,
    parzellennummern.grundbuchnummern,
    flurnamen.flurname AS flurnamen
FROM
    afu_verzeichnis_schadstoffbelastete_boeden.schdstfflstt_bden_gartenbau
    LEFT JOIN dokumente_json
        ON dokumente_json.gartenbau = schdstfflstt_bden_gartenbau.t_id
    LEFT JOIN schadstoffe_json
        ON schadstoffe_json.gartenbau = schdstfflstt_bden_gartenbau.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = schdstfflstt_bden_gartenbau.t_id
    LEFT JOIN bfs_nummern
        ON bfs_nummern.t_id = schdstfflstt_bden_gartenbau.t_id
    LEFT JOIN parzellennummern
        ON parzellennummern.t_id = schdstfflstt_bden_gartenbau.t_id
    LEFT JOIN flurnamen
        ON flurnamen.t_id = schdstfflstt_bden_gartenbau.t_id
;