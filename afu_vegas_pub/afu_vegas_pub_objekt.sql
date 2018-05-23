WITH  
    bohrung AS (
        SELECT
            bohrtyp,
            bohr_durchmesser,
            obere_hoehe,
            obere_hoehe_bez,
            tiefe,
            sohle,
            rohr_durchmesser,
            uk_rohr,
            ok_rohr,
            limnigraf,
            vegas_id,
            piezometer,
            'Bohrung'::text AS objekttyp
        FROM 
            vegas.obj_bohrung_
        WHERE
            piezometer = FALSE
        
        UNION
        
        SELECT
            bohrtyp,
            bohr_durchmesser,
            obere_hoehe,
            obere_hoehe_bez,
            tiefe,
            sohle,
            rohr_durchmesser,
            uk_rohr,
            ok_rohr,
            limnigraf,
            vegas_id,
            piezometer,
            'Bohrung mit Piezometer'::text AS objekttyp
        FROM 
            vegas.obj_bohrung_
        WHERE
            piezometer = TRUE 
    ),
    baggerschlitz AS (
        SELECT
            tiefe_ab_okt,
            vegas_id,
            'Baggerschlitz'::text AS objekttyp
        FROM
            vegas.obj_baggerschlitz_
    ),
    gerammtes_piezometer AS (
        SELECT
            obere_hoehe,
            obere_hoehe_bez,
            limnigraf,
            vegas_id,
            'gerammtes Piezometer'::text AS objekttyp
        FROM
            vegas.obj_gerammtes_piezometer_
    )
 

