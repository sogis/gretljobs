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
        WHEN obj_bohrung_.limnigraf IS NOT NULL
            THEN obj_bohrung_.limnigraf
        WHEN obj_gerammtes_piezometer_.limnigraf IS NOT NULL
            THEN obj_gerammtes_piezometer_.limnigraf
        ELSE NULL
    END AS limnigraf,
    CASE
        WHEN obj_sodbrunnen_.zustand IS NOT NULL
            THEN obj_sodbrunnen_.zustand
        WHEN obj_filterbrunnen_.zustand IS NOT NULL
            THEN obj_filterbrunnen_.zustand
        WHEN obj_quelle_gefasst_.zustand IS NOT NULL
            THEN obj_quelle_gefasst_.zustand
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
        WHEN obj_bohrung_.tiefe IS NOT NULL
            THEN obj_bohrung_.tiefe
        ELSE NULL
    END AS tiefe,
    CASE 
        WHEN obj_bohrung_.obere_hoehe IS NOT NULL
            THEN obj_bohrung_.obere_hoehe
        WHEN obj_gerammtes_piezometer_.obere_hoehe IS NOT NULL
            THEN obj_gerammtes_piezometer_.obere_hoehe
        ELSE NULL
    END AS obere_hoehe,
    CASE
        WHEN obj_bohrung_.obere_hoehe_bez IS NOT NULL
            THEN obj_bohrung_.obere_hoehe_bez
        WHEN obj_gerammtes_piezometer_.obere_hoehe_bez IS NOT NULL
            THEN obj_gerammtes_piezometer_.obere_hoehe_bez
        ELSE NULL
    END AS obere_hoehe_bez,
    obj_sodbrunnen_.durchmesser,
    obj_sodbrunnen_.aufgehoben,
    obj_quelle_gefasst_.rechtsstand_gwba,
    obj_quelle_gefasst_.pflichten_gwba,
    obj_bohrung_.bohrtyp, 
    obj_bohrung_.bohr_durchmesser, 
    obj_bohrung_.sohle, 
    obj_bohrung_.rohr_durchmesser, 
    obj_bohrung_.uk_rohr, 
    obj_bohrung_.ok_rohr, 
    obj_bohrung_.piezometer,
    obj_baggerschlitz_.tiefe_ab_okt
    
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
    LEFT JOIN  vegas.obj_bohrung_
        ON obj_objekt.vegas_id = obj_bohrung_.vegas_id
    LEFT JOIN vegas.obj_baggerschlitz_
        ON obj_objekt.vegas_id = obj_baggerschlitz_.vegas_id
    LEFT JOIN vegas.obj_gerammtes_piezometer_
        ON obj_objekt.vegas_id = obj_gerammtes_piezometer_.vegas_id
WHERE 
    archive = 0
;
