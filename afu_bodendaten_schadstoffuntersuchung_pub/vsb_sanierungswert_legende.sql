 WITH analysedaten AS (
 SELECT
    COALESCE(standort.standortid, ' '::text)::text||' '||COALESCE(probedbf.untersuchungskampagne::text,''::text)::text AS standort_untersuchung,
    standort.standortid AS standort_id,
    st_x(standort.koordinaten) AS standort_koordinate_x,
    st_y(standort.koordinaten) AS standort_koordinate_y,
    standort.anonymisierung,
    zugangsstufe_standort.codetext_de AS standort_zugangsstufe,
    projekt.aname AS projektname,
    erhebung.erhebungsnr,
    erhebung.erhebungsdatum,
    erhebungsart.codetext_de AS erhebungsart,
    erhebung.probenehmer,
    erhebung.bodenbearbeitung,
    erhebung.lufttemperatur,
    erhebung.witterung,
    erhebung.bodenfeuchtigkeit,
    zugangsstufe_erhebung.codetext_de AS erhebung_zugangsstufe,
    probe.probenr,
    analysematerial.codetext_de AS analysematerial,
    beprobungsart.codetext_de AS beprobungsart,
    probentyp.codetext_de AS probentyp,
    probe.tiefevon,
    probe.tiefebis,
    geraet.codetext_de AS geraet,
    probedbf.untersuchungskampagne,
    probedbf.wiederholung,
    probedbf.archivstandort,
    zugangsstufe_probe.codetext_de AS probe_zugangsstufe,
    CASE 
	    WHEN analyseparameter.parameterid::text LIKE 'DIOX%'::text 
		THEN 'DIOX'
		WHEN analyseparameter.parameterid::text LIKE 'SM%'::text 
		THEN 'SM' 
		WHEN analyseparameter.parameterid::text LIKE 'PAK%'::text 
		THEN 'PAK' 
		WHEN analyseparameter.parameterid::text LIKE 'PCB%'::text 
		THEN 'PCB' 
	END AS analysegruppecode,
    analyseparameter.parameterid AS analyseparameter,
    messung.bestimmungsnr,
    messung.datum,
    messung.messwert,
    analyseparameter.einheit AS messwert_einheit,
    messung.messwertunterbg AS messwertunterbestimmungsgrenze,
    messung.bestimmungsgrenze,
    analyseparameter.einheit AS bestimmungsgrenze_einheit,
    messung.nachweisgrenze,
    analyseparameter.einheit AS nachweisgrenze_einheit,
    messung.messungreferenziert,
    messung.referenzmethode,
    methodeaufschluss.codeid AS methodeaufschluss,
    methodemessung.codeid AS methodemessung,
    methodeaufbereitung.codetext_de AS methodeaufbereitung,
    messung.refmethodeaufschluss,
    messung.refmethodemessung,
    messung.refmethodeaufbereitung,
    belastung.codetext_de AS belastung,
    zugangsstufe_messung.codetext_de AS messung_zugangsstufe,
    standort.koordinaten AS geometrie
   FROM afu_bodendaten_nabodat.punktdaten_messung messung
     LEFT JOIN afu_bodendaten_nabodat.codelistnnlysdten_analyseparameter analyseparameter ON messung.analyseparameter = analyseparameter.t_id
     LEFT JOIN afu_bodendaten_nabodat.codelistnnlysdten_methodeaufschluss methodeaufschluss ON messung.methodeaufschluss = methodeaufschluss.t_id
     LEFT JOIN afu_bodendaten_nabodat.codelistnnlysdten_methodemessung methodemessung ON messung.methodemessung = methodemessung.t_id
     LEFT JOIN afu_bodendaten_nabodat.codelistnnlysdten_methodeaufbereitung methodeaufbereitung ON messung.methodeaufbereitung = methodeaufbereitung.t_id
     LEFT JOIN afu_bodendaten_nabodat.codlstnpktstndort_zugangsstufe zugangsstufe_messung ON zugangsstufe_messung.t_id = messung.zugangsstufe
     LEFT JOIN afu_bodendaten_nabodat.codelistnnlysdten_belastung belastung ON messung.belastung = belastung.t_id
     LEFT JOIN afu_bodendaten_nabodat.punktdaten_probe probe ON messung.probe = probe.t_id
     LEFT JOIN afu_bodendaten_nabodat.codelistnnlysdten_analysematerial analysematerial ON probe.analysematerial = analysematerial.t_id
     LEFT JOIN afu_bodendaten_nabodat.codelistnnlysdten_beprobungsart beprobungsart ON probe.beprobungsart = beprobungsart.t_id
     LEFT JOIN afu_bodendaten_nabodat.codelistnnlysdten_probentyp probentyp ON probe.probentyp = probentyp.t_id
     LEFT JOIN afu_bodendaten_nabodat.codelistnnlysdten_geraet geraet ON probe.geraet = geraet.t_id
     LEFT JOIN afu_bodendaten_nabodat.punktdaten_probedbf probedbf ON probedbf.probe = probe.t_id
     LEFT JOIN afu_bodendaten_nabodat.codlstnpktstndort_zugangsstufe zugangsstufe_probe ON zugangsstufe_probe.t_id = probe.zugangsstufe
     LEFT JOIN afu_bodendaten_nabodat.erhebung_probe_profil zwischentab ON probe.erhebung = zwischentab.erhebung_probe
     LEFT JOIN afu_bodendaten_nabodat.punktdaten_standort standort ON standort.t_id = zwischentab.standort
     LEFT JOIN afu_bodendaten_nabodat.codlstnpktstndort_zugangsstufe zugangsstufe_standort ON zugangsstufe_standort.t_id = standort.zugangsstufe
     LEFT JOIN afu_bodendaten_nabodat.punktdaten_projektstandort projektstandort ON standort.t_id = projektstandort.standort
     LEFT JOIN afu_bodendaten_nabodat.punktdaten_projekt projekt ON projektstandort.projekt = projekt.t_id
     LEFT JOIN afu_bodendaten_nabodat.codlstnpktstndort_status projektstatus ON projektstandort.status_projektstandort = projektstatus.t_id
     LEFT JOIN afu_bodendaten_nabodat.punktdaten_erhebung erhebung ON erhebung.t_id = zwischentab.erhebung_probe
     LEFT JOIN afu_bodendaten_nabodat.codlstnpktstndort_erhebungsart erhebungsart ON erhebung.erhebungsart = erhebungsart.t_id
     LEFT JOIN afu_bodendaten_nabodat.codlstnpktstndort_zugangsstufe zugangsstufe_erhebung ON zugangsstufe_erhebung.t_id = erhebung.zugangsstufe
	 WHERE (
		    (analyseparameter.parameterid::text = 'DIOX..133'::text)
			OR  
		   (analyseparameter.parameterid::text LIKE 'SM%' 
                            AND methodeaufschluss.codeid::text = ANY (ARRAY['HNO3_(VBBo_total)'::character varying::text, 'NaNO3_(VBBo_loeslich)'::character varying::text, 'HNO3+Citronensaeure'::character varying::text])) 
			OR  
			(analyseparameter.parameterid::text = 'PCB..117'::text 
			    AND projekt.aname::text <> 'sanierte Flächen'::text) 
			OR  
			(analyseparameter.parameterid::text = ANY (ARRAY['PAK..97'::character varying::text, 'PAK..87'::character varying::text]) )
                        
		   )
                AND 
                (projektstatus.codeid IN ('a', 'archiv')) --Projektstatus nur aktiv und archiviert
),
stoffwerte_abgefuellt AS (
SELECT analysedaten.standort_untersuchung,
    analysedaten.standort_id,
    analysedaten.standort_koordinate_x,
    analysedaten.standort_koordinate_y,
    analysedaten.projektname,
    analysedaten.probenr,
    analysedaten.tiefevon,
    analysedaten.tiefebis,
    analysedaten.untersuchungskampagne,
    analysedaten.methodeaufschluss,
    analysedaten.messwert_einheit,
    analysedaten.messwert,
    analysedaten.datum,
    analysedaten.analyseparameter,
    analysedaten.analysegruppecode,
    analysedaten.erhebungsnr,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND analysedaten.analyseparameter::text = 'SM..61'::text AND analysedaten.methodeaufschluss::text !~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_cd_kg,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND (analysedaten.analyseparameter::text = ANY (ARRAY['SM..63'::character varying, 'SM..10147'::character varying]::text[])) AND analysedaten.methodeaufschluss::text !~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_cr_kg,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND analysedaten.analyseparameter::text = 'SM..64'::text AND analysedaten.methodeaufschluss::text !~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_cu_kg,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND analysedaten.analyseparameter::text = 'SM..66'::text AND analysedaten.methodeaufschluss::text !~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_hg_kg,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND analysedaten.analyseparameter::text = 'SM..68'::text AND analysedaten.methodeaufschluss::text !~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_ni_kg,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND analysedaten.analyseparameter::text = 'SM..69'::text AND analysedaten.methodeaufschluss::text !~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_pb_kg,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND analysedaten.analyseparameter::text = 'SM..73'::text AND analysedaten.methodeaufschluss::text !~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_zn_kg,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND analysedaten.analyseparameter::text = 'SM..67'::text AND analysedaten.methodeaufschluss::text !~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_mo_kg,
        CASE
            WHEN analysedaten.analysegruppecode = 'PAK'::text AND analysedaten.analyseparameter::text = 'PAK..87'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS pak_bap,
        CASE
            WHEN analysedaten.analysegruppecode = 'PAK'::text AND analysedaten.analyseparameter::text = 'PAK..97'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS pak_16epa,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND analysedaten.analyseparameter::text = 'SM..61'::text AND analysedaten.methodeaufschluss::text ~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_cd_l,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND analysedaten.analyseparameter::text = 'SM..63'::text AND analysedaten.methodeaufschluss::text ~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_zn_l,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND analysedaten.analyseparameter::text = 'SM..64'::text AND analysedaten.methodeaufschluss::text ~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_cu_l,
        CASE
            WHEN analysedaten.analysegruppecode = 'SM'::text AND analysedaten.analyseparameter::text = 'SM..68'::text AND analysedaten.methodeaufschluss::text ~~ 'loeslich'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS sm_ni_l,
        CASE
            WHEN analysedaten.analysegruppecode = 'PCB'::text AND analysedaten.analyseparameter::text = 'PCB..117'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS pcb_s7_kg,
        CASE
            WHEN analysedaten.analysegruppecode = 'DIOX'::text THEN round(analysedaten.messwert, 3)
            ELSE NULL::numeric
        END AS pcdd_f2_kg,
    st_buffer(analysedaten.geometrie, 0.1::double precision) AS st_buffer
   FROM analysedaten
), 
dissolve_values AS (
 SELECT stoffwerte_abgefuellt.tiefebis,
    stoffwerte_abgefuellt.erhebungsnr,
    stoffwerte_abgefuellt.standort_untersuchung,
    stoffwerte_abgefuellt.probenr,
    stoffwerte_abgefuellt.projektname,
    sum(stoffwerte_abgefuellt.sm_cd_kg) AS sm_cd_kg,
    sum(stoffwerte_abgefuellt.sm_cr_kg) AS sm_cr_kg,
    sum(stoffwerte_abgefuellt.sm_cu_kg) AS sm_cu_kg,
    sum(stoffwerte_abgefuellt.sm_hg_kg) AS sm_hg_kg,
    sum(stoffwerte_abgefuellt.sm_ni_kg) AS sm_ni_kg,
    sum(stoffwerte_abgefuellt.sm_pb_kg) AS sm_pb_kg,
    sum(stoffwerte_abgefuellt.sm_zn_kg) AS sm_zn_kg,
    sum(stoffwerte_abgefuellt.sm_mo_kg) AS sm_mo_kg,
    sum(stoffwerte_abgefuellt.pak_bap) AS pak_bap,
    sum(stoffwerte_abgefuellt.pak_16epa) AS pak_16epa,
    sum(stoffwerte_abgefuellt.sm_cd_l) AS sm_cd_l,
    sum(stoffwerte_abgefuellt.sm_zn_l) AS sm_zn_l,
    sum(stoffwerte_abgefuellt.sm_cu_l) AS sm_cu_l,
    sum(stoffwerte_abgefuellt.sm_ni_l) AS sm_ni_l,
    sum(stoffwerte_abgefuellt.pcb_s7_kg) AS pcb_s7_kg,
    sum(stoffwerte_abgefuellt.pcdd_f2_kg) AS pcdd_f2_kg,
    st_centroid(stoffwerte_abgefuellt.st_buffer) AS geometrie
   FROM stoffwerte_abgefuellt
  GROUP BY stoffwerte_abgefuellt.tiefebis, stoffwerte_abgefuellt.erhebungsnr, stoffwerte_abgefuellt.standort_untersuchung, stoffwerte_abgefuellt.probenr, stoffwerte_abgefuellt.projektname, stoffwerte_abgefuellt.st_buffer
) 

