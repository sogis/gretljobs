SELECT 
    aufschluesse.ingeso_id AS t_id, 
    aufschluesse.ingeso_oid, 
    aufschluesse.ingesonr_alt, 
    ST_Multi(aufschluesse.wkb_geometry) AS geometrie, 
    round(ST_X(ST_Centroid(aufschluesse.wkb_geometry))::numeric, 0) AS xkoord, 
    round(ST_Y(ST_Centroid(aufschluesse.wkb_geometry))::numeric, 0) AS ykoord, 
    code_b.text AS objektart_spez, 
    aufschluesse.lokalname, 
    code_m.text AS regio_geol_einheit, 
    aufschluesse.objektname, 
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
    code_a.text AS objektart_allg, 
    code_r.text AS bedeutung, 
    code_q.text AS zustand, 
    code_s.text AS gefaehrdung, 
    code_w.text AS geowiss_wert, 
    aufschluesse.kurzbeschreibung, 
    code_t.text AS schutzbedarf, 
    aufschluesse.rrb_nr, 
    aufschluesse.rrb_date, 
    code_n.text AS fachbereich1, 
    code_o.text AS fachbereich2, 
    code_p.text AS fachbereich3, 
    aufschluesse.quelle, 
    aufschluesse.nsinventar_nr, 
    NULL::character varying AS aufenthaltsort, 
    aufschluesse.gmde_alt, 
    aufschluesse.txt_idx, 
    ST_GeometryType(aufschluesse.wkb_geometry) AS geometrytype, 
    code.text AS teilinventar, 
    aufschluesse.foto1, 
    aufschluesse.foto1_name, 
    aufschluesse.foto2, 
    aufschluesse.foto2_name
FROM 
    ingeso.aufschluesse
    LEFT JOIN ingeso.code AS code_a 
        ON aufschluesse.objektart_allg = code_a.code_id
    LEFT JOIN ingeso.code AS code_b 
        ON aufschluesse.objektart_spez = code_b.code_id
    LEFT JOIN ingeso.code AS code_c 
        ON aufschluesse.geol_sys_von = code_c.code_id
    LEFT JOIN ingeso.code AS code_d 
        ON aufschluesse.geol_serie_von = code_d.code_id
    LEFT JOIN ingeso.code AS code_e 
        ON aufschluesse.geol_stufe_von = code_e.code_id
    LEFT JOIN ingeso.code AS code_f 
        ON aufschluesse.geol_schicht_von = code_f.code_id
    LEFT JOIN ingeso.code AS code_g 
        ON aufschluesse.geol_schicht_von = code_g.code_id
    LEFT JOIN ingeso.code AS code_h 
        ON aufschluesse.geol_serie_bis = code_h.code_id
    LEFT JOIN ingeso.code AS code_i 
        ON aufschluesse.geol_stufe_bis = code_i.code_id
    LEFT JOIN ingeso.code AS code_j 
        ON aufschluesse.geol_schicht_bis = code_j.code_id
    LEFT JOIN ingeso.code AS code_m 
        ON aufschluesse.regio_geol_einheit = code_m.code_id
    LEFT JOIN ingeso.code AS code_n 
        ON aufschluesse.fachbereich1 = code_n.code_id
    LEFT JOIN ingeso.code AS code_o 
        ON aufschluesse.fachbereich2 = code_o.code_id
    LEFT JOIN ingeso.code AS code_p 
        ON aufschluesse.fachbereich3 = code_p.code_id
    LEFT JOIN ingeso.code AS code_q 
        ON aufschluesse.zustand = code_q.code_id
    LEFT JOIN ingeso.code AS code_r 
        ON aufschluesse.bedeutung = code_r.code_id
    LEFT JOIN ingeso.code AS code_s 
        ON aufschluesse.gefaehrdung = code_s.code_id
    LEFT JOIN ingeso.code AS code_t 
        ON aufschluesse.schutzbedarf = code_t.code_id
    LEFT JOIN ingeso.code AS code_v 
        ON aufschluesse.petrografie = code_v.code_id
    LEFT JOIN ingeso.code AS code_w 
        ON aufschluesse.geowiss_wert = code_w.code_id, 
    ingeso.code
