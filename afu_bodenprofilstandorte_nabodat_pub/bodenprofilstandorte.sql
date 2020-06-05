SELECT 
        standort.hoehe AS hoehe, 
	standort_exposition.codeid AS exposition, 
	standort_exposition.codetext_de AS exposition_text, 
	standort_klimaeignung.codeid AS klimaeignungszone, 
	standort_klimaeignung.codetext_de AS klimaeignungszone_text,
	standort_vegetation.codeid AS vegetation, 
	standort_vegetation.codetext_de AS vegetation_text,
	ausgangsmaterial_oben.codeid AS ausgangsmaterial_oben, 
	ausgangsmaterial_oben.codetext_de AS ausgangsmaterial_oben_text, 
	ausgangsmaterial_unten.codeid AS ausgangsmaterial_unten, 
	ausgangsmaterial_unten.codetext_de AS ausgangsmaterial_unten_text,
	ausgangsmaterial_eiszeit.codeid AS eiszeit,
	ausgangsmaterial_eiszeit.codetext_de AS eiszeit_text,
	standort_landschaftselement.codeid AS landschaftselement,
	standort_landschaftselement.codetext_de AS landschaftselement_text,
	standort_kleinrelief.codeid AS kleinrelief,
	standort_kleinrelief.codetext_de AS kleinrelief_text, 
	standort.gemeinde AS gemeinde, 
	standort.flurname AS flurname, 
	standort.bfsnummeraktuell AS bfs_nummer, 
        standort.standortid AS profilnummer,
	standort.bfsnummer AS bfs_nummer_erfassung,
	st_x(standort.koordinaten)||' / '||st_y(standort.koordinaten) AS koordinaten,  
	profil.profilbezeichnung1 AS profilbezeichnung,
	bich_klassifikation.codeid AS klassifikationssystem, 
	bich_klassifikation.codetext_de AS klassifikationssystem_text, 
	erhebung_erhebungsart.codeid AS erhebungsart, 
	erhebung_erhebungsart.codetext_de AS erhebungsart_text, 
	erhebung.probenehmer AS probenehmer, 
	erhebung.erhebungsdatum AS erhebungsdatum, 
	profil_bodentyp.codeid AS bodentyp, 
	profil_bodentyp.codetext_de AS bodentyp_text,
        boden_untertypen.untertyp_string AS untertyp, 
	oberbodenskelett.codeid AS skelettgehalt_oberboden, 
	oberbodenskelett.codetext_de AS skelettgehalt_oberboden_text, 
	unterbodenskelett.codeid AS skelettgehalt_unterboden, 
	unterbodenskelett.codetext_de AS skelettgehalt_unterboden_text, 
	oberbodenkoernungsbereich.codeid AS feinerdekoernung_oberboden, 
	oberbodenkoernungsbereich.codetext_de AS feinerdekoernung_oberboden_text, 
	unterbodenkoernungsbereich.codeid AS feinerdekoernung_unterboden, 
	unterbodenkoernungsbereich.codetext_de AS feinerdekoernung_unterboden_text, 
	bodenwasserhaushaltsgruppe.codeid AS bodenwasserhaushaltsgruppe, 
	bodenwasserhaushaltsgruppe.codetext_de AS bodenwasserhaushaltsgruppe_text, 
	pflanzengruendigkeit.codeid AS pflanzengruendigkeit, 
	profil.pflanzennutzbaregruendigkeitwert AS pflanzengruendigkeitswert, 
	pflanzengruendigkeit.codetext_de AS pflanzengruendigkeitswert_text, 
	standorteigenschaften.neigungprozent AS neigung,
	standort_gelaendeform.codeid As gelaendeform, 
	standort_gelaendeform .codetext_de AS gelaendeform_text,
	topografiedokument_dokument.originaldokumentname AS topografieskizze, 
        standort.koordinaten AS geometrie,
	profilfoto_dokument.originaldokumentname AS profilfoto, 
	profilskizze_dokument.originaldokumentname AS profilskizze,
	horizontwerte.horizontwert AS horizonte, 
	profil.bemerkung AS bemerkung, 
	erhebung.bemerkung AS bemerkung_erhebung, 
	standortbeurteilung_krumen.codeid AS krumenzustand, 
	standortbeurteilung_krumen.codetext_de AS krumenzustand_text, 
	limitierende_eigenschaften.codeid AS limitierungen, 
	limitierende_eigenschaften.codetext_de AS limitierungen_text,
	nutzungsbeschraenkung.codeid AS nutzungsbeschraenkung, 
	nutzungsbeschraenkung.codetext_de AS nutzungsbeschraenkung_text, 
	meliorationfestgestellt.codeid AS melioration_festgestellt, 
	meliorationfestgestellt.codetext_de AS melioration_festgestellt_text,
	meliorationempfohlen.codeid AS melioration_empfohlen, 
	meliorationempfohlen.codetext_de AS melioration_empfohlen_text, 
	duengerfest.codeid AS duengereinsatz_fest, 
	duengerfest.codetext_de AS duengereinsatz_fest_text, 
	duengerfluessig.codeid AS duengereinsatz_fluessig, 
	duengerfluessig.codetext_de AS duengereinsatz_fluessig_text, 
	fruchtbarkeitsstufe.codeid AS fruchtbarkeitsstufe, 
	fruchtbarkeitsstufe.codetext_de AS fruchtbarkeitsstufe_text, 
	profilbeurteilung.bodenpunktezahl AS Bodenpunktezahl, 
	nutzungseignung.codeid AS nutzungseignung, 
	nutzungseignung.codetext_de AS nutzungseignung_text, 
	eignungsklasse.codeid AS eignungsklasse, 
	eignungsklasse.codetext_de AS eignungsklasse_text,
	humusform.codeid AS humusform, 
	humusform.codetext_de AS humusform_text,
	produktionsfaehigkeitsstufe.codeid AS produktionsfaehigkeitsstufe,
	produktionsfaehigkeitsstufe.codetext_de AS produktionsfaehigkeitsstufe_text,
	wald.waldproduktionspunkte AS produktionsfaehigkeit_punkte
