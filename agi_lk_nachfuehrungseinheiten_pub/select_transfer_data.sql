/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/SQLTemplate.sql to edit this template
 */
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
    agi_lk_nachfuehrungseinheiten_v1.nachfuehrngsnhten_perimeter p
JOIN
    agi_lk_nachfuehrungseinheiten_v1.nachfuehrngsnhten_perimeter_nachfuehrungseinheit pn
        ON pn.perimeter = p.t_id
JOIN
    agi_lk_nachfuehrungseinheiten_v1.nachfuehrngsnhten_nachfuehrungseinheit nfe
        ON pn.nachfuehrungseinheit = nfe.t_id
JOIN
    agi_lk_nachfuehrungseinheiten_v1.nachfuehrngsnhten_organisation org
        ON nfe.nachfuehrungsstelle = org.t_id
JOIN
    agi_lk_nachfuehrungseinheiten_v1.nachfuehrngsnhten_medium med
        ON nfe.amedium = med.t_id