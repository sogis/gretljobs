WITH dokumente AS (
    SELECT
        schdstfflstt_bden_dokument.t_id,
        schdstfflstt_bden_dokument.t_ili_tid,
        schdstfflstt_bden_dokument.dokumentname,
        schdstfflstt_bden_dokument.dateipfad,
        schdstfflstt_bden_bodenbelastungsgebiet.t_id AS bodenbelastungsgebiet
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument_bodenbelastungsflaeche
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_bodenbelastungsgebiet
            ON schdstfflstt_bden_bodenbelastungsgebiet.t_id = schdstfflstt_bden_dokument_bodenbelastungsflaeche.bodenbelastungsflaeche
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_dokument
            ON schdstfflstt_bden_dokument.t_id = schdstfflstt_bden_dokument_bodenbelastungsflaeche.dokument
), dokumente_json AS (
    SELECT
        array_to_json(
            array_agg(
                row_to_json((
                    SELECT
                        docs
                    FROM 
                        (
                            select
                                'SO_AFU_Verzeichnis_schadstoffbelastete_Boeden_Publikation_20200701.Dokument' as "@type",
                                dokumentname as "Name",
                                dateipfad as "URL"
                        ) docs
                ))
            )
        ) AS dokumente,
        bodenbelastungsgebiet
    FROM
        dokumente
    GROUP BY
        bodenbelastungsgebiet
), schadstoffe AS (
    SELECT
        schdstfflstt_bden_schadstoff.t_id,
        schdstfflstt_bden_schadstoff.t_ili_tid,
        schdstfflstt_bden_schadstoff.schadstoffname,
        schdstfflstt_bden_schadstoff.kuerzel,
        schdstfflstt_bden_bodenbelastungsgebiet.t_id AS bodenbelastungsgebiet
    FROM
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff_bodenbelastungsflaeche
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_bodenbelastungsgebiet
            ON schdstfflstt_bden_bodenbelastungsgebiet.t_id = schdstfflstt_bden_schadstoff_bodenbelastungsflaeche.bodenbelastungsflaeche
        LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_schadstoff
            ON schdstfflstt_bden_schadstoff.t_id = schdstfflstt_bden_schadstoff_bodenbelastungsflaeche.schadstoff
), schadstoffe_json AS (
    SELECT
        array_to_json(
            array_agg(
                row_to_json((
                    SELECT
                        schadstoffe
                    FROM 
                        (
                            select
                                'SO_AFU_Verzeichnis_schadstoffbelastete_Boeden_Publikation_20200701.Schadstoff' as "@type",
                                schadstoffname AS "Schadstoffname",
                                kuerzel AS "Kuerzel"
                        ) schadstoffe
                ))
            )
        ) AS schadstoffe,
        bodenbelastungsgebiet
    FROM
        schadstoffe
    GROUP BY
        bodenbelastungsgebiet
), gemeinden AS (
    SELECT
        schdstfflstt_bden_bodenbelastungsgebiet.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_bodenbelastungsgebiet
    WHERE
        ST_DWithin(schdstfflstt_bden_bodenbelastungsgebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_bodenbelastungsgebiet.t_id
), bfs_nummern AS (
    SELECT
        schdstfflstt_bden_bodenbelastungsgebiet.t_id,
        string_agg(DISTINCT CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar), ', ' ORDER BY CAST(hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer AS varchar) ASC) AS bfs_nummern
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_bodenbelastungsgebiet
    WHERE
        ST_DWithin(schdstfflstt_bden_bodenbelastungsgebiet.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_bodenbelastungsgebiet.t_id
), parzellennummern AS (
    SELECT
        schdstfflstt_bden_bodenbelastungsgebiet.t_id,
        string_agg(DISTINCT liegen.nummer || '(' || liegen.bfs_nr|| ')', ', ' ORDER BY liegen.nummer || '(' || liegen.bfs_nr || ')') AS grundbuchnummern
    FROM
        (SELECT liegenschaften_grundstueck.nummer, 
		         liegenschaften_grundstueck.t_datasetname AS bfs_nr,
		         liegenschaften_liegenschaft.geometrie 
		 FROM agi_dm01avso24.liegenschaften_grundstueck 
		 LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft 
		     ON liegenschaften_liegenschaft.liegenschaft_von = liegenschaften_grundstueck.t_id
		) liegen,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_bodenbelastungsgebiet
    WHERE
        ST_DWithin(schdstfflstt_bden_bodenbelastungsgebiet.geometrie, liegen.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_bodenbelastungsgebiet.t_id
), flurnamen AS (
    SELECT
        schdstfflstt_bden_bodenbelastungsgebiet.t_id,
         string_agg(DISTINCT flurname.flurname, ', ' ORDER BY flurname.flurname) AS flurname
    FROM
        ( SELECT 
		     aname AS flurname, 
		     geometrie 
		 FROM 
		     agi_dm01avso24.nomenklatur_flurname
		 ) flurname,
        afu_schadstoffbelastete_boeden.schdstfflstt_bden_bodenbelastungsgebiet
    WHERE
        ST_DWithin(schdstfflstt_bden_bodenbelastungsgebiet.geometrie, flurname.geometrie, 0)
    GROUP BY
        schdstfflstt_bden_bodenbelastungsgebiet.t_id
)


SELECT
    schdstfflstt_bden_bodenbelastungsgebiet.t_ili_tid,
    schdstfflstt_bden_bodenbelastungsgebiet.verursacher,
    schdstfflstt_bden_bodenbelastungsgebiet.belastungsstufe,
    schdstfflstt_bden_bodenbelastungsgebiet.pruefwert,
    schdstfflstt_bden_bodenbelastungsgebiet.probenanzahl,
    schdstfflstt_bden_bodenbelastungsgebiet.grundbucheintrag,
    schdstfflstt_bden_bodenbelastungsgebiet.flaechentyp,
    dokumente_json.dokumente,
    schadstoffe_json.schadstoffe,
    schdstfflstt_bden_gebiet.gebietsname AS gebietsname,
    schdstfflstt_bden_bodenbelastungsgebiet.bezeichnung,
    schdstfflstt_bden_bodenbelastungsgebiet.astatus,
    schdstfflstt_bden_bodenbelastungsgebiet.aktiv,
    schdstfflstt_bden_bodenbelastungsgebiet.erfassungsdatum,
    schdstfflstt_bden_bodenbelastungsgebiet.datenerfasser,
    schdstfflstt_bden_bodenbelastungsgebiet.begruendung_aus_vsb_entlassen,
    schdstfflstt_bden_bodenbelastungsgebiet.datum_aus_vsb_entlassen,
    schdstfflstt_bden_bodenbelastungsgebiet.bemerkung,
    schdstfflstt_bden_bodenbelastungsgebiet.nutzungseinschraenkung,
    schdstfflstt_bden_bodenbelastungsgebiet.nutzungsverbot,
    schdstfflstt_bden_bodenbelastungsgebiet.geometrie,
    bfs_nummern.bfs_nummern AS bfs_gemeindenummern,
    gemeinden.gemeinden AS gemeindenamen,
    parzellennummern.grundbuchnummern,
    flurnamen.flurname AS flurnamen,
    belastungsstufe.description AS belastungsstufe_txt,
    status.description AS status_txt,
    begruendung_vsb_entlassen.description AS begruendung_aus_vsb_entlassen_txt,
    flaechentyp.description AS flaechentyp_txt,
    verursacher.description AS verursacher_txt
FROM
    afu_schadstoffbelastete_boeden.schdstfflstt_bden_bodenbelastungsgebiet
    LEFT JOIN afu_schadstoffbelastete_boeden.schdstfflstt_bden_gebiet
        ON schdstfflstt_bden_bodenbelastungsgebiet.bodenbelastungsgebiet = schdstfflstt_bden_gebiet.t_id
    LEFT JOIN dokumente_json
        ON dokumente_json.bodenbelastungsgebiet = schdstfflstt_bden_bodenbelastungsgebiet.t_id
    LEFT JOIN schadstoffe_json
        ON schadstoffe_json.bodenbelastungsgebiet = schdstfflstt_bden_bodenbelastungsgebiet.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = schdstfflstt_bden_bodenbelastungsgebiet.t_id
    LEFT JOIN bfs_nummern
        ON bfs_nummern.t_id = schdstfflstt_bden_bodenbelastungsgebiet.t_id
    LEFT JOIN parzellennummern
        ON parzellennummern.t_id = schdstfflstt_bden_bodenbelastungsgebiet.t_id
    LEFT JOIN flurnamen
        ON flurnamen.t_id = schdstfflstt_bden_bodenbelastungsgebiet.t_id
    LEFT JOIN afu_schadstoffbelastete_boeden.schdstfstt_bden_bodenbelastungsgebiet_belastungsstufe AS belastungsstufe
        ON belastungsstufe.ilicode = schdstfflstt_bden_bodenbelastungsgebiet.belastungsstufe
    LEFT JOIN afu_schadstoffbelastete_boeden.schadstoffbelasteter_boden_status status
        ON status.ilicode = schdstfflstt_bden_bodenbelastungsgebiet.astatus
    LEFT JOIN afu_schadstoffbelastete_boeden.schadstoffbelasteter_boden_begruendung_aus_vsb_entlassen begruendung_vsb_entlassen
        ON begruendung_vsb_entlassen.ilicode = schdstfflstt_bden_bodenbelastungsgebiet.begruendung_aus_vsb_entlassen
    LEFT JOIN afu_schadstoffbelastete_boeden.schdstfstt_bden_eisenbahn_flaechentyp flaechentyp
        ON flaechentyp.ilicode = schdstfflstt_bden_bodenbelastungsgebiet.flaechentyp
    LEFT JOIN afu_schadstoffbelastete_boeden.schdstfstt_bden_bodenbelastungsgebiet_verursacher verursacher
        ON verursacher.ilicode = schdstfflstt_bden_bodenbelastungsgebiet.verursacher
