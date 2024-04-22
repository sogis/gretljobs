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
    ausgleichsabgabe.erfassungsdatum,
    ausgleichsabgabe.astatus,
    ausgleichsabgabe.geometrie,
    ausgleichsabgabe.ausloeser_faelligkeit,
    ausgleichsabgabe.rrb_nr,
    ausgleichsabgabe.bemerkung,
    ausgleichsabgabe.bezahlt,
    grundstueck.egrid,
    hoheitsgrenzen.gemeindename AS gemeinde,
    grundstueck.grundbuchnummer
FROM
    agi_ausgleichsabgabe_v1.ausgleichsabgaben_anpassung AS ausgleichsabgabe
JOIN
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS hoheitsgrenzen ON ST_Contains(hoheitsgrenzen.geometrie, ausgleichsabgabe.geometrie)
JOIN
    grundstueck ON ST_Contains(grundstueck.geometrie, ausgleichsabgabe.geometrie)
WHERE 
    ausgleichsabgabe.geometrie IS NOT NULL
