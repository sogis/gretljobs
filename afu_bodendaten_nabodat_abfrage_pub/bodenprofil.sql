/*
----------------------------------------------------
-------------------- Beginn CTE --------------------
----------------------------------------------------
 */

WITH

standort AS (
    SELECT
        standort.t_id,
        standort.wald AS wald_id, -- Für Join mit punktdaten_wald
        standort.standortbeurteilung AS standortbeurteilung_id, -- Für Join mit punktdaten_standortbeurteilung
        standort.bfsnummer AS bfs_nummer_erfassung,
        standort.bfsnummeraktuell AS bfs_nummer,
        standort.flurname,
        standort.gemeinde,
        standort.gemeindeaktuell AS gemeinde_aktuell,
        standort.hoehe,
        standort.kanton,
        standort.koordinaten AS geometrie,
        st_x(standort.koordinaten)||' / '||st_y(standort.koordinaten) AS koordinaten,
        standort.standortid AS profilnummer
    FROM 
        afu_bodendaten_nabodat_v1.punktdaten_standort AS standort
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_projektstandort AS projektstandort
        ON standort.t_id = projektstandort.standort
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_projekt AS projekt
        ON projektstandort.projekt = projekt.t_id
    WHERE projekt.aname = 'Bodenkartierung Kt. SO'
),

standorteigenschaften AS (
    SELECT
        standorteigenschaften.t_id, -- Für Join mit Tabellen darunter
        standorteigenschaften.standort AS standort_id, -- Für Join mit punkdaten_standort
        standorteigenschaften.neigungprozent AS neigung,
        gelaendeform.codeid AS gelaendeform,
        gelaendeform.codetext_de AS gelaendeform_text,
        landschaftselement.codeid AS landschaftselement,
        landschaftselement.codetext_de AS landschaftselement_text,
        exposition.codeid AS exposition,
        exposition.codetext_de AS exposition_text,
        klimaeignungszone.codeid AS klimaeignungszone,
        klimaeignungszone.codetext_de AS klimaeignungszone_text,
        vegetation.codeid AS vegetation,
        vegetation.codetext_de AS vegetation_text,
        kleinrelief.codeid AS kleinrelief,
        kleinrelief.codetext_de AS kleinrelief_text
    FROM 
        afu_bodendaten_nabodat_v1.punktdaten_standorteigenschaften AS standorteigenschaften
    -- Geländeform --
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_gelaendeform AS gelaendeform
        ON standorteigenschaften.gelaendeform = gelaendeform.t_id
    -- Landschaftselement --
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_landschaftselement AS landschaftselement
        ON standorteigenschaften.landschaftselement = landschaftselement.t_id
    -- Exposition --
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_exposition AS exposition
        ON standorteigenschaften.exposition = exposition.t_id
    -- Klimaeignungszone --
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_klimaeignungszone AS klimaeignungszone
        ON standorteigenschaften.klimaeignungzone = klimaeignungszone.t_id
    -- Vegetation --
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_vegetation AS vegetation
        ON standorteigenschaften.vegetation = vegetation.t_id
    -- Kleinrelief --
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_kleinrelief AS kleinrelief
        ON standorteigenschaften.kleinrelief = kleinrelief.t_id
),

