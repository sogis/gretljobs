(
    (                           
        SELECT 
            e.ingeso_id AS t_id, 
            e.ingeso_oid, 
            e.ingesonr_alt, 
            e.wkb_geometry AS geometrie, 
            round(x(centroid(e.wkb_geometry))::numeric, 0) AS xkoord, 
            round(y(centroid(e.wkb_geometry))::numeric, 0) AS ykoord, 
            NULL::character varying AS objektart_spez, 
            e.lokalname, 
            cm.text AS regio_geol_einheit, 
            e.objektname, 
            NULL::character varying AS geol_sys_von, 
            NULL::character varying AS geol_serie_von, 
            NULL::character varying AS geol_stufe_von, 
            NULL::character varying AS geol_schicht_von, 
            NULL::character varying AS geol_sys_bis, 
            NULL::character varying AS geol_serie_bis, 
            NULL::character varying AS geol_stufe_bis, 
            NULL::character varying AS geol_schicht_bis, 
            cv.text AS petrografie, 
            NULL::character varying AS landschaftstyp, 
            e.groesse, 
            cc.text AS eiszeit, 
            e.herkunft, 
            cd.text AS schalenstein, 
            NULL::character varying AS fundgegenstaende, 
            ca.text AS objektart_allg, 
            cr.text AS bedeutung, 
            cq.text AS zustand, 
            cs.text AS gefaehrdung, 
            cw.text AS geowiss_wert, 
            e.kurzbeschreibung, 
            ct.text AS schutzbedarf,
            e.rrb_nr, 
            e.rrb_date, 
            cn.text AS fachbereich1, 
            co.text AS fachbereich2, 
            cp.text AS fachbereich3, 
            e.quelle, 
            e.nsinventar_nr, 
            e.aufenthaltsort, 
            NULL::character varying AS gmde_alt, 
            e.txt_idx, 
            geometrytype(e.wkb_geometry) AS geometrytype, 
            c.text AS teilinventar, 
            e.foto1, 
            e.foto1_name, 
            e.foto2, 
            e.foto2_name
        FROM 
            ingeso.erratiker e
            LEFT JOIN 
                ingeso.code ca 
                ON 
                    e.objektart_allg = ca.code_id
            LEFT JOIN 
                ingeso.code cc 
                ON 
                    e.eiszeit = cc.code_id
            LEFT JOIN 
                ingeso.code cd 
                ON 
                    e.schalenstein = cd.code_id
            LEFT JOIN 
                ingeso.code cm 
                ON 
                    e.regio_geol_einheit = cm.code_id
            LEFT JOIN 
                ingeso.code cn 
                ON 
                    e.fachbereich1 = cn.code_id
            LEFT JOIN 
                ingeso.code co 
                ON 
                    e.fachbereich2 = co.code_id
            LEFT JOIN 
                ingeso.code cp 
                ON 
                    e.fachbereich3 = cp.code_id
            LEFT JOIN 
                ingeso.code cq 
                ON 
                    e.zustand = cq.code_id
            LEFT JOIN 
                ingeso.code cr 
                ON 
                    e.bedeutung = cr.code_id
            LEFT JOIN 
                ingeso.code cs 
                ON 
                    e.gefaehrdung = cs.code_id
            LEFT JOIN 
                ingeso.code ct 
                ON 
                    e.schutzbedarf = ct.code_id
            LEFT JOIN 
                ingeso.code cv 
                ON 
                    e.petrografie = cv.code_id
            LEFT JOIN 
                ingeso.code cw 
                ON 
                    e.geowiss_wert = cw.code_id, 
                    ingeso.code c
        WHERE 
            e.archive = 0 
            AND 
            c.codeart_id = 19 
            AND c.text::text = 'Erratiker'::text

                    
        UNION 
                             
        SELECT 
            f.ingeso_id, 
            f.ingeso_oid, 
            f.ingesonr_alt, 
            f.wkb_geometry, 
            round(x(centroid(f.wkb_geometry))::numeric, 0) AS xkoord, 
            round(y(centroid(f.wkb_geometry))::numeric, 0) AS ykoord, 
            NULL::character varying AS objektart_spez, 
            f.lokalname, 
            cm.text AS regio_geol_einheit, 
            f.objektname, 
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
            f.fundgegenstaende, 
            NULL::character varying AS objektart_allg, 
            cr.text AS bedeutung, 
            cq.text AS zustand, 
            cs.text AS gefaehrdung, 
            cw.text AS geowiss_wert, 
            f.kurzbeschreibung, 
            ct.text AS schutzbedarf, 
            f.rrb_nr, 
            f.rrb_date, 
            cn.text AS fachbereich1, 
            co.text AS fachbereich2, 
            cp.text AS fachbereich3, 
            f.quelle, 
            f.nsinventar_nr, 
            f.aufenthaltsort_funde AS aufenthaltsort, 
            NULL::character varying AS gmde_alt, 
            f.txt_idx, 
            geometrytype(f.wkb_geometry) AS geometrytype, 
            c.text AS teilinventar, 
            f.foto1, 
            f.foto1_name, 
            f.foto2, 
            f.foto2_name
        FROM 
            ingeso.fundstl_grabungen f
            LEFT JOIN 
                ingeso.code cc 
                ON 
                    f.geol_sys_von = cc.code_id
            LEFT JOIN 
                ingeso.code cd 
                ON 
                    f.geol_serie_von = cd.code_id
            LEFT JOIN 
                ingeso.code ce 
                ON 
                    f.geol_stufe_von = ce.code_id
            LEFT JOIN 
                ingeso.code cf 
                ON 
                    f.geol_schicht_von = cf.code_id
            LEFT JOIN 
                ingeso.code cg 
                ON 
                    f.geol_schicht_von = cg.code_id
            LEFT JOIN 
                ingeso.code ch 
                ON 
                    f.geol_serie_bis = ch.code_id
            LEFT JOIN 
                ingeso.code ci 
                ON 
                    f.geol_stufe_bis = ci.code_id
            LEFT JOIN 
                ingeso.code cj 
                ON 
                    f.geol_schicht_bis = cj.code_id
            LEFT JOIN 
                ingeso.code cm 
                ON 
                    f.regio_geol_einheit = cm.code_id
            LEFT JOIN 
                ingeso.code cn 
                ON 
                    f.fachbereich1 = cn.code_id
            LEFT JOIN 
                ingeso.code co 
                ON 
                    f.fachbereich2 = co.code_id
            LEFT JOIN 
                ingeso.code cp 
                ON 
                    f.fachbereich3 = cp.code_id
            LEFT JOIN 
                ingeso.code cq 
                ON 
                    f.zustand = cq.code_id
            LEFT JOIN 
                ingeso.code cr 
                ON 
                    f.bedeutung = cr.code_id
            LEFT JOIN 
                ingeso.code cs 
                ON 
                    f.gefaehrdung = cs.code_id
            LEFT JOIN 
                ingeso.code ct 
                ON 
                    f.schutzbedarf = ct.code_id
            LEFT JOIN 
                ingeso.code cv 
                ON 
                    f.petrografie = cv.code_id
            LEFT JOIN 
                ingeso.code cw 
                ON 
                    f.geowiss_wert = cw.code_id, 
                    ingeso.code c
        WHERE 
            f.archive = 0 
            AND 
            c.codeart_id = 19 
            AND 
            c.text::text = 'Fundstellen/ Grabungen'::text
    )
    
    UNION 
                     
    SELECT 
        h.ingeso_id, 
        h.ingeso_oid, 
        h.ingesonr_alt, 
        h.wkb_geometry, 
        round(x(centroid(h.wkb_geometry))::numeric, 0) AS xkoord, 
        round(y(centroid(h.wkb_geometry))::numeric, 0) AS ykoord, 
        cb.text AS objektart_spez, 
        h.lokalname, 
        cm.text AS regio_geol_einheit, 
        h.objektname, 
        cc.text AS geol_sys_von, 
        cd.text AS geol_serie_von, 
        ce.text AS geol_stufe_von, 
        cf.text AS geol_schicht_von, 
        cg.text AS geol_sys_bis, ch.text AS geol_serie_bis, 
        ci.text AS geol_stufe_bis, 
        cj.text AS geol_schicht_bis, cv.text AS petrografie, 
        NULL::character varying AS landschaftstyp, 
        NULL::character varying AS groesse, 
        NULL::character varying AS eiszeit, 
        NULL::character varying AS herkunft, 
        NULL::character varying AS schalenstein, 
        NULL::character varying AS fundgegenstaende, 
        NULL::character varying AS objektart_allg, 
        cr.text AS bedeutung, 
        cq.text AS zustand, 
        cs.text AS gefaehrdung, 
        cw.text AS geowiss_wert, 
        h.kurzbeschreibung, 
        ct.text AS schutzbedarf, 
        h.rrb_nr, 
        h.rrb_date, 
        cn.text AS fachbereich1, 
        co.text AS fachbereich2, 
        cp.text AS fachbereich3, 
        h.quelle, 
        h.nsinventar_nr, 
        NULL::character varying AS aufenthaltsort, 
        NULL::character varying AS gmde_alt, 
        h.txt_idx, 
        geometrytype(h.wkb_geometry) AS geometrytype, 
        'Höhlen'::character varying AS teilinventar, 
        h.foto1, 
        h.foto1_name, 
        h.foto2, 
        h.foto2_name
    FROM 
        ( 
            SELECT 
                hoehlen.ingeso_id, 
                hoehlen.ingeso_oid, 
                hoehlen.ingesonr_alt, 
                hoehlen.wkb_geometry, 
                hoehlen.objektart_spez, 
                hoehlen.lokalname, 
                hoehlen.regio_geol_einheit, 
                hoehlen.objektname, 
                hoehlen.geol_sys_von, 
                hoehlen.geol_serie_von, 
                hoehlen.geol_stufe_von, 
                hoehlen.geol_schicht_von, 
                hoehlen.geol_sys_bis, 
                hoehlen.geol_serie_bis, 
                hoehlen.geol_stufe_bis, 
                hoehlen.geol_schicht_bis, 
                hoehlen.gesteinsart_von, 
                hoehlen.gesteinsart_bis, 
                hoehlen.objektart_allg, 
                hoehlen.bedeutung, 
                hoehlen.zustand, 
                hoehlen.gefaehrdung, 
                hoehlen.geowiss_wert, 
                hoehlen.kurzbeschreibung, 
                hoehlen.schutzbedarf, 
                hoehlen.rrb_nr, 
                hoehlen.rrb_date, 
                hoehlen.fachbereich1, 
                hoehlen.fachbereich2, 
                hoehlen.fachbereich3, 
                hoehlen.wertungskriterien, 
                hoehlen.nsinventar_nr, 
                hoehlen.quelle, 
                hoehlen.new_date, 
                hoehlen.archive_date, 
                hoehlen.archive, 
                hoehlen.txt_idx, 
                hoehlen.bearbeiter, 
                hoehlen.petrografie, 
                hoehlen.foto1, 
                hoehlen.foto1_name, 
                hoehlen.foto2, 
                hoehlen.foto2_name
            FROM 
                ingeso.hoehlen
            WHERE 
                hoehlen.objektart_spez = 140
        ) h
        LEFT JOIN 
            ingeso.code cb 
            ON 
                h.objektart_spez = cb.code_id
        LEFT JOIN 
            ingeso.code cc 
            ON 
                h.geol_sys_von = cc.code_id
        LEFT JOIN 
            ingeso.code cd 
            ON 
                h.geol_serie_von = cd.code_id
        LEFT JOIN 
            ingeso.code ce 
            ON 
                h.geol_stufe_von = ce.code_id
        LEFT JOIN 
            ingeso.code cf 
            ON 
                h.geol_schicht_von = cf.code_id
        LEFT JOIN 
            ingeso.code cg 
            ON 
                h.geol_schicht_von = cg.code_id
        LEFT JOIN 
            ingeso.code ch 
            ON 
                h.geol_serie_bis = ch.code_id
        LEFT JOIN 
            ingeso.code ci 
            ON 
                h.geol_stufe_bis = ci.code_id
        LEFT JOIN 
            ingeso.code cj 
            ON 
                h.geol_schicht_bis = cj.code_id
        LEFT JOIN 
            ingeso.code cm 
            ON 
                h.regio_geol_einheit = cm.code_id
        LEFT JOIN 
            ingeso.code cn 
            ON 
                h.fachbereich1 = cn.code_id
        LEFT JOIN 
            ingeso.code co 
            ON 
                h.fachbereich2 = co.code_id
        LEFT JOIN 
            ingeso.code cp 
            ON 
                h.fachbereich3 = cp.code_id
        LEFT JOIN 
            ingeso.code cq 
            ON 
                h.zustand = cq.code_id
        LEFT JOIN 
            ingeso.code cr 
            ON 
                h.bedeutung = cr.code_id
        LEFT JOIN 
            ingeso.code cs 
            ON 
                h.gefaehrdung = cs.code_id
        LEFT JOIN 
            ingeso.code ct 
            ON 
                h.schutzbedarf = ct.code_id
        LEFT JOIN 
            ingeso.code cv 
            ON 
                h.petrografie = cv.code_id
        LEFT JOIN 
            ingeso.code cw 
            ON 
                h.geowiss_wert = cw.code_id, ingeso.code c
    WHERE 
        h.archive = 0 
        AND 
        c.codeart_id = 19 
        AND 
        c.text::text = 'Höhlen/ Quellen'::text
)
    
