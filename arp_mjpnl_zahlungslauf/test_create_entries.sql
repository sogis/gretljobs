/* 
- Lösche gemäss operator_erstellung "Test34"
*/

/*  00_HE_00001
    Inaktive Vereinbarung hecke ohne Beurteilung
    -> Keine Leistungen werden erstellt.
*/
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
    bewe_id_geprueft,
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
    '00_HE_00001',
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
    'inaktiv',
    true,
    false,
    'MJPNL_2032',
    4,
    'Test-Entry: Inaktive Vereinbarung hecke ohne Beurteilung',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

/*  00_HE_00002
    Aktive Vereinbarung hecke ohne Beurteilung
    -> Leistungen werden vom Vorjahr kopiert (wobei diese natürlich keine Vorjahresleistungen hat)
*/
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
    bewe_id_geprueft,
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
    '00_HE_00002',
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
    true,
    false,
    'MJPNL_2032',
    4,
    'Test-Entry: Aktive Vereinbarung hecke ohne Beurteilung',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

/*  00_HE_00003
    Vereinbarung hecke mit 3 Beurteilungen, einer NOT mit_bewirtschafter_besprochen
    -> berechnet Leistungen anhand von neuster, besprochenen Beurteilung
*/
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
    bewe_id_geprueft,
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
    '00_He_00003',
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
    true,
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
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_He_00003') -- vereinbarung
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
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_He_00003') -- vereinbarung
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
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_He_00003') -- vereinbarung
);

/*  00_ALRB_00001
    Vereinbarung alr_buntbrache mit Beurteilung
*/
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
    bewe_id_geprueft,
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
    '00_ALRB_00001',
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
    true,
    false,
    'MJPNL_2032',
    4,
    'Vereinbarung alr_buntbrache mit Beurteilung',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

