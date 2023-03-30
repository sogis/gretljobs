select 
    rowdef.*, 
    st_makepoint(rowdef.x_koordinate, rowdef.y_koordinate) AS geometrie
from 
    awjf_efj_v1.efj_abgaenge s
CROSS JOIN LATERAL
	jsonb_to_record(replace(s.content,'""','null')::jsonb) as rowdef(
        "Betriebsart" TEXT,
        "fallnr" TEXT,
        "tierart" TEXT,
        "anzahl" INTEGER,
        "datum" DATE,
        "zeit" TIME,
        "bezugsperson" TEXT,
        "bezugsperson_id" INTEGER,
        "reviernr" INTEGER,
        "kulturodernutztierart" TEXT,
        "totalschadenauszahlung" FLOAT,
        "todesgrund" TEXT,
        "tieralter" INTEGER,
        "tieralter_txt" TEXT,
        "geschlecht" TEXT,
        "schutzart" TEXT,
        "beobachtungsfall" TEXT,
        "eFJ_id" TEXT,
        "x_koordinate" INTEGER,
        "y_koordinate" INTEGER,
        "apolygon" TEXT
    )

