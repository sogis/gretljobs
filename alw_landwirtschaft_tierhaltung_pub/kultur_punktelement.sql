SELECT
    kultur.t_id,
    kultur.t_basket,
    kultur.t_datasetname,
    'so_lw_l0211019betrbsdttrktrdten_kultur_punktelement' AS t_type,
    kultur.t_ili_tid,
    kultur.geometrie, 
    kultur.bezugsjahr,
    kultur.kultur_id,
    kultur.kulturcode_gelan,
    kultur.kulturart,
    kultur.zone_kultur_code,
    kultur.zone_kultur_text,
    kultur.ohne_dz_bauzone,
    kultur.bewe_id,
    kultur.flaeche_land_in_ln,
    kultur.flaeche_land_ausserhalb_ln,
    kultur.baumzahl,
    kultur.bff2_flaeche,
    kultur.naturschutzvertrag_flaeche,
    kultur.vernetzung_flaeche,
    kultur.vernetzung_nutzungsvariante,
    bewe.betriebsnummer_agis,
    person.pid_gelan,
    person.name_vorname,
    person.adresse_strasse || ' ' || adresse_hausnummer AS adresse,
    person.telefon_privat,
    person.telefon_geschaeft,
    person.telefon_mobil,
    person.mailadresse,
    person.gemeinde_wohnsitz,
    person.plz || ' ' || person.ortschaft AS plz_ortschaft
FROM
    alw_landwirtschaft_tierhaltung_v1.betrbsdttrktrdten_kultur_punktelemente AS kultur
    LEFT JOIN alw_landwirtschaft_tierhaltung_v1.betrbsdttrktrdten_bewirtschaftungseinheit AS bewe
        ON kultur.bewirtschaftungseinheit = bewe.t_id
    LEFT JOIN alw_landwirtschaft_tierhaltung_v1.betrbsdttrktrdten_betrieb AS betrieb
        ON bewe.betrieb = betrieb.t_id
    LEFT JOIN alw_landwirtschaft_tierhaltung_v1.betrbsdttrktrdten_gelan_person AS person
        ON betrieb.person = person.t_id
WHERE 
-- es wird immer nur ein Jahr publiziert
    bewe.bezugsjahr = ${publikationsjahr_flaechenerhebung}
;
