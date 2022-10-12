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
     -- FWerte (Referenzen)
     -- die eigentlich Werte (IDs) werden in Post-Processing-Schritt abgefüllt
     99 AS f_bdo,
     99 AS f_car,
     99 AS f_sik,
     99 AS f_smn,
     -- Referenzen auf andere Tabellen
     -- die eigentlich Werte werden in Post-Processing-Schritt abgefüllt
     99 AS id_detailszenarioghk,
     99 AS id_toxreferenzszenario,
     szen.id_betrieb AS id_betrieb,
     szen."BSID" AS id_stoff
   FROM qrcat."tbl_RCAT_SZENARIO" szen;