ausgangsmaterial AS (
    SELECT
        coalesce(standort_ausgangsmaterial_unten.codeid,'') || coalesce(standort_eiszeit_unten.codeid,'') AS ausgangsmaterial_alle,
        standort_ausgangsmaterial_oben.codeid AS ausgangsmaterial_oben,
        standort_ausgangsmaterial_oben.codetext_de AS ausgangsmaterial_oben_text,
        standort_ausgangsmaterial_unten.codeid AS ausgangsmaterial_unten,
        standort_ausgangsmaterial_unten.codetext_de AS ausgangsmaterial_unten_text,
        standort_eiszeit_oben.codeid AS eiszeit_oberboden,
        standort_eiszeit_oben.codetext_de AS eiszeit_oberboden_text,
        standort_eiszeit_unten.codeid AS eiszeit_unterboden,
        standort_eiszeit_unten.codetext_de AS eiszeit_unterboden_text,
        standorteigenschaften.standort_id -- Für JOIN mit punktdaten_standort
    FROM
        standorteigenschaften
    -- Ausgangsmaterial oben --
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_ausgangsmaterial AS punktdaten_ausgangsmaterial_oben
        ON standorteigenschaften.t_id = punktdaten_ausgangsmaterial_oben.punktdtn_strtgnschften_ausgangsmaterialoben
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_ausgangsmaterial AS standort_ausgangsmaterial_oben
        ON punktdaten_ausgangsmaterial_oben.ausgangsmaterial = standort_ausgangsmaterial_oben.t_id
    -- Ausgangsmaterial unten --
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_ausgangsmaterial AS punktdaten_ausgangsmaterial_unten
        ON standorteigenschaften.t_id = punktdaten_ausgangsmaterial_unten.punktdtn_strtgnschften_ausgangsmaterialunten
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_ausgangsmaterial AS standort_ausgangsmaterial_unten
        ON punktdaten_ausgangsmaterial_unten.ausgangsmaterial = standort_ausgangsmaterial_unten.t_id
    -- Eiszeit Oberboden --
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_ausgangsmaterial AS punktdaten_eiszeit_oben
        ON standorteigenschaften.t_id = punktdaten_eiszeit_oben.punktdtn_strtgnschften_ausgangsmaterialoben
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_eiszeit AS standort_eiszeit_oben
        ON punktdaten_eiszeit_oben.eiszeit = standort_eiszeit_oben.t_id
    -- Eiszeit Unterboden --
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_ausgangsmaterial AS punktdaten_eiszeit_unten
        ON standorteigenschaften.t_id = punktdaten_eiszeit_unten.punktdtn_strtgnschften_ausgangsmaterialunten
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_eiszeit AS standort_eiszeit_unten
        ON punktdaten_eiszeit_unten.eiszeit = standort_eiszeit_unten.t_id  
),

wald AS (
    SELECT
        wald.t_id, -- Für Join mit punktdaten_standort
        wald.waldproduktionspunkte AS produktionsfahigkeit_punkte,
        produktionsfaehigkeitwald.codeid AS produktionsfaehigkeitsstufe,
        produktionsfaehigkeitwald.codetext_de AS produktionsfaehigkeitsstufe_text,
        humusform.codeid AS humusform,
        humusform.codetext_de AS humusform_text
    FROM 
        afu_bodendaten_nabodat_v1.punktdaten_wald AS wald
    -- Produktionsfähigkeitsstufe Wald
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_produktionsfaehigkstufewald AS produktionsfaehigkeitwald
        ON wald.produktionsfaehigkstufewald = produktionsfaehigkeitwald.t_id
    -- Humusform
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_humusform AS humusform
        ON wald.humusform = humusform.t_id
),

melioration_empfohlen AS (
    SELECT 
        string_agg(meliorationempf.codeid,', ') AS melioration_empfohlen,
        string_agg(meliorationempf.codetext_de,', ') AS melioration_empfohlen_text,
        meliorationempf_ref.punktdaten_standort_empfohlenemelioration AS standort_id -- Für JOIN mit punktdaten_standort
    FROM 
        afu_bodendaten_nabodat_v1.codlstnpktstndort_meliorationempf AS meliorationempf
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_meliorationempf_ref AS meliorationempf_ref
        ON meliorationempf.t_id = meliorationempf_ref.areference
    GROUP BY 
        standort_id
),

melioration_festgestellt AS (
    SELECT 
        string_agg(meliorationfest.codeid,', ') AS melioration_festgestellt,
        string_agg(meliorationfest.codetext_de,', ') AS melioration_festgestellt_text,
        meliorationfest_ref.punktdaten_standort_festgestelltemelioration AS standort_id -- Für JOIN mit punktdaten_standort
    FROM 
        afu_bodendaten_nabodat_v1.codlstnpktstndort_meliorationfest AS meliorationfest
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_meliorationfest_ref AS meliorationfest_ref
        ON meliorationfest.t_id = meliorationfest_ref.areference
    GROUP BY 
        standort_id
),

