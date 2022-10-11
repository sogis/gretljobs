SELECT
  dszen."ID" || '§' || dszen."BESCHREIBUNG" AS beschreibung,
  CASE
     WHEN dszen."Szenario" = 'b' THEN 'Brand'
     WHEN dszen."Szenario" = 'e' THEN 'Explosion'
     WHEN dszen."Szenario" = 't' THEN 'toxische_Wolke'
  END AS szenario_art,
  dszen."Detailszenario" AS abkuerzung_detailszenario,
  dszen."TEXTCODE" AS code,
  dszen."W_GHK" AS grundhaeufigkeit_szenario,
  'pro_Jahr' AS wahrscheinlichkeit_grundhaeufigkeit_art,
  asz AS relevant_asz,
  msz AS relevant_msz,
  qstoff AS relevant_qstoff
FROM qrcat."stbl_GHK" dszen;
