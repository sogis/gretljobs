SELECT 
    obs_id AS id_infoflora, 
    project_name AS datenquelle, 
    x, 
    y, 
    xy_precision AS kreisradius, 
    locality_descript AS fundortbeschreibung, 
    CASE   
        WHEN typo_ch = '1' 
            THEN 'Gewässer' 
        WHEN typo_ch = '2'
            THEN 'Ufer und Feuchtgebiete'
        WHEN typo_ch = '3'
            THEN 'Gletscher, Fels, Schutt und Geröll'
        WHEN typo_ch = '4'
            THEN 'Grünland (Naturrasen, Wiesen und Weiden)'
        WHEN typo_ch = '5' 
            THEN 'Krautsäume, Hochstaudenflure und Gebüsche'
        WHEN typo_ch = '6'
            THEN 'Wälder' 
        WHEN typo_ch = '7'
            THEN 'Pioniervegetation gestörter Plätze (Ruderalstandorte)'
        WHEN typo_ch = '8'
            THEN 'Pflanzungen, Äcker und Kulturen'
        WHEN typo_ch = '9'
            THEN 'Bauten, Anlagen'
        WHEN typo_ch LIKE '1.1%'
            THEN 'Stehendes Gewässer'
        WHEN typo_ch LIKE '1.2%'
            THEN 'Fliessgewässer' 
        WHEN typo_ch LIKE '1.3%'
            THEN 'Quellen und Quellfluren' 
        WHEN typo_ch LIKE '1.4%' 
            THEN 'Unterirdische Gewässer' 
        WHEN typo_ch LIKE '2.0%'
            THEN 'Künstliche Ufer'
        WHEN typo_ch LIKE '2.1%' 
            THEN 'Ufer mit Vegetation' 
        WHEN typo_ch LIKE '2.2%'
            THEN 'Flachmoore' 
        WHEN typo_ch LIKE '2.3%'
            THEN 'Feuchtwiesen' 
        WHEN typo_ch LIKE '2.4%'
            THEN 'Hochmoore' 
        WHEN typo_ch LIKE '2.5%'
            THEN 'Wechselfeuchte Pionierfluren'
        WHEN typo_ch LIKE '3.1%' 
            THEN 'Gletscher, Firn- und Schneefelder' 
        WHEN typo_ch LIKE '3.2%'
            THEN 'Alluvionen und Moränen' 
        WHEN typo_ch LIKE '3.3%'
            THEN 'Steinschutt und Geröllfluren'
        WHEN typo_ch LIKE '3.4%'
            THEN 'Felsen' 
        WHEN typo_ch LIKE '3.5%' 
            THEN 'Höhlen' 
        WHEN typo_ch LIKE '4.0%' 
            THEN 'Kunstrasen' 
        WHEN typo_ch LIKE '4.1%' 
            THEN 'Pionierfluren auf Felsböden (Felsgrasfluren)' 
        WHEN typo_ch LIKE '4.2%' 
            THEN 'Wärmeliebende Trockenrasen'
        WHEN typo_ch LIKE '4.3%' 
            THEN 'Gebirgs-Magerrasen'
        WHEN typo_ch LIKE '4.4%'
            THEN 'Schneetälchen'
        WHEN typo_ch LIKE '4.5%' 
            THEN 'Fettwiesen und - weiden'
        WHEN typo_ch LIKE '4.6%' 
            THEN 'Grasbrachen' 
        WHEN typo_ch LIKE '5.1%'
            THEN 'Krautsäume' 
        WHEN typo_ch LIKE '5.2%' 
            THEN 'Hochstauden- und Schlagfluren'
        WHEN typo_ch LIKE '5.3%' 
            THEN 'Gebüsche'
        WHEN typo_ch LIKE '5.4%' 
            THEN 'Zwergstrauchheiden' 
        WHEN typo_ch LIKE '6.0%'
            THEN 'Forstpflanzungen'
        WHEN typo_ch LIKE '6.1%'
            THEN 'Bruch- und Auenwälder'
        WHEN typo_ch LIKE '6.2%' 
            THEN 'Buchenwälder' 
        WHEN typo_ch LIKE '6.3%' 
            THEN 'Andere Laubwälder' 
        WHEN typo_ch LIKE '6.4%'
            THEN 'Wärmeliebende Föhrenwälder'
        WHEN typo_ch LIKE '6.5%'
            THEN 'Hochmoorwälder' 
        WHEN typo_ch LIKE '6.6%' 
            THEN 'Gebirgsnadelwälder' 
        WHEN typo_ch LIKE '7.1%' 
            THEN 'Trittrasen und Ruderalfluren'
        WHEN typo_ch LIKE '7.2%' 
            THEN 'Anthropogene Steinfluren' 
        WHEN typo_ch LIKE '8.1%' 
            THEN 'Baumschulen, Obstgärten, Rebberge' 
        WHEN typo_ch LIKE '8.2%'
            THEN 'Feldkulturen (Äcker)' 
        WHEN typo_ch LIKE '9.1%'
            THEN 'Lagerplätze, Deponien' 
        WHEN typo_ch LIKE '9.2%'
            THEN 'Bauten' 
        WHEN typo_ch LIKE '9.3%'
            THEN 'Verkehrswege'
        WHEN typo_ch LIKE '9.4%' 
            THEN 'Versiegelter Sportplatz, Parkplatz etc.'
        ELSE typo_ch 
    END AS lebensraum,  
    taxon_id AS schweizerflora_id, 
    taxon AS artenname_latein, 
    name_de AS artenname_deutsch, 
    list_type AS listentyp, 
    array_to_json(ARRAY[doc_1_path, doc_2_path, doc_3_path]) AS fotos, 
    obs_date AS beobachtungsdatum, 
    presence_descript AS auftreten, 
    releve_type_descript AS erfassungsmethode, 
    eradication_descript AS populationskontrolle_ergebnis, 
    control_type_descript AS bekaempfungsmethode, 
    cover_code_descript AS deckung, 
    CASE  
        WHEN count_unit_descript = 'Fläche [m²]' 
        THEN abundance_code_descript||' m2' 
        ELSE abundance_code_descript||' '||coalesce(count_unit_descript,'')  
    END AS abundanz, 
    obs_type_descript AS meldungstyp, 
    vitality_codes_descript entwicklung, 
    phenology_descript AS phaenologie, 
    v_doubt_status_descript AS validierungsstatus, 
    CASE 
        WHEN project_id IN (82056, 83505) 
            THEN v_observers 
        ELSE '(nicht publiziert)' 
    END AS beobachter, 
    remarks AS bemerkungen, 
    geometrie
FROM afu_infoflora.neophyten_neophytenstandorte
WHERE presence IN (681, 686); 