FROM 
    afu_bodendaten_nabodat.punktdaten_standort standort
-- Standort

-- Limitierung
LEFT JOIN 
    (SELECT 
     punktdaten_standort_limitierendeeigenschaft, 
	 string_agg(limitierende_eigenschaft.codeid,', ') AS codeid, 
	 string_agg(limitierende_eigenschaft.codetext_de,', ') AS codetext_de
     FROM afu_bodendaten_nabodat.codlstnpktstndort_limitierendeeigenschaft_ref standort_limitierung_ref
	 LEFT JOIN 
	     afu_bodendaten_nabodat.codlstnpktstndort_limitierendeeigenschaft limitierende_eigenschaft
	     ON limitierende_eigenschaft.t_id = standort_limitierung_ref.areference
	 GROUP BY 
	     punktdaten_standort_limitierendeeigenschaft
	 ) limitierende_eigenschaften
	ON limitierende_eigenschaften.punktdaten_standort_limitierendeeigenschaft = standort.t_id
	
--Nutzungsbeschraenkung
LEFT JOIN 
    (SELECT 
     punktdaten_standort_nutzungsbeschraenkung, 
	 string_agg(nutzungsbeschraenkung_code.codeid,', ') AS codeid, 
	 string_agg(nutzungsbeschraenkung_code.codetext_de,', ') AS codetext_de
     FROM afu_bodendaten_nabodat.codlstnpktstndort_nutzungsbeschraenkung_ref standort_nutzungsbeschraenkung_ref
	 LEFT JOIN 
	     afu_bodendaten_nabodat.codlstnpktstndort_nutzungsbeschraenkung nutzungsbeschraenkung_code
	  	 ON nutzungsbeschraenkung_code.t_id = standort_nutzungsbeschraenkung_ref.areference
	 GROUP BY 
	     punktdaten_standort_nutzungsbeschraenkung
	 ) nutzungsbeschraenkung
	ON nutzungsbeschraenkung.punktdaten_standort_nutzungsbeschraenkung = standort.t_id

