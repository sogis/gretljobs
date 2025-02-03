WITH

-- Selektion Attribute aus Tabelle Flaeche --
flaeche AS (
    SELECT
        flaeche.t_id,
        flaeche.ersatzmassnahmennl,
        ersatz_typ.dispname AS ersatzmassnahmennl_txt,
        flaeche.massnahmennl_typ,
        massnahmennl_typ.dispname AS massnahmennl_typ_txt,
        flaeche.frist,
        flaeche.frist_bemerkung,
        flaeche.frist_verlaengerung,
        flaeche.frist_verlaengerung_bemerkung,
        flaeche.datum_abnahme,
        flaeche.geometrie,
        flaeche.ausgleichsabgabe_r,
        flaeche.rodung_r,
        flaeche.objekttyp,
        geometrie_typ.dispname AS objekttyp_txt,
        flaeche.bemerkung AS bemerkung_geometrie,
        string_agg(DISTINCT gemeinde.gemeindename, ', ') AS gemeindenamen,
        string_agg(DISTINCT forstkreis.aname, ', ') AS forstkreis,
        string_agg(DISTINCT forstrevier.aname, ', ') AS forstrevier
    FROM 
        awjf_rodung_rodungsersatz_v1.flaeche AS flaeche
    LEFT JOIN awjf_rodung_rodungsersatz_v1.geometrie_objekttyp AS geometrie_typ
        ON flaeche.objekttyp = geometrie_typ.ilicode
    LEFT JOIN awjf_rodung_rodungsersatz_v1.flaeche_ersatzmassnahmennl AS ersatz_typ
        ON flaeche.ersatzmassnahmennl = ersatz_typ.ilicode  
    LEFT JOIN awjf_rodung_rodungsersatz_v1.flaeche_massnahmennl_typ AS massnahmennl_typ
        ON flaeche.massnahmennl_typ = massnahmennl_typ.ilicode    
    LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeinde
        ON ST_Intersects(flaeche.geometrie, gemeinde.geometrie)
    LEFT JOIN awjf_forstreviere.forstreviere_forstreviergeometrie AS forstgeometrie
        ON ST_Intersects(flaeche.geometrie, forstgeometrie.geometrie)
    LEFT JOIN awjf_forstreviere.forstreviere_forstkreis AS forstkreis
        ON forstgeometrie.forstkreis = forstkreis.t_id
    LEFT JOIN awjf_forstreviere.forstreviere_forstrevier AS forstrevier
        ON forstgeometrie.forstrevier = forstrevier.t_id
    GROUP BY
        flaeche.t_id,
        flaeche.ersatzmassnahmennl,
        flaeche.massnahmennl_typ,
        flaeche.frist,
        flaeche.frist_bemerkung,
        flaeche.frist_verlaengerung,
        flaeche.frist_verlaengerung_bemerkung,
        flaeche.datum_abnahme,
        flaeche.geometrie,
        flaeche.ausgleichsabgabe_r,
        flaeche.rodung_r,
        flaeche.objekttyp,
        flaeche.bemerkung,
        geometrie_typ.dispname,
        ersatz_typ.dispname,
        massnahmennl_typ.dispname
),

-- Selektion Attribute aus Tabelle Rodung --
rodung AS (
    SELECT 
        t_id,
        nr_kanton,
        nr_bund,
        vorhaben,
        astatus,
        typ_status.dispname AS astatus_txt,
        zustaendigkeit,
        rodungszweck,
        typ_rodungszweck.dispname AS rodungszweck_txt,
        rodungszweck_bemerkung,
        art_bewilligungsverfahren,
        art_bewilligung.dispname AS art_bewilligungsverfahren_txt,
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
        REPLACE(REPLACE(REPLACE(ersatzverzicht, '{"', ''), '"}', ''), ',', ', ') AS ersatzverzicht_txt,
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
    LEFT JOIN awjf_rodung_rodungsersatz_v1.rodungsdaten_art_bewilligungsverfahren AS art_bewilligung
        ON rodungsdaten.art_bewilligungsverfahren = art_bewilligung.ilicode
    LEFT JOIN awjf_rodung_rodungsersatz_v1.rodungsdaten_rodungszweck AS typ_rodungszweck
        ON rodungsdaten.rodungszweck = typ_rodungszweck.ilicode
    LEFT JOIN awjf_rodung_rodungsersatz_v1.verfahrensstatus AS typ_status
        ON rodungsdaten.astatus = typ_status.ilicode
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
    flaeche.objekttyp_txt,
    flaeche.ersatzmassnahmennl,
    flaeche.ersatzmassnahmennl_txt,
    flaeche.geometrie,
    flaeche.frist,
    flaeche.frist_bemerkung,
    flaeche.frist_verlaengerung,
    flaeche.frist_verlaengerung_bemerkung,
    flaeche.datum_abnahme,
    flaeche.massnahmennl_typ,
    flaeche.massnahmennl_typ_txt,
    flaeche.bemerkung_geometrie,
    flaeche.gemeindenamen,
    flaeche.forstkreis,
    flaeche.forstrevier,
    rodung.nr_kanton,
    rodung.nr_bund,
    rodung.vorhaben,
    rodung.astatus,
    rodung.astatus_txt,
    rodung.zustaendigkeit,
    rodung.rodungszweck,
    rodung.rodungszweck_txt,
    rodung.rodungszweck_bemerkung,
    rodung.art_bewilligungsverfahren,
    rodung.art_bewilligungsverfahren_txt,
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
    CASE
    	WHEN ersatzverzicht_txt ILIKE '%Hochwasserschutz_Revitalisierung%'
        	THEN REPLACE(ersatzverzicht_txt, 'Hochwasserschutz_Revitalisierung', 'Hochwasserschutz/Gewässerrevitalisierung')
            ELSE ersatzverzicht_txt       
        END AS ersatzverzicht_txt,
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