SELECT
  dszen."BESCHREIBUNG" AS beschreibung,
  CASE
     WHEN dszen."Szenario" = 'b' THEN 'Brand'
     WHEN dszen."Szenario" = 'e' THEN 'Explosion'
     WHEN dszen."Szenario" = 't' THEN 'toxische_Wolke'
  END AS szenario_art,
  rtrim(dszen."Detailszenario") AS abkuerzung_detailszenario,
  dszen."TEXTCODE" AS acode,
  dszen."W_GHK" AS grundhaeufigkeit_szenario,
  'pro_Jahr' AS wahrscheinlichkeit_grundhaeufigkeit_art,
  asz AS relevant_asz,
  msz AS relevant_msz,
  qstoff AS relevant_q_stoff,
  dszen."ID"::text AS bemerkung
FROM qrcat."stbl_GHK" dszen;
