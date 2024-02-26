SELECT
    t_ili_tid,
    geometrie,
    schutzbauten_id,
    'Wasser' AS hauptprozess,
    'Wasser' AS hauptprozess_txt,
    false AS weiterer_prozess_wasser,
    false AS weiterer_prozess_wasser_txt,
    weiterer_prozess_rutschung,
    weiterer_prozess_rutschung AS weiterer_prozess_rutschung_txt,
    weiterer_prozess_sturz,
    weiterer_prozess_sturz AS weiterer_prozess_sturz_txt,
    'Wasser.Schutz_vor_Ueberflutung_Uebersarung.Mauer' AS werksart,
    'Wasser.Schutz_vor_Ueberflutung_Uebersarung.Mauer' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    laenge AS laenge,
    NULL AS breite, -- nicht vorhanden
    NULL AS hoehe, -- nicht vorhanden
    hoehe_zum_umland AS hoehe_zum_umland,
    NULL AS flaeche, -- nicht vorhanden
    NULL AS rueckhaltevolumen, -- nicht vorhanden
    erstellungsjahr,
    erhaltungsverantwortung_kategorie,
    kt.dispname AS erhaltungsverantwortung_kategorie_txt,
    erhaltungsverantwortung_name,
    zustand,    
    zt.dispname AS zustand_txt,
    zustandsbeurteilung_jahr,
    wirksamkeit,
    wt.dispname AS wirksamkeit_txt,
    bemerkungen,
    NULL AS dokumente
FROM afu_schutzbauten_v1.wasser_mauer wm
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = wm.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = wm.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = wm.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = wm.wirksamkeit

UNION

-- wasser_rueckhaltebauwerk, Art = Schwemmholzrueckhaltebauwerk

SELECT
    t_ili_tid,
    geometrie,
    schutzbauten_id,
    'Wasser' AS hauptprozess,
    'Wasser' AS hauptprozess_txt,
    false AS weiterer_prozess_wasser,
    false AS weiterer_prozess_wasser_txt,
    weiterer_prozess_rutschung,
    weiterer_prozess_rutschung AS weiterer_prozess_rutschung_txt,
    weiterer_prozess_sturz,
    weiterer_prozess_sturz AS weiterer_prozess_sturz_txt,
    'Wasser.Rueckhalt.Schwemmholzrueckhaltebauwerk' AS werksart,
    'Wasser.Rueckhalt.Schwemmholzrueckhaltebauwerk' AS werksart_txt,
    material,
    bt.dispname AS material_txt,
    NULL AS laenge, -- nicht vorhanden
    breite, 
    hoehe, 
    NULL AS hoehe_zum_umland, -- nicht vorhanden
    NULL AS flaeche, -- nicht vorhanden
    rueckhaltevolumen,
    erstellungsjahr,
    erhaltungsverantwortung_kategorie,
    kt.dispname AS erhaltungsverantwortung_kategorie_txt,
    erhaltungsverantwortung_name,
    zustand,    
    zt.dispname AS zustand_txt,
    zustandsbeurteilung_jahr,
    wirksamkeit,
    wt.dispname AS wirksamkeit_txt,
    bemerkungen,
    NULL AS dokumente
FROM afu_schutzbauten_v1.wasser_rueckhaltebauwerk rhbw
JOIN
    afu_schutzbauten_v1.baumaterial_typ bt
        ON bt.ilicode = rhbw.material
JOIN
    afu_schutzbauten_v1.koerperschaft_typ kt
        ON kt.ilicode = rhbw.erhaltungsverantwortung_kategorie
JOIN
    afu_schutzbauten_v1.beurteilung_typ zt
        ON zt.ilicode = rhbw.zustand
JOIN
    afu_schutzbauten_v1.wirksamkeit_typ wt
        ON wt.ilicode = rhbw.wirksamkeit
WHERE
    rhbw.art = 'Schwemmholzrueckhaltebauwerk'