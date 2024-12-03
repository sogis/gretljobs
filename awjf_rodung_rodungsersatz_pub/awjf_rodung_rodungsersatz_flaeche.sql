WITH

-- Selektion Attribute aus Tabelle Flaeche --
flaeche AS (
    SELECT
        t_id,
        ersatzmassnahmennl,
        massnahmennl_typ,
        frist,
        frist_bemerkung,
        frist_verlaengerung,
        frist_verlaengerung_bemerkung,
        datum_abnahme,
        geometrie,
        ausgleichsabgabe_r,
        rodung_r,
        objekttyp,
        bemerkung AS bemerkung_geometrie
    FROM 
        awjf_rodung_rodungsersatz_v1.flaeche
),

-- Selektion Attribute aus Tabelle Rodung --
rodung AS (
    SELECT 
        t_id,
        nr_kanton,
        nr_bund,
        vorhaben,
        astatus,
        zustaendigkeit,
        rodungszweck,
        rodungszweck_bemerkung,
        art_bewilligungsverfahren,
        datum_amtsblatt_gesuch,
        datum_amtsblatt_bewilligung,
        auflagestart,
        auflageende,
        datum_entscheid,
        datum_rechtskraft,
        datum_anzeige_bafu,    
        datum_abschluss_rodung,
        ausgleichsabgabe_eingang,
        rodungsentscheid,
        sobauid,
        einsprache,
        beschwerde,
        massnahmenl_pool,    
        ersatzverzicht,
        art_sicherung,
        anmerkung_grundbuch,
        lieferung_bafu,
        waldplan_nachgefuehrt,
        flaeche_rodung_def_g,
        flaeche_rodung_def_e,
        flaeche_rodung_temp_g,
        flaeche_rodung_temp_e,
        flaeche_ersatz_real_g,
        flaeche_ersatz_real_e,
        flaeche_ersatz_massnahmennl_g,
        flaeche_ersatz_massnahmennl_e,
        bemerkung AS bemerkung_rodung
    FROM 
        awjf_rodung_rodungsersatz_v1.rodungsdaten
),

-- Selektion Attribute aus Tabelle Ausgleichsabgabe --
ausgleichsabgabe AS (
    SELECT 
        t_id,
        bezeichnung AS ausgleichsabgabe_bezeichnung,
        betrag AS ausgleichsabgabe_betrag,
        zahlung AS ausgleichsabgabe_zahlung,
        bemerkung AS ausgleichsabgabe_bemerkung
    FROM 
        awjf_rodung_rodungsersatz_v1.ausgleichsabgabe
),

-- Selektion Attribute aus Tabelle Dokument --
dokumente AS (
    SELECT
        dok_id.rodung_r AS rodung_id,
        dokument.t_id,
        dokument.bezeichnung,
        dokument.dateipfad,
        dokument.typ,
        dokument.publiziertab,
        dokument.offiziellenr,
        dokument.bemerkung,
        dokument.verfuegung_url,
        dokument.astatus
    FROM 
        awjf_rodung_rodungsersatz_v1.dokument AS dokument
    LEFT JOIN awjf_rodung_rodungsersatz_v1.rodung_dokument AS dok_id
        ON dokument.t_id = dok_id.dokument_r
),

-- Umwandlung Dokumente in json-array --
dokumente_json AS (
    SELECT
        array_to_json(
            array_agg(
                row_to_json((
                    SELECT
                        docs
                    FROM 
                        (
                            SELECT
                                t_id,
                                bezeichnung,
                                dateipfad,
                                typ,
                                publiziertab,
                                offiziellenr,
                                bemerkung,
                                verfuegung_url,
                                astatus
                        ) docs
                ))
            )
        ) AS dokumente,
        rodung_id
    FROM
        dokumente
    GROUP BY
        rodung_id    
)

SELECT
    flaeche.objekttyp,
    flaeche.ersatzmassnahmennl,
    flaeche.geometrie,
    flaeche.frist,
    flaeche.frist_bemerkung,
    flaeche.frist_verlaengerung,
    flaeche.frist_verlaengerung_bemerkung,
    flaeche.datum_abnahme,
    flaeche.massnahmennl_typ,
    flaeche.bemerkung_geometrie,
    rodung.nr_kanton,
    rodung.nr_bund,
    rodung.vorhaben,
    rodung.astatus,
    rodung.zustaendigkeit,
    rodung.rodungszweck,
    rodung.rodungszweck_bemerkung,
    rodung.art_bewilligungsverfahren,
    rodung.datum_amtsblatt_gesuch,
    rodung.datum_amtsblatt_bewilligung,
    rodung.auflagestart,
    rodung.auflageende,
    rodung.datum_entscheid,
    rodung.datum_rechtskraft,
    rodung.datum_anzeige_bafu,    
    rodung.datum_abschluss_rodung,
    rodung.ausgleichsabgabe_eingang,
    rodung.rodungsentscheid,
    rodung.sobauid,
    rodung.einsprache,
    rodung.beschwerde,
    rodung.massnahmenl_pool,    
    rodung.ersatzverzicht,
    rodung.art_sicherung,
    rodung.anmerkung_grundbuch,
    rodung.lieferung_bafu,
    rodung.waldplan_nachgefuehrt,
    rodung.flaeche_rodung_def_g,
    rodung.flaeche_rodung_def_e,
    rodung.flaeche_rodung_temp_g,
    rodung.flaeche_rodung_temp_e,
    rodung.flaeche_ersatz_real_g,
    rodung.flaeche_ersatz_real_e,
    rodung.flaeche_ersatz_massnahmennl_g,
    rodung.flaeche_ersatz_massnahmennl_e,
    rodung.bemerkung_rodung,
    ausgleichsabgabe.ausgleichsabgabe_bezeichnung,
    ausgleichsabgabe.ausgleichsabgabe_betrag,
    ausgleichsabgabe.ausgleichsabgabe_zahlung,
    ausgleichsabgabe.ausgleichsabgabe_bemerkung,
    dokumente_json.dokumente
FROM 
    flaeche
LEFT JOIN rodung
    ON flaeche.rodung_r = rodung.t_id
LEFT JOIN ausgleichsabgabe
    ON flaeche.ausgleichsabgabe_r = ausgleichsabgabe.t_id
LEFT JOIN dokumente_json
    ON flaeche.rodung_r = dokumente_json.rodung_id