SELECT 
    obj_objekt.vegas_id, 
    obj_objekt.objekttyp_id, 
    obj_objekt.mobj_id, 
    obj_objekt.bezeichnung, 
    obj_objekt.beschreibung, 
    obj_objekt.aufnahmedatum, 
    obj_objekt.erfasser, 
    obj_objekt.url, 
    obj_objekt.bemerkung, 
    obj_objekt.wkb_geometry AS geometrie, 
    CASE
        WHEN obj_quelle_.schutzzone IS NOT NULL 
            THEN obj_quelle_.schutzzone
        WHEN obj_filterbrunnen_.schutzzone IS NOT NULL 
            THEN obj_filterbrunnen_.schutzzone
        WHEN obj_quelle_gefasst_.schutzzone IS NOT NULL 
            THEN obj_quelle_gefasst_.schutzzone
        WHEN obj_sodbrunnen_.vegas_id IS NOT NULL 
            THEN false
        ELSE NULL::boolean
    END AS schutzzone, 
    CASE
        WHEN obj_quelle_.min_schuettung IS NOT NULL 
            THEN obj_quelle_.min_schuettung
        WHEN obj_quelle_.max_schuettung IS NOT NULL 
            THEN obj_quelle_.max_schuettung
        WHEN obj_quelle_gefasst_.min_schuettung IS NOT NULL 
            THEN obj_quelle_gefasst_.min_schuettung
        WHEN obj_quelle_gefasst_.max_schuettung IS NOT NULL 
            THEN obj_quelle_gefasst_.max_schuettung
        WHEN gso_mobj.min_sch_sum IS NOT NULL 
            THEN gso_mobj.min_sch_sum
        WHEN gso_mobj.max_sch_sum IS NOT NULL 
            THEN gso_mobj.max_sch_sum
        ELSE NULL::integer
    END AS min_schuettung, 
    CASE
        WHEN obj_quelle_.max_schuettung IS NOT NULL 
            THEN obj_quelle_.max_schuettung
        WHEN obj_quelle_.min_schuettung IS NOT NULL 
            THEN obj_quelle_.min_schuettung
        WHEN obj_quelle_gefasst_.max_schuettung IS NOT NULL 
            THEN obj_quelle_gefasst_.max_schuettung
        WHEN obj_quelle_gefasst_.min_schuettung IS NOT NULL 
            THEN obj_quelle_gefasst_.min_schuettung
        WHEN gso_mobj.max_sch_sum IS NOT NULL 
            THEN gso_mobj.max_sch_sum
        WHEN gso_mobj.min_sch_sum IS NOT NULL 
            THEN gso_mobj.min_sch_sum
        ELSE NULL::integer
    END AS max_schuettung, 
    CASE
        WHEN obj_quelle_gefasst_.nutzungsart_schutzzone IS NULL 
            THEN obj_filterbrunnen_.nutzungsart_schutzzone
        WHEN obj_filterbrunnen_.nutzungsart_schutzzone IS NULL 
            THEN obj_quelle_gefasst_.nutzungsart_schutzzone
        ELSE NULL::integer
    END AS nutzungsart, 
    obj_filterbrunnen_.subtyp, 
    CASE
        WHEN obj_filterbrunnen_.verwendung IS NOT NULL
            THEN obj_filterbrunnen_.verwendung
        WHEN obj_quelle_gefasst_.verwendung IS NOT NULL 
            THEN obj_quelle_gefasst_.verwendung
        WHEN obj_sodbrunnen_.verwendung IS NOT NULL 
            THEN obj_sodbrunnen_.verwendung
        ELSE NULL::integer
    END AS verwendung, 
    CASE
        WHEN 
            obj_filterbrunnen_.verwendung = 1
            OR
            obj_quelle_gefasst_.verwendung = 1
            OR 
            obj_sodbrunnen_.verwendung = 1
                THEN 'Trinkwasser'
        WHEN 
            obj_filterbrunnen_.verwendung = 2
            OR
            obj_quelle_gefasst_.verwendung = 2
            OR 
            obj_sodbrunnen_.verwendung = 2
                THEN 'Brauchwasser'
        WHEN 
            obj_filterbrunnen_.verwendung = 3
            OR
            obj_quelle_gefasst_.verwendung = 3
            OR 
            obj_sodbrunnen_.verwendung = 3
                THEN 'Notbrunnen'
        ELSE NULL
    END AS verwendungstyp,
    obj_grundwasserwaerme_.schachttyp, 
    CASE
        WHEN gso_mobj.max_sch_sum IS NOT NULL 
            THEN gso_mobj.max_sch_sum::double precision
        WHEN obj_konzession.menge IS NOT NULL 
            THEN obj_konzession.menge
        ELSE NULL::double precision
    END AS menge,
    CASE
        WHEN obj_sodbrunnen_.limnigraf IS NOT NULL
            THEN obj_sodbrunnen_.limnigraf
        WHEN obj_filterbrunnen_.limnigraf IS NOT NULL
            THEN obj_filterbrunnen_.limnigraf
        WHEN obj_quelle_gefasst_.limnigraf IS NOT NULL
            THEN obj_quelle_gefasst_.limnigraf
        WHEN bohrung.limnigraf IS NOT NULL
            THEN bohrung.limnigraf
        WHEN gerammtes_piezometer.limnigraf IS NOT NULL
            THEN gerammtes_piezometer.limnigraf
        WHEN obj_messstation_.limnigraf
            THEN obj_messstation_.limnigraf
        ELSE NULL
    END AS limnigraf,
    CASE
        WHEN obj_sodbrunnen_.zustand IS NOT NULL
            THEN obj_sodbrunnen_.zustand
        WHEN obj_filterbrunnen_.zustand IS NOT NULL
            THEN obj_filterbrunnen_.zustand
        WHEN obj_quelle_gefasst_.zustand IS NOT NULL
            THEN obj_quelle_gefasst_.zustand
        WHEN obj_messstation_.zustand IS NOT NULL
            THEN obj_messstation_.zustand
        ELSE NULL
    END AS zustand,
    CASE
        WHEN obj_quelle_.mittlere_schuettung IS NOT NULL 
            THEN obj_quelle_.mittlere_schuettung
        WHEN obj_quelle_gefasst_.mittlere_schuettung IS NOT NULL
            THEN obj_quelle_gefasst_.mittlere_schuettung
        ELSE NULL
    END AS mittlere_schuettung,
    CASE 
        WHEN obj_sodbrunnen_.tiefe IS NOT NULL
            THEN obj_sodbrunnen_.tiefe
        WHEN bohrung.tiefe IS NOT NULL
            THEN bohrung.tiefe
        ELSE NULL
    END AS tiefe,
    CASE 
        WHEN bohrung.obere_hoehe IS NOT NULL
            THEN bohrung.obere_hoehe
        WHEN gerammtes_piezometer.obere_hoehe IS NOT NULL
            THEN gerammtes_piezometer.obere_hoehe
        ELSE NULL
    END AS obere_hoehe,
    CASE
        WHEN bohrung.obere_hoehe_bez IS NOT NULL
            THEN bohrung.obere_hoehe_bez
        WHEN gerammtes_piezometer.obere_hoehe_bez IS NOT NULL
            THEN gerammtes_piezometer.obere_hoehe_bez
        ELSE NULL
    END AS obere_hoehe_bez,
    obj_sodbrunnen_.durchmesser,
    obj_sodbrunnen_.aufgehoben,
    obj_quelle_gefasst_.rechtsstand_gwba,
    obj_quelle_gefasst_.pflichten_gwba,
    bohrung.bohrtyp, 
    bohrung.bohr_durchmesser, 
    bohrung.sohle, 
    bohrung.rohr_durchmesser, 
    bohrung.uk_rohr, 
    bohrung.ok_rohr, 
    bohrung.piezometer,
    baggerschlitz.tiefe_ab_okt,
    obj_messstation_.subtyp AS messstation_subtyp,
    obj_messstation_.region,
    obj_messstation_.gewaesserart,
    obj_messstation_.messfrequenz,
    obj_messstation_.ezg_flaeche,
    obj_messstation_.klaeranlage,
    obj_messstation_.betreiber,
    obj_einbauten_.subtyp AS einbauten_subtyp,
    obj_einbauten_.art,
    obj_einbauten_.entnahmemenge,
    obj_einbauten_.entnahmemenge_einheit,
    obj_einbauten_.beginn_wasserhaltung,
    obj_einbauten_.ende_wasserhaltung,
    obj_einbauten_.einbaukote,
    obj_einbauten_.querschnittsverringerung,
    obj_einbauten_.durchflussrelevantes_einbauvolumen,
    CASE
        WHEN bohrung.objekttyp IS NOT NULL
            THEN bohrung.objekttyp
        WHEN baggerschlitz.objekttyp IS NOT NULL
            THEN baggerschlitz.objekttyp
        WHEN gerammtes_piezometer.objekttyp IS NOT NULL
            THEN gerammtes_piezometer.objekttyp
        WHEN obj_objekt.objekttyp_id = 6
            THEN 'Sodbrunnen'::text
        WHEN
            obj_objekt.objekttyp_id = 7
            AND 
            obj_filterbrunnen_.subtyp = 2
                THEN 'Horizontalfilterbrunnen'
        WHEN 
            obj_objekt.objekttyp_id = 7
            AND
            obj_filterbrunnen_.subtyp = 1
                THEN 'Vertikalfilterbrunnen'
        WHEN obj_objekt.objekttyp_id = 9
            THEN 'Quelle gefasst'
        WHEN obj_objekt.objekttyp_id = 10
            THEN 'Quelle ungefasst'
        WHEN
            obj_objekt.objekttyp_id = 18
            AND
            obj_grundwasserwaerme_.schachttyp = 2
                THEN 'Versickerungsschacht'
        WHEN
            obj_objekt.objekttyp_id = 18
            AND
            (
                obj_grundwasserwaerme_.schachttyp = 1
                OR 
                obj_grundwasserwaerme_.schachttyp IS NULL
            )
            AND 
            obj_grundwasserwaerme_.zustand != 4
                THEN 'Entnahmeschacht für eine Grundwasserwärmenutzung'
    END AS objekttyp
    
