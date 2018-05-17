SELECT
    flaecheid AS t_id,
    wkb_geometry AS geometrie,
    belastungstyp,
    CASE
        WHEN belastungstyp = 1
            THEN 'Bodenbelastungsgebiet'
        WHEN belastungstyp = 2
            THEN 'Eisenbahn inkl. Bahnhofareal'
        WHEN belastungstyp = 3
            THEN 'Flugplatz'
        WHEN belastungstyp = 5
            THEN 'Hopfenbaugebiet'
        WHEN belastungstyp = 6
            THEN 'Rebbaugebiet'
        WHEN belastungstyp = 7
            THEN 'Schiessanlage'
        WHEN belastungstyp = 8
            THEN 'Familiengarten'
        WHEN belastungstyp = 9
            THEN 'Siedlungsgebiet'
        WHEN belastungstyp = 11
            THEN 'Strasse'
        WHEN belastungstyp = 12 OR belastungstyp = 10 OR belastungstyp = 221
            THEN 'Korrosionsgeschützte Objekte'
        WHEN belastungstyp = 220
            THEN 'Gärtnerei'
    END AS belastungstyp_txt,
    CASE
        WHEN belastungstyp = 1
            THEN 'Bodenbelastungsgebiet'
        WHEN belastungstyp = 2
            THEN 'Eisenbahn'
        WHEN belastungstyp = 3
            THEN 'Flugplatz'
        WHEN belastungstyp = 5
            THEN 'Hopfenbaugebiet'
        WHEN belastungstyp = 6
            THEN 'Rebbaugebiet'
        WHEN belastungstyp = 7
            THEN 'Schiessanlage'
        WHEN belastungstyp = 8
            THEN 'Familiengarten'
        WHEN belastungstyp = 9
            THEN 'Siedlungsgebiet'
        WHEN belastungstyp = 11
            THEN 'Strasse'
        WHEN belastungstyp = 12 OR belastungstyp = 10 OR belastungstyp = 221
            THEN 'Korrosionsgeschützte Objekte'
        WHEN belastungstyp = 220
            THEN 'Gärtnerei'
    END AS verursacher,
    CASE 
        WHEN belastungstyp = 2 AND bezeichnung = '0'
            THEN ''
        WHEN belastungstyp = 2 AND bezeichnung = '5'
            THEN '20''000 - 50''000 GBRT'
        WHEN belastungstyp = 2 AND bezeichnung = '10'
            THEN '> 50''000 GBRT'
        WHEN belastungstyp = 3 OR belastungstyp = 1
            THEN 'Einzelfallerhebung'
        WHEN belastungstyp = 5
            THEN 'Nutzungszeitraum > 15 Jahre'
        WHEN belastungstyp = 6
            THEN 'Seit 1920 jemals Rebbaugebiet, Nutzungszeitraum > 15 Jahre'
        WHEN belastungstyp = 7
            THEN 'Schützenhaus in Schiessrichtung'
        WHEN belastungstyp = 8
            THEN 'Alle Familiengärten mit Nutzungsdauer > 15 Jahre'
        WHEN belastungstyp = 9
            THEN ''
        WHEN belastungstyp = 10
            THEN 'Stahlbrücke'
        WHEN belastungstyp = 11 AND bezeichnung = '5'
            THEN '3''000 - 20''000 DTV'
        WHEN belastungstyp = 11 AND bezeichnung = '10'
            THEN '20''000 - 50''000 DTV'
        WHEN belastungstyp = 11 AND bezeichnung = '15'
            THEN '> 50''000 DTV'
        WHEN belastungstyp = 12
            THEN 'Stahlmast'
        WHEN belastungstyp =  220
            THEN 'Nutzungszeitraum > 10 Jahre'
        WHEN belastungstyp = 221
            THEN 'Umspannwerk'
    END AS trennkriterium_1,
    CASE 
        WHEN belastungstyp = 7
            THEN 'Kugelfang 300m Anlage, Kugelfang 25 und 50m Anlage'
    END AS trennkriterium_2,
    CASE    
        WHEN belastungstyp = 7
            THEN 'Jagdschiessanlage / Tontaubenschiessanlage'
    END AS trennkriterium_3,
    CASE
        WHEN belastungstyp = 1 AND bezeichnung = '199'
            THEN 'Fläche mit nachgewiesener Schadstoffbelastung: Richtwertzone'
        WHEN belastungstyp = 1 AND (bezeichnung = '18' OR bezeichnung = '19' OR bezeichnung = '20' OR bezeichnung = '200')
            THEN 'Fläche mit nachgewiesener Schadstoffbelastung: Prüfwertzone'
        WHEN belastungstyp = 1 AND bezeichnung = '17'
            THEN 'Fläche mit nachgewiesener Schadstoffbelastung: Sanierungswertzone'
        WHEN belastungstyp = 2 AND bezeichnung = '0'
            THEN 'betroffene Fläche'
        WHEN belastungstyp = 2 AND bezeichnung = '5'
            THEN '5m seitlich ab Schotterrand (die Darstellung ist nicht lagegenau)'
        WHEN belastungstyp = 2 AND bezeichnung = '10'
            THEN '10m seitlich ab Schotterrand (die Darstellung ist nicht lagegenau)'
        WHEN belastungstyp = 3 
            THEN 'Flughafenareal'
        WHEN belastungstyp = 7
            THEN '10m vor Schützenhaus'
        WHEN belastungstyp = 8 OR belastungstyp = 220 OR belastungstyp = 6 OR belastungstyp = 5 OR belastungstyp = 221
            THEN 'betroffene Fläche'
        WHEN belastungstyp = 9
            THEN 'Ausdehnung des Siedlungsgebiets 1955'
        WHEN belastungstyp = 10
            THEN '20m zum Objekt'
        WHEN belastungstyp = 11 AND bezeichnung = '5'
            THEN '5m seitlich ab Fahrbahnrand (die Darstellung ist nicht lagegenau)'
        WHEN belastungstyp = 11 AND bezeichnung = '10'
            THEN '10m seitlich ab Fahrbahnrand (die Darstellung ist nicht lagegenau)'
        WHEN belastungstyp = 11 AND bezeichnung = '15'
            THEN '15m seitlich ab Fahrbahnrand (die Darstellung ist nicht lagegenau)'
        WHEN belastungstyp = 12
            THEN 'Übertragungsleitungsmast vor 1970 erbaut - 25m zum Objekt,<br>Übertragungsleitungsmast nach 1970 erbaut und alle weiteren Stahlmasten - 10m zum Objekt'
    END AS ausdehnung_belastungsflaeche_1,
    CASE
        WHEN belastungstyp = 7
            THEN 'entspricht dem Eintrag im Kataster der belasteten Standorte'
    END AS ausdehnung_belastungsflaeche_2,
    CASE
        WHEN belastungstyp = 7
            THEN 'entspricht dem Eintrag im Kataster der belasteten Standorte'
    END AS ausdehnung_belastungsflaeche_3,
    CASE
        WHEN belastungstyp = 1
            THEN 'abhängig vom Emittenten'
        WHEN belastungstyp = 2
            THEN 'Abrieb von Fahrleitungen, Stromabnehmern, Rädern, Schienen, Bremsbelägen'
        WHEN belastungstyp = 3
            THEN 'Pneu, Treibstoff'
        WHEN belastungstyp = 5
            THEN 'Pflanzenschutzmittel'
        WHEN belastungstyp = 6
            THEN 'Pflanzenschutzmittel, Abfalldünger'
        WHEN belastungstyp = 7
            THEN 'Zündkapselinhaltsstoffe, Projektilabrieb'
        WHEN belastungstyp = 8
            THEN 'Gartenhilfsstoffe, Pflanzenschutzmittel, Dünger, Kompost, Asche, Kehrichtkompost und -schlacke'
        WHEN belastungstyp = 9
            THEN 'Asche, Gartenhilfsstoffe, Pflanzenschutzmittel, Dünger, Farbanstriche, Kompost, Kehrichtkompost und -schlacke'
        WHEN belastungstyp = 11
            THEN 'Abgasemissionen, Abrieb von Strassenbelägen, Bremsbelägen und Pneus'
        WHEN belastungstyp = 12 OR belastungstyp = 10
            THEN 'Verwitterung / Abrieb Korrosionsschutz'
        WHEN belastungstyp = 220
            THEN 'Gartenhilfsstoffe, Pflanzenschutzmittel, Dünger, Kompost, Asche'
        WHEN belastungstyp = 221
            THEN 'Verwitterung / Abrieb Korrosionsschutz, Transformatorenöl'
    END AS belastungsursache_1,
    CASE
        WHEN belastungstyp = 7
            THEN 'Projektilfragmente, Projektilabrieb'
    END AS belastungsursache_2,
    CASE    
        WHEN belastungstyp = 7
            THEN 'Projektilfragmente, Projektilabrieb, Tontauben'
    END AS belastungsursache_3,
    CASE 
        WHEN belastungstyp = 1
            THEN 'abhängig vom Emittenten'
        WHEN belastungstyp = 2
            THEN 'Cu, Cd'
        WHEN belastungstyp = 3
            THEN 'Pb, PAK'
        WHEN belastungstyp = 6 OR belastungstyp = 5
            THEN 'Cu'
        WHEN belastungstyp = 7
            THEN 'Hg, Pb'
        WHEN belastungstyp = 8 OR belastungstyp = 220
            THEN 'Pb, Cd, Cu, Zn, Hg, PAK'
        WHEN belastungstyp = 9
            THEN 'Pb, Cd, Cu, Zn, PAK'
        WHEN belastungstyp = 11
            THEN 'Pb, Zn, PAK'
        WHEN belastungstyp = 12 OR belastungstyp = 10 OR belastungstyp = 221
            THEN 'Pb, Zn, Cr, PCB, PAK'
    END AS schadstoffe_1,
    CASE
        WHEN belastungstyp = 7
            THEN 'Pb, Sb'
    END AS schadstoffe_2,
    CASE
        WHEN belastungstyp = 7
            THEN 'Pb, Sb, PAK'
    END AS schadstoffe_3,
    statustyp,
    bezeichnung,
    anz_order,
    'docs/ch.so.afu.luftbelastung/was_ist_zu_tun.pdf' AS was_ist_zu_tun_dokument,
     CASE
        WHEN belastungstyp = 1
            THEN 'https://www.so.ch/verwaltung/bau-und-justizdepartement/amt-fuer-umwelt/boden-untergrund-geologie/boden/bodenbelastungsgebiete/'
        WHEN 
            belastungstyp = 2
            OR
            belastungstyp = 3
            OR
            belastungstyp = 5
            OR
            belastungstyp = 6
            OR 
            belastungstyp = 8
            OR
            belastungstyp = 9
            OR 
            belastungstyp = 10
            OR 
            belastungstyp = 11
            OR
            belastungstyp = 12
            OR
            belastungstyp = 220
            OR
            belastungstyp = 221
            THEN 'https://www.so.ch/verwaltung/bau-und-justizdepartement/amt-fuer-umwelt/boden-untergrund-geologie/boden/pruefperimeter-bodenabtrag/'
        WHEN belastungstyp = 7
            THEN 'https://www.so.ch/verwaltung/bau-und-justizdepartement/amt-fuer-umwelt/boden-untergrund-geologie/altlasten-belastete-standorte/schiessanlagen/'
    END AS weitere_infos
FROM
    vsb.afu_pruefperimeter_qgis_server_client_t
;