INSERT
   INTO ${DB_Schema_MJPNL}.mjpnl_beurteilung_weide_soeg
     (
       --ignored: t_id 
       t_basket,
       --ignored: t_ili_tid
       einstiegskriterium_lage,
       einstiegskriterium_mindestflaeche,
       einstiegskriterium_keinezufuetterung,
       einstiegskriterium_verzichtduengung,
       einstiegskriterium_verzichtdiversegeraete,
       einstiegskriterium_verzichthilfsstoffe,
       einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
       einstiegskriterium_abgeltung_ha,
       einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
       einstufungbeurteilungistzustand_flora_typische_arten,
       einstufungbeurteilungistzustand_flora_bes_typ_arten,
       einstufungbeurteilungistzustand_flora_seltene_arten,
       einstufungbeurteilungistzustand_anzahl_fauna,
       einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
       einstufungbeurteilungistzustand_weidenkategorie,
       einstufungbeurteilungistzustand_weidenkategorie_abgeltung_ha,
       einstufungbeurteilungistzustand_struktur_optimal_beibehalten,
       einstufungbeurteilungistzustand_struktur_verbessern_anlegen,
       einstufungbeurteilungistzustand_struktur_vrbschng_ngrff_ntig,
       einstufungbeurteilungistzustand_struktur_abgeltung_ha,
       --ignored: einstufungbeurteilungistzustand_bodeneigenschaften,
       --ignored: einstufungbeurteilungistzustand_weidnarbe,
       --ignored: einstufungbeurteilungistzustand_besonderestrukturen,
       einstufungbeurteilungistzustand_abgeltung_ha,
       bewirtschaftabmachung_beweidungrinder,
       bewirtschaftabmachung_beweidungmutterkuehe,
       bewirtschaftabmachung_beweidungszeitraum,
       --ignored: bewirtschaftabmachung_beweidungszeitraum_von,
       --ignored: bewirtschaftabmachung_beweidungszeitraum_bis,
       bewirtschaftabmachung_besatzdichte,
       --ignored: bewirtschaftabmachung_besatzdichte_zahl,
       erschwernis_massnahme1,
       --ignored: erschwernis_massnahme1_text ,
       erschwernis_massnahme1_abgeltung_ha,
       erschwernis_massnahme2,
       --ignored: erschwernis_massnahme2_text,
       erschwernis_massnahme2_abgeltung_ha,
       erschwernis_massnahme3,
       --ignored: erschwernis_massnahme3_text,
       erschwernis_massnahme3_abgeltung_ha,
       erschwernis_abgeltung_ha,
       --ignored: artenfoerderung_ff_zielart1,
       --ignored: artenfoerderung_ff_zielart1_massnahme,
       artenfoerderung_ff_zielart1_abgeltung,
       --ignored: artenfoerderung_ff_zielart2,
       --ignored: artenfoerderung_ff_zielart2_massnahme,
       artenfoerderung_ff_zielart2_abgeltung,
       --ignored: artenfoerderung_ff_zielart3,
       --ignored: artenfoerderung_ff_zielart3_massnahme,
       artenfoerderung_ff_zielart3_abgeltung,
       artenfoerderung_abgeltungsart,
       artenfoerderung_abgeltung_total,
       beurteilungsdatum,
       bemerkungen,
       kopie_an_bewirtschafter,
       mit_bewirtschafter_besprochen,
       --ignored: datum_besprechung_bewirtschafter
       abgeltung_per_ha_total,
       abgeltung_flaeche_total,
       abgeltung_pauschal_total,
       --ignored: abgeltung_generisch_text
       --ignored: abgeltung_generisch_betrag
       abgeltung_total,
       --ignored: besondere_abmachungen
       erstellungsdatum,
       operator_erstellung,
       --ignored: aenderungsdatum,
       --ignored: operator_aenderung
       berater,
       vereinbarung
     ) 
