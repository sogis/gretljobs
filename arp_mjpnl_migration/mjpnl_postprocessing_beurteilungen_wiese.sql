INSERT
   INTO ${DB_Schema_MJPNL}.mjpnl_beurteilung_wiese
     (
       t_basket,
       einstiegskriterium_lage,
       einstiegskriterium_mindestflaeche,
       einstiegskriterium_verzichtduengung,
       einstiegskriterium_verzichtdiversegeraete,
       einstiegskriterium_verzichthilfsstoffe,
       einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
       einstiegskriterium_bodenheu,
       einstiegskriterium_abgeltung_ha,
       einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
       einstufungbeurteilungistzustand_flora_typische_arten,
       einstufungbeurteilungistzustand_flora_bes_typ_arten,
       einstufungbeurteilungistzustand_flora_seltene_arten,
       einstufungbeurteilungistzustand_anzahl_fauna,
       einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
       einstufungbeurteilungistzustand_wiesenkategorie,
       einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha,
       bewirtschaftabmachung_heuschnittabgesprochen,
       bewirtschaftabmachung_schnittzeitpunkt_1,
       bewirtschaftabmachung_schnittzeitpunkt_2,
       bewirtschaftabmachung_emdenbodenheu,
       bewirtschaftabmachung_rueckzugstreifen,
       bewirtschaftabmachung_herbstschnitt,
       bewirtschaftabmachung_herbstweide,
       bewirtschaftabmachung_keineherbstweide,
       bewirtschaftabmachung_messerbalkenmaehgeraet,
       bewirtschaftabmachung_abgeltung_ha,
       erschwernis_massnahme1,
       erschwernis_massnahme1_abgeltung_ha,
       erschwernis_massnahme2,
       erschwernis_massnahme2_abgeltung_ha,
       erschwernis_abgeltung_ha,
       artenfoerderung_ff_zielart1_abgeltung,
       artenfoerderung_ff_zielart2_abgeltung,
       artenfoerderung_ff_zielart3_abgeltung,
       artenfoerderung_abgeltungsart,
       artenfoerderung_abgeltung_total,
       beurteilungsdatum,
       bemerkungen,
       kopie_an_bewirtschafter,
       mit_bewirtschafter_besprochen,
       abgeltung_per_ha_total,
       abgeltung_flaeche_total,
       abgeltung_pauschal_total,
       abgeltung_total,
       erstellungsdatum,
       operator_erstellung,
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
        ltrim(regexp_replace((string_to_array(bemerkung,'§'))[2]::jsonb->>'schnittzeitpunkt','[^0-9./-]', '', 'g'),'.') AS schnittzeitpunkt
    FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung
        WHERE vereinbarungsart = 'Wiese' AND vereinbarungs_nr != '01_DUMMY_00001'
),
-- ein paar zusätzliche Berechnungen die später wiederverwendet werden sollen
-- zur Vermeidung von Code-Duplication
tmp2 AS (
    SELECT
       *,
       regexp_replace(replace(schnittzeitpunkt,'/','-'), '[^0-9.-]', '', 'g') AS schnittzeitpkt_prep,
       CASE
           WHEN old_attr->>'wiesenkategorie' = 'I' THEN 600
           WHEN old_attr->>'wiesenkategorie' = 'II' THEN 400
           WHEN old_attr->>'wiesenkategorie' = 'II / RF' THEN 200
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
   TRUE AS einstiegskriterium_mindestflaeche,
   TRUE AS einstiegskriterium_verzichtduengung,
   TRUE AS einstiegskriterium_verzichtdiversegeraete,
   TRUE AS einstiegskriterium_verzichthilfsstoffe,
   TRUE AS einstiegskriterium_keineinsatzwieseneggenstriegelwalzen,
   TRUE AS einstiegskriterium_bodenheu,
   0 AS einstiegskriterium_abgeltung_ha,
   0 AS einstufungbeurteilungistzustand_flora_naehrstoffzeiger,
   0 AS einstufungbeurteilungistzustand_flora_typische_arten,
   0 AS einstufungbeurteilungistzustand_flora_bes_typ_arten,
   0 AS einstufungbeurteilungistzustand_flora_seltene_arten,
   0 AS einstufungbeurteilungistzustand_anzahl_fauna,
   0 AS einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal,
   CASE
       WHEN old_attr->>'wiesenkategorie' = 'I' THEN 'Kat_I_besondersartenreicheWiese'
       WHEN old_attr->>'wiesenkategorie' = 'II' THEN 'Kat_II_artenreicheWiese'
       WHEN old_attr->>'wiesenkategorie' = 'II / RF' THEN 'Kat_II_RF'
       WHEN old_attr->>'wiesenkategorie' = 'RF / II' THEN 'Kat_RF_II'
       WHEN old_attr->>'wiesenkategorie' = 'RF' THEN 'Kat_W_RF'
       ELSE 'Kat_W_RF'
   END AS einstufungbeurteilungistzustand_wiesenkategorie,
   CASE
       WHEN old_attr->>'wiesenkategorie' = 'I' THEN 600
       WHEN old_attr->>'wiesenkategorie' = 'II' THEN 400
       WHEN old_attr->>'wiesenkategorie' = 'II / RF' THEN 200
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