-- Beurteilung ALR_Buntbrache:
-- 2 arten faunabonus = 200 p 
-- alle bewirtschaftungen = 200 ha
-- Strauch 200 + Steinhaufen 50 + Erdhaufen 50 = 300 p 
-- pauschal: 500
-- per ha: 200
-- * flaeche 1.5 = 300
-- total = 800
INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_alr_buntbrache
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_massnahmengebiet_feldhasenlerchen,
    einstiegskriterium_min_ackerflaeche,
    einstiegskriterium_nicht_entlang_flurwegen,
    einstiegskriterium_vor_ansaat_acker,
    einstiegskriterium_standort_diverse_kriterien,
    einstiegskriterium_maxbreite_12m,
    einstiegskriterium_mindestdauer_artenschutz_fauna,
    einstiegskriterium_problempflanzen_bekaempfen,
    einstiegskriterium_zwischenbeurteilung_alle_2jahre,
    einstiegskriterium_monitoring_durch_bewirtschafter,
    faunabonus_anzahl_arten,
    faunabonus_artenvielfalt_abgeltung_pauschal,
    bewirtschaftung_ansaat_und_pflege,
    bewirtschaftung_reinigungsschnitte,
    bewirtschaftung_schnittzeitpunkt,
    bewirtschaftung_schnitthoehe,
    bewirtschaftung_schnittgut_trocknen_lassen,
    bewirtschaftung_abgeltung_ha,
    strukturelemente_strauchgruppen,
    strukturelemente_strauchgruppen_abgeltung_pauschal,
    strukturelemente_asthaufen_totholz,
    strukturelemente_asthaufen_totholz_abgeltung_pauschal,
    strukturelemente_steinhaufen,
    strukturelemente_steinhaufen_abgeltung_pauschal,
    strukturelemente_schnittguthaufen,
    strukturelemente_schnittguthaufen_abgeltung_pauschal,
    strukturelemente_erdhaufen,
    strukturelemente_erdhaufen_abgeltung_pauschal,
    strukturelemente_abgeltung_pauschal_total,
    abgeltung_per_ha_total,
    abgeltung_flaeche_total,
    abgeltung_pauschal_total,
    beurteilungsdatum,
    abgeltung_total,
    mit_bewirtschafter_besprochen,
    erstellungsdatum,
    operator_erstellung,
    berater,
    vereinbarung
) 
VALUES 
(
    (SELECT t_id FROM arp_mjpnl_v1.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
    uuid_generate_v4(),
    true,           -- einstiegskriterium_massnahmengebiet_feldhasenlerchen
    true,           -- einstiegskriterium_min_ackerflaeche
    true,           -- einstiegskriterium_nicht_entlang_flurwegen
    true,           -- einstiegskriterium_vor_ansaat_acker
    true,           -- einstiegskriterium_standort_diverse_kriterien
    true,           -- einstiegskriterium_maxbreite_12m
    true,           -- einstiegskriterium_mindestdauer_artenschutz_fauna
    true,           -- einstiegskriterium_problempflanzen_bekaempfen
    true,           -- einstiegskriterium_zwischenbeurteilung_alle_2jahre
    true,           -- einstiegskriterium_monitoring_durch_bewirtschafter
    2,              -- faunabonus_anzahl_arten
    200.00,           -- faunabonus_artenvielfalt_abgeltung_pauschal
    true,           -- bewirtschaftung_ansaat_und_pflege
    true,           -- bewirtschaftung_reinigungsschnitte
    true,           -- bewirtschaftung_schnittzeitpunkt
    true,           -- bewirtschaftung_schnitthoehe
    true,           -- bewirtschaftung_schnittgut_trocknen_lassen
    200.00,           -- bewirtschaftung_abgeltung_ha
    true,           -- strukturelemente_strauchgruppen
    200.00,           -- strukturelemente_strauchgruppen_abgeltung_pauschal
    false,           -- strukturelemente_asthaufen_totholz
    0.00,           -- strukturelemente_asthaufen_totholz_abgeltung_pauschal
    true,           -- strukturelemente_steinhaufen
    50.00,           -- strukturelemente_steinhaufen_abgeltung_pauschal
    false,           -- strukturelemente_schnittguthaufen
    0.00,           -- strukturelemente_schnittguthaufen_abgeltung_pauschal
    true,           -- strukturelemente_erdhaufen
    50.00,           -- strukturelemente_erdhaufen_abgeltung_pauschal
    300.00,           -- strukturelemente_abgeltung_pauschal_total
    200.00,           -- abgeltung_per_ha_total
    300.00,           -- abgeltung_flaeche_total
    500.00,           -- abgeltung_pauschal_total
    now()::date,     -- beurteilungsdatum
    800,                -- abgeltung_total
    true,           -- mit_bewirtschafter_besprochen
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_ALRB_00001') -- vereinbarung
);

/*  00_ALRS_00001
    Vereinbarung alr_saum Beurteilung
*/
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
    bewe_id_geprueft,
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
    '00_ALRS_00001',
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
    true,
    false,
    'MJPNL_2032',
    4,
    'Vereinbarung alr_saum mit Beurteilung',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

-- Beurteilung ALR_Saum:
-- einstiegskriterien = 0
-- 3 arten faunabonus = 300 p 
-- eine bewirtschaftung nicht = 0 ha
-- Strauch 100 + Steinhaufen 50 + Schnittgut 50 = 200 p 
-- pauschal: 500
-- per ha: 0
-- * flaeche 1.5 = 0
-- total = 500
INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_alr_saum
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_massnahmengebiet_feldhasenlerchen,
    einstiegskriterium_min_ackerflaeche,
    einstiegskriterium_nicht_entlang_flurwegen,
    einstiegskriterium_vor_ansaat_acker,
    einstiegskriterium_standort_diverse_kriterien,
    einstiegskriterium_maxbreite_12m,
    einstiegskriterium_mindestdauer_artenschutz_fauna,
    einstiegskriterium_problempflanzen_bekaempfen,
    einstiegskriterium_zwischenbeurteilung_alle_2jahre,
    einstiegskriterium_monitoring_durch_bewirtschafter,
    faunabonus_anzahl_arten,
    faunabonus_artenvielfalt_abgeltung_pauschal,
    bewirtschaftung_ansaat_und_pflege,
    bewirtschaftung_reinigungsschnitte,
    bewirtschaftung_schnittzeitpunkt,
    bewirtschaftung_schnitthoehe,
    bewirtschaftung_schnittgut_trocknen_lassen,
    bewirtschaftung_abgeltung_ha,
    strukturelemente_strauchgruppen,
    strukturelemente_strauchgruppen_abgeltung_pauschal,
    strukturelemente_asthaufen_totholz,
    strukturelemente_asthaufen_totholz_abgeltung_pauschal,
    strukturelemente_steinhaufen,
    strukturelemente_steinhaufen_abgeltung_pauschal,
    strukturelemente_schnittguthaufen,
    strukturelemente_schnittguthaufen_abgeltung_pauschal,
    strukturelemente_abgeltung_pauschal_total,
    abgeltung_per_ha_total,
    abgeltung_flaeche_total,
    abgeltung_pauschal_total,
    beurteilungsdatum,
    abgeltung_total,
    mit_bewirtschafter_besprochen,
    erstellungsdatum,
    operator_erstellung,
    berater,
    vereinbarung
) 
VALUES 
(
    (SELECT t_id FROM arp_mjpnl_v1.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
    uuid_generate_v4(),
    true,               -- einstiegskriterium_massnahmengebiet_feldhasenlerchen
    true,               -- einstiegskriterium_min_ackerflaeche
    true,               -- einstiegskriterium_nicht_entlang_flurwegen
    true,               -- einstiegskriterium_vor_ansaat_acker
    true,               -- einstiegskriterium_standort_diverse_kriterien
    true,               -- einstiegskriterium_maxbreite_12m
    true,               -- einstiegskriterium_mindestdauer_artenschutz_fauna
    true,               -- einstiegskriterium_problempflanzen_bekaempfen
    true,               -- einstiegskriterium_zwischenbeurteilung_alle_2jahre
    true,               -- einstiegskriterium_monitoring_durch_bewirtschafter
    3,                  -- faunabonus_anzahl_arten
    300.00,               -- faunabonus_artenvielfalt_abgeltung_pauschal
    true,               -- bewirtschaftung_ansaat_und_pflege
    true,               -- bewirtschaftung_reinigungsschnitte
    false,               -- bewirtschaftung_schnittzeitpunkt
    true,               -- bewirtschaftung_schnitthoehe
    true,               -- bewirtschaftung_schnittgut_trocknen_lassen
    0.00,               -- bewirtschaftung_abgeltung_ha
    true,               -- strukturelemente_strauchgruppen
    100.00,               -- strukturelemente_strauchgruppen_abgeltung_pauschal
    false,               -- strukturelemente_asthaufen_totholz
    0.00,               -- strukturelemente_asthaufen_totholz_abgeltung_pauschal
    true,               -- strukturelemente_steinhaufen
    50.00,               -- strukturelemente_steinhaufen_abgeltung_pauschal
    true,               -- strukturelemente_schnittguthaufen
    50.00,               -- strukturelemente_schnittguthaufen_abgeltung_pauschal
    200.00,               -- strukturelemente_abgeltung_pauschal_total
    0.00,               -- abgeltung_per_ha_total
    0.00,               -- abgeltung_flaeche_total
    600.00,               -- abgeltung_pauschal_total
    now()::date,     -- beurteilungsdatum
    600,            -- abgeltung_total
    true,           -- mit_bewirtschafter_besprochen
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_ALRS_00001') -- vereinbarung
);

/*  00_Ho_00001
    Vereinbarung hostet Beurteilung
*/
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
    bewe_id_geprueft,
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
    '00_Ho_00001',
    ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
    (SELECT pid_gelan FROM arp_mjpnl_v1.betrbsdttrktrdten_gelan_person LIMIT 1),
    'GELAN_BEWE_DUMMY',
    false,
    '{2601}',
    '{"Dummy-Gemeinde"}',
    '{"Dummy-GBNr"}',
    '{"Dummy-Flurname"}',
    'Hostet',
    false,
    1.5,
    'aktiv',
    true,
    false,
    'MJPNL_2032',
    4,
    'Vereinbarung hostet mit Beurteilung',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

-- Beurteilung Hostet:
-- grundbeitrag 15 * 5 = 75
-- 40cm 10 * 15 = 150
-- erntepflicht 0 = 0
-- oekoplus 3 * 10 = 30
-- oekomaxi 7 * 10 = 70
-- total 325 
INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_hostet
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_hostet,
    grundbeitrag_baum_anzahl,
    grundbeitrag_baum_total,
    beitrag_baumab40cmdurchmesser_anzahl,
    beitrag_baumab40cmdurchmesser_total,
    beitrag_erntepflicht_anzahl,
    beitrag_erntepflicht_total,
    beitrag_oekoplus_anzahl,
    beitrag_oekoplus_total,
    beitrag_oekomaxi_anzahl,
    beitrag_oekomaxi_total,
    beurteilungsdatum,
    abgeltung_total,
    mit_bewirtschafter_besprochen,
    erstellungsdatum,
    operator_erstellung,
    berater,
    vereinbarung
) 
VALUES 
(
    (SELECT t_id FROM arp_mjpnl_v1.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
    uuid_generate_v4(),
    true,               -- einstiegskriterium_hostet
    15,                 -- grundbeitrag_baum_anzahl
    75.00,              -- grundbeitrag_baum_total
    10,                  -- beitrag_baumab40cmdurchmesser_anzahl
    150.00,            -- beitrag_baumab40cmdurchmesser_total
    0,                  -- beitrag_erntepflicht_anzahl
    0.00,             -- beitrag_erntepflicht_total
    3,                  -- beitrag_oekoplus_anzahl
    30.00,             -- beitrag_oekoplus_total
    7,                  -- beitrag_oekomaxi_anzahl
    70.00,             -- beitrag_oekomaxi_total
    now()::date,     -- beurteilungsdatum
    325.00,         --abgeltung_total
    true,           -- mit_bewirtschafter_besprochen
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_Ho_00001') -- vereinbarung
);

/*  00_OBL_00001
    Vereinbarung obl Beurteilung
*/
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
    bewe_id_geprueft,
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
    '00_OBL_00001',
    ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
    (SELECT pid_gelan FROM arp_mjpnl_v1.betrbsdttrktrdten_gelan_person LIMIT 1),
    'GELAN_BEWE_DUMMY',
    false,
    '{2601}',
    '{"Dummy-Gemeinde"}',
    '{"Dummy-GBNr"}',
    '{"Dummy-Flurname"}',
    'OBL',
    false,
    1.5,
    'aktiv',
    true,
    false,
    'MJPNL_2032',
    4,
    'Vereinbarung obl mit Beurteilung',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

-- Beurteilung OBL:
-- grundbeitrag 10 * 10 = 100
-- 40cm 5 * 15 = 75
-- erntepflicht 2 * 10 = 20
-- oekoplus 0 = 0
-- oekomaxi 3 * 10 = 30
-- generisch (Trinkgeld) 5
-- total 230
INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_obl
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_obl,
    grundbeitrag_baum_anzahl,
    grundbeitrag_baum_total,
    beitrag_baumab40cmdurchmesser_anzahl,
    beitrag_baumab40cmdurchmesser_total,
    beitrag_erntepflicht_anzahl,
    beitrag_erntepflicht_total,
    beitrag_oekoplus_anzahl,
    beitrag_oekoplus_total,
    beitrag_oekomaxi_anzahl,
    beitrag_oekomaxi_total,
    abgeltung_generisch_betrag,
    beurteilungsdatum,
    abgeltung_total,
    mit_bewirtschafter_besprochen,
    erstellungsdatum,
    operator_erstellung,
    berater,
    vereinbarung
) 
VALUES 
(
    (SELECT t_id FROM arp_mjpnl_v1.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
    uuid_generate_v4(),
    true,               -- einstiegskriterium_obl
    10,                 -- grundbeitrag_baum_anzahl
    100.00,             -- grundbeitrag_baum_total
    5,                  -- beitrag_baumab40cmdurchmesser_anzahl
    75.00,            -- beitrag_baumab40cmdurchmesser_total
    2,                  -- beitrag_erntepflicht_anzahl
    20.00,             -- beitrag_erntepflicht_total
    0,                  -- beitrag_oekoplus_anzahl
    0.00,             -- beitrag_oekoplus_total
    3,                  -- beitrag_oekomaxi_anzahl
    30.00,             -- beitrag_oekomaxi_total
    5.00,               -- abgeltung_generisch_betrag
    now()::date,     -- beurteilungsdatum
    230.00,         --abgeltung_total
    true,           -- mit_bewirtschafter_besprochen
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_OBL_00001') -- vereinbarung
);

/*  00_WBLWe_00001
    Vereinbarung wbl_weide Beurteilung
*/
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
    bewe_id_geprueft,
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
    '00_WBLWe_00001',
    ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
    (SELECT pid_gelan FROM arp_mjpnl_v1.betrbsdttrktrdten_gelan_person LIMIT 1),
    'GELAN_BEWE_DUMMY',
    false,
    '{2601}',
    '{"Dummy-Gemeinde"}',
    '{"Dummy-GBNr"}',
    '{"Dummy-Flurname"}',
    'WBL_Weide',
    false,
    1.5,
    'aktiv',
    true,
    false,
    'MJPNL_2032',
    4,
    'Vereinbarung wbl_weide mit Beurteilung',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

-- Beurteilung WBL_Weide:
-- einstiegskriterien = 100 ha
-- 3 arten faunabonus = 150 p 
-- Kat_W1 = 100 ha
-- opt Struktur = 100 ha
-- ersch. massnahme1 = 200 ha
-- spez artförderung = 50 ha
-- strukturelemente streuehaufen 300 + asthaufen 300 + gebüsch 200 = 800 p
-- total ha 550
-- * flaeche 1.5 = 825
-- total 950 p
-- total = 1775 .-

INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_wbl_weide
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_lage,
    einstiegskriterium_keinezufuetterung,
    einstiegskriterium_verzichtduengung,
    einstiegskriterium_verzichtdiversegeraete,
    einstiegskriterium_verzichthilfsstoffe,
    einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
    einstiegskriterium_abgeltung_ha,
    einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
    einstufungbeurteilungistzustand_flora_typische_arten,
    einstufungbeurteilungistzustand_flora_bes_typ_arten,
    einstufungbeurteilungistzustand_flora_seltene_arten,
    einstufungbeurteilungistzustand_anzahl_fauna,
    einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
    einstufungbeurteilungistzustand_weidenkategorie,
    einstufungbeurteilungistzustand_weidenkategorie_abgeltung_ha,
    einstufungbeurteilungistzustand_struktur_optimal_beibehalten,
    einstufungbeurteilungistzustand_struktur_verbessern_anlegen,
    einstufungbeurteilungistzustand_struktur_vrbschng_ngrff_ntig,
    einstufungbeurteilungistzustand_struktur_abgeltung_ha,
    einstufungbeurteilungistzustand_bodeneigenschaften,
    einstufungbeurteilungistzustand_weidnarbe,
    einstufungbeurteilungistzustand_besonderestrukturen,
    einstufungbeurteilungistzustand_abgeltung_ha,
    bewirtschaftabmachung_beweidungrinder,
    bewirtschaftabmachung_beweidunganderetierrassen,
    bewirtschaftabmachung_beweidungszeitraum,
    bewirtschaftabmachung_besatzdichte,
    bewirtschaftabmachung_besatzdichte_zahl,
    erschwernis_massnahme1,
    erschwernis_massnahme1_text,
    erschwernis_massnahme1_abgeltung_ha,
    erschwernis_massnahme2,
    erschwernis_massnahme2_text,
    erschwernis_massnahme2_abgeltung_ha,
    erschwernis_abgeltung_ha,
    artenfoerderung_ff_zielart1,
    artenfoerderung_ff_zielart1_massnahme,
    artenfoerderung_ff_zielart1_abgeltung,
    artenfoerderung_ff_zielart2_abgeltung,
    artenfoerderung_ff_zielart3_abgeltung,
    artenfoerderung_abgeltungsart,
    artenfoerderung_abgeltung_total,
    strukturelemente_gewaesser,
    strukturelemente_gewaesser_abgeltung,
    strukturelemente_hochstaudenflurenriederoehrichte,
    strukturelemente_hochstaudenflurenriederoehrichte_abgeltung,
    strukturelemente_streuehaufen,
    strukturelemente_streuehaufen_abgeltung,
    strukturelemente_asthaufentotholz,
    strukturelemente_asthaufentotholz_abgeltung,
    strukturelemente_steinhaufen,
    strukturelemente_steinhaufen_abgeltung,
    strukturelemente_gebueschgruppen,
    strukturelemente_gebueschgruppen_abgeltung,
    strukturelemente_kopfweiden,
    strukturelemente_kopfweiden_abgeltung,
    strukturelemente_abgeltung_total,
    abgeltung_per_ha_total,
    abgeltung_flaeche_total,
    abgeltung_pauschal_total,
    beurteilungsdatum,
    mit_bewirtschafter_besprochen,
    abgeltung_generisch_text,
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
    true,               -- einstiegskriterium_lage
    true,               -- einstiegskriterium_keinezufuetterung
    true,               -- einstiegskriterium_verzichtduengung
    true,               -- einstiegskriterium_verzichtdiversegeraete
    true,               -- einstiegskriterium_verzichthilfsstoffe
    true,               -- einstiegskriterium_keineinsatzwieseneggenstriegelwalzen
    100.00,             -- einstiegskriterium_abgeltung_ha
    0,                  -- einstufungbeurteilungistzustand_flora_naehrstoffzeiger
    0,                  -- einstufungbeurteilungistzustand_flora_typische_arten
    0,                  -- einstufungbeurteilungistzustand_flora_bes_typ_arten
    0,                  -- einstufungbeurteilungistzustand_flora_seltene_arten
    3,                  -- einstufungbeurteilungistzustand_anzahl_fauna
    150.00,               -- einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal
    'Kat_W1',                 -- einstufungbeurteilungistzustand_weidenkategorie
    100.00,               -- einstufungbeurteilungistzustand_weidenkategorie_abgeltung_ha
    true,               -- einstufungbeurteilungistzustand_struktur_optimal_beibehalten
    false,              -- einstufungbeurteilungistzustand_struktur_verbessern_anlegen
    false,              -- einstufungbeurteilungistzustand_struktur_vrbschng_ngrff_ntig
    100.00,               -- einstufungbeurteilungistzustand_struktur_abgeltung_ha
    '{}',               -- einstufungbeurteilungistzustand_bodeneigenschaften
    '{}',               -- einstufungbeurteilungistzustand_weidnarbe
    '{}',               -- einstufungbeurteilungistzustand_besonderestrukturen
    200.00,             -- einstufungbeurteilungistzustand_abgeltung_ha
    false,               -- bewirtschaftabmachung_beweidungrinder
    false,              -- bewirtschaftabmachung_beweidunganderetierrassen
    false,               -- bewirtschaftabmachung_beweidungszeitraum
    false,               -- bewirtschaftabmachung_besatzdichte
    '0',                -- bewirtschaftabmachung_besatzdichte_zahl
    true,              -- erschwernis_massnahme1
    'Man muss alles von Hand schneiden',                 -- erschwernis_massnahme1_text
    200.00,               -- erschwernis_massnahme1_abgeltung_ha
    false,              -- erschwernis_massnahme2
    '',                 -- erschwernis_massnahme2_text
    0.00,               -- erschwernis_massnahme2_abgeltung_ha
    200.00,               -- erschwernis_abgeltung_ha
    'Kolibris',                 -- artenfoerderung_ff_zielart1
    'Futterhäuschen',                 -- artenfoerderung_ff_zielart1_massnahme
    50.00,               -- artenfoerderung_ff_zielart1_abgeltung
    0.00,               -- artenfoerderung_ff_zielart2_abgeltung
    0.00,               -- artenfoerderung_ff_zielart3_abgeltung
    'per_ha',                 -- artenfoerderung_abgeltungsart
    50.00,               -- artenfoerderung_abgeltung_total
    false,              -- strukturelemente_gewaesser
    0.00,               -- strukturelemente_gewaesser_abgeltung
    false,              -- strukturelemente_hochstaudenflurenriederoehrichte
    0.00,               -- strukturelemente_hochstaudenflurenriederoehrichte_abgeltung
    true,              -- strukturelemente_streuehaufen
    300.00,               -- strukturelemente_streuehaufen_abgeltung
    true,              -- strukturelemente_asthaufentotholz
    300.00,               -- strukturelemente_asthaufentotholz_abgeltung
    false,              -- strukturelemente_steinhaufen
    0.00,               -- strukturelemente_steinhaufen_abgeltung
    true,              -- strukturelemente_gebueschgruppen
    200.00,               -- strukturelemente_gebueschgruppen_abgeltung
    false,              -- strukturelemente_kopfweiden
    0.00,               -- strukturelemente_kopfweiden_abgeltung
    800.00,               -- strukturelemente_abgeltung_total
    550.00,               -- abgeltung_per_ha_total
    825.00,               -- abgeltung_flaeche_total
    900.00,               -- abgeltung_pauschal_total
    now()::date,     -- beurteilungsdatum
    true,           -- mit_bewirtschafter_besprochen
    '',                 -- abgeltung_generisch_text
    0.00,               -- abgeltung_generisch_betrag
    1725.00,               -- abgeltung_total
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_WBLWe_00001') -- vereinbarung
);