--Meliorationempfehlung
LEFT JOIN 
    (SELECT 
     punktdaten_standort_empfohlenemelioration, 
	 string_agg(melioration_code.codeid,', ') AS codeid, 
	 string_agg(melioration_code.codetext_de,', ') AS codetext_de
     FROM afu_bodendaten_nabodat.codlstnpktstndort_meliorationempf_ref standort_melioration_ref
	 LEFT JOIN 
	     afu_bodendaten_nabodat.codlstnpktstndort_meliorationempf melioration_code
	  	 ON melioration_code.t_id = standort_melioration_ref.areference
	 GROUP BY 
	     punktdaten_standort_empfohlenemelioration
	 ) meliorationempfohlen
	 ON meliorationempfohlen.punktdaten_standort_empfohlenemelioration = standort.t_id
	 
--Meliorationfestgestellt
LEFT JOIN 
    (SELECT 
     punktdaten_standort_festgestelltemelioration, 
	 string_agg(melioration_code.codeid,', ') AS codeid, 
	 string_agg(melioration_code.codetext_de,', ') AS codetext_de
     FROM afu_bodendaten_nabodat.codlstnpktstndort_meliorationfest_ref standort_melioration_ref
	 LEFT JOIN 
	     afu_bodendaten_nabodat.codlstnpktstndort_meliorationfest melioration_code
	  	 ON melioration_code.t_id = standort_melioration_ref.areference
	 GROUP BY 
	     punktdaten_standort_festgestelltemelioration
	 ) meliorationfestgestellt
	 ON meliorationfestgestellt.punktdaten_standort_festgestelltemelioration = standort.t_id

--PROJEKT
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_projektstandort projektstandort 
	ON projektstandort.standort = standort.t_id 
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_projekt projekt 
	ON projektstandort.projekt = projekt.t_id
	
--STANDORDEIGENSCHAFTEN
LEFT JOIN 	
    afu_bodendaten_nabodat.punktdaten_standorteigenschaften standorteigenschaften 
	ON standort.t_id = standorteigenschaften.standort
LEFT JOIN 
    afu_bodendaten_nabodat.codlstnpktstndort_exposition standort_exposition 
	ON standort_exposition.t_id = standorteigenschaften.exposition
LEFT JOIN 
    afu_bodendaten_nabodat.codlstnpktstndort_klimaeignungszone standort_klimaeignung 
	ON standort_klimaeignung.t_id = standorteigenschaften.klimaeignungzone 
LEFT JOIN 
    afu_bodendaten_nabodat.codlstnpktstndort_vegetation standort_vegetation 
	ON standort_vegetation.t_id = standorteigenschaften.vegetation 
LEFT JOIN 
    afu_bodendaten_nabodat.codlstnpktstndort_landschaftselement standort_landschaftselement
	ON standort_landschaftselement.t_id = standorteigenschaften.landschaftselement
LEFT JOIN 
    afu_bodendaten_nabodat.codlstnpktstndort_kleinrelief standort_kleinrelief
	ON standort_kleinrelief.t_id = standorteigenschaften.kleinrelief
LEFT JOIN 
	afu_bodendaten_nabodat.codlstnpktstndort_gelaendeform standort_gelaendeform 
	ON standort_gelaendeform.t_id = standorteigenschaften.gelaendeform

-- Standortbeurteilung
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_standortbeurteilung standortbeurteilung
	ON standort.standortbeurteilung = standortbeurteilung.t_id
LEFT JOIN 
    afu_bodendaten_nabodat.codlstnpktstndort_krumenzustand standortbeurteilung_krumen
	ON standortbeurteilung.krumenzustand = standortbeurteilung_krumen.t_id

--Duenger
LEFT JOIN 
    afu_bodendaten_nabodat.codlstnpktstndort_einsatzduengerfest duengerfest 
	ON standortbeurteilung.einsatzduengerfest = duengerfest.t_id
LEFT JOIN 
    afu_bodendaten_nabodat.codlstnpktstndort_risikoduengerfluess duengerfluessig
	ON standortbeurteilung.risikoduengerfluess = duengerfluessig.t_id


--AUSGANGSMATERIAL
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_ausgangsmaterial standort_ausgangsmaterial_oben 
	ON standorteigenschaften.t_id = standort_ausgangsmaterial_oben.punktdtn_strtgnschften_ausgangsmaterialoben 
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_ausgangsmaterial standort_ausgangsmaterial_unten 
	ON standorteigenschaften.t_id = standort_ausgangsmaterial_unten.punktdtn_strtgnschften_ausgangsmaterialunten