WITH tmp AS (
    SELECT
        t_id,
        t_basket,
        vereinbarungs_nr,
        flaeche,
        (string_to_array(bemerkung,'§'))[2]::jsonb AS old_attr
    FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung
        WHERE vereinbarungsart = 'Weide_SOEG' AND vereinbarungs_nr != '01_DUMMY_00001'
),
-- ein paar zusätzliche Berechnungen die später wiederverwendet werden sollen
-- zur Vermeidung von Code-Duplication
tmp2 AS (
    SELECT
       *,
       CASE
           WHEN old_attr->>'wiesenkategorie' = 'W 1' THEN 200
           WHEN old_attr->>'wiesenkategorie' = 'W 1+' THEN 300
           WHEN old_attr->>'wiesenkategorie' = 'W 2' THEN 100
           WHEN old_attr->>'wiesenkategorie' = 'W RW' THEN 0
           ELSE 0
       END AS abgeltung_per_ha_total      
    FROM tmp
)
SELECT
   t_basket,
   TRUE AS einstiegskriterium_lage,
   TRUE AS einstiegskriterium_mindestdimension_gehoelz_krautsaum,
   TRUE AS einstiegskriterium_unterhalteingriffe_abgesprochen,
   TRUE AS einstiegskriterium_verzichtdiversegeraete,
   TRUE AS einstiegskriterium_verzichthilfsstoffe,
   TRUE AS einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
   TRUE AS einstiegskriterium_bff_stufe_i_ii_erfuellt,
   100 AS einstiegskriterium_abgeltung_ha,
   0 AS einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
   0 AS einstufungbeurteilungistzustand_flora_typische_arten,
   0 AS einstufungbeurteilungistzustand_flora_bes_typ_arten,
   0 AS einstufungbeurteilungistzustand_flora_seltene_arten,
   0 AS einstufungbeurteilungistzustand_anzahl_fauna,
   0 AS einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
    CASE
       --wiesenkategorie W 1/2 wird nicht mehr berücksichtigt
       WHEN old_attr->>'wiesenkategorie' = 'W 1' THEN 'Kat_W1'
       WHEN old_attr->>'wiesenkategorie' = 'W 1+' THEN 'Kat_W1_plus'
       WHEN old_attr->>'wiesenkategorie' = 'W 2' THEN 'Kat_W2'
       WHEN old_attr->>'wiesenkategorie' = 'W RW' THEN 'Kat_W_RF'
       ELSE 'Kat_W_RF'
   END AS einstufungbeurteilungistzustand_weidenkategorie,
   CASE
       WHEN old_attr->>'wiesenkategorie' = 'W 1' THEN 200
       WHEN old_attr->>'wiesenkategorie' = 'W 1+' THEN 300
       WHEN old_attr->>'wiesenkategorie' = 'W 2' THEN 100
       WHEN old_attr->>'wiesenkategorie' = 'W RW' THEN 0
       ELSE 0
   END AS einstufungbeurteilungistzustand_weidenkategorie_abgeltung_ha,
   FALSE AS einstufungbeurteilungistzustand_struktur_optimal_beibehalten,
   FALSE AS einstufungbeurteilungistzustand_struktur_verbessern_anlegen,
   FALSE AS einstufungbeurteilungistzustand_struktur_vrbschng_ngrff_ntig,
   0 AS einstufungbeurteilungistzustand_struktur_abgeltung_ha,
   0 AS einstufungbeurteilungistzustand_abgeltung_ha,
   FALSE AS bewirtschaftabmachung_beweidungrinder,
   FALSE AS bewirtschaftabmachung_beweidungmutterkuehe,
   FALSE AS bewirtschaftabmachung_beweidungszeitraum,
   FALSE AS bewirtschaftabmachung_besatzdichte,
   FALSE AS erschwernis_massnahme1,
   0 AS erschwernis_massnahme1_abgeltung_ha,
   FALSE AS erschwernis_massnahme2,
   0 AS erschwernis_massnahme2_abgeltung_ha,
   FALSE AS erschwernis_massnahme3,
   0 AS erschwernis_massnahme3_abgeltung_ha,
   0 AS erschwernis_abgeltung_ha,
   0 AS artenfoerderung_ff_zielart1_abgeltung,
   0 AS artenfoerderung_ff_zielart2_abgeltung,
   0 AS artenfoerderung_ff_zielart3_abgeltung,
   'per_ha' AS artenfoerderung_abgeltungsart,
   0 AS artenfoerderung_abgeltung_total,
   now()::date AS beurteilungsdatum,
   'Unvollständige Beurteilung aus Migration' AS bemerkungen,
   FALSE AS kopie_an_bewirtschafter,
   FALSE AS mit_bewirtschafter_besprochen,
   abgeltung_per_ha_total,
   Round(abgeltung_per_ha_total * flaeche,2) AS abgeltung_flaeche_total,
   0 AS abgeltung_pauschal_total,
   -- derzeit keine Pauschale berücksichtigen
   Round(abgeltung_per_ha_total * flaeche,2) AS abgeltung_total,
   now()::date AS erstellungsdatum,
   'Migration' AS operator_erstellung,
   (SELECT t_id FROM ${DB_Schema_MJPNL}.mjpnl_berater WHERE aname = 'Bruggisser') AS berater,
   t_id AS vereinbarung
FROM
  tmp2
;