SELECT 
    dissolve_values.tiefebis AS tiefe_bis,
    dissolve_values.standort_untersuchung AS standort_untersuchung,
    dissolve_values.projektname AS projektname,
    round(dissolve_values.sm_cd_kg,2) AS schwermetall_cadmium,
    round(dissolve_values.sm_cr_kg,1) AS schwermetall_chrom,
    round(dissolve_values.sm_cu_kg,1) AS schwermetall_kupfer, 
    round(dissolve_values.sm_hg_kg,2) AS schwermetall_quecksilber,
    round(dissolve_values.sm_ni_kg,1) AS schwermetall_nickel,
    round(dissolve_values.sm_pb_kg,1) AS schwermetall_blei, 
    round(dissolve_values.sm_zn_kg,1) AS schwermetall_zink,
    round(dissolve_values.sm_mo_kg,1) AS schwermetall_molybdaen,
    round(dissolve_values.pak_bap,0) AS pak_bap,
    round(dissolve_values.pak_16epa,0) AS pak_16epa,
    round(dissolve_values.sm_cd_l,2) AS loesliches_schwermetall_cadmium,
    round(dissolve_values.sm_zn_l,2) AS loesliches_schwermetall_zink,
    round(dissolve_values.sm_cu_l,2) AS loesliches_schwermetall_kupfer,
    round(dissolve_values.sm_ni_l,2) AS loesliches_schwermetall_nickel, 
    round(dissolve_values.pcb_s7_kg,0) AS pcb_gesamt_7,
    round(dissolve_values.pcdd_f2_kg,1) AS diox_pcddf,
        CASE
            WHEN dissolve_values.sm_cu_kg >= 1000::numeric OR dissolve_values.sm_cu_l >= 4::numeric OR dissolve_values.sm_zn_kg >= 2000::numeric OR dissolve_values.sm_zn_l >= 5::numeric OR dissolve_values.sm_cd_kg >= 20::numeric OR dissolve_values.sm_cd_l >= 0.1 OR dissolve_values.sm_pb_kg >= 1000::numeric OR dissolve_values.pak_bap >= 10000::numeric OR dissolve_values.pak_16epa >= 100000::numeric OR dissolve_values.pcb_s7_kg >= 1000::numeric OR dissolve_values.pcdd_f2_kg >= 100::numeric THEN 'Sanierungswert'::text
            WHEN dissolve_values.sm_cu_kg >= 150::numeric OR dissolve_values.sm_cu_l >= 0.7 OR dissolve_values.sm_cd_kg >= 2::numeric OR dissolve_values.sm_cd_l >= 0.02 OR dissolve_values.sm_hg_kg >= 0.5 OR dissolve_values.sm_pb_kg >= 200::numeric OR dissolve_values.pak_bap >= 1000::numeric OR dissolve_values.pak_16epa >= 10000::numeric OR dissolve_values.pcb_s7_kg >= 100::numeric OR dissolve_values.pcdd_f2_kg >= 20::numeric THEN 'Prüfwert'::text
            WHEN dissolve_values.sm_cr_kg >= 50::numeric OR dissolve_values.sm_ni_kg >= 50::numeric OR dissolve_values.sm_ni_l >= 0.2 OR dissolve_values.sm_cu_kg >= 40::numeric OR dissolve_values.sm_cu_l >= 0.7 OR dissolve_values.sm_zn_kg >= 150::numeric OR dissolve_values.sm_zn_l >= 0.5 OR dissolve_values.sm_mo_kg >= 5::numeric OR dissolve_values.sm_cd_kg >= 0.8 OR dissolve_values.sm_cd_l >= 0.02 OR dissolve_values.sm_hg_kg >= 0.5 OR dissolve_values.sm_pb_kg >= 50::numeric OR dissolve_values.pak_bap >= 200::numeric OR dissolve_values.pak_16epa >= 1000::numeric OR dissolve_values.pcdd_f2_kg >= 5::numeric THEN 'Richtwert'::text
            ELSE 'unbelastet'::text
        END AS beurteilung,
    dissolve_values.geometrie
   FROM dissolve_values;