LEFT JOIN 
     afu_bodendaten_nabodat.codlstnpktstndort_ausgangsmaterial ausgangsmaterial_oben
	 ON standort_ausgangsmaterial_oben.ausgangsmaterial = ausgangsmaterial_oben.t_id
LEFT JOIN 
     afu_bodendaten_nabodat.codlstnpktstndort_ausgangsmaterial ausgangsmaterial_unten
	 ON standort_ausgangsmaterial_unten.ausgangsmaterial = ausgangsmaterial_unten.t_id
LEFT JOIN 
     afu_bodendaten_nabodat.codlstnpktstndort_eiszeit ausgangsmaterial_eiszeit
	 ON standort_ausgangsmaterial_oben.eiszeit = ausgangsmaterial_eiszeit.t_id

--ERHEBUNG
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_erhebung erhebung
	ON erhebung.standort = standort.t_id
LEFT JOIN 
    afu_bodendaten_nabodat.codlstnpktstndort_erhebungsart erhebung_erhebungsart
	ON erhebung.erhebungsart = erhebung_erhebungsart.t_id
	
--Profil
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_profil profil
	ON profil.erhebung = erhebung.t_id
LEFT JOIN 
    afu_bodendaten_nabodat.codelistnprfldten_bodentyp profil_bodentyp
	ON profil.bodentyp = profil_bodentyp.t_id
LEFT JOIN 
    (SELECT  untertyp.profil, 
             json_build_object(
                 'untertyp', string_agg(code.codeid,', '), 
                 'untertyp_text', string_agg(code.codetext_de,', ')
             ) AS untertyp_string 
     FROM
     afu_bodendaten_nabodat.punktdaten_untertyp untertyp
     LEFT JOIN 
         afu_bodendaten_nabodat.codelistnprfldten_untertyp code
	     ON untertyp.untertyp = code.t_id
     GROUP BY 
         untertyp.profil
	 ) boden_untertypen
	 On boden_untertypen.profil = profil.t_id
LEFT JOIN
    afu_bodendaten_nabodat.codelistnprfldten_bodenwasserhaushaltsgruppe bodenwasserhaushaltsgruppe
	ON bodenwasserhaushaltsgruppe.t_id = profil.bodenwasserhaushaltsgruppe
LEFT JOIN 
    afu_bodendaten_nabodat.codelistnprfldten_pflanzennutzbaregruendigkeit pflanzengruendigkeit
	ON pflanzengruendigkeit.t_id = profil.pflanzennutzbaregruendigkeit
	
--Profilbeurteilung
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_profilbeurteilung profilbeurteilung 
	ON profil.profilbeurteilung = profilbeurteilung.t_id
LEFT JOIN 
    afu_bodendaten_nabodat.codelistnprfldten_fruchtbarkeitsstufe fruchtbarkeitsstufe
	ON profilbeurteilung.fruchtbarkeitsstufe = fruchtbarkeitsstufe.t_id
LEFT JOIN 
    afu_bodendaten_nabodat.codelistnprfldten_nutzungseignung nutzungseignung
	ON profilbeurteilung.nutzungseignung = nutzungseignung.t_id
LEFT JOIN 
    afu_bodendaten_nabodat.codelistnprfldten_eignungsklasse eignungsklasse
	ON profilbeurteilung.eignungsklasse = eignungsklasse.t_id

--Wald 
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_wald wald
	ON standort.wald = wald.t_id 
LEFT JOIN 
    afu_bodendaten_nabodat.codlstnpktstndort_humusform humusform
	ON wald.humusform = humusform.t_id
LEFT JOIN 
    afu_bodendaten_nabodat.codlstnpktstndort_produktionsfaehigkstufewald produktionsfaehigkeitsstufe
	ON wald.produktionsfaehigkstufewald = produktionsfaehigkeitsstufe.t_id

--BICHQualitaet
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_bichqualitaet bichqualitaet 
	ON bichqualitaet.t_id = profil.bichqualitaet
