SELECT
    bg.t_id,
    bg.geometrie,
    bg.datum_nachfuehrung,
    bg.typ,
    string_agg(prj.geschaeftsnummer,', ') AS geschaeftsnummer,
    string_agg(prj.kantonsnummer,', ') AS kantonsnummer
  FROM alw_strukturverbesserungen.raeumlicheelemnte_beizugsgebiet bg
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_beizugsgebiet_projekt zt ON bg.t_id = zt.beizugsgebiet
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON prj.t_id = zt.projekt
  GROUP BY bg.t_id, bg.geometrie, bg.datum_nachfuehrung, bg.typ
;
