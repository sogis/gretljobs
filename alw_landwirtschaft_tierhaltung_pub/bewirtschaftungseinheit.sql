SELECT
    bewe.t_id,
    bewe.t_basket,
    bewe.t_datasetname,
    'so_lw_l0211019betrbsdttrktrdten_bewirtschaftungseinheit' AS t_type,
    bewe.t_ili_tid,
    bewe.geometrie, 
    bewe.bezugsjahr,
    bewe.bewe_id,
    bewe.bewe_typ,
    bewe.zone_bewe_code,
    bewe.zone_bewe_text,
    bewe.ohne_dz_bauzone,
    bewe.pflanzenbauliche_flaeche,
    bewe.bestockte_flaeche,
    bewe.unproduktive_flaeche,
    bewe.betriebsnummer_agis,
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
    alw_landwirtschaft_tierhaltung_v1.betrbsdttrktrdten_bewirtschaftungseinheit AS bewe
    LEFT JOIN alw_landwirtschaft_tierhaltung_v1.betrbsdttrktrdten_betrieb AS betrieb
        ON bewe.betrieb = betrieb.t_id
    LEFT JOIN alw_landwirtschaft_tierhaltung_v1.betrbsdttrktrdten_gelan_person AS person
        ON person.t_id = betrieb.person
WHERE 
-- es wird immer nur ein Jahr publiziert
    bewe.bezugsjahr = ${publikationsjahr_flaechenerhebung}
;
