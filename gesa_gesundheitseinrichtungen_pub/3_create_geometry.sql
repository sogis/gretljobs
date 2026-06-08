UPDATE gesa_gesundheitseinrichtungen_staging_v1.gesundheitseinrichtung
SET geometrie = ST_SetSRID(ST_MakePoint(x_koordinate, y_koordinate), 2056);