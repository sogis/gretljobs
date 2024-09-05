WITH

grundstueck AS (
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
),

dokumente AS (
    SELECT
        t_id AS ausgleichsabgabe_id,
        concat('https://geo.so.ch/docs/ch.so.dsbjd.ausgleichsabgabe/', unnest(string_to_array(dokumente, E'\n'))) AS link
    FROM 
        dsbjd_ausgleichsabgabe_v1.ausgleichsabgaben_ausgleichsabgabe
    GROUP BY 
        t_id
),

dokumente_json AS (
    SELECT
        ausgleichsabgabe_id,
        json_agg(json_build_object('Dokument', dokumente.link)) AS dokumente
    FROM 
        dokumente
    GROUP BY 
        ausgleichsabgabe_id
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
    ausgleichsabgabe.datum_rechnung_abbruch,
    ausgleichsabgabe.datum_zahlung_abbruch,
    ausgleichsabgabe.bemerkung,
    ausgleichsabgabe.geometrie,
    hoheitsgrenzen.gemeindename AS gemeinde,
    grundstueck.grundbuchnummer,
    grundstueck.egrid,
    dokumente_json.dokumente
FROM
    dsbjd_ausgleichsabgabe_v1.ausgleichsabgaben_ausgleichsabgabe AS ausgleichsabgabe
LEFT JOIN dokumente_json
    ON ausgleichsabgabe.t_id = dokumente_json.ausgleichsabgabe_id
JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS hoheitsgrenzen
    ON ST_Contains(hoheitsgrenzen.geometrie, ausgleichsabgabe.geometrie)
JOIN grundstueck
    ON ST_Contains(grundstueck.geometrie, ausgleichsabgabe.geometrie)
WHERE 
    ausgleichsabgabe.geometrie IS NOT NULL
;
