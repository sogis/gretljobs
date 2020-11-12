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
    prj.dispname AS projekttyp,
    string_agg(gentyp.dispname,', ') genossenschaft_typ,
    string_agg(genoss.aname,', ') genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    el.geometrie AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH tmp AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'url','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnt_bw_flchn_bwssrung = el.t_id
        )
        SELECT json_agg(jsondok) FROM tmp
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_bew_flaechen_bewaesserung el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.bewaesserung_flaechen bwfltyp ON el.typ = bwfltyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttypen = prj.ilicode
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
    prj.dispname AS projekttyp,
    string_agg(gentyp.dispname,', ') genossenschaft_typ,
    string_agg(genoss.aname,', ') genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    el.geometrie AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH tmp AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'url','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_bewaesserng_lnie = el.t_id
        )
        SELECT json_agg(jsondok) FROM tmp
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_bewaesserung_linie el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.bewaesserung_linien bwlintyp ON el.typ = bwlintyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttypen = prj.ilicode
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
    prj.dispname AS projekttyp,
    string_agg(gentyp.dispname,', ') genossenschaft_typ,
    string_agg(genoss.aname,', ') genossenschaft_name,
    el.geometrie AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    NULL::geometry(MultiPOlygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH tmp AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'url','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelemnte_bewaesserng_pnkt = el.t_id
        )
        SELECT json_agg(jsondok) FROM tmp
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_bewaesserung_punkt el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.bewaesserung_punkte bwpkttyp ON el.typ = bwpkttyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttypen = prj.ilicode
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
    prj.dispname AS projekttyp,
    string_agg(gentyp.dispname,', ') genossenschaft_typ,
    string_agg(genoss.aname,', ') genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    el.geometrie AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH tmp AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'url','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlichelmnt_ntw_bdnstrktr_flche = el.t_id
        )
        SELECT json_agg(jsondok) FROM tmp
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_flaeche el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.entw_bodenstruktur_flaechen entwbsfltyp ON el.typ = entwbsfltyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttypen = prj.ilicode
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
    prj.dispname AS projekttyp,
    string_agg(gentyp.dispname,', ') genossenschaft_typ,
    string_agg(genoss.aname,', ') genossenschaft_name,
    NULL::geometry(Point,2056) AS punktgeometrie,
    el.geometrie AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH tmp AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'url','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlicheelmnt_ntw_bdnstrktr_lnie = el.t_id
        )
        SELECT json_agg(jsondok) FROM tmp
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_linie el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.entw_bodenstruktur_linien entwbslintyp ON el.typ = entwbslintyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttypen = prj.ilicode
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
    prj.dispname AS projekttyp,
    string_agg(gentyp.dispname,', ') genossenschaft_typ,
    string_agg(genoss.aname,', ') genossenschaft_name,
    el.geometrie AS punktgeometrie,
    NULL::geometry(MultiLineString,2056) AS liniengeometrie,
    NULL::geometry(MultiPolygon,2056) AS flaechengeometrie,
    werkeig.aname AS werkeigentum,
    (
      WITH tmp AS (
        SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'url','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
        FROM
          alw_strukturverbesserungen.raeumlicheelemnte_raeumliches_element_dokument ztdok
          LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
            WHERE ztdok.rauemliches_element_raeumlchlmnt_ntw_bdnstrktr_pmpwerk = el.t_id
        )
        SELECT json_agg(jsondok) FROM tmp
    )::jsonb AS dokumente
  FROM alw_strukturverbesserungen.raeumlicheelemnte_entw_bodenstruktur_pumpwerk el
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt proj ON el.projekt = proj.t_id
    LEFT JOIN alw_strukturverbesserungen.astatus status ON el.astatus = status.ilicode
    LEFT JOIN alw_strukturverbesserungen.bautyp btyp ON el.bautyp = btyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.projekt prj ON proj.projekttypen = prj.ilicode
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

-- final ordering    
  ORDER BY t_id
;