/*  00_WBLWi_00001
    Vereinbarung wbl_wiese Beurteilung
*/
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
    bewe_id_geprueft,
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
    '00_WBLWi_00001',
    ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
    (SELECT pid_gelan FROM arp_mjpnl_v1.betrbsdttrktrdten_gelan_person LIMIT 1),
    'GELAN_BEWE_DUMMY',
    false,
    '{2601}',
    '{"Dummy-Gemeinde"}',
    '{"Dummy-GBNr"}',
    '{"Dummy-Flurname"}',
    'WBL_Wiese',
    false,
    1.5,
    'aktiv',
    true,
    false,
    'MJPNL_2032',
    4,
    'Vereinbarung wbl_wiese mit Beurteilung',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

-- Beurteilung WBL_Wiese:
-- einstiegskriterien 100 ha
-- faunabonus 50 p
-- kategorie KAT II RF 220 ha
-- messebalkengerät 300 ha
-- erschwernis 1 - bieber - 100 ha
-- artenförderung schmetterlinge 100 p
-- struktur steinhaufen 50 p
-- total ha 720
-- * 1.5 flaeche = 1080
-- total pauschal 200
-- total 1280
INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_wbl_wiese
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_lage,
    einstiegskriterium_verzichtduengung,
    einstiegskriterium_verzichtdiversegeraete,
    einstiegskriterium_verzichthilfsstoffe,
    einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
    einstiegskriterium_bodenheu,
    einstiegskriterium_abgeltung_ha,
    einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
    einstufungbeurteilungistzustand_flora_typische_arten,
    einstufungbeurteilungistzustand_flora_bes_typ_arten,
    einstufungbeurteilungistzustand_flora_seltene_arten,
    einstufungbeurteilungistzustand_anzahl_fauna,
    einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
    einstufungbeurteilungistzustand_wiesenkategorie,
    einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha,
    bewirtschaftabmachung_schnittzeitpunkte,
    bewirtschaftabmachung_emdenbodenheu,
    bewirtschaftabmachung_rueckzugstreifen,
    bewirtschaftabmachung_herbstschnitt,
    bewirtschaftabmachung_herbstweide,
    bewirtschaftabmachung_keineherbstweide,
    bewirtschaftabmachung_messerbalkenmaehgeraet,
    bewirtschaftabmachung_abgeltung_ha,
    erschwernis_massnahme1,
    erschwernis_massnahme1_text,
    erschwernis_massnahme1_abgeltung_ha,
    erschwernis_massnahme2,
    erschwernis_massnahme2_abgeltung_ha,
    erschwernis_abgeltung_ha,
    artenfoerderung_ff_zielart1,
    artenfoerderung_ff_zielart1_massnahme,
    artenfoerderung_ff_zielart1_abgeltung,
    artenfoerderung_ff_zielart2_abgeltung,
    artenfoerderung_ff_zielart3_abgeltung,
    artenfoerderung_abgeltungsart,
    artenfoerderung_abgeltung_total,
    strukturelemente_gewaesser,
    strukturelemente_gewaesser_abgeltung,
    strukturelemente_hochstaudenflurenriederoehrichte,
    strukturelemente_hochstaudenflurenriederoehrichte_abgeltung,
    strukturelemente_streuehaufen,
    strukturelemente_streuehaufen_abgeltung,
    strukturelemente_asthaufentotholz,
    strukturelemente_asthaufentotholz_abgeltung,
    strukturelemente_steinhaufen,
    strukturelemente_steinhaufen_abgeltung,
    strukturelemente_gebueschgruppen,
    strukturelemente_gebueschgruppen_abgeltung,
    strukturelemente_kopfweiden,
    strukturelemente_kopfweiden_abgeltung,
    strukturelemente_abgeltung_total,
    abgeltung_per_ha_total,
    abgeltung_flaeche_total,
    abgeltung_pauschal_total,
    beurteilungsdatum,
    abgeltung_total,
    mit_bewirtschafter_besprochen,
    erstellungsdatum,
    operator_erstellung,
    berater,
    vereinbarung
) 
VALUES 
(
    (SELECT t_id FROM arp_mjpnl_v1.t_ili2db_basket WHERE t_ili_tid = 'SO_ARP_MJPNL_20201026.MJPNL' LIMIT 1),
    uuid_generate_v4(),
    true,               -- einstiegskriterium_lage
    true,               -- einstiegskriterium_verzichtduengung
    true,               -- einstiegskriterium_verzichtdiversegeraete
    true,               -- einstiegskriterium_verzichthilfsstoffe
    true,               -- einstiegskriterium_keineinsatzwieseneggenstriegelwalzen
    true,               -- einstiegskriterium_bodenheu
    100.00,               -- einstiegskriterium_abgeltung_ha
    0,                  -- einstufungbeurteilungistzustand_flora_naehrstoffzeiger
    0,                  -- einstufungbeurteilungistzustand_flora_typische_arten
    0,                  -- einstufungbeurteilungistzustand_flora_bes_typ_arten
    0,                  -- einstufungbeurteilungistzustand_flora_seltene_arten
    1,                  -- einstufungbeurteilungistzustand_anzahl_fauna
    50.00,               -- einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal
    'Kat_II_RF',                 -- einstufungbeurteilungistzustand_wiesenkategorie
    220.00,               -- einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha
    true,               -- bewirtschaftabmachung_schnittzeitpunkte
    false,              -- bewirtschaftabmachung_emdenbodenheu
    true,               -- bewirtschaftabmachung_rueckzugstreifen
    false,              -- bewirtschaftabmachung_herbstschnitt
    false,              -- bewirtschaftabmachung_herbstweide
    true,               -- bewirtschaftabmachung_keineherbstweide
    true,              -- bewirtschaftabmachung_messerbalkenmaehgeraet
    300.00,               -- bewirtschaftabmachung_abgeltung_ha
    true,               -- erschwernis_massnahme1
    'Bieber etc.',      -- erschwernis_massnahme1_text
    100,                -- erschwernis_massnahme1_abgeltung_ha
    false,              -- erschwernis_massnahme2
    0,                -- erschwernis_massnahme2_abgeltung_ha
    100.00,             -- erschwernis_abgeltung_ha
    'Schmetterlinge',   -- artenfoerderung_ff_zielart1,
    'Pflege',           -- artenfoerderung_ff_zielart1_massnahme,
    100.00,             -- artenfoerderung_ff_zielart1_abgeltung,
    0.00,             -- artenfoerderung_ff_zielart2_abgeltung,
    0.00,             -- artenfoerderung_ff_zielart3_abgeltung,
    'pauschal',         -- artenfoerderung_abgeltungsart
    100.00,             -- artenfoerderung_abgeltung_total
    false,              -- strukturelemente_gewaesser
    0.00,               -- strukturelemente_gewaesser_abgeltung
    false,              -- strukturelemente_hochstaudenflurenriederoehrichte
    0.00,               -- strukturelemente_hochstaudenflurenriederoehrichte_abgeltung
    false,              -- strukturelemente_streuehaufen
    0.00,               -- strukturelemente_streuehaufen_abgeltung
    false,              -- strukturelemente_asthaufentotholz
    0.00,               -- strukturelemente_asthaufentotholz_abgeltung
    true,              -- strukturelemente_steinhaufen
    50.00,               -- strukturelemente_steinhaufen_abgeltung
    false,              -- strukturelemente_gebueschgruppen
    0.00,               -- strukturelemente_gebueschgruppen_abgeltung
    false,              -- strukturelemente_kopfweiden
    0.00,               -- strukturelemente_kopfweiden_abgeltung
    50.00,               -- strukturelemente_abgeltung_total
    720.00,               -- abgeltung_per_ha_total
    1080.00,               -- abgeltung_flaeche_total
    200.00,               -- abgeltung_pauschal_total
    now()::date,      -- beurteilungsdatum
    1280, -- abgeltung_total
    true,               -- mit_bewirtschafter_besprochen
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_WBLWi_00001') -- vereinbarung
);


