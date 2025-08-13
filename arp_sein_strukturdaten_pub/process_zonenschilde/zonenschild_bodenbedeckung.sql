-- Zonenschild x Bodenbedeckung

DROP TABLE IF EXISTS
    export.zonenschild_bodenbedeckung CASCADE
;

CREATE TABLE
    export.zonenschild_bodenbedeckung (
    schild_uuid     UUID,
    kategorie_text  TEXT,
    flaeche_agg     NUMERIC
);

INSERT
    INTO export.zonenschild_bodenbedeckung
    SELECT
        z.schild_uuid,
        b.kategorie_text,
        sum(b.flaeche_agg) AS flaeche_agg
    FROM
        export.zonenschild_basis z
    JOIN export.parzellen_basis p
        ON ST_Intersects(p.pip, z.geometrie)
    -- tbd Denkfehler: ein Zonenschild kann kleiner sein als Parzelle, ich darf nicht die ganze Parzelle joinen!
    JOIN export.parzellen_bodenbedeckung b
        USING (t_ili_tid)
    GROUP BY
        z.schild_uuid,
        b.kategorie_text
;

CREATE INDEX
    ON export.zonenschild_bodenbedeckung (kategorie_text);