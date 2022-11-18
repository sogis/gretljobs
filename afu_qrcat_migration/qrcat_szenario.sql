SELECT
     szen.title AS szenario_titel,
     szen.wkb_geometry AS geometrie,
     CASE
         WHEN szen."R_SZENARIO" = 1 THEN 'Brand'
         WHEN szen."R_SZENARIO" = 2 THEN 'Explosion'
         WHEN szen."R_SZENARIO" = 3 THEN 'toxische_Wolke'
     END AS szenario_art,
     szen.w_szenario AS wahrscheinlichkeit_szenario,
     szen."ASZ" AS asz_relevante_freisetzungsflaeche,
     szen."MSZ" AS msz_relevante_freigesetzte_stoffmenge,
     szen."Q_STOFF" AS q_stoff_stoffspezverbrennungswaerme,
     round(szen.r_lr90::numeric,1) AS lsz_90,
     round(szen.r_lr1::numeric,1) AS lsz_1,
     szen."F_ANZ" AS betriebsfaktor_f_anz,
     '{"f_bdo":' || szen."F_BDO" || ',' ||
     '"f_car":' || szen."F_CAR" || ',' ||
     '"f_sik":' || szen."F_SIK" || ',' ||
     '"f_smn":' || szen."F_SMN" || ',' ||
     '"id_detailszenarioghk":' || szen."W_GHK" || ',' ||
     '"id_toxreferenzszenario":' || szen.tox_referenz_id ||
     '}' AS bemerkung,
     -- FWerte (Referenzen)
     -- die eigentlich Werte (IDs) werden in Post-Processing-Schritt abgefüllt
     99999 AS f_bdo,
     99999 AS f_car,
     99999 AS f_sik,
     99999 AS f_smn,
     -- Referenzen auf andere Tabellen
     -- die eigentlich Werte werden in Post-Processing-Schritt abgefüllt
     99999 AS id_detailszenarioghk,
     99999 AS id_toxreferenzszenario,
     szen."BRID" AS id_bereich,
     szen."BSID" AS id_betrieb,
     szen."LSID" AS id_stoff,
     szen.id_assoziation AS id_stoff_in_bereich
   FROM qrcat."tbl_RCAT_SZENARIO" szen
  WHERE id_assoziation IS NOT NULL
;