nutzungsbeschraenkung AS (
    SELECT 
        string_agg(nutzungsbeschraenkung.codeid,', ') AS nutzungsbeschraenkung,
        string_agg(nutzungsbeschraenkung.codetext_de,', ') AS nutzungsbeschraenkung_text,
        nutzungsbeschraenkung_ref.punktdaten_standort_nutzungsbeschraenkung AS standort_id -- Für JOIN mit punktdaten_standort
    FROM
        afu_bodendaten_nabodat_v1.codlstnpktstndort_nutzungsbeschraenkung AS nutzungsbeschraenkung
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_nutzungsbeschraenkung_ref AS nutzungsbeschraenkung_ref
        ON nutzungsbeschraenkung.t_id = nutzungsbeschraenkung_ref.areference
    GROUP BY
        standort_id
),

standortbeurteilung AS (
    SELECT 
        standortbeurteilung.t_id, -- Für JOIN mit punktdaten_standort
        krumenzustand.codeid AS krumenzustand,
        krumenzustand.codetext_de AS krumenzustand_text,
        einsatzduengerfest.codeid AS duengereinsatz_fest,
        einsatzduengerfest.codetext_de AS duengereinsatz_fest_text,
        risikoduengerfluess.codeid AS duengerrisiko_fluessig,
        risikoduengerfluess.codetext_de AS duengerrisiko_fluessig_text
    FROM afu_bodendaten_nabodat_v1.punktdaten_standortbeurteilung AS standortbeurteilung
    -- Krumenzustand
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_krumenzustand AS krumenzustand
        ON standortbeurteilung.krumenzustand = krumenzustand.t_id
    -- Duengereinsatz flüssig
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_einsatzduengerfest AS einsatzduengerfest
        ON standortbeurteilung.einsatzduengerfest = einsatzduengerfest.t_id
    -- Duengerrisiko flüssig
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_risikoduengerfluess AS risikoduengerfluess
        ON standortbeurteilung.risikoduengerfluess = risikoduengerfluess.t_id
),

limitierungen AS (
    SELECT 
        string_agg(limitierung.codeid,', ') AS limitierungen,
        string_agg(limitierung.codetext_de,', ') AS limitierungen_text,
        limitierung_ref.punktdaten_standort_limitierendeeigenschaft AS standort_id -- Für Join mit punktdaten_standort
    FROM 
        afu_bodendaten_nabodat_v1.codlstnpktstndort_limitierendeeigenschaft AS limitierung
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_limitierendeeigenschaft_ref AS limitierung_ref
        ON limitierung.t_id = limitierung_ref.areference
    GROUP BY 
        standort_id
),

erhebungsdaten AS (
    SELECT 
        erhebung.t_id, -- Für Join mit Tabellen darunter
        erhebung.standort AS standort_id, -- Für Join mit punktdaten_standort
        erhebung.erhebungsdatum,
        erhebung.probenehmer,
        string_agg(erhebungsart.codeid,', ') AS erhebungsart,
        string_agg(erhebungsart.codetext_de,', ') AS erhebungsart_text
    FROM
        afu_bodendaten_nabodat_v1.punktdaten_erhebung AS erhebung
    LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_erhebungsart AS erhebungsart
        ON erhebung.erhebungsart = erhebungsart.t_id
    WHERE erhebungsart.codeid != 'PN'
    GROUP BY
        erhebung.standort,
        erhebung.erhebungsdatum,
        erhebung.t_id
),

