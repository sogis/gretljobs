/**
 * Author:  bjsvwweb
 * Created: 15.10.2024
 */

SELECT
    med.ilicode AS amedium,
    med.dispName AS amedium_txt,
    nfe.letzte_Aenderung,
    p.geometrie,
    p.bfsnr,
    p.bezeichnung,
    -- Nachführungsstelle
    onf.organisation_name AS nachfuehrungsstelle_name,
    onf.strasse || ' ' || onf.hausnummer || ', ' || onf.plz || ' ' || onf.ortschaft AS nachfuehrungsstelle_postadresse,
    onf.telefon AS nachfuehrungsstelle_telefon,
    onf.web AS nachfuehrungsstelle_web,
    onf.email AS nachfuehrungsstelle_email,
    -- Betreiber
    obe.organisation_name AS betreiber_name,
    obe.strasse || ' ' || obe.hausnummer || ', ' || obe.plz || ' ' || obe.ortschaft AS betreiber_postadresse,
    obe.telefon AS betreiber_telefon,
    obe.web AS betreiber_web,
    obe.email AS betreiber_email,
    -- Werkeigentümer
    oeig.organisation_name AS werkeigentuemer_name,
    oeig.strasse || ' ' || oeig.hausnummer || ', ' || oeig.plz || ' ' || oeig.ortschaft AS werkeigentuemer_postadresse,
    oeig.telefon AS werkeigentuemer_telefon,
    oeig.web AS werkeigentuemer_web,
    oeig.email AS werkeigentuemer_email
FROM
    agi_lk_netzgebiete_v1.perimeter p
JOIN
    agi_lk_netzgebiete_v1.netzgebiet nfe
        ON nfe.perimeter = p.t_id
-- Verknüpfe die Nachführungsstelle
LEFT JOIN
    agi_lk_netzgebiete_v1.organisation onf
        ON nfe.nachfuehrungsstelle = onf.t_id
-- Verknüpfe den Betreiber
LEFT JOIN
    agi_lk_netzgebiete_v1.organisation obe
        ON nfe.betreiber = obe.t_id
-- Verknüpfe den Werkeigentümer
LEFT JOIN
    agi_lk_netzgebiete_v1.organisation oeig
        ON nfe.werkeigentuemer = oeig.t_id
JOIN
    agi_lk_netzgebiete_v1.amedium med
        ON nfe.amedium = med.ilicode
