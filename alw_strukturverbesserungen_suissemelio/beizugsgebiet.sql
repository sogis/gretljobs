SELECT
    bg.t_id,
    (ST_Dump(bg.geometrie)).geom AS geometrie,
    bg.datum_nachfuehrung,
    bg.typ,
    Left(string_agg(prj.geschaeftsnummer,', '),10) AS geschaeftsnummer,
    Left(string_agg(prj.kantonsnummer,', '), 40) AS kantonsnummer
  FROM alw_strukturverbesserungen.raeumlicheelemnte_beizugsgebiet bg
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_beizugsgebiet_projekt zt ON bg.t_id = zt.beizugsgebiet
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_projekt prj ON prj.t_id = zt.projekt
  WHERE prj.geschaeftsnummer IS NOT NULL
  GROUP BY bg.t_id, bg.datum_nachfuehrung, bg.typ
;