profildaten AS (
    SELECT
        erhebungsdaten.standort_id, -- Für Join mit punktdaten_standort 
        profil.t_id, -- Für Join mit punktdaten_profildokument
        profil.profilbeurteilung, -- Für Join mit punktdaten_profilbeurteilung
        profil.profilbezeichnung1 AS profilbezeichnung,
        profil.bemerkung,
        bichqualitaet.bemerkung AS bemerkung_erhebung,
        klassifikationssystem.codeid AS klassifikationssystem,
        klassifikationssystem.codetext_de AS klassifikationssystem_text,
        bodentyp.codeid AS bodentyp,
        bodentyp.codetext_de AS bodentyp_text,
        untertyp_agg.boden_untertyp,
        untertyp_agg.boden_untertyp_text,
        skelettgehalt_oberboden.codeid AS skelettgehalt_oberboden,
        skelettgehalt_oberboden.codetext_de AS skelettgehalt_oberboden_text,
        skelettgehalt_unterboden.codeid AS skelettgehalt_unterboden,
        skelettgehalt_unterboden.codetext_de AS skelettgehalt_unterboden_text,
        feinerdekoernung_oberboden.codeid AS feinerdekoernung_oberboden,
        feinerdekoernung_oberboden.codetext_de AS feinerdekoernung_oberboden_text,
        feinerdekoernung_unterboden.codeid AS feinerdekoernung_unterboden,
        feinerdekoernung_unterboden.codetext_de AS feinerdekoernung_unterboden_text,
        wasserspeichervermoegen.codeid AS wasserspeichervermoegen,
        wasserspeichervermoegen.codetext_de AS wasserspeichervermoegen_text,
        bodenwasserhaushaltsgruppe.codeid AS bodenwasserhaushaltsgruppe,
        bodenwasserhaushaltsgruppe.codetext_de AS bodenwasserhaushaltsgruppe_text,
        pflanzengruendigkeit.codeid AS pflanzengruendigkeitswert,
        pflanzengruendigkeit.codetext_de AS pflanzengruendigkeitswert_text
    FROM 
        afu_bodendaten_nabodat_v1.punktdaten_profil AS profil
    -- Erhebungsdaten
    LEFT JOIN erhebungsdaten
        ON profil.erhebung = erhebungsdaten.t_id
    -- Klassifikationssystem via punktdaten_bichqualtät
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_bichqualitaet AS bichqualitaet
        ON profil.bichqualitaet = bichqualitaet.t_id
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_klassifikationssystem AS klassifikationssystem
        ON bichqualitaet.klassifikationssystem = klassifikationssystem.t_id
    -- Bodentyp
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_bodentyp AS bodentyp
        ON profil.bodentyp = bodentyp.t_id
    -- Skelettgehalt Oberboden via punktdaten_punktdaten_bodenskelettfeldbereich
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_bodenskelettfeldbereich AS bodenskelett_oberboden
        ON profil.t_id = bodenskelett_oberboden.punktdaten_profil_bodenskelettobfeldbereich
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_skelettgehalt AS skelettgehalt_oberboden
        ON bodenskelett_oberboden.skelettgehalt = skelettgehalt_oberboden.t_id
    -- Skelettgehalt Unterboden via punktdaten_punktdaten_bodenskelettfeldbereich
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_bodenskelettfeldbereich AS bodenskelett_unterboden
        ON profil.t_id = bodenskelett_unterboden.punktdaten_profil_bodenskelettubfeldbereich
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_skelettgehalt AS skelettgehalt_unterboden
        ON bodenskelett_unterboden.skelettgehalt = skelettgehalt_unterboden.t_id
    -- Feinerdekörnung Oberboden via punktdaten_koernungungsbereich
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_koernungsbereich AS koernungsbereich_oberboden
        ON profil.t_id = koernungsbereich_oberboden.punktdaten_profil_koernungsbereichob
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_feinerdekoernung AS feinerdekoernung_oberboden
        ON koernungsbereich_oberboden.feinerdekoernung = feinerdekoernung_oberboden.t_id
    -- Feinerdekörnung Unterboden via punktdaten_koernungungsbereich
    LEFT JOIN afu_bodendaten_nabodat_v1.punktdaten_koernungsbereich AS koernungsbereich_unterboden
        ON profil.t_id = koernungsbereich_unterboden.punktdaten_profil_koernungsbereichub
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_feinerdekoernung AS feinerdekoernung_unterboden
        ON koernungsbereich_unterboden.feinerdekoernung = feinerdekoernung_unterboden.t_id
    -- Wasserspeichervermögen
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_wasserspeichervermoegen AS wasserspeichervermoegen
        ON profil.wasserspeichervermoegen = wasserspeichervermoegen.t_id
    -- Bodenwasserhaushaltsgruppe
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_bodenwasserhaushaltsgruppe AS bodenwasserhaushaltsgruppe
        ON profil.bodenwasserhaushaltsgruppe = bodenwasserhaushaltsgruppe.t_id
    -- Pflanzengründigkeitswert
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_pflanzennutzbaregruendigkeit AS pflanzengruendigkeit
        ON profil.pflanzennutzbaregruendigkeit = pflanzengruendigkeit.t_id
    LEFT JOIN (
        SELECT
            punktdaten_untertyp.profil,
            string_agg(untertyp.codeid,', ') AS boden_untertyp,
            string_agg(untertyp.codetext_de,', ') AS boden_untertyp_text
        FROM
            afu_bodendaten_nabodat_v1.punktdaten_untertyp AS punktdaten_untertyp
        LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_untertyp AS untertyp
            ON punktdaten_untertyp.untertyp = untertyp.t_id
        GROUP BY 
            punktdaten_untertyp.profil
    ) AS untertyp_agg
        ON profil.t_id = untertyp_agg.profil
),

