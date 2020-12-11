SELECT
      bzgb.t_id,
      bzgb.t_ili_tid,
      bzgb.geometrie,
      datum_nachfuehrung AS datum_nachfuehrung,
      bzgbtyp.dispname AS typ,
      string_agg(prj.geschaeftsnummer,', ') AS geschaeftsnummern,
      string_agg(prj.kantonsnummer,', ') AS kantonsnummern,
      string_agg(prj.projekttyp,', ') AS projekttyp
  FROM alw_strukturverbesserungen.raeumlicheelemnte_beizugsgebiet bzgb
    LEFT JOIN alw_strukturverbesserungen.beizugsgebiete bzgbtyp ON bzgb.typ = bzgbtyp.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_beizugsgebiet_projekt zt ON bzgb.t_id = zt.beizugsgebiet
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON zt.projekt = prj.t_id
  GROUP BY bzgb.t_id, bzgb.geometrie, bzgb.datum_nachfuehrung, bzgbtyp.dispname
;
