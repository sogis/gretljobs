WITH fachbereich AS (
    SELECT 
        string_agg(geotope_fachbereich.fachbereichsname, ', ' ORDER BY fachbereichsname ASC) AS fachbereiche,
        geotope_landschaftsform.t_id
    FROM
        afu_geotope.geotope_landform_fachbereich
        LEFT JOIN afu_geotope.geotope_landschaftsform
            ON geotope_landschaftsform.t_id = geotope_landform_fachbereich.landform
        LEFT JOIN afu_geotope.geotope_fachbereich
            ON geotope_fachbereich.t_id = geotope_landform_fachbereich.fachbereich
    GROUP BY
        geotope_landschaftsform.t_id
), dokumente AS (
    SELECT
        geotope_landschaftsform.t_id AS landschaftsform,
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
        afu_geotope.geotope_landform_dokument
        LEFT JOIN afu_geotope.geotope_landschaftsform
            ON geotope_landschaftsform.t_id = geotope_landform_dokument.landform
        LEFT JOIN afu_geotope.geotope_dokument
            ON geotope_dokument.t_id = geotope_landform_dokument.dokument
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
        landschaftsform
    FROM
        dokumente
    GROUP BY
        landschaftsform
), gemeinden AS (
    SELECT
        geotope_landschaftsform.t_id,
        string_agg(DISTINCT hoheitsgrenzen_gemeindegrenze.gemeindename, ', ' ORDER BY hoheitsgrenzen_gemeindegrenze.gemeindename ASC) AS gemeinden
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_geotope.geotope_landschaftsform
    WHERE
        ST_Intersects(geotope_landschaftsform.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
    GROUP BY
        geotope_landschaftsform.t_id
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
        geotope_landschaftsform.t_id,
        string_agg(DISTINCT ortschaft.ortschaftsname, ', ' ORDER BY ortschaft.ortschaftsname ASC) AS ortschaften
    FROM
        ortschaft,
        afu_geotope.geotope_landschaftsform
    WHERE
        ST_Intersects(geotope_landschaftsform.geometrie, ortschaft.geometrie) = TRUE
    GROUP BY
        geotope_landschaftsform.t_id
), schutz AS (
    SELECT
        'Naturreservat' AS schutz,
        geotope_landschaftsform.t_id
    FROM
        arp_naturreservate.reservate_teilgebiet,
        afu_geotope.geotope_landschaftsform
    WHERE
        ST_Intersects(geotope_landschaftsform.geometrie, reservate_teilgebiet.geometrie) = TRUE
    UNION
    SELECT
        'BLN-Gebiet' AS schutz,
        geotope_landschaftsform.t_id
    FROM
        arp_richtplan.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_landschaftsform
    WHERE
        ST_Intersects(geotope_landschaftsform.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        richtplankarte_ueberlagernde_flaeche.objekttyp = 'BLN_Gebiet'
    UNION
    SELECT
        'Uferschutzzone' AS schutz,
        geotope_landschaftsform.t_id
    FROM
        arp_richtplan.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_landschaftsform
    WHERE
        ST_Intersects(geotope_landschaftsform.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        richtplankarte_ueberlagernde_flaeche.objekttyp = 'kantonale_Uferschutzzone'
    UNION
    SELECT
        'Juraschutzzone' AS schutz,
        geotope_landschaftsform.t_id
    FROM
        arp_richtplan.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_landschaftsform
    WHERE
        ST_Intersects(geotope_landschaftsform.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        (
            richtplankarte_ueberlagernde_flaeche.objekttyp = 'Juraschutzzone'
        )
    /* muss noch ergaenzt werden mit dem npl daten, da Juraschutzonen aus npl und richtplan kommen */
), zusammengefasster_schutz AS (
    SELECT
        geotope_landschaftsform.t_id,
        string_agg(DISTINCT schutz.schutz, ', ' ORDER BY schutz.schutz ASC) AS schutz
    FROM
        afu_geotope.geotope_landschaftsform
        LEFT JOIN schutz
            ON schutz.t_id = geotope_landschaftsform.t_id
    GROUP BY
        geotope_landschaftsform.t_id
)

SELECT
    geotope_landschaftsform.t_ili_tid,
    geotope_landschaftsform.landschaftstyp,
    replace(geotope_landschaftsform.landschaftstyp,'_',' ') AS landschaftstyp_text,
    geotope_landschaftsform.entstehung,
    CASE 
        WHEN geotope_landschaftsform.entstehung = 'natuerlich'
            THEN 'natürlich' 
        ELSE geotope_landschaftsform.entstehung
    END AS entstehung_text,
    geotope_landschaftsform.oberflaechenform AS oberflaechenform,
    replace(geotope_landschaftsform.oberflaechenform,'_',' ') AS oberflaechenform_text,
    gemeinden.gemeinden,
    ortschaften.ortschaften,
    geotope_landschaftsform.objektname,
    geotope_landschaftsform.regionalgeologische_einheit,
    geotope_landschaftsform.regionalgeologische_einheit AS regionalgeologische_einheit_text,
    geotope_landschaftsform.bedeutung,
    geotope_landschaftsform.bedeutung AS bedeutung_text,
    geotope_landschaftsform.zustand,
    CASE 
        WHEN geotope_landschaftsform.zustand = 'gering_beeintraechtigt'
            THEN 'gering beeinträchtigt'
        WHEN geotope_landschaftsform.zustand = 'nicht_beeintraechtigt'
            THEN 'nicht beeinträchtigt' 
        WHEN geotope_landschaftsform.zustand = 'stark_beeintraechtigt'
            THEN 'stark beeinträchtigt' 
        ELSE geotope_landschaftsform.zustand 
    END AS zustand_text,
    geotope_landschaftsform.beschreibung,
    geotope_landschaftsform.schutzwuerdigkeit,
    CASE 
        WHEN geotope_landschaftsform.schutzwuerdigkeit = 'geschuetzt' 
            THEN 'geschützt'
        WHEN geotope_landschaftsform.schutzwuerdigkeit = 'schutzwuerdig' 
            THEN 'schutzwürdig'
        ELSE geotope_landschaftsform.schutzwuerdigkeit
    END AS schutzwuerdigkeit_text,
    geotope_landschaftsform.geowissenschaftlicher_wert,
    replace(geotope_landschaftsform.geowissenschaftlicher_wert,'_',' ') AS geowissenschaftlicher_wert_text,
    geotope_landschaftsform.anthropogene_gefaehrdung,
    geotope_landschaftsform.anthropogene_gefaehrdung AS anthropogene_gefaehrdung_text,
    geotope_landschaftsform.lokalname,
    geotope_landschaftsform.kant_geschuetztes_objekt,
    geotope_landschaftsform.alte_inventar_nummer,
    geotope_landschaftsform.ingeso_oid, 
    geotope_landschaftsform.hinweis_literatur,
    geotope_landschaftsform.rechtsstatus,
    replace(geotope_landschaftsform.rechtsstatus,'_',' ') AS rechtsstatus_text,
    geotope_landschaftsform.publiziert_ab,
    geotope_landschaftsform.oereb_objekt,
    fachbereich.fachbereiche,
    dokumente_json.dokumente AS dokumente,
    geotope_zustaendige_stelle.amtsname,
    geotope_zustaendige_stelle.amt_im_web,
    zusammengefasster_schutz.schutz AS bestehender_schutz,
    geotope_landschaftsform.geometrie
FROM
    afu_geotope.geotope_landschaftsform
    LEFT JOIN fachbereich
        ON geotope_landschaftsform.t_id = fachbereich.t_id
    LEFT JOIN dokumente_json
        ON dokumente_json.landschaftsform = geotope_landschaftsform.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = geotope_landschaftsform.t_id
    LEFT JOIN ortschaften
        ON ortschaften.t_id = geotope_landschaftsform.t_id
    LEFT JOIN zusammengefasster_schutz
        ON zusammengefasster_schutz.t_id = geotope_landschaftsform.t_id
    LEFT JOIN afu_geotope.geotope_zustaendige_stelle
        ON geotope_landschaftsform.zustaendige_stelle = geotope_zustaendige_stelle.t_id