profilbeurteilung AS (
    SELECT
        profildaten.standort_id, -- Für Join mit punktdaten_standort
        profilbeurteilung.bodenpunktezahl,
        fruchtbarkeitsstufe.codeid AS fruchtbarkeitsstufe,
        fruchtbarkeitsstufe.codetext_de AS fruchtbarkeitsstufe_text,
        nutzungseignung.codeid AS nutzungseignung,
        nutzungseignung.codetext_de AS nutzungseignung_text,
        eignungsklasse.codeid AS eignungsklasse,
        eignungsklasse.codetext_de AS eignungsklasse_text
    FROM 
        afu_bodendaten_nabodat_v1.punktdaten_profilbeurteilung AS profilbeurteilung
    LEFT JOIN profildaten
        ON profildaten.profilbeurteilung = profilbeurteilung.t_id
    -- Fruchtbarkeitsstufe
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_fruchtbarkeitsstufe AS fruchtbarkeitsstufe
        ON profilbeurteilung.fruchtbarkeitsstufe = fruchtbarkeitsstufe.t_id
    -- Nutzungseignung
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_nutzungseignung AS nutzungseignung
        ON profilbeurteilung.nutzungseignung = nutzungseignung.t_id
    -- Eignungsklasse
    LEFT JOIN afu_bodendaten_nabodat_v1.codelistnprfldten_eignungsklasse AS eignungsklasse
        ON profilbeurteilung.eignungsklasse = eignungsklasse.t_id
),

