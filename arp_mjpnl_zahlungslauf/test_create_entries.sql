/* 
- Lösche gemäss operator_erstellung "Test"
- Ersetze arp_mjpnl_v1 mit arp_mjpnl_v1
*/

/* alr_buntbrache */

-- Vereinbarung 01_TEST_00001
INSERT INTO arp_mjpnl_v1.mjpnl_vereinbarung
(   
    t_basket,
    t_ili_tid,
    vereinbarungs_nr,
    geometrie,
    gelan_pid_gelan,
    gelan_bewe_id,
    uebersteuerung_bewirtschafter,
    bfs_nr,
    gemeinde,
    gb_nr,
    flurname,
    vereinbarungsart,
    ist_nutzungsvereinbarung,
    flaeche,
    status_vereinbarung,
    soemmerungsgebiet,
    mjpnl_version,
    kontrollintervall,
    bemerkung,
    uzl_subregion,
    kantonsintern,
    dateipfad_oder_url,
    erstellungsdatum,
    operator_erstellung 
)
VALUES
(
    (SELECT t_id FROM arp_mjpnl_v1.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
    uuid_generate_v4(),
    '01_TEST_00001',
    ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
    (SELECT pid_gelan FROM arp_mjpnl_v1.betrbsdttrktrdten_gelan_person LIMIT 1),
    'GELAN_BEWE_DUMMY',
    false,
    '{2601}',
    '{"Dummy-Gemeinde"}',
    '{"Dummy-GBNr"}',
    '{"Dummy-Flurname"}',
    'ALR_Buntbrache',
    false,
    1.5,
    'aktiv',
    false,
    'MJPNL_2032',
    4,
    'Test-Entry: alr_buntbrache',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

/* alr_saum */
-- Vereinbarung 01_TEST_00002
INSERT INTO arp_mjpnl_v1.mjpnl_vereinbarung
(   
    t_basket,
    t_ili_tid,
    vereinbarungs_nr,
    geometrie,
    gelan_pid_gelan,
    gelan_bewe_id,
    uebersteuerung_bewirtschafter,
    bfs_nr,
    gemeinde,
    gb_nr,
    flurname,
    vereinbarungsart,
    ist_nutzungsvereinbarung,
    flaeche,
    status_vereinbarung,
    soemmerungsgebiet,
    mjpnl_version,
    kontrollintervall,
    bemerkung,
    uzl_subregion,
    kantonsintern,
    dateipfad_oder_url,
    erstellungsdatum,
    operator_erstellung 
)
VALUES
(
    (SELECT t_id FROM arp_mjpnl_v1.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
    uuid_generate_v4(),
    '01_TEST_00002',
    ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
    (SELECT pid_gelan FROM arp_mjpnl_v1.betrbsdttrktrdten_gelan_person LIMIT 1),
    'GELAN_BEWE_DUMMY',
    false,
    '{2601}',
    '{"Dummy-Gemeinde"}',
    '{"Dummy-GBNr"}',
    '{"Dummy-Flurname"}',
    'ALR_Saum',
    false,
    1.5,
    'aktiv',
    false,
    'MJPNL_2032',
    4,
    'Test-Entry: alr_saum',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

/* hecke MIT zwei Beurteilungen*/
-- Vereinbarung 01_TEST_00003
INSERT INTO arp_mjpnl_v1.mjpnl_vereinbarung
(   
    t_basket,
    t_ili_tid,
    vereinbarungs_nr,
    geometrie,
    gelan_pid_gelan,
    gelan_bewe_id,
    uebersteuerung_bewirtschafter,
    bfs_nr,
    gemeinde,
    gb_nr,
    flurname,
    vereinbarungsart,
    ist_nutzungsvereinbarung,
    flaeche,
    status_vereinbarung,
    soemmerungsgebiet,
    mjpnl_version,
    kontrollintervall,
    bemerkung,
    uzl_subregion,
    kantonsintern,
    dateipfad_oder_url,
    erstellungsdatum,
    operator_erstellung 
)
VALUES
(
    (SELECT t_id FROM arp_mjpnl_v1.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
    uuid_generate_v4(),
    '01_TEST_00003',
    ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
    (SELECT pid_gelan FROM arp_mjpnl_v1.betrbsdttrktrdten_gelan_person LIMIT 1),
    'GELAN_BEWE_DUMMY',
    false,
    '{2601}',
    '{"Dummy-Gemeinde"}',
    '{"Dummy-GBNr"}',
    '{"Dummy-Flurname"}',
    'Hecke',
    false,
    1.5,
    'aktiv',
    false,
    'MJPNL_2032',
    4,
    'Test-Entry: alr_saum',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

-- Beurteilung 1 (alt - zählt nicht)
-- einstiegskriterien = 200 ha
-- Strauch 100 + Schichtholzbeigen 150 + Steinhaufen 150 + Sitzwarte 25 = 425 ha
-- Krautsaum 300 + Schnittzeitpunkte 100 + Offener Boden 300 = 700 ha
-- 200 Meter Lebhag = 300 p 
-- ersch1 11 + ersch2 22 + ersch 33 = 66 ha
-- pauschal: 400
-- per ha: 1391
-- * flaeche 1.5 = 2086.5
-- generisch 5.- trinkgeld
-- total = 2391.5
INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_hecke
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_lage,
    einstiegskriterium_mindestdimension_gehoelz_krautsaum,
    einstiegskriterium_unterhalteingriffe_abgesprochen,
    einstiegskriterium_verzichtdiversegeraete,
    einstiegskriterium_verzichthilfsstoffe,
    einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
    einstiegskriterium_bff_stufe_i_ii_erfuellt,
    einstiegskriterium_abgeltung_ha,
    faunabonus_anzahl_arten,
    faunabonus_artenvielfalt_abgeltung_pauschal,
    einstufungbeurteilungistzustand_artenvielfalt_strauch_bmrten,
    einstufungbeurteilungistzustand_asthaufen,
    einstufungbeurteilungistzustand_totholz,
    einstufungbeurteilungistzustand_steinhaufen,
    einstufungbeurteilungistzustand_schichtholzbeigen,
    einstufungbeurteilungistzustand_nisthilfe_wildbienen,
    einstufungbeurteilungistzustand_hoehlenbaeume_biotpbm_ttholz,
    einstufungbeurteilungistzustand_sitzwarte,
    einstufungbeurteilungistzustand_abgeltung_ha,
    bewirtschaftung_hecke_typ_niederhecke,
    bewirtschaftung_hecke_typ_hochhecke,
    bewirtschaftung_hecke_typ_baumhecke,
    bewirtschaftung_hecke_typ_lebhag,
    bewirtschaftung_hecke_unterhalt,
    bewirtschaftung_hecke_unterhaltanteil,
    bewirtschaftung_krautsaum,
    bewirtschaftung_krautsaum_schnittzeitpunkte,
    bewirtschaftung_krautsaum_offener_boden,
    bewirtschaftung_krautsaum_keine_beweidung,
    bewirtschaftung_krautsaum_beweidung_nach_absprache,
    bewirtschaftung_krautsaum_abgeltung_ha,
    bewirtschaftung_lebhag_laufmeter,
    bewirtschaftung_lebhag_abgeltung_pauschal,
    erschwernis_massnahme1,
    erschwernis_massnahme1_abgeltung_ha,
    erschwernis_massnahme2,
    erschwernis_massnahme2_abgeltung_ha,
    erschwernis_massnahme3,
    erschwernis_massnahme3_abgeltung_ha,
    erschwernis_abgeltung_ha,
    beurteilungsdatum,
    bemerkungen,
    kopie_an_bewirtschafter,
    mit_bewirtschafter_besprochen,
    abgeltung_per_ha_total,
    abgeltung_flaeche_total,
    abgeltung_pauschal_total,
    abgeltung_generisch_betrag,
    abgeltung_total,
    erstellungsdatum,
    operator_erstellung,
    berater,
    vereinbarung
) 
VALUES
(
    (SELECT t_id FROM arp_mjpnl_v1.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
    uuid_generate_v4(),
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    200, -- einstiegskriterium_abgeltung_ha,
    0, -- faunabonus_anzahl_arten,
    0, -- faunabonus_artenvielfalt_abgeltung_pauschal,
    TRUE, -- einstufungbeurteilungistzustand_artenvielfalt_strauch_bmrten,
    FALSE, -- einstufungbeurteilungistzustand_asthaufen,
    FALSE, -- einstufungbeurteilungistzustand_totholz,
    TRUE, -- einstufungbeurteilungistzustand_steinhaufen,
    TRUE, -- einstufungbeurteilungistzustand_schichtholzbeigen,
    FALSE, -- einstufungbeurteilungistzustand_nisthilfe_wildbienen,
    FALSE, -- einstufungbeurteilungistzustand_hoehlenbaeume_biotpbm_ttholz,
    TRUE, -- einstufungbeurteilungistzustand_sitzwarte,
    425, -- einstufungbeurteilungistzustand_abgeltung_ha,
    TRUE, -- bewirtschaftung_hecke_typ_niederhecke,
    FALSE, -- bewirtschaftung_hecke_typ_hochhecke,
    FALSE, -- bewirtschaftung_hecke_typ_baumhecke,
    FALSE, -- bewirtschaftung_hecke_typ_lebhag,
    TRUE, -- bewirtschaftung_hecke_unterhalt,
    'der ganzen Fläche', -- bewirtschaftung_hecke_unterhaltanteil,
    TRUE, -- bewirtschaftung_krautsaum,
    TRUE, -- bewirtschaftung_krautsaum_schnittzeitpunkte,
    TRUE, -- bewirtschaftung_krautsaum_offener_boden,
    FALSE, -- bewirtschaftung_krautsaum_keine_beweidung,
    FALSE, -- bewirtschaftung_krautsaum_beweidung_nach_absprache,
    700, -- bewirtschaftung_krautsaum_abgeltung_ha,
    200, -- bewirtschaftung_lebhag_laufmeter,
    300, -- bewirtschaftung_lebhag_abgeltung_pauschal,
    TRUE, -- erschwernis_massnahme1,
    11, -- erschwernis_massnahme1_abgeltung_ha,
    TRUE, -- erschwernis_massnahme2,
    22, -- erschwernis_massnahme2_abgeltung_ha,
    TRUE, -- erschwernis_massnahme3,
    33, -- erschwernis_massnahme3_abgeltung_ha,
    66, -- erschwernis_abgeltung_ha,
    now()::date-4, -- beurteilungsdatum,
    'Test-Entry', 
    TRUE, -- kopie_an_bewirtschafter,
    TRUE, -- mit_bewirtschafter_besprochen,
    1391, -- abgeltung_per_ha_total,
    2086.5, -- abgeltung_flaeche_total,
    130, -- abgeltung_pauschal_total,
    5, -- abgeltung_generisch_betrag,
    2221.5, -- abgeltung_total,
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '01_TEST_00003') -- vereinbarung
);

-- Beurteilung 2 - (aktuelle Beurteilung, die zählt)
-- einstiegskriterien = 200 ha
-- 2 arten faunabonus = 100 p 
-- Strauch 100 + Schichtholzbeigen 150 + Steinhaufen 150 + Sitzwarte 25 = 425 ha
-- Krautsaum 300 + Schnittzeitpunkte 100 + Offener Boden 300 = 700 ha
-- 20 Meter Lebhag = 30 p 
-- ersch1 11 + ersch2 22 + ersch 33 = 66 ha
-- pauschal: 130
-- per ha: 1391
-- * flaeche 1.5 = 2086.5
-- generisch 5.- trinkgeld
-- total = 2221.5
INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_hecke
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_lage,
    einstiegskriterium_mindestdimension_gehoelz_krautsaum,
    einstiegskriterium_unterhalteingriffe_abgesprochen,
    einstiegskriterium_verzichtdiversegeraete,
    einstiegskriterium_verzichthilfsstoffe,
    einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
    einstiegskriterium_bff_stufe_i_ii_erfuellt,
    einstiegskriterium_abgeltung_ha,
    faunabonus_anzahl_arten,
    faunabonus_artenvielfalt_abgeltung_pauschal,
    einstufungbeurteilungistzustand_artenvielfalt_strauch_bmrten,
    einstufungbeurteilungistzustand_asthaufen,
    einstufungbeurteilungistzustand_totholz,
    einstufungbeurteilungistzustand_steinhaufen,
    einstufungbeurteilungistzustand_schichtholzbeigen,
    einstufungbeurteilungistzustand_nisthilfe_wildbienen,
    einstufungbeurteilungistzustand_hoehlenbaeume_biotpbm_ttholz,
    einstufungbeurteilungistzustand_sitzwarte,
    einstufungbeurteilungistzustand_abgeltung_ha,
    bewirtschaftung_hecke_typ_niederhecke,
    bewirtschaftung_hecke_typ_hochhecke,
    bewirtschaftung_hecke_typ_baumhecke,
    bewirtschaftung_hecke_typ_lebhag,
    bewirtschaftung_hecke_unterhalt,
    bewirtschaftung_hecke_unterhaltanteil,
    bewirtschaftung_krautsaum,
    bewirtschaftung_krautsaum_schnittzeitpunkte,
    bewirtschaftung_krautsaum_offener_boden,
    bewirtschaftung_krautsaum_keine_beweidung,
    bewirtschaftung_krautsaum_beweidung_nach_absprache,
    bewirtschaftung_krautsaum_abgeltung_ha,
    bewirtschaftung_lebhag_laufmeter,
    bewirtschaftung_lebhag_abgeltung_pauschal,
    erschwernis_massnahme1,
    erschwernis_massnahme1_abgeltung_ha,
    erschwernis_massnahme2,
    erschwernis_massnahme2_abgeltung_ha,
    erschwernis_massnahme3,
    erschwernis_massnahme3_abgeltung_ha,
    erschwernis_abgeltung_ha,
    beurteilungsdatum,
    bemerkungen,
    kopie_an_bewirtschafter,
    mit_bewirtschafter_besprochen,
    abgeltung_per_ha_total,
    abgeltung_flaeche_total,
    abgeltung_pauschal_total,
    abgeltung_generisch_betrag,
    abgeltung_total,
    erstellungsdatum,
    operator_erstellung,
    berater,
    vereinbarung
) 
VALUES
(
    (SELECT t_id FROM arp_mjpnl_v1.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
    uuid_generate_v4(),
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    200, -- einstiegskriterium_abgeltung_ha,
    2, -- faunabonus_anzahl_arten,
    100, -- faunabonus_artenvielfalt_abgeltung_pauschal,
    TRUE, -- einstufungbeurteilungistzustand_artenvielfalt_strauch_bmrten,
    FALSE, -- einstufungbeurteilungistzustand_asthaufen,
    FALSE, -- einstufungbeurteilungistzustand_totholz,
    TRUE, -- einstufungbeurteilungistzustand_steinhaufen,
    TRUE, -- einstufungbeurteilungistzustand_schichtholzbeigen,
    FALSE, -- einstufungbeurteilungistzustand_nisthilfe_wildbienen,
    FALSE, -- einstufungbeurteilungistzustand_hoehlenbaeume_biotpbm_ttholz,
    TRUE, -- einstufungbeurteilungistzustand_sitzwarte,
    425, -- einstufungbeurteilungistzustand_abgeltung_ha,
    TRUE, -- bewirtschaftung_hecke_typ_niederhecke,
    FALSE, -- bewirtschaftung_hecke_typ_hochhecke,
    FALSE, -- bewirtschaftung_hecke_typ_baumhecke,
    FALSE, -- bewirtschaftung_hecke_typ_lebhag,
    TRUE, -- bewirtschaftung_hecke_unterhalt,
    'der ganzen Fläche', -- bewirtschaftung_hecke_unterhaltanteil,
    TRUE, -- bewirtschaftung_krautsaum,
    TRUE, -- bewirtschaftung_krautsaum_schnittzeitpunkte,
    TRUE, -- bewirtschaftung_krautsaum_offener_boden,
    FALSE, -- bewirtschaftung_krautsaum_keine_beweidung,
    FALSE, -- bewirtschaftung_krautsaum_beweidung_nach_absprache,
    700, -- bewirtschaftung_krautsaum_abgeltung_ha,
    20, -- bewirtschaftung_lebhag_laufmeter,
    30, -- bewirtschaftung_lebhag_abgeltung_pauschal,
    TRUE, -- erschwernis_massnahme1,
    11, -- erschwernis_massnahme1_abgeltung_ha,
    TRUE, -- erschwernis_massnahme2,
    22, -- erschwernis_massnahme2_abgeltung_ha,
    TRUE, -- erschwernis_massnahme3,
    33, -- erschwernis_massnahme3_abgeltung_ha,
    66, -- erschwernis_abgeltung_ha,
    now()::date-1, -- beurteilungsdatum,
    'Test-Entry', 
    TRUE, -- kopie_an_bewirtschafter,
    TRUE, -- mit_bewirtschafter_besprochen,
    1391, -- abgeltung_per_ha_total,
    2086.5, -- abgeltung_flaeche_total,
    130, -- abgeltung_pauschal_total,
    5, -- abgeltung_generisch_betrag,
    2221.5, -- abgeltung_total,
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '01_TEST_00003') -- vereinbarung
);

-- Beurteilung 3 - (am neusten aber noch nicht besprochen - zählt nicht)
-- einstiegskriterien = 200 ha
-- 2 arten faunabonus = 100 p 
-- Strauch 100 + Schichtholzbeigen 150 + Steinhaufen 150 + Sitzwarte 25 = 425 ha
-- Krautsaum 300 + Schnittzeitpunkte 100 + Offener Boden 300 = 700 ha
-- 2000 Meter Lebhag = 3000 p
-- ersch1 11 + ersch2 22 + ersch 33 = 66 ha
-- pauschal: 3100
-- per ha: 1391
-- * flaeche 1.5 = 2086.5
-- generisch 5.- trinkgeld
-- total = 5191.5
INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_hecke
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_lage,
    einstiegskriterium_mindestdimension_gehoelz_krautsaum,
    einstiegskriterium_unterhalteingriffe_abgesprochen,
    einstiegskriterium_verzichtdiversegeraete,
    einstiegskriterium_verzichthilfsstoffe,
    einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
    einstiegskriterium_bff_stufe_i_ii_erfuellt,
    einstiegskriterium_abgeltung_ha,
    faunabonus_anzahl_arten,
    faunabonus_artenvielfalt_abgeltung_pauschal,
    einstufungbeurteilungistzustand_artenvielfalt_strauch_bmrten,
    einstufungbeurteilungistzustand_asthaufen,
    einstufungbeurteilungistzustand_totholz,
    einstufungbeurteilungistzustand_steinhaufen,
    einstufungbeurteilungistzustand_schichtholzbeigen,
    einstufungbeurteilungistzustand_nisthilfe_wildbienen,
    einstufungbeurteilungistzustand_hoehlenbaeume_biotpbm_ttholz,
    einstufungbeurteilungistzustand_sitzwarte,
    einstufungbeurteilungistzustand_abgeltung_ha,
    bewirtschaftung_hecke_typ_niederhecke,
    bewirtschaftung_hecke_typ_hochhecke,
    bewirtschaftung_hecke_typ_baumhecke,
    bewirtschaftung_hecke_typ_lebhag,
    bewirtschaftung_hecke_unterhalt,
    bewirtschaftung_hecke_unterhaltanteil,
    bewirtschaftung_krautsaum,
    bewirtschaftung_krautsaum_schnittzeitpunkte,
    bewirtschaftung_krautsaum_offener_boden,
    bewirtschaftung_krautsaum_keine_beweidung,
    bewirtschaftung_krautsaum_beweidung_nach_absprache,
    bewirtschaftung_krautsaum_abgeltung_ha,
    bewirtschaftung_lebhag_laufmeter,
    bewirtschaftung_lebhag_abgeltung_pauschal,
    erschwernis_massnahme1,
    erschwernis_massnahme1_abgeltung_ha,
    erschwernis_massnahme2,
    erschwernis_massnahme2_abgeltung_ha,
    erschwernis_massnahme3,
    erschwernis_massnahme3_abgeltung_ha,
    erschwernis_abgeltung_ha,
    beurteilungsdatum,
    bemerkungen,
    kopie_an_bewirtschafter,
    mit_bewirtschafter_besprochen,
    abgeltung_per_ha_total,
    abgeltung_flaeche_total,
    abgeltung_pauschal_total,
    abgeltung_generisch_betrag,
    abgeltung_total,
    erstellungsdatum,
    operator_erstellung,
    berater,
    vereinbarung
) 
VALUES
(
    (SELECT t_id FROM arp_mjpnl_v1.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
    uuid_generate_v4(),
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    TRUE,
    200, -- einstiegskriterium_abgeltung_ha,
    2, -- faunabonus_anzahl_arten,
    100, -- faunabonus_artenvielfalt_abgeltung_pauschal,
    TRUE, -- einstufungbeurteilungistzustand_artenvielfalt_strauch_bmrten,
    FALSE, -- einstufungbeurteilungistzustand_asthaufen,
    FALSE, -- einstufungbeurteilungistzustand_totholz,
    TRUE, -- einstufungbeurteilungistzustand_steinhaufen,
    TRUE, -- einstufungbeurteilungistzustand_schichtholzbeigen,
    FALSE, -- einstufungbeurteilungistzustand_nisthilfe_wildbienen,
    FALSE, -- einstufungbeurteilungistzustand_hoehlenbaeume_biotpbm_ttholz,
    TRUE, -- einstufungbeurteilungistzustand_sitzwarte,
    425, -- einstufungbeurteilungistzustand_abgeltung_ha,
    TRUE, -- bewirtschaftung_hecke_typ_niederhecke,
    FALSE, -- bewirtschaftung_hecke_typ_hochhecke,
    FALSE, -- bewirtschaftung_hecke_typ_baumhecke,
    FALSE, -- bewirtschaftung_hecke_typ_lebhag,
    TRUE, -- bewirtschaftung_hecke_unterhalt,
    'der ganzen Fläche', -- bewirtschaftung_hecke_unterhaltanteil,
    TRUE, -- bewirtschaftung_krautsaum,
    TRUE, -- bewirtschaftung_krautsaum_schnittzeitpunkte,
    TRUE, -- bewirtschaftung_krautsaum_offener_boden,
    FALSE, -- bewirtschaftung_krautsaum_keine_beweidung,
    FALSE, -- bewirtschaftung_krautsaum_beweidung_nach_absprache,
    700, -- bewirtschaftung_krautsaum_abgeltung_ha,
    2000, -- bewirtschaftung_lebhag_laufmeter,
    3000, -- bewirtschaftung_lebhag_abgeltung_pauschal,
    TRUE, -- erschwernis_massnahme1,
    11, -- erschwernis_massnahme1_abgeltung_ha,
    TRUE, -- erschwernis_massnahme2,
    22, -- erschwernis_massnahme2_abgeltung_ha,
    TRUE, -- erschwernis_massnahme3,
    33, -- erschwernis_massnahme3_abgeltung_ha,
    66, -- erschwernis_abgeltung_ha,
    now()::date, -- beurteilungsdatum,
    'Test-Entry', 
    TRUE, -- kopie_an_bewirtschafter,
    FALSE, -- mit_bewirtschafter_besprochen,
    1391, -- abgeltung_per_ha_total,
    2086.5, -- abgeltung_flaeche_total,
    130, -- abgeltung_pauschal_total,
    5, -- abgeltung_generisch_betrag,
    2221.5, -- abgeltung_total,
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '01_TEST_00003') -- vereinbarung
);