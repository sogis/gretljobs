SELECT
    standorte.t_id,
    standorte.t_basket,
    standorte.t_datasetname,
    'so_lw_l0211019betrbsdttrktrdten_tierstandort' AS t_type,
    standorte.t_ili_tid,
    standorte.geometrie,
    standorte.bezugsjahr,
    standorte.standortnummer,
    standorte.standorttyp,
    standorte.status_standort,
    standorte.tvd_nummer,
    standorte.tvd_aktiv,
    standorte.bienenstand_nummer,
    standorte.bienenstandort_saisonal,
    standorte.bur_registernummer_standort,
    standorte.gattung_rindvieh,
    standorte.gattung_equiden,
    standorte.gattung_schafe,
    standorte.gattung_ziegen,
    standorte.gattung_schweine,
    standorte.gattung_gefluegel,
    standorte.gattung_wild,
    standorte.gattung_neuweltkameliden,
    standorte.gattung_bienen,
    standorte.gattung_fische,
    standorte.standortnummer_agis,
    betrieb.betriebstyp, 
    betrieb.gemeinde_haupstandort,
    betrieb.betriebsnummer_agis,
    betrieb.betriebszweiggemeinschaft,
    summe.sak_betrieb,
    summe.programm_oeln,
    summe.programm_bio,
    summe.programm_biotyp,
    summe.total_gve_betrieb,
    summe.total_gve_rindvieh,
    summe.total_gve_equiden,
    summe.total_gve_schafe,
    summe.total_gve_ziegen,
    summe.total_gve_schweine,
    summe.total_gve_gefluegel,
    summe.total_gve_andere_raufutter,
    summe.total_gve_andere_tiere,
    summe.total_ln_betrieb,
    person.pid_gelan,
    person.name_vorname,
    person.adresse_strasse || ' ' || adresse_hausnummer AS adresse,
    person.plz || ' ' || person.ortschaft AS plz_ortschaft,
    person.telefon_privat,
    person.telefon_geschaeft,
    person.telefon_mobil,
    person.mailadresse,
    person.gemeinde_wohnsitz
FROM
    alw_landwirtschaft_tierhaltung_v1.betrbsdttrktrdten_standorte AS standorte 
    LEFT JOIN alw_landwirtschaft_tierhaltung_v1.betrbsdttrktrdten_betrieb AS betrieb
        ON standorte.betrieb_standort = betrieb.t_id
    LEFT JOIN alw_landwirtschaft_tierhaltung_v1.betrbsdttrktrdten_summe_tiere_flaechen AS summe
        ON betrieb.t_id = summe.betrieb
    LEFT JOIN alw_landwirtschaft_tierhaltung_v1.betrbsdttrktrdten_gelan_person AS person
        ON person.t_id = betrieb.person
WHERE 
-- es wird immer nur ein Jahr publiziert
    standorte.bezugsjahr = ${publikationsjahr_standort}
;