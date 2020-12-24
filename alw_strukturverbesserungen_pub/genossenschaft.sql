WITH gen AS (
  SELECT
    gen.t_id,
    gen.t_ili_tid,
    gen.typ,
    gen.aname,
    gen.adresse,
    gen.unterhaltsobjekt AS unterhaltsobjekte,
    gen.gruendungsdatum,
    gen.genehmigungsdatum,
    gen.reorganisationsdatum,
    gen.aufloesungsdatum,
    gen.bemerkung,
    gen.geometrie,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'url','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.genossenschaft = gen.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM
    alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft gen
),
projekte AS (
    --Bewaesserung Flächen
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlichlmnt_bw_flchn_bwssrung IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_bew_flaechen_bewaesserung el ON el.t_id = ztgenel.element_genossenschaft_raeumlichlmnt_bw_flchn_bwssrung
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Bewaesserung Linien
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlicheelemnte_bewssrng_lnie IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_bewaesserung_linie el ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_bewssrng_lnie
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Bewaesserung Punkte
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlicheelemnte_bewssrng_lnie IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_bewaesserung_linie el ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_bewssrng_lnie
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Entwaesserung Bodenstruktur Flaeche
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raemlchlmnt_ntw_bdnstrktr_flche IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_flaeche el ON el.t_id = ztgenel.element_genossenschaft_raemlchlmnt_ntw_bdnstrktr_flche
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Entwaesserung Bodenstruktur Linie
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlchlmnt_ntw_bdnstrktr_lnie IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_linie el ON el.t_id = ztgenel.element_genossenschaft_raeumlchlmnt_ntw_bdnstrktr_lnie
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Entwaesserung Bodenstruktur Pumpwerk
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raemlchlmnt_ntwdnstrktr_pmpwerk IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_pumpwerk el ON el.t_id = ztgenel.element_genossenschaft_raemlchlmnt_ntwdnstrktr_pmpwerk
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Elektrizitaetsversorgung Linie
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlicheelemnte_ev_linie IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_ev_linie el ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_ev_linie
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Elektrizitaetsversorgung Punkt
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlicheelemnte_ev_punkt IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_ev_punkt el ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_ev_punkt
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Oeologie Flaeche
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlicheelemnte_oekolog_flche IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_oekologie_flaeche el ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_oekolog_flche
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Oekologie Linie
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlicheelemnte_oekologi_lnie IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_oekologie_linie el ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_oekologi_lnie
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Oekologie Punkt
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlicheelemnte_oekologi_pnkt IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_oekologie_punkt el ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_oekologi_pnkt
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Oekologie Trockenmauer
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlicheelemnte_klg_trcknmuer IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_oekologie_trockenmauer el ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_klg_trcknmuer
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Wasserversorgung Leitung
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raemlchlmnt_wv_tng_wssrvrsrgung IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_wv_leitung_wasserversorgung el ON el.t_id = ztgenel.element_genossenschaft_raemlchlmnt_wv_tng_wssrvrsrgung
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Wasserversorgung Punkt
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlichelmnt_wssrvrsrgng_pnkt IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_wasserversorgung_punkt el ON el.t_id = ztgenel.element_genossenschaft_raeumlichelmnt_wssrvrsrgng_pnkt
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Wegebau Linie
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlicheelemnte_wegebau_linie IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_wegebau_linie el ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_wegebau_linie
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Wegebau Bruecken
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlichlmnt_wg_brck_lhnnvdukt IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_wege_bruecke_lehnenviadukt el ON el.t_id = ztgenel.element_genossenschaft_raeumlichlmnt_wg_brck_lhnnvdukt
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
  UNION
    --Wiederherstellung Punkt
    SELECT DISTINCT
      gen.t_id,
      proj.kantonsnummer,
      proj.geschaeftsnummer
    FROM
      gen
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON gen.t_id = ztgenel.genossenschaft_element AND ztgenel.element_genossenschaft_raeumlichelmnt_wdrhrstllng_pnkt IS NOT NULL
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_wiederherstellung_punkt el ON el.t_id = ztgenel.element_genossenschaft_raeumlichelmnt_wdrhrstllng_pnkt
      LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
)

SELECT
    gen.t_id,
    gen.t_ili_tid,
    gen.typ,
    gen.aname,
    gen.adresse,
    gen.unterhaltsobjekte,
    gen.gruendungsdatum,
    gen.genehmigungsdatum,
    gen.reorganisationsdatum,
    gen.aufloesungsdatum,
    gen.bemerkung,
    gen.geometrie,
    string_agg(proj.kantonsnummer,', ') AS kantonsnummern,
    string_agg(proj.geschaeftsnummer,', ') AS geschaeftsnummern,
    gen.dokumente
  FROM gen
    LEFT JOIN projekte proj ON gen.t_id = proj.t_id
  GROUP BY
    gen.t_id,
    gen.t_ili_tid,
    gen.typ,
    gen.aname,
    gen.adresse,
    gen.unterhaltsobjekte,
    gen.gruendungsdatum,
    gen.genehmigungsdatum,
    gen.reorganisationsdatum,
    gen.aufloesungsdatum,
    gen.bemerkung,
    gen.geometrie,
    gen.dokumente
  ORDER BY t_id ASC
;