LEFT JOIN 
    afu_bodendaten_nabodat.codelistnprfldten_klassifikationssystem bich_klassifikation
    ON bichqualitaet.klassifikationssystem = bich_klassifikation.t_id

--BODENSKELETTFELDBEREICH
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_bodenskelettfeldbereich profil_oberbodenskelettfeldbereich
    ON profil_oberbodenskelettfeldbereich.punktdaten_profil_bodenskelettobfeldbereich = profil.t_id 
LEFT JOIN 
    afu_bodendaten_nabodat.codelistnprfldten_skelettgehalt oberbodenskelett
	ON oberbodenskelett.t_id = profil_oberbodenskelettfeldbereich.skelettgehalt
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_bodenskelettfeldbereich profil_unterbodenskelettfeldbereich
    ON profil_unterbodenskelettfeldbereich.punktdaten_profil_bodenskelettubfeldbereich = profil.t_id 
LEFT JOIN 
    afu_bodendaten_nabodat.codelistnprfldten_skelettgehalt unterbodenskelett
	ON unterbodenskelett.t_id = profil_unterbodenskelettfeldbereich.skelettgehalt

--FEINERDEKOERNUNG
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_koernungsbereich profil_oberbodenkoernungsbereich
	ON profil.t_id = profil_oberbodenkoernungsbereich.punktdaten_profil_koernungsbereichob
LEFT JOIN 
    afu_bodendaten_nabodat.codelistnprfldten_feinerdekoernung oberbodenkoernungsbereich
	ON oberbodenkoernungsbereich.t_id = profil_oberbodenkoernungsbereich.feinerdekoernung
LEFT JOIN 
    afu_bodendaten_nabodat.punktdaten_koernungsbereich profil_unterbodenkoernungsbereich
	ON profil.t_id = profil_unterbodenkoernungsbereich.punktdaten_profil_koernungsbereichub
LEFT JOIN 
    afu_bodendaten_nabodat.codelistnprfldten_feinerdekoernung unterbodenkoernungsbereich
	ON unterbodenkoernungsbereich.t_id = profil_unterbodenkoernungsbereich.feinerdekoernung

--DOKUMENTE 
--TOPOGRAFIEDOKUMENT
LEFT JOIN 
    (SELECT * FROM afu_bodendaten_nabodat.punktdaten_profildokument profildokument 
         LEFT JOIN
            (SELECT dokument.* 
	         FROM afu_bodendaten_nabodat.punktdaten_dokument dokument
	         LEFT JOIN afu_bodendaten_nabodat.codlstnpktstndort_dokumenttyp dokumenttyp 
	             ON dokument.dokumenttyp = dokumenttyp.t_id 
	         WHERE dokumenttyp.codetext_de = 'Scan Profil-Topografie'
	        ) topografiedokument
	         ON topografiedokument.t_id = profildokument.profildokument
	 WHERE topografiedokument.originaldokumentname IS NOT NULL 
    ) topografiedokument_dokument
	ON topografiedokument_dokument.profil = profil.t_id

--PROFILFOTO
LEFT JOIN 
    (SELECT * FROM afu_bodendaten_nabodat.punktdaten_profildokument profildokument 
         LEFT JOIN
            (SELECT dokument.* 
	         FROM afu_bodendaten_nabodat.punktdaten_dokument dokument
	         LEFT JOIN afu_bodendaten_nabodat.codlstnpktstndort_dokumenttyp dokumenttyp 
	             ON dokument.dokumenttyp = dokumenttyp.t_id 
	         WHERE dokumenttyp.codetext_de = 'Foto Profil'
	        ) profilfoto
	         ON profilfoto.t_id = profildokument.profildokument
	 WHERE profilfoto.originaldokumentname IS NOT NULL 
    ) profilfoto_dokument
	ON profilfoto_dokument.profil = profil.t_id

--Profilskizze
LEFT JOIN 
    (SELECT * FROM afu_bodendaten_nabodat.punktdaten_profildokument profildokument 
         LEFT JOIN
            (SELECT dokument.* 
	         FROM afu_bodendaten_nabodat.punktdaten_dokument dokument
	         LEFT JOIN afu_bodendaten_nabodat.codlstnpktstndort_dokumenttyp dokumenttyp 
	             ON dokument.dokumenttyp = dokumenttyp.t_id 
	         WHERE dokumenttyp.codetext_de = 'Scan Profil-Skizze'
	        ) profilskizze
	         ON profilskizze.t_id = profildokument.profildokument
	 WHERE profilskizze.originaldokumentname IS NOT NULL 
    ) profilskizze_dokument
	ON profilskizze_dokument.profil = profil.t_id
	