dokumente AS (
    SELECT
        profildaten.standort_id,
        profilfoto_dokument.originaldokumentname AS profilfoto,
        profilskizze_dokument.originaldokumentname AS profilskizze,
        topografieskizze_dokument.originaldokumentname AS topografieskizze
    FROM
        profildaten
    -- Profilfoto
    LEFT JOIN (
        SELECT 
            profildokument.profil,
            profilfoto.originaldokumentname
        FROM
            afu_bodendaten_nabodat_v1.punktdaten_profildokument AS profildokument
            LEFT JOIN (
                SELECT
                    dokument.t_id,
                    dokument.originaldokumentname
                FROM 
                    afu_bodendaten_nabodat_v1.punktdaten_dokument AS dokument
                LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_dokumenttyp AS dokumenttyp
                    ON dokument.dokumenttyp = dokumenttyp.t_id
                WHERE dokumenttyp.codeid = 'FotoProfil'
                    ) profilfoto           
                ON profildokument.profildokument = profilfoto.t_id
            WHERE profilfoto.originaldokumentname IS NOT NULL
            ) profilfoto_dokument
        ON profildaten.t_id = profilfoto_dokument.profil
    -- Profilskizze
    LEFT JOIN (
        SELECT 
            profildokument.profil,
            profilskizze.originaldokumentname
        FROM
            afu_bodendaten_nabodat_v1.punktdaten_profildokument AS profildokument
            LEFT JOIN (
                SELECT
                    dokument.t_id,
                    dokument.originaldokumentname
                FROM 
                    afu_bodendaten_nabodat_v1.punktdaten_dokument AS dokument
                LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_dokumenttyp AS dokumenttyp
                    ON dokument.dokumenttyp = dokumenttyp.t_id
                WHERE dokumenttyp.codeid = 'ScanProfilSkizze'
                    ) profilskizze           
                ON profildokument.profildokument = profilskizze.t_id
            WHERE profilskizze.originaldokumentname IS NOT NULL
            ) profilskizze_dokument
        ON profildaten.t_id = profilskizze_dokument.profil
    -- Topografieskizze
    LEFT JOIN (
        SELECT 
            profildokument.profil,
            topografieskizze.originaldokumentname
        FROM
            afu_bodendaten_nabodat_v1.punktdaten_profildokument AS profildokument
            LEFT JOIN (
                SELECT
                    dokument.t_id,
                    dokument.originaldokumentname
                FROM 
                    afu_bodendaten_nabodat_v1.punktdaten_dokument AS dokument
                LEFT JOIN afu_bodendaten_nabodat_v1.codlstnpktstndort_dokumenttyp AS dokumenttyp
                    ON dokument.dokumenttyp = dokumenttyp.t_id
                WHERE dokumenttyp.codeid = 'ScanProfilTopografie'
                    ) topografieskizze           
                ON profildokument.profildokument = topografieskizze.t_id
            WHERE topografieskizze.originaldokumentname IS NOT NULL
            ) topografieskizze_dokument
        ON profildaten.t_id = topografieskizze_dokument.profil      
)

/*
----------------------------------------------------
--------------------- Ende CTE ---------------------
----------------------------------------------------

----------------------------------------------------
-------------- Beginn SELECT auf CTE's -------------
----------------------------------------------------
 */

