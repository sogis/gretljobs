INSERT
   INTO ${DB_Schema_MJPNL}.mjpnl_beurteilung_weide_ln
     (
       --ignored: t_id 
       t_basket,
       --ignored: t_ili_tid
       -- THE FOLLOWING IS STUFF THAT is mjpnl_beurteilung_weide_ln SPECIFIC AND MANDATORY:
       einstiegskriterium_lage,
       einstiegskriterium_mindestflaeche,
       einstiegskriterium_keinezufuetterung,
       einstiegskriterium_verzichtduengung,
       einstiegskriterium_verzichtdiversegeraete,
       einstiegskriterium_verzichthilfsstoffe,
       einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
       einstiegskriterium_abgeltung_ha,
       --check: einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
       --check: einstufungbeurteilungistzustand_flora_typische_arten,
       --check: einstufungbeurteilungistzustand_flora_bes_typ_arten,
       --check: einstufungbeurteilungistzustand_flora_seltene_arten,
       --check: einstufungbeurteilungistzustand_anzahl_fauna,
       --check: einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
       --check: einstufungbeurteilungistzustand_weidenkategorie,
       --check: einstufungbeurteilungistzustand_weidenkategorie_abgeltung_ha,
       --check: einstufungbeurteilungistzustand_struktur,
       --check: einstufungbeurteilungistzustand_struktur_abgeltung_ha,
       --check: einstufungbeurteilungistzustand_bodeneigenschaften,
       --check: einstufungbeurteilungistzustand_weidnarbe,
       --check: einstufungbeurteilungistzustand_besonderestrukturen,
       --check: einstufungbeurteilungistzustand_abgeltung_ha,
       --check: bewirtschaftabmachung_beweidungrinder,
       --check: bewirtschaftabmachung_beweidungmutterkuehe,
       --check: bewirtschaftabmachung_beweidungszeitraum,
       --check: bewirtschaftabmachung_beweidungszeitraum_von,
       --check: bewirtschaftabmachung_beweidungszeitraum_bis,
       --check: bewirtschaftabmachung_besatzdichte,
       --check: bewirtschaftabmachung_besatzdichte_zahl,
       --check: erschwernis_massnahme1,
       --check: erschwernis_massnahme1_text,
       --check: erschwernis_massnahme1_abgeltung_ha,
       --check: erschwernis_massnahme2,
       --check: erschwernis_massnahme2_text,
       --check: erschwernis_massnahme2_abgeltung_ha,
       --check: erschwernis_massnahme3,
       --check: erschwernis_massnahme3_text,
       --check: erschwernis_massnahme3_abgeltung_ha,
       --check: erschwernis_abgeltung_ha,
       --check: artenfoerderung_ff_zielart1,
       --check: artenfoerderung_ff_zielart1_massnahme,
       --check: artenfoerderung_ff_zielart1_abgeltung,
       --check: artenfoerderung_ff_zielart2,
       --check: artenfoerderung_ff_zielart2_massnahme,
       --check: artenfoerderung_ff_zielart2_abgeltung,
       --check: artenfoerderung_ff_zielart3,
       --check: artenfoerderung_ff_zielart3_massnahme,
       --check: artenfoerderung_ff_zielart3_abgeltung,
       --check: artenfoerderung_abgeltungsart,
       --check: artenfoerderung_abgeltung_total,
       -- THE FOLLOWING IS STUFF THAT COULD BEEN TAKE OVER FROM WIESE:
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
        (string_to_array(bemerkung,'§'))[2]::jsonb AS old_attr,
    FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung
        WHERE vereinbarungsart = 'Weide_LN' AND vereinbarungs_nr != '01_DUMMY_00001'
),
-- ein paar zusätzliche Berechnungen die später wiederverwendet werden sollen
-- zur Vermeidung von Code-Duplication
tmp2 AS (
    SELECT
       *,
       --check: regexp_replace(replace(schnittzeitpunkt,'/','-'), '[^0-9.-]', '', 'g') AS schnittzeitpkt_prep,
       CASE
           WHEN old_attr->>'wiesenkategorie' = 'I' THEN 700
           WHEN old_attr->>'wiesenkategorie' = 'II' THEN 450
           WHEN old_attr->>'wiesenkategorie' = 'II / RF' THEN 250
           WHEN old_attr->>'wiesenkategorie' = 'RF / II' THEN 100
           WHEN old_attr->>'wiesenkategorie' = 'RF' THEN 0
           ELSE 0
       END
        +
       CASE WHEN (old_attr->'balkenmaeher')::boolean = True THEN 300 ELSE 0 END
       AS abgeltung_per_ha_total      
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
   200 AS einstiegskriterium_abgeltung_ha,
   FALSE AS einstufungbeurteilungistzustand_artenvielfalt_strauch_bmrten,
   FALSE AS einstufungbeurteilungistzustand_asthaufen,
   FALSE AS einstufungbeurteilungistzustand_totholz,
   FALSE AS einstufungbeurteilungistzustand_steinhaufen,
   FALSE AS einstufungbeurteilungistzustand_schichtholzbeigen,
   FALSE AS einstufungbeurteilungistzustand_nisthilfe_wildbienen,
   FALSE AS einstufungbeurteilungistzustand_hoehlenbaeume_biotpbm_ttholz,
   FALSE AS einstufungbeurteilungistzustand_sitzwarte,
   0 AS einstufungbeurteilungistzustand_abgeltung_ha,
   old_attr->>hecken_laufmeter AS bewirtschaftung_lebhag_laufmeter
   CASE
       WHEN old_attr->>'wiesenkategorie' = 'I' THEN 'Kat_I_besondersartenreicheWiese'
       WHEN old_attr->>'wiesenkategorie' = 'II' THEN 'Kat_II_artenreicheWiese'
       WHEN old_attr->>'wiesenkategorie' = 'II / RF' THEN 'Kat_II_RF'
       WHEN old_attr->>'wiesenkategorie' = 'RF / II' THEN 'Kat_RF_II'
       WHEN old_attr->>'wiesenkategorie' = 'RF' THEN 'Kat_W_RF'
       ELSE 'Kat_W_RF'
   END AS einstufungbeurteilungistzustand_wiesenkategorie,
   CASE
       WHEN old_attr->>'wiesenkategorie' = 'I' THEN 700
       WHEN old_attr->>'wiesenkategorie' = 'II' THEN 450
       WHEN old_attr->>'wiesenkategorie' = 'II / RF' THEN 250
       WHEN old_attr->>'wiesenkategorie' = 'RF / II' THEN 100
       WHEN old_attr->>'wiesenkategorie' = 'RF' THEN 0
       ELSE 0
   END AS einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha,
   CASE
       WHEN length(COALESCE(old_attr->>'schnittzeitpunkt','')) > 0 THEN True
       ELSE FALSE
   END AS bewirtschaftabmachung_heuschnittabgesprochen,
   to_date(
       CASE
           WHEN length(COALESCE(schnittzeitpkt_prep,'')) > 0 THEN
                CASE WHEN regexp_match(schnittzeitpkt_prep,'^\d') IS NOT NULL THEN --Prüfung ob String mit Zahl anfängt
                    CASE
                        WHEN cardinality((string_to_array(schnittzeitpkt_prep,'-'))) > 1 THEN
                            -- Check ob Zwischenresultat dem Schema Zahl.Zahl. oder Zahl.Zahl.Zahl entspricht
                            CASE WHEN regexp_match((string_to_array(schnittzeitpkt_prep,'-'))[1],'^\d{1,2}\.\d{1,2}\.{0,1}(\d{2}|\d{4}){0,1}$') IS NOT NULL THEN
                                -- nur Tag und Monat behalten falls Datum auch eine Jahreszahl enthält
                                split_part((string_to_array(schnittzeitpkt_prep,'-'))[1],'.',1) || '.' || split_part((string_to_array(schnittzeitpkt_prep,'-'))[1],'.',2)
                            END
                        ELSE
                            -- Check ob Zwischenresultat dem Schema Zahl.Zahl. oder Zahl.Zahl.Zahl entspricht
                            CASE WHEN regexp_match(schnittzeitpkt_prep,'^\d{1,2}\.\d{1,2}\.{0,1}(\d{2}|\d{4}){0,1}$') IS NOT NULL THEN
                                split_part(schnittzeitpkt_prep,'.',1) || '.' || split_part(schnittzeitpkt_prep,'.',2)
                            END
                    END
                END
       END || '.2000',
       'DD.MM.YYYY'
   ) AS bewirtschaftabmachung_schnittzeitpunkt_1,
   to_date(
       CASE
           WHEN length(COALESCE(schnittzeitpkt_prep,'')) > 0 THEN
                CASE WHEN regexp_match(schnittzeitpkt_prep,'^\d') IS NOT NULL THEN --Prüfung ob String mit Zahl anfängt
                    CASE
                        WHEN cardinality(string_to_array(schnittzeitpkt_prep,'-')) > 1 THEN
                            -- Check ob Zwischenresultat dem Schema Zahl.Zahl. oder Zahl.Zahl.Zahl entspricht
                            CASE WHEN regexp_match((string_to_array(schnittzeitpkt_prep,'-'))[2],'^\d{1,2}\.\d{1,2}\.{0,1}(\d{2}|\d{4}){0,1}$') IS NOT NULL THEN
                                -- nur Tag und Monat behalten falls Datum auch eine Jahreszahl enthält
                                split_part((string_to_array(schnittzeitpkt_prep,'-'))[2],'.',1) || '.' || split_part((string_to_array(schnittzeitpkt_prep,'-'))[2],'.',2)
                            END
                        ELSE NULL
                    END
                END
       END
       || '.2000',
       'DD.MM.YYYY'
   ) AS bewirtschaftabmachung_schnittzeitpunkt_2,
   CASE WHEN old_attr->>'emden' = 'ja' THEN TRUE ELSE FALSE END AS bewirtschaftabmachung_emdenbodenheu,
   CASE WHEN (old_attr->'rueckzugstreifen')::boolean = True THEN TRUE ELSE FALSE END AS bewirtschaftabmachung_rueckzugstreifen,
   FALSE AS bewirtschaftabmachung_herbstschnitt,
   CASE WHEN (old_attr->'herbstweide')::boolean = True THEN TRUE ELSE FALSE END AS bewirtschaftabmachung_herbstweide,
   FALSE AS bewirtschaftabmachung_keineherbstweide,
   CASE WHEN (old_attr->'balkenmaeher')::boolean = True THEN TRUE ELSE FALSE END AS bewirtschaftabmachung_messerbalkenmaehgeraet,
   CASE WHEN (old_attr->'balkenmaeher')::boolean = True THEN 300 ELSE 0 END AS bewirtschaftabmachung_abgeltung_ha,
   FALSE AS erschwernis_massnahme1,
   0 AS erschwernis_massnahme1_abgeltung_ha,
   FALSE AS erschwernis_massnahme2,
   0 AS erschwernis_massnahme2_abgeltung_ha,
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