/*  00_WeLN_00001
    Vereinbarung weide_ln Beurteilung
*/
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
    bewe_id_geprueft,
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
    '00_WeLN_00001',
    ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
    (SELECT pid_gelan FROM arp_mjpnl_v1.betrbsdttrktrdten_gelan_person LIMIT 1),
    'GELAN_BEWE_DUMMY',
    false,
    '{2601}',
    '{"Dummy-Gemeinde"}',
    '{"Dummy-GBNr"}',
    '{"Dummy-Flurname"}',
    'Weide_LN',
    false,
    1.5,
    'aktiv',
    true,
    false,
    'MJPNL_2032',
    4,
    'Vereinbarung weide_ln mit Beurteilung',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

-- Beurteilung Weide_LN:
-- einstiegskriterien = 100 ha
-- 3 arten faunabonus = 150 p 
-- Kat_W_RF = 0 ha
-- opt Struktur = 100 ha
-- ersch. massnahme1 = 10 ha
-- total ha 210
-- * flaeche 1.5 = 315
-- total 150 p
-- total = 465.-
INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_weide_ln
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_lage,
    einstiegskriterium_mindestflaeche,
    einstiegskriterium_keinezufuetterung,
    einstiegskriterium_verzichtduengung,
    einstiegskriterium_verzichtdiversegeraete,
    einstiegskriterium_verzichthilfsstoffe,
    einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
    einstiegskriterium_abgeltung_ha,
    einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
    einstufungbeurteilungistzustand_flora_typische_arten,
    einstufungbeurteilungistzustand_flora_bes_typ_arten,
    einstufungbeurteilungistzustand_flora_seltene_arten,
    einstufungbeurteilungistzustand_anzahl_fauna,
    einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
    einstufungbeurteilungistzustand_weidenkategorie,
    einstufungbeurteilungistzustand_weidenkategorie_abgeltung_ha,
    einstufungbeurteilungistzustand_struktur_optimal_beibehalten,
    einstufungbeurteilungistzustand_struktur_verbessern_anlegen,
    einstufungbeurteilungistzustand_struktur_vrbschng_ngrff_ntig,
    einstufungbeurteilungistzustand_struktur_abgeltung_ha,
    einstufungbeurteilungistzustand_abgeltung_ha,
    bewirtschaftabmachung_beweidungrinder,
    bewirtschaftabmachung_beweidungmutterkuehe,
    bewirtschaftabmachung_beweidungszeitraum,
    bewirtschaftabmachung_besatzdichte,
    erschwernis_massnahme1,
    erschwernis_massnahme1_text,
    erschwernis_massnahme1_abgeltung_ha,
    erschwernis_massnahme2,
    erschwernis_massnahme2_abgeltung_ha,
    erschwernis_abgeltung_ha,
    artenfoerderung_ff_zielart1_abgeltung,
    artenfoerderung_ff_zielart2_abgeltung,
    artenfoerderung_ff_zielart3_abgeltung,
    artenfoerderung_abgeltungsart,
    artenfoerderung_abgeltung_total,
    abgeltung_per_ha_total,
    abgeltung_flaeche_total,
    abgeltung_pauschal_total,
    beurteilungsdatum,
    mit_bewirtschafter_besprochen,
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
    true, -- einstiegskriterium_lage,
    true,               -- einstiegskriterium_mindestflaeche,
    true,               -- einstiegskriterium_keinezufuetterung,
    true,               -- einstiegskriterium_verzichtduengung,
    true,               -- einstiegskriterium_verzichtdiversegeraete,
    true,               -- einstiegskriterium_verzichthilfsstoffe,
    true,               -- einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
    100,                -- einstiegskriterium_abgeltung_ha
    0,               -- einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
    0,               -- einstufungbeurteilungistzustand_flora_typische_arten,
    0,               -- einstufungbeurteilungistzustand_flora_bes_typ_arten,
    0,               -- einstufungbeurteilungistzustand_flora_seltene_arten,
    3,               -- einstufungbeurteilungistzustand_anzahl_fauna,
    150,               -- einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
    'Kat_W_RF',     -- einstufungbeurteilungistzustand_weidenkategorie,
    0,              -- einstufungbeurteilungistzustand_weidenkategorie_abgeltung_ha,
    true,   --einstufungbeurteilungistzustand_struktur_optimal_beibehalten,
    false, --einstufungbeurteilungistzustand_struktur_verbessern_anlegen,
    false, --einstufungbeurteilungistzustand_struktur_vrbschng_ngrff_ntig,
    100,    -- einstufungbeurteilungistzustand_struktur_abgeltung_ha,
    100,    -- einstufungbeurteilungistzustand_abgeltung_ha,
    false, --bewirtschaftabmachung_beweidungrinder,
    false, --bewirtschaftabmachung_beweidungmutterkuehe,
    false, --bewirtschaftabmachung_beweidungszeitraum,
    false, --bewirtschaftabmachung_besatzdichte,
    true, -- erschwernis_massnahme1,
    'schwierig zu schneiden', -- erschwernis_massnahme1_text,
    10, --erschwernis_massnahme1_abgeltung_ha,
    false, --erschwernis_massnahme2,
    0, --erschwernis_massnahme2_abgeltung_ha,
    10,     --erschwernis_abgeltung_ha,
    0,      --artenfoerderung_ff_zielart1_abgeltung,
    0,      --artenfoerderung_ff_zielart2_abgeltung,
    0,      --artenfoerderung_ff_zielart3_abgeltung,
    'pauschal',      --artenfoerderung_abgeltungsart,
    0, --artenfoerderung_abgeltung_total,
    210,    --abgeltung_per_ha_total,
    315,    -- abgeltung_flaeche_total,
    150,    -- abgeltung_pauschal_total,
    now()::date,     -- beurteilungsdatum
    true,           -- mit_bewirtschafter_besprochen
    465,        -- abgeltung_total,
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_WeLN_00001') -- vereinbarung
);