FROM 
    vegas.obj_objekt
    LEFT JOIN vegas.obj_quelle_ 
        ON obj_objekt.vegas_id = obj_quelle_.vegas_id
    LEFT JOIN vegas.obj_quelle_gefasst_ 
        ON obj_objekt.vegas_id = obj_quelle_gefasst_.vegas_id
    LEFT JOIN vegas.obj_sodbrunnen_ 
        ON obj_objekt.vegas_id = obj_sodbrunnen_.vegas_id
    LEFT JOIN vegas.obj_filterbrunnen_ 
        ON obj_objekt.vegas_id = obj_filterbrunnen_.vegas_id
    LEFT JOIN vegas.obj_grundwasserwaerme_ 
        ON obj_objekt.vegas_id = obj_grundwasserwaerme_.vegas_id
    LEFT JOIN gaso.gso_mobj 
        ON obj_objekt.mobj_id = gso_mobj.mobj_id
    LEFT JOIN vegas.obj_konzession 
        ON obj_objekt.vegas_id = obj_konzession.vegas_id
    LEFT JOIN vegas.obj_messstation_
        ON obj_objekt.vegas_id = obj_messstation_.vegas_id
    LEFT JOIN vegas.obj_einbauten_
        ON obj_objekt.vegas_id = obj_einbauten_.vegas_id
    LEFT JOIN bohrung
        ON obj_objekt.vegas_id = bohrung.vegas_id
    LEFT JOIN baggerschlitz
        ON obj_objekt.vegas_id = baggerschlitz.vegas_id
    LEFT JOIN gerammtes_piezometer
        ON obj_objekt.vegas_id = gerammtes_piezometer.vegas_id
        
WHERE 
    archive = 0
;