WHERE 
    aufschluesse.archive = 0 
    AND 
    code.codeart_id = 19 
    AND 
    code.text::text = 'Aufschlüsse'::text
    
UNION 

SELECT 
    landsformen.ingeso_id AS t_id, 
    landsformen.ingeso_oid, 
    landsformen.ingesonr_alt, 
    ST_Multi(landsformen.wkb_geometry) AS geometrie, 
    round(ST_X(ST_Centroid(landsformen.wkb_geometry))::numeric, 0) AS xkoord, 
    round(ST_Y(ST_Centroid(landsformen.wkb_geometry))::numeric, 0) AS ykoord, 
    code_b.text AS objektart_spez, 
    landsformen.lokalname, 
    code_m.text AS regio_geol_einheit, 
    landsformen.objektname, 
    NULL::character varying AS geol_sys_von, 
    NULL::character varying AS geol_serie_von, 
    NULL::character varying AS geol_stufe_von, 
    NULL::character varying AS geol_schicht_von, 
    NULL::character varying AS geol_sys_bis, 
    NULL::character varying AS geol_serie_bis, 
    NULL::character varying AS geol_stufe_bis, 
    NULL::character varying AS geol_schicht_bis, 
    NULL::character varying AS petrografie, 
    code_v.text AS landschaftstyp, 
    NULL::character varying AS groesse, 
    NULL::character varying AS eiszeit, 
    NULL::character varying AS herkunft, 
    NULL::character varying AS schalenstein, 
    NULL::character varying AS fundgegenstaende, 
    code_a.text AS objektart_allg, 
    code_r.text AS bedeutung, 
    code_q.text AS zustand, 
    code_s.text AS gefaehrdung, 
    code_w.text AS geowiss_wert, 
    landsformen.kurzbeschreibung, 
    code_t.text AS schutzbedarf, 
    landsformen.rrb_nr, 
    landsformen.rrb_date, 
    code_n.text AS fachbereich1, 
    code_o.text AS fachbereich2, 
    code_p.text AS fachbereich3, 
    landsformen.quelle, 
    landsformen.nsinventar_nr, 
    NULL::character varying AS aufenthaltsort, 
    landsformen.gmde_alt, 
    landsformen.txt_idx, 
    geometrytype(landsformen.wkb_geometry) AS geometrytype, 
    code.text AS teilinventar, 
    landsformen.foto1, 
    landsformen.foto1_name, 
    landsformen.foto2, 
    landsformen.foto2_name
FROM 
    ingeso.landsformen
    LEFT JOIN ingeso.code AS code_a 
        ON landsformen.objektart_allg = code_a.code_id
    LEFT JOIN ingeso.code AS code_b 
        ON landsformen.objektart_spez = code_b.code_id
    LEFT JOIN ingeso.code AS code_m 
        ON landsformen.regio_geol_einheit = code_m.code_id
    LEFT JOIN ingeso.code AS code_n 
        ON landsformen.fachbereich1 = code_n.code_id
    LEFT JOIN ingeso.code AS code_o 
        ON landsformen.fachbereich2 = code_o.code_id
    LEFT JOIN ingeso.code AS code_p 
        ON landsformen.fachbereich3 = code_p.code_id
    LEFT JOIN ingeso.code AS code_q 
        ON landsformen.zustand = code_q.code_id
    LEFT JOIN ingeso.code AS code_r 
        ON landsformen.bedeutung = code_r.code_id
    LEFT JOIN ingeso.code AS code_s 
        ON landsformen.gefaehrdung = code_s.code_id
    LEFT JOIN ingeso.code AS code_t 
        ON landsformen.schutzbedarf = code_t.code_id
    LEFT JOIN ingeso.code AS code_v 
        ON landsformen.landschaftstyp = code_v.code_id
    LEFT JOIN ingeso.code AS code_w 
        ON landsformen.geowiss_wert = code_w.code_id, 
    ingeso.code
WHERE 
    landsformen.archive = 0 
    AND 
    code.codeart_id = 19 
    AND 
    code.text::text = 'Landschaftsformen'::text