UNION 
             
SELECT 
    q.ingeso_id, 
    q.ingeso_oid, 
    q.ingesonr_alt, 
    q.wkb_geometry, 
    round(x(centroid(q.wkb_geometry))::numeric, 0) AS xkoord, 
    round(y(centroid(q.wkb_geometry))::numeric, 0) AS ykoord, 
    cb.text AS objektart_spez, 
    q.lokalname, 
    cm.text AS regio_geol_einheit, 
    q.objektname, 
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
    NULL::character varying AS objektart_allg, 
    cr.text AS bedeutung, 
    cq.text AS zustand, 
    cs.text AS gefaehrdung, 
    cw.text AS geowiss_wert, 
    q.kurzbeschreibung, 
    ct.text AS schutzbedarf, 
    q.rrb_nr, 
    q.rrb_date, 
    cn.text AS fachbereich1, 
    co.text AS fachbereich2, 
    cp.text AS fachbereich3, 
    q.quelle, 
    q.nsinventar_nr, 
    NULL::character varying AS aufenthaltsort, 
    NULL::character varying AS gmde_alt, 
    q.txt_idx, 
    geometrytype(q.wkb_geometry) AS geometrytype, 
    'Quellen'::character varying AS teilinventar, 
    q.foto1, 
    q.foto1_name, 
    q.foto2, 
    q.foto2_name