/*  00_WeSög_00001
    Vereinbarung weide_soeg Beurteilung
*/
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
    bewe_id_geprueft,
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
    '00_WeSög_00001',
    ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
    (SELECT pid_gelan FROM arp_mjpnl_v1.betrbsdttrktrdten_gelan_person LIMIT 1),
    'GELAN_BEWE_DUMMY',
    false,
    '{2601}',
    '{"Dummy-Gemeinde"}',
    '{"Dummy-GBNr"}',
    '{"Dummy-Flurname"}',
    'Weide_SOEG',
    false,
    1.5,
    'aktiv',
    true,
    false,
    'MJPNL_2032',
    4,
    'Vereinbarung weide_soeg mit Beurteilung',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

-- Beurteilung Weide_Sög:
-- einstiegskriterien = 100 ha
-- 2 arten faunabonus = 100 p 
-- Kat_W_1 = 200 ha
-- ersch. massnahme1 = 100 ha
-- zielart 300 p
-- total ha 400
-- * flaeche 1.5 = 600
-- total 400 p
-- total = 1000.-
INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_weide_soeg
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_lage,
    einstiegskriterium_mindestflaeche,
    einstiegskriterium_keinezufuetterung,
    einstiegskriterium_verzichtduengung,
    einstiegskriterium_verzichtdiversegeraete,
    einstiegskriterium_verzichthilfsstoffe,
    einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
    einstiegskriterium_abgeltung_ha,
    einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
    einstufungbeurteilungistzustand_flora_typische_arten,
    einstufungbeurteilungistzustand_flora_bes_typ_arten,
    einstufungbeurteilungistzustand_flora_seltene_arten,
    einstufungbeurteilungistzustand_anzahl_fauna,
    einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
    einstufungbeurteilungistzustand_weidenkategorie,
    einstufungbeurteilungistzustand_weidenkategorie_abgeltung_ha,
    einstufungbeurteilungistzustand_struktur_optimal_beibehalten,
    einstufungbeurteilungistzustand_struktur_verbessern_anlegen,
    einstufungbeurteilungistzustand_struktur_vrbschng_ngrff_ntig,
    einstufungbeurteilungistzustand_struktur_abgeltung_ha,
    einstufungbeurteilungistzustand_abgeltung_ha,
    bewirtschaftabmachung_beweidungrinder,
    bewirtschaftabmachung_beweidungmutterkuehe,
    bewirtschaftabmachung_beweidungszeitraum,
    bewirtschaftabmachung_besatzdichte,
    erschwernis_massnahme1,
    erschwernis_massnahme1_text,
    erschwernis_massnahme1_abgeltung_ha,
    erschwernis_massnahme2,
    erschwernis_massnahme2_abgeltung_ha,
    erschwernis_massnahme3,
    erschwernis_massnahme3_abgeltung_ha,
    erschwernis_abgeltung_ha,
    artenfoerderung_ff_zielart1,
    artenfoerderung_ff_zielart1_abgeltung,
    artenfoerderung_ff_zielart2_abgeltung,
    artenfoerderung_ff_zielart3_abgeltung,
    artenfoerderung_abgeltungsart,
    artenfoerderung_abgeltung_total,
    abgeltung_per_ha_total,
    abgeltung_flaeche_total,
    abgeltung_pauschal_total,
    beurteilungsdatum,
    mit_bewirtschafter_besprochen,
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
    true, -- einstiegskriterium_lage,
    true,               -- einstiegskriterium_mindestflaeche,
    true,               -- einstiegskriterium_keinezufuetterung,
    true,               -- einstiegskriterium_verzichtduengung,
    true,               -- einstiegskriterium_verzichtdiversegeraete,
    true,               -- einstiegskriterium_verzichthilfsstoffe,
    true,               -- einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
    100,                -- einstiegskriterium_abgeltung_ha
    0,               -- einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
    0,               -- einstufungbeurteilungistzustand_flora_typische_arten,
    0,               -- einstufungbeurteilungistzustand_flora_bes_typ_arten,
    0,               -- einstufungbeurteilungistzustand_flora_seltene_arten,
    2,               -- einstufungbeurteilungistzustand_anzahl_fauna,
    100,               -- einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
    'Kat_W_1',     -- einstufungbeurteilungistzustand_weidenkategorie,
    200,              -- einstufungbeurteilungistzustand_weidenkategorie_abgeltung_ha,
    false,   --einstufungbeurteilungistzustand_struktur_optimal_beibehalten,
    false, --einstufungbeurteilungistzustand_struktur_verbessern_anlegen,
    false, --einstufungbeurteilungistzustand_struktur_vrbschng_ngrff_ntig,
    0,    -- einstufungbeurteilungistzustand_struktur_abgeltung_ha,
    200,    -- einstufungbeurteilungistzustand_abgeltung_ha,
    false, --bewirtschaftabmachung_beweidungrinder,
    false, --bewirtschaftabmachung_beweidungmutterkuehe,
    false, --bewirtschaftabmachung_beweidungszeitraum,
    false, --bewirtschaftabmachung_besatzdichte,
    true, -- erschwernis_massnahme1,
    'Alles mit Sense', -- erschwernis_massnahme1_text,
    100, --erschwernis_massnahme1_abgeltung_ha,
    false, --erschwernis_massnahme2,
    0, --erschwernis_massnahme2_abgeltung_ha,
    false, --erschwernis_massnahme3,
    0, --erschwernis_massnahme3_abgeltung_ha,
    100,     --erschwernis_abgeltung_ha,
    'Finken', --artenfoerderung_ff_zielart1,
    100,      --artenfoerderung_ff_zielart1_abgeltung,
    0,      --artenfoerderung_ff_zielart2_abgeltung,
    0,      --artenfoerderung_ff_zielart3_abgeltung,
    'pauschal',      --artenfoerderung_abgeltungsart,
    300, --artenfoerderung_abgeltung_total,
    400,    --abgeltung_per_ha_total,
    600,    -- abgeltung_flaeche_total,
    400,    -- abgeltung_pauschal_total,
    now()::date,     -- beurteilungsdatum
    true,           -- mit_bewirtschafter_besprochen
    1000,        -- abgeltung_total,
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_WeSög_00001') -- vereinbarung
);

