WITH

grundstueck AS
(
    SELECT
        grundstueck.nummer AS grundbuchnummer,
        grundstueck.egris_egrid AS egrid,
        liegenschaft.geometrie
    FROM
        agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
        LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft AS liegenschaft
            ON liegenschaft.liegenschaft_von = grundstueck.t_id
    WHERE 
        liegenschaft.geometrie IS NOT NULL
)

SELECT 
    ausgleichsabgabe.zone_alt,
    ausgleichsabgabe.zone_neu,
    ausgleichsabgabe.flaeche_m2,
    ausgleichsabgabe.rrb_nr,
    ausgleichsabgabe.datum_publikation_amtsblatt,
    ausgleichsabgabe.datum_festsetzung_verfuegung,
    ausgleichsabgabe.datum_rechtskraft_verfuegung,
    ausgleichsabgabe.datum_faelligkeit,
    ausgleichsabgabe.datum_rechnung,
    ausgleichsabgabe.datum_zahlung,
    ausgleichsabgabe.dokumente,
    ausgleichsabgabe.bemerkung,
    ausgleichsabgabe.geometrie
    hoheitsgrenzen.gemeindename AS gemeinde,
    grundstueck.grundbuchnummer,
    grundstueck.egrid
FROM
    dsbjd_ausgleichsabgabe_v1.ausgleichsabgaben_ausgleichsabgabe AS ausgleichsabgabe
JOIN
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS hoheitsgrenzen ON ST_Contains(hoheitsgrenzen.geometrie, ausgleichsabgabe.geometrie)
JOIN
    grundstueck ON ST_Contains(grundstueck.geometrie, ausgleichsabgabe.geometrie)
WHERE 
    ausgleichsabgabe.geometrie IS NOT NULL
;