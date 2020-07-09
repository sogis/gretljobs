WITH dokumente AS (
    SELECT
        schdstfflstt_bden_dokument.t_id,
        schdstfflstt_bden_dokument.t_ili_tid,
        schdstfflstt_bden_dokument.dokumentname,
        schdstfflstt_bden_dokument.dateipfad,
        schdstfflstt_bden_schiessanlage.t_id AS schiessanlage
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument_schiessanlage
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_schiessanlage
            ON schdstfflstt_bden_schiessanlage.t_id = schdstfflstt_bden_dokument_schiessanlage.schiessanlage
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument
            ON schdstfflstt_bden_dokument.t_id = schdstfflstt_bden_dokument_schiessanlage.dokument
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
        schiessanlage
    FROM
        dokumente
    GROUP BY
        schiessanlage
), schadstoffe AS (
    SELECT
        schdstfflstt_bden_schadstoff.t_id,
        schdstfflstt_bden_schadstoff.t_ili_tid,
        schdstfflstt_bden_schadstoff.schadstoffname,
        schdstfflstt_bden_schadstoff.kuerzel,
        schdstfflstt_bden_schiessanlage.t_id AS schiessanlage
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff_schiessanlage
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_schiessanlage
            ON schdstfflstt_bden_schiessanlage.t_id = schdstfflstt_bden_schadstoff_schiessanlage.schiessanlage
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff
            ON schdstfflstt_bden_schadstoff.t_id = schdstfflstt_bden_schadstoff_schiessanlage.schadstoff
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
        schiessanlage
    FROM
        schadstoffe
    GROUP BY
        schiessanlage
), schiessanlagentyp AS (
    SELECT
        schdstfflstt_bden_schiessanlagentyp.typ,
        schdstfflstt_bden_schiessanlagentyp.schiessdistanz,
        schdstfflstt_bden_schiessanlage.t_id AS schiessanlage
    FROM afu_schadstoffbelastete_boeden.schdstfflstt_bden_schiessanlage_schiessanlagentyp
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_schiessanlage
            ON schdstfflstt_bden_schiessanlage_schiessanlagentyp.schiessanlage = schdstfflstt_bden_schiessanlage.t_id
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_schiessanlagentyp
            ON schdstfflstt_bden_schiessanlage_schiessanlagentyp.schiessanlagentyp = schdstfflstt_bden_schiessanlagentyp.t_id
), schiessanlagentyp_json AS (
    SELECT
        array_to_json(
            array_agg(
                row_to_json((
                    SELECT
                        typen
                    FROM 
                        (
                            SELECT
                                typ,
                                schiessdistanz
                        ) typen
                ))
            )
        ) AS schiessanlagentypen,
        schiessanlage
    FROM
        schiessanlagentyp
    GROUP BY
        schiessanlage
), gemeinden AS (
    SELECT
        schdstfflstt_bden_schiessanlage.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_schiessanlage
    WHERE
        ST_DWithin(schdstfflstt_bden_schiessanlage.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_schiessanlage.t_id
), bfs_nummern AS (
    SELECT
        schdstfflstt_bden_schiessanlage.t_id,
        string_agg(DISTINCT CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar), ', ' ORDER BY CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar) ASC) AS bfs_nummern
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_schiessanlage
    WHERE
        ST_DWithin(schdstfflstt_bden_schiessanlage.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_schiessanlage.t_id
), parzellennummern AS (
    SELECT
        schdstfflstt_bden_schiessanlage.t_id,
       string_agg(DISTINCT liegen.nummer || '(' || liegen.bfs_nr|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.bfs_nr || ')') AS grundbuchnummern
    FROM
        (SELECT liegenschaften_grundstueck.nummer, 
		         liegenschaften_grundstueck.t_datasetname AS bfs_nr,
		         liegenschaften_liegenschaft.geometrie 
		 FROM agi_dm01avso24.liegenschaften_grundstueck 
		 LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft 
		     ON liegenschaften_liegenschaft.liegenschaft_von = liegenschaften_grundstueck.t_id
		) liegen,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_schiessanlage
    WHERE
        ST_DWithin(schdstfflstt_bden_schiessanlage.geometrie, liegen.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_schiessanlage.t_id
), flurnamen AS (
    SELECT
        schdstfflstt_bden_schiessanlage.t_id,
       string_agg(DISTINCT flurname.flurname, ', ' ORDER BY flurname.flurname) AS flurname
    FROM
        ( SELECT 
		     aname AS flurname, 
		     geometrie 
		 FROM 
		     agi_dm01avso24.nomenklatur_flurname
		 ) flurname,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_schiessanlage
    WHERE
        ST_DWithin(schdstfflstt_bden_schiessanlage.geometrie, flurname.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_schiessanlage.t_id
)

SELECT
    schdstfflstt_bden_schiessanlage.t_ili_tid,
    schdstfflstt_bden_schiessanlage.trennkriterium,
    schdstfflstt_bden_schiessanlage.schiessanlagename AS name_schiessanlage,
    schdstfflstt_bden_schiessanlage.baujahr,
    schdstfflstt_bden_schiessanlage.scheibenanzahl,
    schdstfflstt_bden_schiessanlage.schusszahl_jahr,
    schdstfflstt_bden_schiessanlage.lage,
    schdstfflstt_bden_schiessanlage.betriebsstatus,
    schdstfflstt_bden_schiessanlage.kbs_nummer,
    schdstfflstt_bden_schiessanlage.sanierungsstatus,
    schiessanlagentyp_json.schiessanlagentypen,
    schdstfflstt_bden_schiessanlage.bezeichnung,
    schdstfflstt_bden_schiessanlage.astatus,
    schdstfflstt_bden_schiessanlage.aktiv,
    schdstfflstt_bden_schiessanlage.erfassungsdatum,
    schdstfflstt_bden_schiessanlage.datenerfasser,
    schdstfflstt_bden_schiessanlage.begruendung_aus_vsb_entlassen,
    schdstfflstt_bden_schiessanlage.datum_aus_vsb_entlassen,
    schdstfflstt_bden_schiessanlage.bemerkung,
    schdstfflstt_bden_schiessanlage.nutzungseinschraenkung,
    schdstfflstt_bden_schiessanlage.nutzungsverbot,
    dokumente_json.dokumente,
    schadstoffe_json.schadstoffe,
    schdstfflstt_bden_schiessanlage.geometrie,
    bfs_nummern.bfs_nummern AS bfs_gemeindenummern,
    gemeinden.gemeinden AS gemeindenamen,
    parzellennummern.grundbuchnummern,
    flurnamen.flurname AS flurnamen,
    schiessanlage_trennkriterium.dispname AS trennkriterium_txt,
    lage.aname AS lage_txt,
    schiessanlage_sanierungsstatus.dispname AS sanierungsstatus_txt,
    status.description AS status_txt,
    begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt
FROM
    afu_schadstoffbelastete_boeden.schdstfflstt_bden_schiessanlage
    LEFT JOIN dokumente_json
        ON dokumente_json.schiessanlage = schdstfflstt_bden_schiessanlage.t_id
    LEFT JOIN schadstoffe_json
        ON schadstoffe_json.schiessanlage = schdstfflstt_bden_schiessanlage.t_id
    LEFT JOIN schiessanlagentyp_json
        ON schiessanlagentyp_json.schiessanlage = schdstfflstt_bden_schiessanlage.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = schdstfflstt_bden_schiessanlage.t_id
    LEFT JOIN bfs_nummern
        ON bfs_nummern.t_id = schdstfflstt_bden_schiessanlage.t_id
    LEFT JOIN parzellennummern
        ON parzellennummern.t_id = schdstfflstt_bden_schiessanlage.t_id
    LEFT JOIN flurnamen
        ON flurnamen.t_id = schdstfflstt_bden_schiessanlage.t_id
    LEFT JOIN afu_schadstoffbelastete_boeden.schdstfstt_bden_schiessanlage_trennkriterium schiessanlage_trennkriterium
        ON schiessanlage_trennkriterium.ilicode = schdstfflstt_bden_schiessanlage.trennkriterium
    LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_lage lage
        ON lage.t_id = schdstfflstt_bden_schiessanlage.lage
    LEFT JOIN afu_schadstoffbelastete_boeden.schdstfstt_bden_schiessanlage_sanierungsstatus schiessanlage_sanierungsstatus
        ON schiessanlage_sanierungsstatus.ilicode = schdstfflstt_bden_schiessanlage.sanierungsstatus
    LEFT JOIN afu_schadstoffbelastete_boeden.schadstoffbelasteter_boden_status status
        ON status.ilicode = schdstfflstt_bden_schiessanlage.astatus
    LEFT JOIN afu_schadstoffbelastete_boeden.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen begruendung_vsb_entlassen
        ON begruendung_vsb_entlassen.ilicode = schdstfflstt_bden_schiessanlage.begruendung_aus_vsb_entlassen
;
