SELECT 
    a.ingeso_id AS t_id, 
    a.ingeso_oid, 
    a.ingesonr_alt, 
    ST_Multi(a.wkb_geometry) AS geometrie, 
    round(x(centroid(a.wkb_geometry))::numeric, 0) AS xkoord, 
    round(y(centroid(a.wkb_geometry))::numeric, 0) AS ykoord, 
    cb.text AS objektart_spez, 
    a.lokalname, 
    cm.text AS regio_geol_einheit, 
    a.objektname, 
    cc.text AS geol_sys_von, 
    cd.text AS geol_serie_von, 
    ce.text AS geol_stufe_von, 
    cf.text AS geol_schicht_von, 
    cg.text AS geol_sys_bis, 
    ch.text AS geol_serie_bis, 
    ci.text AS geol_stufe_bis, 
    cj.text AS geol_schicht_bis, 
    cv.text AS petrografie, 
    NULL::character varying AS landschaftstyp, 
    NULL::character varying AS groesse, 
    NULL::character varying AS eiszeit, 
    NULL::character varying AS herkunft, 
    NULL::character varying AS schalenstein, 
    NULL::character varying AS fundgegenstaende, 
    ca.text AS objektart_allg, 
    cr.text AS bedeutung, 
    cq.text AS zustand, 
    cs.text AS gefaehrdung, 
    cw.text AS geowiss_wert, 
    a.kurzbeschreibung, 
    ct.text AS schutzbedarf, 
    a.rrb_nr, 
    a.rrb_date, 
    cn.text AS fachbereich1, 
    co.text AS fachbereich2, 
    cp.text AS fachbereich3, 
    a.quelle, 
    a.nsinventar_nr, 
    NULL::character varying AS aufenthaltsort, 
    a.gmde_alt, 
    a.txt_idx, 
    geometrytype(a.wkb_geometry) AS geometrytype, 
    c.text AS teilinventar, 
    a.foto1, 
    a.foto1_name, 
    a.foto2, 
    a.foto2_name
FROM 
    ingeso.aufschluesse a
    LEFT JOIN 
        ingeso.code ca 
        ON 
            a.objektart_allg = ca.code_id
    LEFT JOIN 
        ingeso.code cb 
        ON 
            a.objektart_spez = cb.code_id
    LEFT JOIN 
        ingeso.code cc 
        ON 
            a.geol_sys_von = cc.code_id
    LEFT JOIN 
        ingeso.code cd 
        ON 
            a.geol_serie_von = cd.code_id
    LEFT JOIN 
        ingeso.code ce 
        ON 
            a.geol_stufe_von = ce.code_id
    LEFT JOIN 
        ingeso.code cf 
        ON 
            a.geol_schicht_von = cf.code_id
    LEFT JOIN 
        ingeso.code cg 
        ON 
            a.geol_schicht_von = cg.code_id
    LEFT JOIN 
        ingeso.code ch 
        ON 
            a.geol_serie_bis = ch.code_id
    LEFT JOIN 
        ingeso.code ci 
        ON 
            a.geol_stufe_bis = ci.code_id
    LEFT JOIN 
        ingeso.code cj 
        ON 
            a.geol_schicht_bis = cj.code_id
    LEFT JOIN 
        ingeso.code cm 
        ON 
            a.regio_geol_einheit = cm.code_id
    LEFT JOIN 
        ingeso.code cn 
        ON 
            a.fachbereich1 = cn.code_id
    LEFT JOIN 
        ingeso.code co 
        ON 
            a.fachbereich2 = co.code_id
    LEFT JOIN 
        ingeso.code cp 
        ON 
            a.fachbereich3 = cp.code_id
    LEFT JOIN 
        ingeso.code cq 
        ON 
            a.zustand = cq.code_id
    LEFT JOIN 
        ingeso.code cr 
        ON 
            a.bedeutung = cr.code_id
    LEFT JOIN 
        ingeso.code cs 
        ON 
            a.gefaehrdung = cs.code_id
    LEFT JOIN 
        ingeso.code ct 
        ON 
            a.schutzbedarf = ct.code_id
    LEFT JOIN 
        ingeso.code cv 
        ON 
            a.petrografie = cv.code_id
    LEFT JOIN 
        ingeso.code cw 
        ON 
            a.geowiss_wert = cw.code_id, 
            ingeso.code c
