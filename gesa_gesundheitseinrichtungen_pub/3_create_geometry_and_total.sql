UPDATE gesa_gesundheitseinrichtungen_staging_v1.gesundheitseinrichtung
    SET
        geometrie = ST_SetSRID(ST_MakePoint(x_koordinate, y_koordinate), 2056),
        total = COALESCE(kognitiv_schwer_beeintraechtigt, 0)
            + COALESCE(kognitiv_und_physisch_schwer_beeintraechtigt, 0)
            + COALESCE(physisch_schwer_beeintraechtigt, 0)
            + COALESCE(nicht_schwer_beeintraechtigt, 0)
;