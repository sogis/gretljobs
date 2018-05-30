SELECT DISTINCT punktobjekte.*,
        string_agg(DISTINCT 
        CASE 
            WHEN
                arp_basdat.o_art = 4000 
                OR 
                arp_basdat.o_art = 5000
                THEN
                    'Juraschutzzone'
            WHEN
                arp_basdat.o_art = 6000
                THEN
                    'Uferschutzzone'
            WHEN
                sogis_bln.ogc_fid > 0
                THEN
                    'BLN-Gebiet'
            WHEN
                arp_natres.ogc_fid > 0
                THEN
                    'Naturreservat'
        END, ',') AS schutz   
FROM
(
    (
        (                           
            SELECT 
                erratiker.ingeso_id AS t_id, 
                erratiker.ingeso_oid, 
                erratiker.ingesonr_alt, 
                erratiker.wkb_geometry AS geometrie, 
                round(ST_X(ST_Centroid(erratiker.wkb_geometry))::numeric, 0) AS xkoord, 
                round(ST_Y(ST_Centroid(erratiker.wkb_geometry))::numeric, 0) AS ykoord, 
                NULL::character varying AS objektart_spez, 
                erratiker.lokalname, 
                code_m.text AS regio_geol_einheit, 
                erratiker.objektname, 
                NULL::character varying AS geol_sys_von, 
                NULL::character varying AS geol_serie_von, 
                NULL::character varying AS geol_stufe_von, 
                NULL::character varying AS geol_schicht_von, 
                NULL::character varying AS geol_sys_bis, 
                NULL::character varying AS geol_serie_bis, 
                NULL::character varying AS geol_stufe_bis, 
                NULL::character varying AS geol_schicht_bis, 
                code_v.text AS petrografie, 
                NULL::character varying AS landschaftstyp, 
                erratiker.groesse, 
                code_c.text AS eiszeit, 
                erratiker.herkunft, 
                code_d.text AS schalenstein, 
                NULL::character varying AS fundgegenstaende, 
                code_a.text AS objektart_allg, 
                code_r.text AS bedeutung, 
                code_q.text AS zustand, 
                code_s.text AS gefaehrdung, 
                code_w.text AS geowiss_wert, 
                erratiker.kurzbeschreibung, 
                code_t.text AS schutzbedarf,
                erratiker.rrb_nr, 
                erratiker.rrb_date, 
                code_n.text AS fachbereich1, 
                code_o.text AS fachbereich2, 
                code_p.text AS fachbereich3, 
                erratiker.quelle, 
                erratiker.nsinventar_nr, 
                erratiker.aufenthaltsort, 
                NULL::character varying AS gmde_alt, 
                erratiker.txt_idx, 
                ST_GeometryType(erratiker.wkb_geometry) AS geometrytype, 
                code.text AS teilinventar, 
                erratiker.foto1, 
                erratiker.foto1_name, 
                erratiker.foto2, 
                erratiker.foto2_name
            FROM 
                ingeso.erratiker
                LEFT JOIN ingeso.code AS code_a 
                    ON erratiker.objektart_allg = code_a.code_id
                LEFT JOIN ingeso.code AS code_c 
                    ON erratiker.eiszeit = code_c.code_id
                LEFT JOIN ingeso.code AS code_d 
                    ON erratiker.schalenstein = code_d.code_id
                LEFT JOIN ingeso.code AS code_m 
                    ON erratiker.regio_geol_einheit = code_m.code_id
                LEFT JOIN ingeso.code AS code_n 
                    ON erratiker.fachbereich1 = code_n.code_id
                LEFT JOIN ingeso.code AS code_o 
                    ON erratiker.fachbereich2 = code_o.code_id
                LEFT JOIN ingeso.code AS code_p 
                    ON erratiker.fachbereich3 = code_p.code_id
                LEFT JOIN ingeso.code AS code_q 
                    ON erratiker.zustand = code_q.code_id
                LEFT JOIN ingeso.code AS code_r 
                    ON erratiker.bedeutung = code_r.code_id
                LEFT JOIN ingeso.code AS code_s 
                    ON erratiker.gefaehrdung = code_s.code_id
                LEFT JOIN ingeso.code AS code_t 
                    ON erratiker.schutzbedarf = code_t.code_id
                LEFT JOIN ingeso.code AS code_v 
                    ON erratiker.petrografie = code_v.code_id
                LEFT JOIN ingeso.code AS code_w 
                    ON erratiker.geowiss_wert = code_w.code_id, 
                ingeso.code
            WHERE 
                erratiker.archive = 0 
                AND 
                code.codeart_id = 19 
                AND 
                code.text::text = 'Erratiker'::text
    
                        
            UNION 
                                 
            SELECT 
                fundstelle.ingeso_id, 
                fundstelle.ingeso_oid, 
                fundstelle.ingesonr_alt, 
                fundstelle.wkb_geometry, 
                round(ST_X(ST_Centroid(fundstelle.wkb_geometry))::numeric, 0) AS xkoord, 
                round(ST_Y(ST_Centroid(fundstelle.wkb_geometry))::numeric, 0) AS ykoord, 
                NULL::character varying AS objektart_spez, 
                fundstelle.lokalname, 
                code_m.text AS regio_geol_einheit, 
                fundstelle.objektname, 
                code_c.text AS geol_sys_von, 
                code_d.text AS geol_serie_von, 
                code_e.text AS geol_stufe_von, 
                code_f.text AS geol_schicht_von, 
                code_g.text AS geol_sys_bis, 
                code_h.text AS geol_serie_bis, 
                code_i.text AS geol_stufe_bis, 
                code_j.text AS geol_schicht_bis, 
                code_v.text AS petrografie, 
                NULL::character varying AS landschaftstyp, 
                NULL::character varying AS groesse, 
                NULL::character varying AS eiszeit, 
                NULL::character varying AS herkunft, 
                NULL::character varying AS schalenstein, 
                fundstelle.fundgegenstaende, 
                NULL::character varying AS objektart_allg, 
                code_r.text AS bedeutung, 
                code_q.text AS zustand, 
                code_s.text AS gefaehrdung, 
                code_w.text AS geowiss_wert, 
                fundstelle.kurzbeschreibung, 
                code_t.text AS schutzbedarf, 
                fundstelle.rrb_nr, 
                fundstelle.rrb_date, 
                code_n.text AS fachbereich1, 
                code_o.text AS fachbereich2, 
                code_p.text AS fachbereich3, 
                fundstelle.quelle, 
                fundstelle.nsinventar_nr, 
                fundstelle.aufenthaltsort_funde AS aufenthaltsort, 
                NULL::character varying AS gmde_alt, 
                fundstelle.txt_idx, 
                ST_GeometryType(fundstelle.wkb_geometry) AS geometerytype, 
                code.text AS teilinventar, 
                fundstelle.foto1, 
                fundstelle.foto1_name, 
                fundstelle.foto2, 
                fundstelle.foto2_name
            FROM 
                ingeso.fundstl_grabungen AS fundstelle
                LEFT JOIN ingeso.code AS code_c 
                    ON fundstelle.geol_sys_von = code_c.code_id
                LEFT JOIN ingeso.code AS code_d 
                    ON fundstelle.geol_serie_von = code_d.code_id
                LEFT JOIN ingeso.code AS code_e 
                    ON fundstelle.geol_stufe_von = code_e.code_id
                LEFT JOIN ingeso.code AS code_f 
                    ON fundstelle.geol_schicht_von = code_f.code_id
                LEFT JOIN ingeso.code AS code_g 
                    ON fundstelle.geol_schicht_von = code_g.code_id
                LEFT JOIN ingeso.code AS code_h 
                    ON fundstelle.geol_serie_bis = code_h.code_id
                LEFT JOIN ingeso.code AS code_i 
                    ON fundstelle.geol_stufe_bis = code_i.code_id
                LEFT JOIN ingeso.code AS code_j 
                    ON fundstelle.geol_schicht_bis = code_j.code_id
                LEFT JOIN ingeso.code AS code_m 
                    ON fundstelle.regio_geol_einheit = code_m.code_id
                LEFT JOIN ingeso.code AS code_n 
                    ON fundstelle.fachbereich1 = code_n.code_id
                LEFT JOIN ingeso.code code_o 
                    ON fundstelle.fachbereich2 = code_o.code_id
                LEFT JOIN ingeso.code AS code_p 
                    ON fundstelle.fachbereich3 = code_p.code_id
                LEFT JOIN ingeso.code AS code_q 
                    ON fundstelle.zustand = code_q.code_id
                LEFT JOIN ingeso.code AS code_r 
                    ON fundstelle.bedeutung = code_r.code_id
                LEFT JOIN ingeso.code AS code_s 
                    ON fundstelle.gefaehrdung = code_s.code_id
                LEFT JOIN ingeso.code AS code_t 
                    ON fundstelle.schutzbedarf = code_t.code_id
                LEFT JOIN ingeso.code AS code_v 
                    ON fundstelle.petrografie = code_v.code_id
                LEFT JOIN ingeso.code AS code_w 
                    ON fundstelle.geowiss_wert = code_w.code_id, 
                ingeso.code
            WHERE 
                fundstelle.archive = 0 
                AND 
                code.codeart_id = 19 
                AND 
                code.text::text = 'Fundstellen/ Grabungen'::text
        )
        
        UNION 
                         
        SELECT 
            hoehlen.ingeso_id, 
            hoehlen.ingeso_oid, 
            hoehlen.ingesonr_alt, 
            hoehlen.wkb_geometry, 
            round(x(centroid(hoehlen.wkb_geometry))::numeric, 0) AS xkoord, 
            round(y(centroid(hoehlen.wkb_geometry))::numeric, 0) AS ykoord, 
            code_b.text AS objektart_spez, 
            hoehlen.lokalname, 
            code_m.text AS regio_geol_einheit, 
            hoehlen.objektname, 
            code_c.text AS geol_sys_von, 
            code_d.text AS geol_serie_von, 
            code_e.text AS geol_stufe_von, 
            code_f.text AS geol_schicht_von, 
            code_g.text AS geol_sys_bis, 
            code_h.text AS geol_serie_bis, 
            code_i.text AS geol_stufe_bis, 
            code_j.text AS geol_schicht_bis, 
            code_v.text AS petrografie, 
            NULL::character varying AS landschaftstyp, 
            NULL::character varying AS groesse, 
            NULL::character varying AS eiszeit, 
            NULL::character varying AS herkunft, 
            NULL::character varying AS schalenstein, 
            NULL::character varying AS fundgegenstaende, 
            NULL::character varying AS objektart_allg, 
            code_r.text AS bedeutung, 
            code_q.text AS zustand, 
            code_s.text AS gefaehrdung, 
            code_w.text AS geowiss_wert, 
            hoehlen.kurzbeschreibung, 
            code_t.text AS schutzbedarf, 
            hoehlen.rrb_nr, 
            hoehlen.rrb_date, 
            code_n.text AS fachbereich1, 
            code_o.text AS fachbereich2, 
            code_p.text AS fachbereich3, 
            hoehlen.quelle, 
            hoehlen.nsinventar_nr, 
            NULL::character varying AS aufenthaltsort, 
            NULL::character varying AS gmde_alt, 
            hoehlen.txt_idx, 
            ST_GeometryType(hoehlen.wkb_geometry) AS geometrytype, 
            'Höhlen'::character varying AS teilinventar, 
            hoehlen.foto1, 
            hoehlen.foto1_name, 
            hoehlen.foto2, 
            hoehlen.foto2_name
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
            ) AS hoehlen
            LEFT JOIN ingeso.code AS code_b 
                ON hoehlen.objektart_spez = code_b.code_id
            LEFT JOIN ingeso.code AS code_c 
                ON hoehlen.geol_sys_von = code_c.code_id
            LEFT JOIN ingeso.code AS code_d 
                ON hoehlen.geol_serie_von = code_d.code_id
            LEFT JOIN ingeso.code AS code_e 
                ON hoehlen.geol_stufe_von = code_e.code_id
            LEFT JOIN ingeso.code AS code_f 
                ON hoehlen.geol_schicht_von = code_f.code_id
            LEFT JOIN ingeso.code AS code_g 
                ON hoehlen.geol_schicht_von = code_g.code_id
            LEFT JOIN ingeso.code AS code_h 
                ON hoehlen.geol_serie_bis = code_h.code_id
            LEFT JOIN ingeso.code AS code_i 
                ON hoehlen.geol_stufe_bis = code_i.code_id
            LEFT JOIN ingeso.code AS code_j 
                ON hoehlen.geol_schicht_bis = code_j.code_id
            LEFT JOIN ingeso.code code_m 
                ON hoehlen.regio_geol_einheit = code_m.code_id
            LEFT JOIN ingeso.code AS code_n 
                ON hoehlen.fachbereich1 = code_n.code_id
            LEFT JOIN ingeso.code AS code_o 
                ON hoehlen.fachbereich2 = code_o.code_id
            LEFT JOIN ingeso.code AS code_p 
                ON hoehlen.fachbereich3 = code_p.code_id
            LEFT JOIN ingeso.code AS code_q 
                ON hoehlen.zustand = code_q.code_id
            LEFT JOIN ingeso.code AS code_r 
                ON hoehlen.bedeutung = code_r.code_id
            LEFT JOIN ingeso.code AS code_s 
                ON hoehlen.gefaehrdung = code_s.code_id
            LEFT JOIN ingeso.code AS code_t 
                ON hoehlen.schutzbedarf = code_t.code_id
            LEFT JOIN ingeso.code AS code_v 
                ON hoehlen.petrografie = code_v.code_id
            LEFT JOIN ingeso.code AS code_w 
                ON hoehlen.geowiss_wert = code_w.code_id, 
            ingeso.code
        WHERE 
            hoehlen.archive = 0 
            AND 
            code.codeart_id = 19 
            AND 
            code.text::text = 'Höhlen/ Quellen'::text
    )
        
    UNION 
                 
    SELECT 
        quellen.ingeso_id, 
        quellen.ingeso_oid, 
        quellen.ingesonr_alt, 
        quellen.wkb_geometry, 
        round(ST_X(ST_Centroid(quellen.wkb_geometry))::numeric, 0) AS xkoord, 
        round(ST_Y(ST_Centroid(quellen.wkb_geometry))::numeric, 0) AS ykoord, 
        code_b.text AS objektart_spez, 
        quellen.lokalname, 
        code_m.text AS regio_geol_einheit, 
        quellen.objektname, 
        code_c.text AS geol_sys_von, 
        code_d.text AS geol_serie_von, 
        code_e.text AS geol_stufe_von, 
        code_f.text AS geol_schicht_von, 
        code_g.text AS geol_sys_bis, 
        code_h.text AS geol_serie_bis, 
        code_i.text AS geol_stufe_bis, 
        code_j.text AS geol_schicht_bis, 
        code_v.text AS petrografie, 
        NULL::character varying AS landschaftstyp, 
        NULL::character varying AS groesse, 
        NULL::character varying AS eiszeit, 
        NULL::character varying AS herkunft, 
        NULL::character varying AS schalenstein, 
        NULL::character varying AS fundgegenstaende, 
        NULL::character varying AS objektart_allg, 
        code_r.text AS bedeutung, 
        code_q.text AS zustand, 
        code_s.text AS gefaehrdung, 
        code_w.text AS geowiss_wert, 
        quellen.kurzbeschreibung, 
        code_t.text AS schutzbedarf, 
        quellen.rrb_nr, 
        quellen.rrb_date, 
        code_n.text AS fachbereich1, 
        code_o.text AS fachbereich2,
        code_p.text AS fachbereich3, 
        quellen.quelle, 
        quellen.nsinventar_nr, 
        NULL::character varying AS aufenthaltsort, 
        NULL::character varying AS gmde_alt, 
        quellen.txt_idx, 
        ST_GeometryType(quellen.wkb_geometry) AS geometrytype, 
        'Quellen'::character varying AS teilinventar, 
        quellen.foto1, 
        quellen.foto1_name, 
        quellen.foto2, 
        quellen.foto2_name
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
        ) AS quellen
        LEFT JOIN ingeso.code AS code_b 
            ON quellen.objektart_spez = code_b.code_id
        LEFT JOIN ingeso.code AS code_c 
            ON quellen.geol_sys_von = code_c.code_id
        LEFT JOIN ingeso.code AS code_d 
            ON quellen.geol_serie_von = code_d.code_id
        LEFT JOIN ingeso.code AS code_e 
            ON quellen.geol_stufe_von = code_e.code_id
        LEFT JOIN ingeso.code AS code_f 
            ON quellen.geol_schicht_von = code_f.code_id
        LEFT JOIN ingeso.code AS code_g 
            ON quellen.geol_schicht_von = code_g.code_id
        LEFT JOIN ingeso.code AS code_h 
            ON quellen.geol_serie_bis = code_h.code_id
        LEFT JOIN ingeso.code AS code_i 
            ON quellen.geol_stufe_bis = code_i.code_id
        LEFT JOIN ingeso.code AS code_j 
            ON quellen.geol_schicht_bis = code_j.code_id
        LEFT JOIN ingeso.code AS code_m 
            ON quellen.regio_geol_einheit = code_m.code_id
        LEFT JOIN ingeso.code AS code_n 
            ON quellen.fachbereich1 = code_n.code_id
        LEFT JOIN ingeso.code AS code_o 
            ON quellen.fachbereich2 = code_o.code_id
        LEFT JOIN ingeso.code AS code_p 
            ON quellen.fachbereich3 = code_p.code_id
        LEFT JOIN ingeso.code AS code_q 
            ON quellen.zustand = code_q.code_id
        LEFT JOIN ingeso.code AS code_r 
            ON quellen.bedeutung = code_r.code_id
        LEFT JOIN ingeso.code AS code_s 
            ON quellen.gefaehrdung = code_s.code_id
        LEFT JOIN ingeso.code AS code_t 
            ON quellen.schutzbedarf = code_t.code_id
        LEFT JOIN ingeso.code AS code_v 
            ON quellen.petrografie = code_v.code_id
        LEFT JOIN ingeso.code AS code_w 
            ON quellen.geowiss_wert = code_w.code_id, 
        ingeso.code       
    WHERE 
        quellen.archive = 0 
        AND 
        code.codeart_id = 19 
        AND 
        code.text::text = 'Höhlen/ Quellen'::text) AS punktobjekte
    LEFT JOIN sogis_bln
        ON 
            ST_DWithin(sogis_bln.wkb_geometry, punktobjekte.geometrie, 0)
            AND
            sogis_bln.archive = 0
    LEFT JOIN richtplan.arp_basdat
        ON 
            ST_DWithin(arp_basdat.wkb_geometry, punktobjekte.geometrie, 0)
            AND
            arp_basdat.archive = 0
            AND
            (
                arp_basdat.o_art IN (6000)
                OR
                arp_basdat.o_art IN (4000,5000)
            )
    LEFT JOIN richtplan.arp_natres
        ON 
            ST_DWithin(arp_natres.wkb_geometry, punktobjekte.geometrie, 0)
            AND
            arp_natres.archive = 0
GROUP BY
    t_id,
    ingeso_oid, 
    ingesonr_alt,
    geometrie,
    xkoord, 
    ykoord,
    objektart_spez,
    lokalname,
    regio_geol_einheit,
    objektname,
    geol_sys_von,
    geol_serie_von,
    geol_stufe_von,
    geol_schicht_von,
    geol_sys_bis,
    geol_serie_bis,
    geol_stufe_bis,
    geol_schicht_bis,
    petrografie,
    landschaftstyp,
    groesse,
    eiszeit,
    herkunft,
    schalenstein,
    fundgegenstaende,
    objektart_allg,
    bedeutung,
    zustand,
    gefaehrdung,
    geowiss_wert,
    kurzbeschreibung,
    schutzbedarf,
    rrb_nr,
    rrb_date,
    fachbereich1,
    fachbereich2,
    fachbereich3,
    quelle,
    nsinventar_nr,
    aufenthaltsort,
    gmde_alt,
    txt_idx,
    geometrytype,
    teilinventar,
    foto1,
    foto1_name,
    foto2,
    foto2_name
;