/*  00_Wi_00001
    Vereinbarung wiese Beurteilung
*/
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
    bewe_id_geprueft,
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
    '00_Wi_00001',
    ST_GeomFromText('MultiPolygon(((2607251.77485882537439466 1228263.4145868313498795, 2607286.84019394358620048 1228231.1071994190569967, 2607340.42317794449627399 1228270.90044489037245512, 2607304.56985776731744409 1228305.17779494961723685, 2607251.77485882537439466 1228263.4145868313498795)))'),
    (SELECT pid_gelan FROM arp_mjpnl_v1.betrbsdttrktrdten_gelan_person LIMIT 1),
    'GELAN_BEWE_DUMMY',
    false,
    '{2601}',
    '{"Dummy-Gemeinde"}',
    '{"Dummy-GBNr"}',
    '{"Dummy-Flurname"}',
    'Wiese',
    false,
    1.5,
    'aktiv',
    true,
    false,
    'MJPNL_2032',
    4,
    'Vereinbarung wiese mit Beurteilung',
    (SELECT t_id FROM arp_mjpnl_v1.umweltziele_uzl_subregion LIMIT 1),
    false,
    'Dummy-Pfad',
    now()::DATE,
    'Tester'
);

-- Beurteilung Wiese:
-- einstiegskriterien = 200 ha
-- 1 arten faunabonus = 50 p 
-- Kat_I_besondere = 700 ha
-- messerbalken 300 p
-- ersch. massnahme1 100 + massnahme2 50 = 150 ha
-- zielart1 100 + z2 50 + z3 100 = 250 ha
-- total ha 1400
-- * flaeche 1.5 = 2100
-- total 350 p
-- total = 2450.-
INSERT INTO arp_mjpnl_v1.mjpnl_beurteilung_wiese
(
    t_basket,
    t_ili_tid,
    einstiegskriterium_lage,
    einstiegskriterium_mindestflaeche,
    einstiegskriterium_verzichtduengung,
    einstiegskriterium_verzichtdiversegeraete,
    einstiegskriterium_verzichthilfsstoffe,
    einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
    einstiegskriterium_bodenheu,
    einstiegskriterium_abgeltung_ha,
    einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
    einstufungbeurteilungistzustand_flora_typische_arten,
    einstufungbeurteilungistzustand_flora_bes_typ_arten,
    einstufungbeurteilungistzustand_flora_seltene_arten,
    einstufungbeurteilungistzustand_anzahl_fauna,
    einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
    einstufungbeurteilungistzustand_wiesenkategorie,
    einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha,
    bewirtschaftabmachung_heuschnittabgesprochen,
    bewirtschaftabmachung_emdenbodenheu,
    bewirtschaftabmachung_rueckzugstreifen,
    bewirtschaftabmachung_herbstschnitt,
    bewirtschaftabmachung_herbstweide,
    bewirtschaftabmachung_keineherbstweide,
    bewirtschaftabmachung_messerbalkenmaehgeraet,
    bewirtschaftabmachung_abgeltung_ha,
    erschwernis_massnahme1,
    erschwernis_massnahme1_text,
    erschwernis_massnahme1_abgeltung_ha,
    erschwernis_massnahme2,
    erschwernis_massnahme2_text,
    erschwernis_massnahme2_abgeltung_ha,
    erschwernis_abgeltung_ha,
    artenfoerderung_ff_zielart1,
    artenfoerderung_ff_zielart1_abgeltung,
    artenfoerderung_ff_zielart2,
    artenfoerderung_ff_zielart2_abgeltung,
    artenfoerderung_ff_zielart3,
    artenfoerderung_ff_zielart3_abgeltung,
    artenfoerderung_abgeltungsart,
    artenfoerderung_abgeltung_total,
    abgeltung_per_ha_total,
    abgeltung_flaeche_total,
    abgeltung_pauschal_total,
    beurteilungsdatum,
    mit_bewirtschafter_besprochen,
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
    true,    -- einstiegskriterium_lage,
    true,    -- einstiegskriterium_mindestflaeche,
    true,    -- einstiegskriterium_verzichtduengung,
    true,    -- einstiegskriterium_verzichtdiversegeraete,
    true,    -- einstiegskriterium_verzichthilfsstoffe,
    true,    -- einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
    true,    -- einstiegskriterium_bodenheu,
    200,     -- einstiegskriterium_abgeltung_ha,
    0,       -- einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
    0,    -- einstufungbeurteilungistzustand_flora_typische_arten,
    0,    -- einstufungbeurteilungistzustand_flora_bes_typ_arten,
    0,    -- einstufungbeurteilungistzustand_flora_seltene_arten,
    1,    -- einstufungbeurteilungistzustand_anzahl_fauna,
    50,    -- einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
    'Kat_I_besondersartenreicheWiese',    -- einstufungbeurteilungistzustand_wiesenkategorie,
    700,  -- einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha
    true,    -- bewirtschaftabmachung_heuschnittabgesprochen,
    true,    -- bewirtschaftabmachung_emdenbodenheu,
    true,    -- bewirtschaftabmachung_rueckzugstreifen,
    true,    -- bewirtschaftabmachung_herbstschnitt,
    true,    -- bewirtschaftabmachung_herbstweide,
    true,    -- bewirtschaftabmachung_keineherbstweide,
    true,    -- bewirtschaftabmachung_messerbalkenmaehgeraet,
    300,    -- bewirtschaftabmachung_abgeltung_ha,
    true,   -- erschwernis_massnahme1,
    'Alles Sense', -- erschwernis_massnahme1_text,
    100, --erschwernis_massnahme1_abgeltung_ha,
    true, --erschwernis_massnahme2,
    'Mühsames arbeiten', -- erschwernis_massnahme2_text,
    50,    -- erschwernis_massnahme2_abgeltung_ha,
    150,    -- erschwernis_abgeltung_ha,
    'Fuchs', --artenfoerderung_ff_zielart1,
    100,      --artenfoerderung_ff_zielart1_abgeltung,
    'Hase', --artenfoerderung_ff_zielart2,
    50,      --artenfoerderung_ff_zielart2_abgeltung,
    'Wolf', --artenfoerderung_ff_zielart3,
    100,      --artenfoerderung_ff_zielart3_abgeltung,
    'per_ha',    -- artenfoerderung_abgeltungsart,
    250,    -- artenfoerderung_abgeltung_total,
    1400,    -- abgeltung_per_ha_total,
    2100,    -- abgeltung_flaeche_total,
    350,    -- abgeltung_pauschal_total,
    now()::date,     -- beurteilungsdatum
    true,           -- mit_bewirtschafter_besprochen
    2450,        -- abgeltung_total,
    now()::date-20, -- erstellungsdatum,
    'Tester', -- operator_erstellung,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_berater WHERE aname = 'Bruggisser'), -- berater,
    (SELECT t_id FROM arp_mjpnl_v1.mjpnl_vereinbarung WHERE vereinbarungs_nr = '00_Wi_00001') -- vereinbarung
);