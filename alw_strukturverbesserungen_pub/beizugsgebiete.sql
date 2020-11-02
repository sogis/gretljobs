SELECT
      bzgb.t_id,
      bzgb.geometrie,
      bzgb.datum_nachfuehrung,
      bzgb.typ,
      string_agg(prj.geschaeftsnummer,', ') AS geschaeftsnr
  FROM alw_strukturverbesserungen.raeumlicheelemnte_beizugsgebiet bzgb
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_beizugsgebiet_projekt zt ON bzgb.t_id = zt.beizugsgebiet
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON zt.projekt = prj.t_id
  GROUP BY bzgb.t_id, bzgb.geometrie, bzgb.datum_nachfuehrung, bzgb.typ
;
