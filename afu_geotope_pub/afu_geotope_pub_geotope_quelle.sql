WITH fachbereich AS (
    SELECT 
        string_agg(geotope_fachbereich.fachbereichsname, ', ' ORDER BY fachbereichsname ASC) AS fachbereiche,
        geotope_quelle.t_id
    FROM
        afu_geotope.geotope_quelle_fachbereich
        LEFT JOIN afu_geotope.geotope_quelle
            ON geotope_quelle.t_id = geotope_quelle_fachbereich.quelle
        LEFT JOIN afu_geotope.geotope_fachbereich
            ON geotope_fachbereich.t_id = geotope_quelle_fachbereich.fachbereich
    GROUP BY
        geotope_quelle.t_id
), dokumente AS (
    SELECT
        geotope_quelle.t_id AS quelle,
        geotope_dokument.t_id,
        geotope_dokument.t_ili_tid,
        geotope_dokument.titel,
        geotope_dokument.offizieller_titel,
        geotope_dokument.abkuerzung,
        REGEXP_REPLACE(replace(geotope_dokument.pfad,'G:\documents\ch.so.afu.geotope','https://geo.so.ch/docs/ch.so.afu.geotope/'), '\\', '','g') AS pfad,
        geotope_dokument.typ,
        geotope_dokument.offizielle_nr,
        geotope_dokument.rechtsstatus,
        geotope_dokument.publiziert_ab
    FROM
        afu_geotope.geotope_quelle_dokument
        LEFT JOIN afu_geotope.geotope_quelle
            ON geotope_quelle.t_id = geotope_quelle_dokument.quelle
        LEFT JOIN afu_geotope.geotope_dokument
            ON geotope_dokument.t_id = geotope_quelle_dokument.dokument
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
                                titel,
                                offizieller_titel,
                                abkuerzung,
                                pfad,
                                typ,
                                offizielle_nr,
                                rechtsstatus,
                                publiziert_ab
                        ) docs
                ))
            )
        ) AS dokumente,
        quelle
    FROM
        dokumente
    GROUP BY
        quelle
), gemeinden AS (
    SELECT
        geotope_quelle.t_id,
        gemeindename AS gemeinde
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_geotope.geotope_quelle
    WHERE
        ST_Within(geotope_quelle.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
), ortschaft AS (
    SELECT 
        plzortschaft_ortschaftsname.atext AS ortschaftsname,
        plzortschaft_ortschaft.astatus AS status,
        ST_Multi(ST_Union(plzortschaft_ortschaft.flaeche)) AS geometrie
    FROM 
        agi_plz_ortschaften.plzortschaft_ortschaftsname
        LEFT JOIN agi_plz_ortschaften.plzortschaft_ortschaft
            ON plzortschaft_ortschaftsname.ortschaftsname_von = plzortschaft_ortschaft.t_id
    GROUP BY
        plzortschaft_ortschaftsname.atext,
        plzortschaft_ortschaft.astatus
), ortschaften AS (
    SELECT
        geotope_quelle.t_id,
        ortschaft.ortschaftsname AS ortschaft
    FROM
        ortschaft,
        afu_geotope.geotope_quelle
    WHERE
        ST_Within(geotope_quelle.geometrie, ortschaft.geometrie) = TRUE
), schutz AS (
    SELECT
        'Naturreservat' AS schutz,
        geotope_quelle.t_id
    FROM
        arp_naturreservate.reservate_teilgebiet,
        afu_geotope.geotope_quelle
    WHERE
        ST_Intersects(geotope_quelle.geometrie, reservate_teilgebiet.geometrie) = TRUE
    UNION
    SELECT
        'BLN-Gebiet' AS schutz,
        geotope_quelle.t_id
    FROM
        arp_richtplan_v1.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_quelle
    WHERE
        ST_Intersects(geotope_quelle.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        richtplankarte_ueberlagernde_flaeche.objekttyp = 'BLN_Gebiet'
    UNION
    SELECT
        'Uferschutzzone' AS schutz,
        geotope_quelle.t_id
    FROM
        arp_richtplan_v1.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_quelle
    WHERE
        ST_Intersects(geotope_quelle.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        richtplankarte_ueberlagernde_flaeche.objekttyp = 'kantonale_Uferschutzzone'
    UNION
    SELECT
        'Juraschutzzone' AS schutz,
        geotope_quelle.t_id
    FROM
        arp_richtplan_v1.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_quelle
    WHERE
        ST_Intersects(geotope_quelle.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        (
            richtplankarte_ueberlagernde_flaeche.objekttyp = 'Juraschutzzone'
        )
    /* muss noch ergaenzt werden mit dem npl daten, da Juraschutzonen aus npl und richtplan kommen */
), zusammengefasster_schutz AS (
    SELECT
        geotope_quelle.t_id,
        string_agg(DISTINCT schutz.schutz, ', ' ORDER BY schutz.schutz ASC) AS schutz
    FROM
        afu_geotope.geotope_quelle
        LEFT JOIN schutz
            ON schutz.t_id = geotope_quelle.t_id
    GROUP BY
        geotope_quelle.t_id
)

SELECT
    geotope_quelle.t_ili_tid,
    gemeinden.gemeinde,
    ortschaften.ortschaft,
    geotope_quelle.objektname,
    geotope_quelle.regionalgeologische_einheit,
    geotope_quelle.regionalgeologische_einheit AS regionalgeologische_einheit_text,
    geotope_quelle.bedeutung,
    geotope_quelle.bedeutung AS bedeutung_text,
    geotope_quelle.zustand,
    CASE 
        WHEN geotope_quelle.zustand = 'gering_beeintraechtigt'
            THEN 'gering beeinträchtigt'
        WHEN geotope_quelle.zustand = 'nicht_beeintraechtigt'
            THEN 'nicht beeinträchtigt' 
        WHEN geotope_quelle.zustand = 'stark_beeintraechtigt'
            THEN 'stark beeinträchtigt' 
        ELSE geotope_quelle.zustand 
    END AS zustand_text,
    geotope_quelle.beschreibung,
    geotope_quelle.schutzwuerdigkeit,
    CASE 
        WHEN geotope_quelle.schutzwuerdigkeit = 'geschuetzt' 
            THEN 'geschützt'
        WHEN geotope_quelle.schutzwuerdigkeit = 'schutzwuerdig' 
            THEN 'schutzwürdig'
        ELSE geotope_quelle.schutzwuerdigkeit
    END AS schutzwuerdigkeit_text,
    geotope_quelle.geowissenschaftlicher_wert,
    replace(geotope_quelle.geowissenschaftlicher_wert,'_',' ') AS geowissenschaftlicher_wert_text,
    geotope_quelle.anthropogene_gefaehrdung,
    geotope_quelle.anthropogene_gefaehrdung AS anthropogene_gefaehrdung_text,
    geotope_quelle.lokalname,
    geotope_quelle.kant_geschuetztes_objekt,
    geotope_quelle.alte_inventar_nummer,
    geotope_quelle.ingeso_oid,
    geotope_quelle.hinweis_literatur,
    geotope_quelle.rechtsstatus,
    replace(geotope_quelle.rechtsstatus,'_',' ') AS rechtsstatus_text,
    geotope_quelle.publiziert_ab,
    geotope_quelle.oereb_objekt,
    fachbereich.fachbereiche,
    dokumente_json.dokumente AS dokumente,
    geotope_zustaendige_stelle.amtsname,
    geotope_zustaendige_stelle.amt_im_web,
    zusammengefasster_schutz.schutz AS bestehender_schutz,
    geotope_quelle.geometrie
FROM
    afu_geotope.geotope_quelle
    LEFT JOIN afu_geotope.geotope_zustaendige_stelle
        ON geotope_quelle.zustaendige_stelle = geotope_zustaendige_stelle.t_id
    LEFT JOIN fachbereich
        ON geotope_quelle.t_id = fachbereich.t_id
    LEFT JOIN dokumente_json
        ON dokumente_json.quelle = geotope_quelle.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = geotope_quelle.t_id
    LEFT JOIN ortschaften
        ON ortschaften.t_id = geotope_quelle.t_id
    LEFT JOIN zusammengefasster_schutz
        ON zusammengefasster_schutz.t_id = geotope_quelle.t_id