-- Horizont
LEFT JOIN 
    (SELECT 
        horizont.profil,
	    json_agg(
			json_build_object(
				'tiefe', horizont.tiefebis, 
				'gefuege', json_build_object(
					'gefuegeform', gefuege_form.codeid, 
					'gefuegeform_text', gefuege_form.codetext_de, 
					'gefuegegroesse', gefuege_groesse.codeid, 
					'gefuegegroesse_text', gefuege_groesse.codetext_de
				),
				'zustand_organische_substanz', messung.zustand_org_substanz, 
				'zustand_organische_substanz_labor', messung.zustand_org_substanz_messwert, 
				'tongehalt', messung.tongehalt, 
				'tongehalt_labor', messung.tongehalt_labor,
				'schluffgehalt', messung.schluffgehalt, 
				'schluffgehalt_labor', messung.schluffgehalt_labor, 
				'sandgehalt', messung.sandgehalt, 
				'sandgehalt_labor', messung.sandgehalt_labor, 
				'kies', messung.kies, 
				'steine', messung.steine,
				'kalk', messung.kalk, 
				'kalk_labor', messung.kalk_labor, 
				'ph_wert', messung.ph_wert, 
				' cacl2_wert', messung.cacl2_wert, 
				'farbe', json_build_object(
					'farbtonzahl', messung.farbtonzahl, 
					'farbton', messung.farbton, 
					'farbton_helligkeit', messung.farbe_helligkeit, 
					'farbton_intensitaet', messung.farbe_intensitaet
				)
			)
		) AS horizontwert
    FROM 
        afu_bodendaten_nabodat.punktdaten_horizont horizont
    --Gefuege	
    LEFT JOIN 
        afu_bodendaten_nabodat.punktdaten_gefuege gefuege 
    	ON gefuege.horizont = horizont.t_id
    LEFT JOIN 
        afu_bodendaten_nabodat.codelistnprfldten_form gefuege_form
	    ON gefuege.form = gefuege_form.t_id
    LEFT JOIN 
        afu_bodendaten_nabodat.codelistnprfldten_groesse gefuege_groesse
	    ON gefuege.groesse = gefuege_groesse.t_id
    --MESSUNGEN
    LEFT JOIN 
        ( SELECT 
              profil.t_id AS profil_tid,
              horizont.profil AS horizontprofil,
              horizont.t_id AS horizont_id,
              horizont.horizontnr AS horizont,
              horizont.tiefevon AS tiefe,
              gefuege.form AS gefuegeform,
              gefuege_form.codetext_de AS gefuegeform_text,
              gefuege.groesse AS gefuegegroesse,
              gefuege_groesse.codetext_de AS gefuegegroesse_text,
	          horizont.humusgehaltfeld AS zustand_org_substanz,
              (messung.messwerte) ->> 'Bodenkennwerte // Organische Substanz'::text AS zustand_org_substanz_messwert,
              horizont.tonfeld AS tongehalt,
              (messung.messwerte) ->> 'Bodenkennwerte // Tongehalt (< 0.002 mm)'::text AS tongehalt_labor,
              horizont.schlufffeld AS schluffgehalt,
              (messung.messwerte) ->> 'Bodenkennwerte // Schluffgehalt (0.002 - 0.05 mm)'::text AS schluffgehalt_labor,
              horizont.sandfeld AS sandgehalt,
              (messung.messwerte) ->> 'Bodenkennwerte // Sandgehalt (0.05 - 2 mm)'::text AS sandgehalt_labor,
              horizont.kiesfeld AS kies,
              horizont.steinefeld AS steine,
              kalk_code.codeid AS kalk,
              (messung.messwerte) ->> 'Bodenkennwerte // Kalk (CaCO3)'::text AS kalk_labor,
              horizont.phfeld AS ph_wert,
              (messung.messwerte) ->> 'Bodenkennwerte // pH-Wert'::text AS cacl2_wert,
              farbtonzahl_code.codeid AS farbtonzahl,
              farbtontext_code.codetext_de AS farbton,
              farbtonhelligkeit_code.codeid AS farbe_helligkeit,
              farbtonintensitaet_code.codeid AS farbe_intensitaet,
              (messung.messwerte) ->> 'Bodenkennwerte // Potentielle Kationenaustauschkapazität'::text AS kationenaustauschkapazitaet_potentiell,
              (messung.messwerte) ->> 'Bodenkennwerte // Effektive Kationenaustauschkapazität'::text AS kationenaustauschkapazitaet_effektiv
           FROM afu_bodendaten_nabodat.punktdaten_profil profil
               LEFT JOIN afu_bodendaten_nabodat.punktdaten_horizont horizont ON horizont.profil = profil.t_id
               LEFT JOIN afu_bodendaten_nabodat.punktdaten_horizontbezeichnung horizontbezeichnung ON horizont.horizontbezeichnung = horizontbezeichnung.t_id
               LEFT JOIN afu_bodendaten_nabodat.punktdaten_gefuege gefuege ON gefuege.horizont = horizont.t_id
	       LEFT JOIN afu_bodendaten_nabodat.codelistnprfldten_zustandorgsubst zustand_organischesubstanz ON horizontbezeichnung.zustandorgsubst = zustand_organischesubstanz.t_id
               LEFT JOIN afu_bodendaten_nabodat.codelistnprfldten_groesse gefuege_groesse ON gefuege.groesse = gefuege_groesse.t_id
               LEFT JOIN afu_bodendaten_nabodat.codelistnprfldten_form gefuege_form ON gefuege.form = gefuege_form.t_id
               LEFT JOIN afu_bodendaten_nabodat.codelistnprfldten_kalkreaktionhcl kalk_code ON horizont.kalkreaktionhcl = kalk_code.t_id
               LEFT JOIN afu_bodendaten_nabodat.punktdaten_bodenfarbe bodenfarbe ON bodenfarbe.horizont = horizont.t_id
               LEFT JOIN afu_bodendaten_nabodat.codelistnprfldten_farbtonzahl farbtonzahl_code ON bodenfarbe.farbtonzahl = farbtonzahl_code.t_id
               LEFT JOIN afu_bodendaten_nabodat.codelistnprfldten_farbtontext farbtontext_code ON bodenfarbe.farbtontext = farbtontext_code.t_id
               LEFT JOIN afu_bodendaten_nabodat.codelistnprfldten_helligkeit farbtonhelligkeit_code ON bodenfarbe.helligkeit = farbtonhelligkeit_code.t_id
               LEFT JOIN afu_bodendaten_nabodat.codelistnprfldten_intensitaet farbtonintensitaet_code ON bodenfarbe.intensitaet = farbtonintensitaet_code.t_id
               LEFT JOIN afu_bodendaten_nabodat.erhebung_probe_profil hilfsview ON hilfsview.erhebung_profil = profil.erhebung
               LEFT JOIN afu_bodendaten_nabodat.punktdaten_probe probe ON hilfsview.erhebung_probe = probe.erhebung AND probe.tiefevon = horizont.tiefevon
               LEFT JOIN ( SELECT json_object_agg(analyseparameter.parametertext_de, messung_1.messwert) AS messwerte,
                      messung_1.probe
                     FROM afu_bodendaten_nabodat.punktdaten_messung messung_1
                       LEFT JOIN afu_bodendaten_nabodat.codelistnnlysdten_analyseparameter analyseparameter ON messung_1.analyseparameter = analyseparameter.t_id
                    GROUP BY messung_1.probe) messung ON messung.probe = probe.t_id
    ) messung 
	    ON messung.horizont_id = horizont.t_id
	GROUP BY 
	    horizont.profil
    ORDER BY 
        horizont.profil
) horizontwerte 
ON horizontwerte.profil = profil.t_id
--WHERE 
WHERE 
    projekt.aname = 'Bodenkartierung Kt. SO'
	AND 
	erhebung_erhebungsart.codeid != 'PN'
