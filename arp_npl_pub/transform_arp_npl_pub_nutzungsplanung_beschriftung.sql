WITH beschriftung AS (
    ---- Beschriftung Grundnutzung
    SELECT 
        grundnutzung.t_id,
        grundnutzung.t_datasetname,
        grundnutzung.t_ili_tid,
        typ_grundnutzung.typ_kt,
        typ_grundnutzung.code_kommunal,
        typ_grundnutzung.bezeichnung,
        typ_grundnutzung.abkuerzung,
        typ_grundnutzung.verbindlichkeit,
        typ_grundnutzung.bemerkungen as typ_bemerkungen,
        pos.pos, 
        pos.ori,
        pos.hali,
        pos.vali,
        pos.groesse,
        'Grundnutzung' AS beschriftung_fuer
    FROM 
        arp_npl.nutzungsplanung_grundnutzung_pos AS pos
        LEFT JOIN arp_npl.nutzungsplanung_grundnutzung AS grundnutzung
        ON pos.grundnutzung = grundnutzung.t_id
        LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung AS typ_grundnutzung 
        ON typ_grundnutzung.t_id = grundnutzung.typ_grundnutzung

    UNION

    ---- Beschriftung ueberlagernde Flaeche
     SELECT 
        ueberlagernd_flaeche.t_id,
        ueberlagernd_flaeche.t_datasetname,
        ueberlagernd_flaeche.t_ili_tid,
        typ_ueberlagernd_flaeche.typ_kt,
        typ_ueberlagernd_flaeche.code_kommunal,
        typ_ueberlagernd_flaeche.bezeichnung,
        typ_ueberlagernd_flaeche.abkuerzung,
        typ_ueberlagernd_flaeche.verbindlichkeit,
        typ_ueberlagernd_flaeche.bemerkungen as typ_bemerkungen,
        pos.pos, 
        pos.ori,
        pos.hali,
        pos.vali,
        pos.groesse,
        'ueberlagernd_Flaeche' AS beschriftung_fuer
    FROM 
        arp_npl.nutzungsplanung_ueberlagernd_flaeche_pos AS pos
        LEFT JOIN arp_npl.nutzungsplanung_ueberlagernd_flaeche AS ueberlagernd_flaeche
        ON pos.ueberlagernd_flaeche = ueberlagernd_flaeche.t_id
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche AS typ_ueberlagernd_flaeche
        ON typ_ueberlagernd_flaeche.t_id = ueberlagernd_flaeche.typ_ueberlagernd_flaeche

    UNION

    ---- Beschriftung ueberlagernde Linie
    SELECT 
        ueberlagernd_linie.t_id,
        ueberlagernd_linie.t_datasetname,
        ueberlagernd_linie.t_ili_tid,
        typ_ueberlagernd_linie.typ_kt,
        typ_ueberlagernd_linie.code_kommunal,
        typ_ueberlagernd_linie.bezeichnung,
        typ_ueberlagernd_linie.abkuerzung,
        typ_ueberlagernd_linie.verbindlichkeit,
        typ_ueberlagernd_linie.bemerkungen as typ_bemerkungen,
        pos.pos, 
        pos.ori,
        pos.hali,
        pos.vali,
        pos.groesse,
        'ueberlagernd_Linie' AS beschriftung_fuer
    FROM 
        arp_npl.nutzungsplanung_ueberlagernd_linie_pos AS pos
        LEFT JOIN arp_npl.nutzungsplanung_ueberlagernd_linie AS ueberlagernd_linie
        ON pos.ueberlagernd_linie = ueberlagernd_linie.t_id
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_linie AS typ_ueberlagernd_linie
        ON typ_ueberlagernd_linie.t_id = ueberlagernd_linie.typ_ueberlagernd_linie 
         
    ---- Beschriftung ueberlagernd Punkt
             
    UNION
    
    SELECT 
        ueberlagernd_punkt.t_id,
        ueberlagernd_punkt.t_datasetname,
        ueberlagernd_punkt.t_ili_tid,
        typ_ueberlagernd_punkt.typ_kt,
        typ_ueberlagernd_punkt.code_kommunal,
        typ_ueberlagernd_punkt.bezeichnung,
        typ_ueberlagernd_punkt.abkuerzung,
        typ_ueberlagernd_punkt.verbindlichkeit,
        typ_ueberlagernd_punkt.bemerkungen as typ_bemerkungen,
        pos.pos, 
        pos.ori,
        pos.hali,
        pos.vali,
        pos.groesse,
        'ueberlagernd_Punkt' AS beschriftung_fuer

    FROM 
        arp_npl.nutzungsplanung_ueberlagernd_punkt_pos AS pos
        LEFT JOIN arp_npl.nutzungsplanung_ueberlagernd_punkt AS ueberlagernd_punkt
        ON pos.ueberlagernd_punkt = ueberlagernd_punkt.t_id
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_punkt AS typ_ueberlagernd_punkt
        ON typ_ueberlagernd_punkt.t_id = ueberlagernd_punkt.typ_ueberlagernd_punkt 
)		   
SELECT  
    g.t_datasetname::int4 AS bfs_nr,
    g.t_ili_tid,
    g.bezeichnung AS typ_bezeichnung,
    g.abkuerzung AS typ_abkuerzung,
    g.verbindlichkeit AS typ_verbindlichkeit,
    g.typ_bemerkungen,
    g.typ_kt,
    g.code_kommunal AS typ_code_kommunal,
    g.ori AS pos_ori,
    g.hali AS pos_hali,
    g.vali AS pos_vali,
    g.groesse AS pos_groesse,
    --g.beschriftung_fuer,
    g.pos
FROM 
    beschriftung AS g;