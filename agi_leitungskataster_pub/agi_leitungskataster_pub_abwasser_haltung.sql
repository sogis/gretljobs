SELECT 
    abw_haltung.t_id, 
    abw_haltung.verlauf AS geometrie, 
    abw_haltung.baujahr, 
    abw_haltung.bw_bezeichnung AS bezeichnung, 
    abw_haltung.baulicherzustand AS baulicherzustand, 
    abw_haltung.bezeichnung AS eigentuemer, 
    abw_haltung.astatus AS status, 
    abw_haltung.zugaenglichkeit AS zugaenglichkeit, 
    abw_haltung.von_kote AS kote_von, 
    abw_haltung.nach_kote AS kote_nach, 
    abw_haltung.lichte_hoehe, 
    abw_haltung.lagebestimmung AS lagebestimmung, 
    abw_haltung.material AS material, 
    CASE
        WHEN abw_haltung.material::text = 'Asbestzement'::text THEN 'AZ'::text
        WHEN abw_haltung.material::text = 'Beton_Normalbeton'::text THEN 'BN'::text
        WHEN abw_haltung.material::text = 'Beton_Ortsbeton'::text THEN 'BO'::text
        WHEN abw_haltung.material::text = 'Beton_Pressrohrbeton'::text THEN 'B'::text
        WHEN abw_haltung.material::text = 'Beton_Spezialbeton'::text THEN 'BS'::text
        WHEN abw_haltung.material::text = 'Beton_unbekannt'::text THEN 'B'::text
        WHEN abw_haltung.material::text = 'Faserzement'::text THEN 'FZ'::text
        WHEN abw_haltung.material::text = 'Guss_duktil'::text THEN 'GD'::text
        WHEN abw_haltung.material::text = 'Guss_Grauguss'::text THEN 'GG'::text
        WHEN abw_haltung.material::text = 'Kunststoff_Epoxydharz'::text THEN 'K'::text
        WHEN abw_haltung.material::text = 'Kunststoff_Hartpolyethylen'::text THEN 'HDPE'::text
        WHEN abw_haltung.material::text = 'Kunststoff_Polyester_GUP'::text THEN 'GUP'::text
        WHEN abw_haltung.material::text = 'Kunststoff_Polyethylen'::text THEN 'PE'::text
        WHEN abw_haltung.material::text = 'Kunststoff_Polypropylen'::text THEN 'PP'::text
        WHEN abw_haltung.material::text = 'Kunststoff_Polyvinilchlorid'::text THEN 'PVZ'::text
        WHEN abw_haltung.material::text = 'Kunststoff_unbekannt'::text THEN 'K'::text
        WHEN abw_haltung.material::text = 'Stahl'::text THEN 'STE'::text
        WHEN abw_haltung.material::text = 'Stahl_rostfrei'::text THEN 'STE'::text
        WHEN abw_haltung.material::text = 'Steinzeug'::text THEN 'ST'::text
        WHEN abw_haltung.material::text = 'Ton'::text THEN 'T'::text
        WHEN abw_haltung.material::text = 'Zement'::text THEN 'Z'::text
        ELSE ''::text
    END as material_kurz,
    abw_haltung.profiltyp AS profil, 
    CASE
        WHEN abw_haltung.laengeeffektiv > 0::double precision THEN abw_haltung.laengeeffektiv
        ELSE kanal.rohrlaenge
    END AS laenge, 
    CASE
        WHEN abw_haltung.laengeeffektiv > 0::double precision THEN round(((abw_haltung.von_kote - abw_haltung.nach_kote) / abw_haltung.laengeeffektiv * 1000::double precision)::numeric, 1)
        ELSE round(((abw_haltung.von_kote - abw_haltung.nach_kote) / kanal.rohrlaenge * 1000::double precision)::numeric, 1)
    END AS gefaelle, 
    kanal.funktionhierarchisch AS funktionhierarchisch, 
    kanal.funktionhydraulisch AS funktionhydraulisch, 
    kanal.nutzungsart AS nutzungsart, 
    kanal.spuelintervall, 
    CASE
        WHEN kanal.nutzungsart::text = 'Mischabwasser'::text THEN '#660066'::text
        WHEN kanal.nutzungsart::text = 'Schmutzabwasser'::text THEN '#FF0000'::text
        WHEN kanal.nutzungsart::text = 'Reinabwasser'::text THEN '#0000FF'::text
        WHEN kanal.nutzungsart::text = 'Regenabwasser'::text THEN '#0000FF'::text
        WHEN kanal.nutzungsart::text = 'Bachabwasser'::text THEN '#0000FF'::text
        WHEN kanal.nutzungsart::text = 'entlastetes_Mischabwasser'::text THEN '#00FF00'::text
        WHEN kanal.nutzungsart::text = 'Industrieabwasser'::text THEN '#FF0000'::text
        WHEN kanal.nutzungsart::text = 'unbekannt'::text THEN '#A1A1A1'::text
        WHEN kanal.nutzungsart::text = 'andere'::text THEN '#FF6600'::text
        ELSE '#000000'::text
    END AS fontcolor
FROM 
    (SELECT bauwerk.t_id AS bw_tid,
        haltung.t_id, 
        haltung.verlauf, 
        haltung.laengeeffektiv, 
        bauwerk.baujahr, 
        bauwerk.bezeichnung AS bw_bezeichnung, 
        bauwerk.baulicherzustand, 
        organisation.bezeichnung, 
        bauwerk.astatus, 
        bauwerk.zugaenglichkeit, 
        haltungspunkt.kote AS von_kote, 
        hp_nach.kote AS nach_kote, 
        haltung.lichte_hoehe, 
        haltung.lagebestimmung, 
        haltung.material, 
        rohrprofil.profiltyp
    FROM agi_leitungskataster_abw.sia405_abwassr_wi_haltung haltung
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_abwassernetzelement netzelement ON netzelement.t_id::text = haltung.superclass::text
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_haltungspunkt haltungspunkt ON haltung.vonhaltungspunkt::text = haltungspunkt.t_id::text
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_haltungspunkt hp_nach ON haltung.nachhaltungspunkt::text = hp_nach.t_id::text
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_abwasserbauwerk bauwerk ON netzelement.abwasserbauwerk::text = bauwerk.t_id::text
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_organisation organisation ON bauwerk.eigentuemer::text = organisation.t_id::text
    LEFT JOIN agi_leitungskataster_abw.sia405_abwassr_wi_rohrprofil rohrprofil ON rohrprofil.t_id::text = haltung.rohrprofil::text
ORDER BY haltung.t_id) abw_haltung
LEFT JOIN 
    (SELECT DISTINCT ON (sia405_abwassr_wi_kanal.superclass)  
        sia405_abwassr_wi_kanal.t_id, 
        sia405_abwassr_wi_kanal.obj_id, 
        sia405_abwassr_wi_kanal.superclass, 
        sia405_abwassr_wi_kanal.bettung_umhuellung, 
        sia405_abwassr_wi_kanal.funktionhierarchisch, 
        sia405_abwassr_wi_kanal.funktionhydraulisch, 
        sia405_abwassr_wi_kanal.nutzungsart, 
        sia405_abwassr_wi_kanal.rohrlaenge, 
        sia405_abwassr_wi_kanal.spuelintervall, 
        sia405_abwassr_wi_kanal.verbindungsart, 
        sia405_abwassr_wi_kanal.t_datasetname
    FROM agi_leitungskataster_abw.sia405_abwassr_wi_kanal) kanal ON kanal.superclass::text = abw_haltung.bw_tid::text
;
