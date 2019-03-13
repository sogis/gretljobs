WITH fachbereich AS (
    SELECT 
        string_agg(geotope_fachbereich.fachbereichsname, ',' ORDER BY fachbereichsname ASC) AS fachbereiche,
        geotope_aufschluss.t_id
    FROM
        afu_geotope.geotope_aufschluss_fachbereich
        LEFT JOIN afu_geotope.geotope_aufschluss
            ON geotope_aufschluss.t_id = geotope_aufschluss_fachbereich.aufschluss
        LEFT JOIN afu_geotope.geotope_fachbereich
            ON geotope_fachbereich.t_id = geotope_aufschluss_fachbereich.fachbereich
    GROUP BY
        geotope_aufschluss.t_id
), dokumente AS (
    SELECT
        geotope_aufschluss.t_id AS aufschluss,
        geotope_dokument.t_id,
        geotope_dokument.t_ili_tid,
        geotope_dokument.titel,
        geotope_dokument.offizieller_titel,
        geotope_dokument.abkuerzung,
        geotope_dokument.pfad,
        geotope_dokument.typ,
        geotope_dokument.offizielle_nr,
        geotope_dokument.rechtsstatus,
        geotope_dokument.publiziert_ab
    FROM
        afu_geotope.geotope_aufschluss_dokument
        LEFT JOIN afu_geotope.geotope_aufschluss
            ON geotope_aufschluss.t_id = geotope_aufschluss_dokument.aufschluss
        LEFT JOIN afu_geotope.geotope_dokument
            ON geotope_dokument.t_id = geotope_aufschluss_dokument.dokument
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
        aufschluss
    FROM
        dokumente
    GROUP BY
        aufschluss
), gemeinden AS (
    SELECT
        geotope_aufschluss.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_geotope.geotope_aufschluss
    WHERE
        ST_Intersects(geotope_aufschluss.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
    GROUP BY
        geotope_aufschluss.t_id
), ortschaft AS (
    SELECT 
        plzortschaft_ortschaftsname.atext AS ortschaftsname,
        plzortschaft_ortschaft.status,
        ST_Multi(ST_Union(plzortschaft_ortschaft.flaeche)) AS geometrie
    FROM 
        agi_plz_ortschaften.plzortschaft_ortschaftsname
        LEFT JOIN agi_plz_ortschaften.plzortschaft_ortschaft
            ON plzortschaft_ortschaftsname.ortschaftsname_von = plzortschaft_ortschaft.t_id
    GROUP BY
        plzortschaft_ortschaftsname.atext,
        plzortschaft_ortschaft.status
), ortschaften AS (
    SELECT
        geotope_aufschluss.t_id,
        string_agg(DISTINCT ortschaft.ortschaftsname, ', ' ORDER BY ortschaft.ortschaftsname ASC) AS ortschaften
    FROM
        ortschaft,
        afu_geotope.geotope_aufschluss
    WHERE
        ST_Intersects(geotope_aufschluss.geometrie, ortschaft.geometrie) = TRUE
    GROUP BY
        geotope_aufschluss.t_id
), schutz AS (
    SELECT
        'Naturreservat' AS schutz,
        geotope_aufschluss.t_id
    FROM
        arp_naturreservate.reservate_teilgebiet,
        afu_geotope.geotope_aufschluss
    WHERE
        ST_Intersects(geotope_aufschluss.geometrie, reservate_teilgebiet.geometrie) = TRUE
    UNION
    SELECT
        'BLN-Gebiet' AS schutz,
        geotope_aufschluss.t_id
    FROM
        arp_richtplan.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_aufschluss
    WHERE
        ST_Intersects(geotope_aufschluss.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        richtplankarte_ueberlagernde_flaeche.objekttyp = 'BLN_Gebiet'
    UNION
    SELECT
        'Uferschutzzone' AS schutz,
        geotope_aufschluss.t_id
    FROM
        arp_richtplan.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_aufschluss
    WHERE
        ST_Intersects(geotope_aufschluss.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        richtplankarte_ueberlagernde_flaeche.objekttyp = 'kantonale_Uferschutzzone'
    UNION
    SELECT
        'Juraschutzzone' AS schutz,
        geotope_aufschluss.t_id
    FROM
        arp_richtplan.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_aufschluss
    WHERE
        ST_Intersects(geotope_aufschluss.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        (
            richtplankarte_ueberlagernde_flaeche.objekttyp = 'Juraschutzzone.ueberlagert_Landwirtschaftsgebiet'
            OR
            richtplankarte_ueberlagernde_flaeche.objekttyp = 'Juraschutzzone.ueberlagert_Wald'
        )
    /* muss noch ergaenzt werden mit dem npl daten, da Juraschutzonen aus npl und richtplan kommen */
), zusammengefasster_schutz AS (
    SELECT
        geotope_aufschluss.t_id,
        string_agg(DISTINCT schutz.schutz, ', ' ORDER BY schutz.schutz ASC) AS schutz
    FROM
        afu_geotope.geotope_aufschluss
        LEFT JOIN schutz
            ON schutz.t_id = geotope_aufschluss.t_id
    GROUP BY
        geotope_aufschluss.t_id
)

SELECT
    geotope_aufschluss.t_ili_tid,
    geotope_aufschluss.petrografie,
    geotope_aufschluss.entstehung,
    geotope_aufschluss.oberflaechenform,
    gemeinden.gemeinden AS gemeinden,
    ortschaften.ortschaften,
    geologische_schicht_von.bezeichnung AS geologische_schicht_von,
    geologische_schicht_bis.bezeichnung AS geologische_schicht_bis,
    geologische_stufe_von.bezeichnung AS geologische_stufe_von,
    geologische_stufe_bis.bezeichnung AS geologische_stufe_bis,
    geologische_serie_von.bezeichnung AS geologische_serie_von,
    geologische_serie_bis.bezeichnung AS geologische_serie_bis,
    geologisches_system_von.bezeichnung AS geologisches_system_von,
    geologisches_system_bis.bezeichnung AS geologisches_system_bis,
    geotope_aufschluss.objektname,
    geotope_aufschluss.regionalgeologische_einheit,
    geotope_aufschluss.bedeutung,
    geotope_aufschluss.zustand,
    geotope_aufschluss.beschreibung,
    geotope_aufschluss.schutzwuerdigkeit,
    geotope_aufschluss.geowissenschaftlicher_wert,
    geotope_aufschluss.anthropogene_gefaehrdung,
    geotope_aufschluss.lokalname,
    geotope_aufschluss.kant_geschuetztes_objekt,
    geotope_aufschluss.alte_inventar_nummer,
    geotope_aufschluss.hinweis_literatur,
    geotope_aufschluss.rechtsstatus,
    geotope_aufschluss.publiziert_ab,
    geotope_aufschluss.oereb_objekt,
    fachbereich.fachbereiche,
    dokumente_json.dokumente AS dokumente,
    geotope_zustaendige_stelle.amtsname,
    geotope_zustaendige_stelle.amt_im_web,
    zusammengefasster_schutz.schutz AS bestehender_schutz,
    geotope_aufschluss.geometrie
FROM
    afu_geotope.geotope_aufschluss
    LEFT JOIN afu_geotope.lithostratigrphie_geologische_schicht AS geologische_schicht_von
        ON geologische_schicht_von.t_id = geotope_aufschluss.geologische_schicht_von
    LEFT JOIN afu_geotope.lithostratigrphie_geologische_schicht AS geologische_schicht_bis
        ON geologische_schicht_bis.t_id = geotope_aufschluss.geologische_schicht_bis
    LEFT JOIN afu_geotope.lithostratigrphie_geologische_serie AS geologische_serie_von
        ON geologische_serie_von.t_id = geotope_aufschluss.geologische_serie_von
    LEFT JOIN afu_geotope.lithostratigrphie_geologische_serie AS geologische_serie_bis
        ON geologische_serie_bis.t_id = geotope_aufschluss.geologische_serie_bis
    LEFT JOIN afu_geotope.lithostratigrphie_geologische_stufe AS geologische_stufe_von
        ON geologische_stufe_von.t_id = geotope_aufschluss.geologische_stufe_von
    LEFT JOIN afu_geotope.lithostratigrphie_geologische_stufe AS geologische_stufe_bis
        ON geologische_stufe_bis.t_id = geotope_aufschluss.geologische_stufe_bis
    LEFT JOIN afu_geotope.lithostratigrphie_geologisches_system AS geologisches_system_von
        ON geologisches_system_von.t_id = geotope_aufschluss.geologisches_system_von
    LEFT JOIN afu_geotope.lithostratigrphie_geologisches_system AS geologisches_system_bis
        ON geologisches_system_bis.t_id = geotope_aufschluss.geologisches_system_bis
    LEFT JOIN afu_geotope.geotope_zustaendige_stelle
        ON geotope_aufschluss.zustaendige_stelle = geotope_zustaendige_stelle.t_id
    LEFT JOIN fachbereich
        ON geotope_aufschluss.t_id = fachbereich.t_id
    LEFT JOIN dokumente_json
        ON dokumente_json.aufschluss = geotope_aufschluss.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = geotope_aufschluss.t_id
    LEFT JOIN ortschaften
        ON ortschaften.t_id = geotope_aufschluss.t_id
    LEFT JOIN zusammengefasster_schutz
        ON zusammengefasster_schutz.t_id = geotope_aufschluss.t_id
