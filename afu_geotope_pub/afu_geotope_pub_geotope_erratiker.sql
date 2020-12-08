WITH fachbereich AS (
    SELECT 
        string_agg(geotope_fachbereich.fachbereichsname, ', ' ORDER BY fachbereichsname ASC) AS fachbereiche,
        geotope_erratiker.t_id
    FROM
        afu_geotope.geotope_erratiker_fachbereich
        LEFT JOIN afu_geotope.geotope_erratiker
            ON geotope_erratiker.t_id = geotope_erratiker_fachbereich.erratiker
        LEFT JOIN afu_geotope.geotope_fachbereich
            ON geotope_fachbereich.t_id = geotope_erratiker_fachbereich.fachbereich
    GROUP BY
        geotope_erratiker.t_id
), dokumente AS (
    SELECT
        geotope_erratiker.t_id AS erratiker,
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
        afu_geotope.geotope_erratiker_dokument
        LEFT JOIN afu_geotope.geotope_erratiker
            ON geotope_erratiker.t_id = geotope_erratiker_dokument.erratiker
        LEFT JOIN afu_geotope.geotope_dokument
            ON geotope_dokument.t_id = geotope_erratiker_dokument.dokument
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
        erratiker
    FROM
        dokumente
    GROUP BY
        erratiker
), gemeinden AS (
    SELECT
        geotope_erratiker.t_id,
        gemeindename AS gemeinde
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        afu_geotope.geotope_erratiker
    WHERE
        ST_Within(geotope_erratiker.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
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
        plzortschaft_ortschaft.status
), ortschaften AS (
    SELECT
        geotope_erratiker.t_id,
        ortschaft.ortschaftsname AS ortschaft
    FROM
        ortschaft,
        afu_geotope.geotope_erratiker
    WHERE
        ST_Within(geotope_erratiker.geometrie, ortschaft.geometrie) = TRUE
), schutz AS (
    SELECT
        'Naturreservat' AS schutz,
        geotope_erratiker.t_id
    FROM
        arp_naturreservate.reservate_teilgebiet,
        afu_geotope.geotope_erratiker
    WHERE
        ST_Intersects(geotope_erratiker.geometrie, reservate_teilgebiet.geometrie) = TRUE
    UNION
    SELECT
        'BLN-Gebiet' AS schutz,
        geotope_erratiker.t_id
    FROM
        arp_richtplan.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_erratiker
    WHERE
        ST_Intersects(geotope_erratiker.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        richtplankarte_ueberlagernde_flaeche.objekttyp = 'BLN_Gebiet'
    UNION
    SELECT
        'Uferschutzzone' AS schutz,
        geotope_erratiker.t_id
    FROM
        arp_richtplan.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_erratiker
    WHERE
        ST_Intersects(geotope_erratiker.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        richtplankarte_ueberlagernde_flaeche.objekttyp = 'kantonale_Uferschutzzone'
    UNION
    SELECT
        'Juraschutzzone' AS schutz,
        geotope_erratiker.t_id
    FROM
        arp_richtplan.richtplankarte_ueberlagernde_flaeche,
        afu_geotope.geotope_erratiker
    WHERE
        ST_Intersects(geotope_erratiker.geometrie, richtplankarte_ueberlagernde_flaeche.geometrie) = TRUE
        AND
        (
            richtplankarte_ueberlagernde_flaeche.objekttyp = 'Juraschutzzone'
        )
    /* muss noch ergaenzt werden mit dem npl daten, da Juraschutzonen aus npl und richtplan kommen */
), zusammengefasster_schutz AS (
    SELECT
        geotope_erratiker.t_id,
        string_agg(DISTINCT schutz.schutz, ', ' ORDER BY schutz.schutz ASC) AS schutz
    FROM
        afu_geotope.geotope_erratiker
        LEFT JOIN schutz
            ON schutz.t_id = geotope_erratiker.t_id
    GROUP BY
        geotope_erratiker.t_id
)

SELECT
    geotope_erratiker.t_ili_tid,
    geotope_erratiker.groesse,
    geotope_erratiker.eiszeit,
    geotope_erratiker.eiszeit AS eiszeit_text,
    geotope_erratiker.herkunft,
    geotope_erratiker.schalenstein,
    geotope_erratiker.aufenthaltsort,
    geotope_erratiker.petrografie,
    CASE 
        WHEN geotope_erratiker.petrografie = 'Penninischer_Gruenschiefer'
            THEN 'Penninischer Grünschiefer'
        ELSE replace(geotope_erratiker.petrografie,'_',' ') 
    END AS petrografie_text,
    geotope_erratiker.entstehung,
    CASE 
        WHEN geotope_erratiker.entstehung = 'natuerlich'
            THEN 'natürlich' 
        ELSE geotope_erratiker.entstehung
    END AS entstehung_text,
    gemeinden.gemeinde,
    ortschaften.ortschaft,
    geotope_erratiker.objektname,
    geotope_erratiker.regionalgeologische_einheit,
    geotope_erratiker.regionalgeologische_einheit AS regionalgeologische_einheit_text,
    geotope_erratiker.bedeutung,
    geotope_erratiker.bedeutung AS bedeutung_text,
    geotope_erratiker.zustand,
    CASE 
        WHEN geotope_erratiker.zustand = 'gering_beeintraechtigt'
            THEN 'gering beeinträchtigt'
        WHEN geotope_erratiker.zustand = 'nicht_beeintraechtigt'
            THEN 'nicht beeinträchtigt' 
        WHEN geotope_erratiker.zustand = 'stark_beeintraechtigt'
            THEN 'stark beeinträchtigt' 
        ELSE geotope_erratiker.zustand 
    END AS zustand_text,
    geotope_erratiker.beschreibung,
    geotope_erratiker.schutzwuerdigkeit,
    CASE 
        WHEN geotope_erratiker.schutzwuerdigkeit = 'geschuetzt' 
            THEN 'geschützt' 
        WHEN geotope_erratiker.schutzwuerdigkeit = 'schutzwuerdig' 
            THEN 'schutzwürdig'
        ELSE geotope_erratiker.schutzwuerdigkeit
    END AS schutzwuerdigkeit_text,
    geotope_erratiker.geowissenschaftlicher_wert,
    replace(geotope_erratiker.geowissenschaftlicher_wert,'_',' ') AS geowissenschaftlicher_wert_text,
    geotope_erratiker.anthropogene_gefaehrdung,
    geotope_erratiker.anthropogene_gefaehrdung AS anthropogene_gefaehrdung_text,
    geotope_erratiker.lokalname,
    geotope_erratiker.kant_geschuetztes_objekt,
    geotope_erratiker.alte_inventar_nummer,
    geotope_erratiker.ingeso_oid,
    geotope_erratiker.hinweis_literatur,
    geotope_erratiker.rechtsstatus,
    geotope_erratiker.rechtsstatus AS rechtsstatus_text,
    geotope_erratiker.publiziert_ab,
    geotope_erratiker.oereb_objekt,
    fachbereich.fachbereiche,
    dokumente_json.dokumente AS dokumente,
    geotope_zustaendige_stelle.amtsname,
    geotope_zustaendige_stelle.amt_im_web,
    zusammengefasster_schutz.schutz AS bestehender_schutz,
    geotope_erratiker.geometrie
FROM
    afu_geotope.geotope_erratiker
    LEFT JOIN afu_geotope.geotope_zustaendige_stelle
        ON geotope_erratiker.zustaendige_stelle = geotope_zustaendige_stelle.t_id
    LEFT JOIN fachbereich
        ON geotope_erratiker.t_id = fachbereich.t_id
    LEFT JOIN dokumente_json
        ON dokumente_json.erratiker = geotope_erratiker.t_id
    LEFT JOIN gemeinden
        ON gemeinden.t_id = geotope_erratiker.t_id
    LEFT JOIN ortschaften
        ON ortschaften.t_id = geotope_erratiker.t_id
    LEFT JOIN zusammengefasster_schutz
        ON zusammengefasster_schutz.t_id = geotope_erratiker.t_id