FROM 
    ( 
        SELECT 
            hoehlen.ingeso_id, 
            hoehlen.ingeso_oid, 
            hoehlen.ingesonr_alt, 
            hoehlen.wkb_geometry, 
            hoehlen.objektart_spez, 
            hoehlen.lokalname, 
            hoehlen.regio_geol_einheit, 
            hoehlen.objektname, 
            hoehlen.geol_sys_von, 
            hoehlen.geol_serie_von, 
            hoehlen.geol_stufe_von, 
            hoehlen.geol_schicht_von, 
            hoehlen.geol_sys_bis, 
            hoehlen.geol_serie_bis, 
            hoehlen.geol_stufe_bis, 
            hoehlen.geol_schicht_bis, 
            hoehlen.gesteinsart_von, 
            hoehlen.gesteinsart_bis, 
            hoehlen.objektart_allg, 
            hoehlen.bedeutung, 
            hoehlen.zustand, 
            hoehlen.gefaehrdung, 
            hoehlen.geowiss_wert, 
            hoehlen.kurzbeschreibung, 
            hoehlen.schutzbedarf, 
            hoehlen.rrb_nr, 
            hoehlen.rrb_date, 
            hoehlen.fachbereich1, 
            hoehlen.fachbereich2, 
            hoehlen.fachbereich3, 
            hoehlen.wertungskriterien, 
            hoehlen.nsinventar_nr, 
            hoehlen.quelle, 
            hoehlen.new_date, 
            hoehlen.archive_date, 
            hoehlen.archive, 
            hoehlen.txt_idx, 
            hoehlen.bearbeiter, 
            hoehlen.petrografie, 
            hoehlen.foto1, 
            hoehlen.foto1_name, 
            hoehlen.foto2, 
            hoehlen.foto2_name
        FROM 
            ingeso.hoehlen
        WHERE 
            hoehlen.objektart_spez = 425
    ) q
    LEFT JOIN 
        ingeso.code cb 
        ON 
            q.objektart_spez = cb.code_id
    LEFT JOIN 
        ingeso.code cc 
        ON 
            q.geol_sys_von = cc.code_id
    LEFT JOIN 
        ingeso.code cd 
        ON 
            q.geol_serie_von = cd.code_id
    LEFT JOIN 
        ingeso.code ce 
        ON 
            q.geol_stufe_von = ce.code_id
    LEFT JOIN 
        ingeso.code cf 
        ON 
            q.geol_schicht_von = cf.code_id
    LEFT JOIN 
        ingeso.code cg 
        ON 
            q.geol_schicht_von = cg.code_id
    LEFT JOIN 
        ingeso.code ch 
        ON 
            q.geol_serie_bis = ch.code_id
    LEFT JOIN 
        ingeso.code ci 
        ON 
            q.geol_stufe_bis = ci.code_id
    LEFT JOIN 
        ingeso.code cj 
        ON 
            q.geol_schicht_bis = cj.code_id
    LEFT JOIN 
        ingeso.code cm 
        ON 
            q.regio_geol_einheit = cm.code_id
    LEFT JOIN 
        ingeso.code cn 
        ON 
            q.fachbereich1 = cn.code_id
    LEFT JOIN 
        ingeso.code co 
        ON 
            q.fachbereich2 = co.code_id
    LEFT JOIN 
        ingeso.code cp 
        ON 
            q.fachbereich3 = cp.code_id
    LEFT JOIN 
        ingeso.code cq 
        ON 
            q.zustand = cq.code_id
    LEFT JOIN 
        ingeso.code cr 
        ON 
            q.bedeutung = cr.code_id
    LEFT JOIN 
        ingeso.code cs 
        ON 
            q.gefaehrdung = cs.code_id
    LEFT JOIN 
        ingeso.code ct 
        ON 
            q.schutzbedarf = ct.code_id
    LEFT JOIN 
        ingeso.code cv 
        ON 
            q.petrografie = cv.code_id
    LEFT JOIN 
        ingeso.code cw 
        ON 
            q.geowiss_wert = cw.code_id, ingeso.code c
WHERE 
    q.archive = 0 
    AND 
    c.codeart_id = 19 
    AND 
    c.text::text = 'Höhlen/ Quellen'::text;