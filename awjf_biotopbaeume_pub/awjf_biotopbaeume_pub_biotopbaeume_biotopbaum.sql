SELECT
    biotopbaum.geometrie,
    baum_id,
    CASE
        WHEN baumkategorie = 'Seltene_Baumart'
            THEN 'Seltene Baumart'
        WHEN baumkategorie = 'Stehendes_Totholz'
            THEN 'Stehendes Totholz'
        ELSE baumkategorie
    END AS baumkategorie,
    inventur_jahr,
    wirtschaftszone,
    gesuchsnummer,
    waldeigentuemer_code,
    CASE
        WHEN baumart = 'Laerche'
            THEN 'Lärche'
        WHEN baumart = 'Bergfoehre'
            THEN 'Bergföhre'
        WHEN baumart = 'Schwarzfoehre'
            THEN 'Schwarzföhre'
        WHEN baumart = 'Weymouthsfoehre'
            THEN 'Weymouthsföhre'
        WHEN baumart = 'Waldfoehre'
            THEN 'Waldföhre'
        WHEN baumart = 'Uebrige_Nadelbaeume'
            THEN 'Übrige Nadelbäume'
        WHEN baumart = 'Schneeballblaettriger_Ahorn'
            THEN 'Schneeballblättriger Ahorn'
        WHEN baumart = 'Uebrige_Laubbaeume'
            THEN 'Übrige Laubbäume'
        ELSE baumart 
    END AS baumart, 
    bhd, 
    baumhoehe, 
    CASE
        WHEN merkmal_1 = 'm1_Stammdurchmesser_70'
            THEN 'Stammdurchmesser ≥ 70cm'
        WHEN merkmal_1 = 'm2_Spechtloecher_Bruthoehlen_Wurzelhoehlen'
            THEN 'Bäume mit Spechtlöchern, Bruthöhlen oder Wurzelhöhlen'
        WHEN merkmal_1 = 'm3_Horstbaeume'
            THEN 'Horstbäume'
        WHEN merkmal_1 = 'm4_Alte_ehemalige_Weidebaeume'
            THEN 'Alte, ehemalige Weidebäume im Bestandesinnern, besondere Überhälter'
        WHEN merkmal_1 = 'm5_Lebende_Baeume_Efeu_Mistelbewuchs'
            THEN 'Lebende Bäume mit starkem Efeu- oder Mistelbewuchs'
        WHEN merkmal_1 = 'm6_Baeume_mit_markanten_Schaeden'
            THEN 'Bäume mit markanten Schäden'
        WHEN merkmal_1 = 'm7_Baeume_mit_besonderem_Wuchs'
            THEN 'Bäume mit besonderem Wuchs'
        WHEN merkmal_1 = 'm20_Stehendes_Totholz'
            THEN 'Stehendes Totholz'
        WHEN merkmal_1 = 'm21_Seltene_Baumart'
            THEN 'Seltene Baumart'
        WHEN merkmal_1 = 'm22_Gesellschaftsbaum'
            THEN 'Gesellschaftsbaum'
        WHEN merkmal_1 = 'm23_Potenzieller_Biotopbaum'
            THEN 'Potenzieller Biotopbaum'
        ELSE merkmal_1
    END AS merkmal_1,
    beschreibung_merkmal_1,
    CASE
        WHEN merkmal_2 = 'm1_Stammdurchmesser_70'
            THEN 'Stammdurchmesser ≥ 70cm'
        WHEN merkmal_2 = 'm2_Spechtloecher_Bruthoehlen_Wurzelhoehlen'
            THEN 'Bäume mit Spechtlöchern, Bruthöhlen oder Wurzelhöhlen'
        WHEN merkmal_2 = 'm3_Horstbaeume'
            THEN 'Horstbäume'
        WHEN merkmal_2 = 'm4_Alte_ehemalige_Weidebaeume'
            THEN 'Alte, ehemalige Weidebäume im Bestandesinnern, besondere Überhälter'
        WHEN merkmal_2 = 'm5_Lebende_Baeume_Efeu_Mistelbewuchs'
            THEN 'Lebende Bäume mit starkem Efeu- oder Mistelbewuchs'
        WHEN merkmal_2 = 'm6_Baeume_mit_markanten_Schaeden'
            THEN 'Bäume mit markanten Schäden'
        WHEN merkmal_2 = 'm7_Baeume_mit_besonderem_Wuchs'
            THEN 'Bäume mit besonderem Wuchs'
        WHEN merkmal_2 = 'm20_Stehendes_Totholz'
            THEN 'Stehendes Totholz'
        WHEN merkmal_2 = 'm21_Seltene_Baumart'
            THEN 'Seltene Baumart'
        WHEN merkmal_2 = 'm22_Gesellschaftsbaum'
            THEN 'Gesellschaftsbaum'
        WHEN merkmal_2 = 'm23_Potenzieller_Biotopbaum'
            THEN 'Potenzieller Biotopbaum'
        ELSE merkmal_2
    END AS merkmal_2,
    beschreibung_merkmal_2,
    CASE
        WHEN merkmal_3 = 'm1_Stammdurchmesser_70'
            THEN 'Stammdurchmesser ≥ 70cm'
        WHEN merkmal_3 = 'm2_Spechtloecher_Bruthoehlen_Wurzelhoehlen'
            THEN 'Bäume mit Spechtlöchern, Bruthöhlen oder Wurzelhöhlen'
        WHEN merkmal_3 = 'm3_Horstbaeume'
            THEN 'Horstbäume'
        WHEN merkmal_3 = 'm4_Alte_ehemalige_Weidebaeume'
            THEN 'Alte, ehemalige Weidebäume im Bestandesinnern, besondere Überhälter'
        WHEN merkmal_3 = 'm5_Lebende_Baeume_Efeu_Mistelbewuchs'
            THEN 'Lebende Bäume mit starkem Efeu- oder Mistelbewuchs'
        WHEN merkmal_3 = 'm6_Baeume_mit_markanten_Schaeden'
            THEN 'Bäume mit markanten Schäden'
        WHEN merkmal_3 = 'm7_Baeume_mit_besonderem_Wuchs'
            THEN 'Bäume mit besonderem Wuchs'
        WHEN merkmal_3 = 'm20_Stehendes_Totholz'
            THEN 'Stehendes Totholz'
        WHEN merkmal_3 = 'm21_Seltene_Baumart'
            THEN 'Seltene Baumart'
        WHEN merkmal_3 = 'm22_Gesellschaftsbaum'
            THEN 'Gesellschaftsbaum'
        WHEN merkmal_3 = 'm23_Potenzieller_Biotopbaum'
            THEN 'Potenzieller Biotopbaum'
        ELSE merkmal_3
    END AS merkmal_3,
    beschreibung_merkmal_3,
    massnahmen,
    besonderheiten,
    bemerkungen,
    CASE
        WHEN tp_inventar = 'TP_aber_nicht_Inventar_nicht_im_TP'
            THEN 'TP aber nicht Inventar, die nicht im TP sind'
        WHEN tp_inventar = 'TP_und_Inventar'
            THEN 'TP und Inventar'
        WHEN tp_inventar = 'Nicht_TP_aber_Inventar'
            THEN 'Nicht TP, aber Inventar inklusive TP im Inventar'
    END AS tp_inventar,
    auszahlung_beitrag,
    auszahlung_beitrag_jahr
FROM
    awjf_programm_biodiversitaet_wald_v1.biodiversitt_wald_biotopbaum AS biotopbaum
;