SELECT 
    standort.profilnummer,
    standort.bfs_nummer_erfassung,
    standort.bfs_nummer,
    standort.flurname,
    standort.gemeinde,
    standort.gemeinde_aktuell,
    standort.hoehe,
    standort.kanton,
    standort.geometrie,
    standort.koordinaten,
    standorteigenschaften.neigung,
    standorteigenschaften.gelaendeform,
    standorteigenschaften.gelaendeform_text,
    standorteigenschaften.landschaftselement,
    standorteigenschaften.landschaftselement_text,
    standorteigenschaften.exposition,
    standorteigenschaften.exposition_text,
    standorteigenschaften.klimaeignungszone,
    standorteigenschaften.klimaeignungszone_text,
    standorteigenschaften.vegetation,
    standorteigenschaften.vegetation_text,
    standorteigenschaften.kleinrelief,
    standorteigenschaften.kleinrelief_text,
    ausgangsmaterial.ausgangsmaterial_alle,
    ausgangsmaterial.ausgangsmaterial_oben,
    ausgangsmaterial.ausgangsmaterial_oben_text,
    ausgangsmaterial.ausgangsmaterial_unten,
    ausgangsmaterial.ausgangsmaterial_unten_text,
    ausgangsmaterial.eiszeit_oberboden,
    ausgangsmaterial.eiszeit_oberboden_text,
    ausgangsmaterial.eiszeit_unterboden,
    ausgangsmaterial.eiszeit_unterboden_text,
    wald.produktionsfaehigkeitsstufe,
    wald.produktionsfaehigkeitsstufe_text,
    wald.humusform,
    wald.humusform_text,
    melioration_empfohlen.melioration_empfohlen,
    melioration_empfohlen.melioration_empfohlen_text,
    melioration_festgestellt.melioration_festgestellt,
    melioration_festgestellt.melioration_festgestellt_text,
    nutzungsbeschraenkung.nutzungsbeschraenkung,
    nutzungsbeschraenkung.nutzungsbeschraenkung_text,
    standortbeurteilung.krumenzustand,
    standortbeurteilung.krumenzustand_text,
    standortbeurteilung.duengereinsatz_fest,
    standortbeurteilung.duengereinsatz_fest_text,
    standortbeurteilung.duengerrisiko_fluessig,
    standortbeurteilung.duengerrisiko_fluessig_text,
    limitierungen.limitierungen,
    limitierungen.limitierungen_text,
    erhebungsdaten.probenehmer,
    erhebungsdaten.erhebungsdatum,
    erhebungsdaten.erhebungsart,
    erhebungsdaten.erhebungsart_text,
    profildaten.profilbezeichnung,
    profildaten.bemerkung,
    profildaten.bemerkung_erhebung,
    profildaten.klassifikationssystem,
    profildaten.klassifikationssystem_text,
    profildaten.bodentyp,
    profildaten.bodentyp_text,
    profildaten.boden_untertyp,
    profildaten.boden_untertyp_text,
    profildaten.skelettgehalt_oberboden,
    profildaten.skelettgehalt_oberboden_text,
    profildaten.skelettgehalt_unterboden,
    profildaten.skelettgehalt_unterboden_text,
    profildaten.feinerdekoernung_oberboden,
    profildaten.feinerdekoernung_oberboden_text,
    profildaten.feinerdekoernung_unterboden,
    profildaten.feinerdekoernung_unterboden_text,
    profildaten.wasserspeichervermoegen,
    profildaten.wasserspeichervermoegen_text,
    profildaten.bodenwasserhaushaltsgruppe,
    profildaten.bodenwasserhaushaltsgruppe_text,
    profildaten.pflanzengruendigkeitswert,
    profildaten.pflanzengruendigkeitswert_text,
    profilbeurteilung.bodenpunktezahl,
    profilbeurteilung.fruchtbarkeitsstufe,
    profilbeurteilung.fruchtbarkeitsstufe_text,
    profilbeurteilung.nutzungseignung,
    profilbeurteilung.nutzungseignung_text,
    profilbeurteilung.eignungsklasse,
    profilbeurteilung.eignungsklasse_text,
    dokumente.profilfoto,
    dokumente.profilskizze,
    dokumente.topografieskizze
FROM 
    standort
    LEFT JOIN standorteigenschaften
        ON standort.t_id = standorteigenschaften.standort_id
    LEFT JOIN ausgangsmaterial
        ON standort.t_id = ausgangsmaterial.standort_id
    LEFT JOIN wald 
        ON standort.wald_id = wald.t_id
    LEFT JOIN melioration_empfohlen
        ON standort.t_id = melioration_empfohlen.standort_id
    LEFT JOIN melioration_festgestellt
        ON standort.t_id = melioration_festgestellt.standort_id
    LEFT JOIN nutzungsbeschraenkung
        ON standort.t_id = nutzungsbeschraenkung.standort_id
    LEFT JOIN standortbeurteilung
        ON standort.standortbeurteilung_id = standortbeurteilung.t_id
    LEFT JOIN limitierungen
        ON standort.t_id = limitierungen.standort_id
    LEFT JOIN erhebungsdaten
        ON standort.t_id = erhebungsdaten.standort_id
    LEFT JOIN profildaten
        ON standort.t_id = profildaten.standort_id
    LEFT JOIN profilbeurteilung
        ON standort.t_id = profilbeurteilung.standort_id
    LEFT JOIN dokumente
        ON standort.t_id = dokumente.standort_id
;