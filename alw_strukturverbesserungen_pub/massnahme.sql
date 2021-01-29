-- Kombination verschiedener Massnahmen
-- Bewässerung Flächen
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Bewässerung Fläche'::character varying(100) AS massnahme,
    bwfltyp.dispname AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    el.geometrie AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnt_bw_flchn_bwssrung = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_bew_flaechen_bewaesserung el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.bewaesserung_flaechen bwfltyp ON el.typ = bwfltyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlichlmnt_bw_flchn_bwssrung
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    bwfltyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Bewässerung Linien
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Bewässerung Linie'::character varying(100) AS massnahme,
    bwlintyp.dispname AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    el.geometrie AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_bewaesserng_lnie = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_bewaesserung_linie el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.bewaesserung_linien bwlintyp ON el.typ = bwlintyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_bewssrng_lnie
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    bwlintyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Bewässerung Punkte
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Bewässerung Punkt'::character varying(100) AS massnahme,
    bwpkttyp.dispname AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    el.geometrie AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    NULL::geometry(MultiPOlygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_bewaesserng_pnkt = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_bewaesserung_punkt el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.bewaesserung_punkte bwpkttyp ON el.typ = bwpkttyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_bewssrng_pnkt
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    bwpkttyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Entwässerung / Bodenstruktur Flächen
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Entwässerung Bodenstruktur Fläche'::character varying(100) AS massnahme,
    entwbsfltyp.dispname AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    el.geometrie AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlichelmnt_ntw_bdnstrktr_flche = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_flaeche el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.entw_bodenstruktur_flaechen entwbsfltyp ON el.typ = entwbsfltyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raemlchlmnt_ntw_bdnstrktr_flche
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    entwbsfltyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Entwässerung / Bodenstruktur Linien
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Entwässerung Bodenstruktur Linie'::character varying(100) AS massnahme,
    entwbslintyp.dispname AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    el.geometrie AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelmnt_ntw_bdnstrktr_lnie = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_linie el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.entw_bodenstruktur_linien entwbslintyp ON el.typ = entwbslintyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlchlmnt_ntw_bdnstrktr_lnie
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    entwbslintyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Entwässerung / Bodenstruktur Pumpwerk
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Entwässerung Bodenstruktur Pumpwerk'::character varying(100) AS massnahme,
    'Pumpwerk'::character varying(50) AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    el.geometrie AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlchlmnt_ntw_bdnstrktr_pmpwerk = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_pumpwerk el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raemlchlmnt_ntwdnstrktr_pmpwerk
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Elektrizitätsversorgung Linien
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Elektrizitätsversorgung Linie'::character varying(100) AS massnahme,
    evlintyp.dispname AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    el.geometrie AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_ev_linie = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_ev_linie el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.elektrizitaet_linien evlintyp ON el.typ = evlintyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_ev_linie
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    evlintyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Elektrizitätsversorgung Punkt
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Elektrizitätsversorgung Punkt'::character varying(100) AS massnahme,
    evpkttyp.dispname AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    el.geometrie AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_ev_punkt = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_ev_punkt el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.elektrizitaet_punkte evpkttyp ON el.typ = evpkttyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_ev_punkt
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    evpkttyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Wasserversorgung Linien
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Wasserversorgung Linie'::character varying(100) AS massnahme,
   'Wasserversorgung Leitung'::character varying(50) AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    el.geometrie AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlichlmnt_wv_ltng_wssrvrsrgung = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_wv_leitung_wasserversorgung el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raemlchlmnt_wv_tng_wssrvrsrgung
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Wasserversorgung Punkte
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Wasserversorgung Punkt'::character varying(100) AS massnahme,
    wvpkttyp.dispname AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    el.geometrie AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_wssrvrsrgng_pnkt = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_wasserversorgung_punkt el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.wasserversorgung_punkte wvpkttyp ON el.typ = wvpkttyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlichelmnt_wssrvrsrgng_pnkt
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    wvpkttyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Ökologie Flächen
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Ökologie Fläche'::character varying(100) AS massnahme,
    oekfltyp.dispname AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    el.geometrie AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_oekologie_flache = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_oekologie_flaeche el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.oekologische_flaechen oekfltyp ON el.typ = oekfltyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_oekolog_flche
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    oekfltyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Ökologie Linien
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Ökologie Linie'::character varying(100) AS massnahme,
    oeklintyp.dispname AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    el.geometrie AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_oekologie_linie = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_oekologie_linie el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.oekologie_linien oeklintyp ON el.typ = oeklintyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_oekologi_lnie
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    oeklintyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Ökologie Punkte
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Ökologie Punkte'::character varying(100) AS massnahme,
    oekpkttyp.dispname AS typ,
    NULL::character varying(30) AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    el.geometrie AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_oekologie_punkt = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_oekologie_punkt el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.oekologie_punkte oekpkttyp ON el.typ = oekpkttyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_oekologi_pnkt
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    oekpkttyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Ökologie Trockenmaur
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Ökologie Trockenmauer'::character varying(100) AS massnahme,
    oektrcktyp.dispname AS typ,
    btyp.dispname AS bautyp,
    el.hoehe AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    el.geometrie AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_oekolg_trcknmuer = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_oekologie_trockenmauer el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.oekologie_trockenmauern oektrcktyp ON el.typ = oektrcktyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_klg_trcknmuer
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    oektrcktyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Wegebau Linien
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Wegebau Linie'::character varying(100) AS massnahme,
    wegtyp.dispname AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    el.fahrbahnbreite AS fahrbahnbreite,
    el.laenge_gerundet AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    funkttyp.dispname AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    el.geometrie AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_wegebau_linie = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_wegebau_linie el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.wege wegtyp ON el.typ = wegtyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.funktionstyp funkttyp ON el.funktionstyp = funkttyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlicheelemnte_wegebau_linie
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    wegtyp.dispname,
    el.fahrbahnbreite,
    el.laenge_gerundet,
    funkttyp.dispname,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Wegebau Brücke und Lehnenviadukt
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Wegebau Brücke oder Lehnenviadukt'::character varying(100) AS massnahme,
    'Wegebau Brücke oder Lehnenviadukt'::character varying(50) AS typ,
    btyp.dispname AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    el.fahrbahnbreite AS fahrbahnbreite,
    el.laenge AS laenge,
    el.tonnage AS tonnage,
    mat.dispname AS material_wege_bruecke_lehenviadukt,
    el.widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    el.geometrie AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnt_wg_brck_lhnnvdukt = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_wege_bruecke_lehnenviadukt el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlichelmnte_wege_bruecke_lehnenviadukt_material mat ON el.material = mat.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlichlmnt_wg_brck_lhnnvdukt
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    mat.dispname,
    el.fahrbahnbreite,
    el.laenge,
    el.widerlager,
    btyp.dispname,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname
UNION
-- Wiederherstellung Punkt
SELECT
    el.t_id,
    el.t_ili_tid,
    status.dispname AS astatus,
    el.status_datum,
    el.bauabnahme_datum,
    el.werksid,
    el.unterhaltsid,
    'Wiederherstellung Punkt'::character varying(100) AS massnahme,
    wdhtyp.dispname AS typ,
    NULL::character varying(30) AS bautyp,
    NULL::numeric(3,1) AS hoehe,
    NULL::numeric(3,1) AS fahrbahnbreite,
    NULL::numeric(10,1) AS laenge,
    NULL::numeric(4,1) AS tonnage,
    NULL::character varying(30) AS material_wege_bruecke_lehenviadukt,
    NULL::boolean AS widerlager,
    NULL::character varying(30) AS funktionstyp_wegbau,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    COALESCE(prj.dispname,'unbekannt') AS projekttyp,
    string_agg(gentyp.dispname,', ') AS genossenschaft_typ,
    string_agg(genoss.aname,', ') AS genossenschaft_name,
    el.geometrie AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH docs AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'dateipfad','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_wdrhrstllng_pnkt = el.t_id
        )
        SELECT json_agg(jsondok) FROM docs
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_wiederherstellung_punkt el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.wiederherstellung_punkte wdhtyp ON el.typ = wdhtyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttyp = prj.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_werkseigentum werkeig ON el.werkeigentum = werkeig.t_id
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft_element ztgenel ON el.t_id = ztgenel.element_genossenschaft_raeumlichelmnt_wdrhrstllng_pnkt
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_genossenschaft genoss ON ztgenel.genossenschaft_element = genoss.t_id
    LEFT JOIN alw_strukturverbesserungen.genossenschaften gentyp ON genoss.typ = gentyp.ilicode
   GROUP BY
    el.t_id,
    el.t_ili_tid,
    status.dispname,
    el.status_datum,
    el.bauabnahme_datum,
    wdhtyp.dispname,
    el.werksid,
    el.unterhaltsid,
    proj.geschaeftsnummer,
    proj.kantonsnummer,
    prj.dispname,
    el.geometrie,
    werkeig.aname

-- final ordering    
  ORDER BY t_id
;
