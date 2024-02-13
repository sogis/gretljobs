/**
 * Author:  bjsvwweb
 * Created: 19.12.2023
 */

SELECT
    med.ilicode AS amedium,
    med.dispName AS amedium_txt,
    nfe.letzte_Aenderung,
    p.geometrie,
    p.bfsnr,
    p.bezeichnung,
    org.organisation_name AS nachfuehrungsstelle_name,
    org.strasse || ' ' || org.hausnummer || ', ' || org.plz || ' ' || org.ortschaft AS nachfuehrungsstelle_postadresse,
    org.telefon AS nachfuehrungsstelle_telefon,
    org.web AS nachfuehrungsstelle_web,
    org.email AS nachfuehrungsstelle_email
FROM
    agi_lk_nachfuehrungseinheiten_v1.perimeter p
JOIN
    agi_lk_nachfuehrungseinheiten_v1.nachfuehrungseinheit nfe
        ON nfe.perimeter = p.t_id
JOIN
    agi_lk_nachfuehrungseinheiten_v1.organisation org
        ON nfe.nachfuehrungsstelle = org.t_id
JOIN
    agi_lk_nachfuehrungseinheiten_v1.amedium med
        ON nfe.amedium = med.ilicode