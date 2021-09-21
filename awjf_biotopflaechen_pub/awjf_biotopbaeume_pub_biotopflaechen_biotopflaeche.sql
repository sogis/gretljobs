WITH 
zielgruppe AS (
SELECT
    zielgruppe.t_id,
    zielgruppe.aname,
    biotop_zielgruppe.biotopflaeche_zielgruppe
FROM awjf_foerderprogramm_biodiversitaet.biotopflaechen_biotop_zielgruppe AS biotop_zielgruppe
LEFT JOIN awjf_foerderprogramm_biodiversitaet.biotopflaechen_biotopflaeche AS flaeche
    ON biotop_zielgruppe.biotopflaeche_zielgruppe = flaeche.t_id
LEFT JOIN awjf_foerderprogramm_biodiversitaet.biotopflaechen_zielgruppe AS zielgruppe
    ON biotop_zielgruppe.zielgruppe_biotopflaeche = zielgruppe.t_id
)

SELECT
    geometrie,
    biotop_id,
    massnahme,
    zielgruppe.aname AS zielgruppe,
    projektziel,
    erster_eingriff,
    waldeigentuemer,
    letzter_eingriff,
    bemerkung,
    besonderheiten,
    vertragsart,
    vertragsende,
    vertragsspeicherort,
    projektstatus,
    ST_Area(biotopflaeche.geometrie) / 100 AS flaeche
FROM
    awjf_foerderprogramm_biodiversitaet.biotopflaechen_biotopflaeche AS biotopflaeche
LEFT JOIN zielgruppe AS zielgruppe
    ON zielgruppe.biotopflaeche_zielgruppe = biotopflaeche.t_id