WHERE 
    a.archive = 0 
    AND 
    c.codeart_id = 19 
    AND 
    c.text::text = 'Aufschlüsse'::text
    
UNION 

SELECT 
    l.ingeso_id AS t_id, 
    l.ingeso_oid, 
    l.ingesonr_alt, 
    ST_Multi(l.wkb_geometry) AS geometrie, 
    round(x(centroid(l.wkb_geometry))::numeric, 0) AS xkoord, 
    round(y(centroid(l.wkb_geometry))::numeric, 0) AS ykoord, 
    cb.text AS objektart_spez, 
    l.lokalname, 
    cm.text AS regio_geol_einheit, 
    l.objektname, 
    NULL::character varying AS geol_sys_von, 
    NULL::character varying AS geol_serie_von, 
    NULL::character varying AS geol_stufe_von, 
    NULL::character varying AS geol_schicht_von, 
    NULL::character varying AS geol_sys_bis, 
    NULL::character varying AS geol_serie_bis, 
    NULL::character varying AS geol_stufe_bis, 
    NULL::character varying AS geol_schicht_bis, 
    NULL::character varying AS petrografie, 
    cv.text AS landschaftstyp, 
    NULL::character varying AS groesse, 
    NULL::character varying AS eiszeit, 
    NULL::character varying AS herkunft, 
    NULL::character varying AS schalenstein, 
    NULL::character varying AS fundgegenstaende, 
    ca.text AS objektart_allg, 
    cr.text AS bedeutung, 
    cq.text AS zustand, 
    cs.text AS gefaehrdung, 
    cw.text AS geowiss_wert, 
    l.kurzbeschreibung, 
    ct.text AS schutzbedarf, 
    l.rrb_nr, 
    l.rrb_date, 
    cn.text AS fachbereich1, 
    co.text AS fachbereich2, 
    cp.text AS fachbereich3, 
    l.quelle, 
    l.nsinventar_nr, 
    NULL::character varying AS aufenthaltsort, 
    l.gmde_alt, 
    l.txt_idx, 
    geometrytype(l.wkb_geometry) AS geometrytype, 
    c.text AS teilinventar, 
    l.foto1, 
    l.foto1_name, 
    l.foto2, 
    l.foto2_name
FROM 
    ingeso.landsformen l
    LEFT JOIN 
        ingeso.code ca 
        ON 
            l.objektart_allg = ca.code_id
    LEFT JOIN 
        ingeso.code cb 
        ON 
            l.objektart_spez = cb.code_id
    LEFT JOIN 
        ingeso.code cm 
        ON 
            l.regio_geol_einheit = cm.code_id
    LEFT JOIN 
        ingeso.code cn 
        ON 
            l.fachbereich1 = cn.code_id
    LEFT JOIN 
        ingeso.code co 
        ON 
            l.fachbereich2 = co.code_id
    LEFT JOIN 
        ingeso.code cp 
        ON 
            l.fachbereich3 = cp.code_id
    LEFT JOIN 
        ingeso.code cq 
        ON 
            l.zustand = cq.code_id
    LEFT JOIN 
        ingeso.code cr 
        ON 
            l.bedeutung = cr.code_id
    LEFT JOIN 
        ingeso.code cs 
        ON 
            l.gefaehrdung = cs.code_id
    LEFT JOIN 
        ingeso.code ct 
        ON 
            l.schutzbedarf = ct.code_id
    LEFT JOIN 
        ingeso.code cv 
        ON 
            l.landschaftstyp = cv.code_id
    LEFT JOIN 
        ingeso.code cw 
        ON 
            l.geowiss_wert = cw.code_id, ingeso.code c
WHERE 
    l.archive = 0 
    AND 
    c.codeart_id = 19 
    AND 
    c.text::text = 'Landschaftsformen'::text