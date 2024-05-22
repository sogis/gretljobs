SELECT
    bodenbedeckung.bfs_nr,
    bodenbedeckung.geometrie,
    adresse.strassenname,
    adresse.hausnummer,
    adresse.egid,
    adresse.edid,
    adresse.plz,
    adresse.ortschaft,
    adresse.astatus,
    adresse.ist_offizielle_bezeichnung,
    adresse.hoehenlage,
    adresse.gebaeudename,
    adresse.orientierung,
    adresse.hali,
    adresse.vali,
    adresse.posx,
    adresse.posy,
    CASE
        WHEN adresse.egid IS NOT NULL
            THEN concat('https://www.housing-stat.ch/de/query/egid.html?egid=',adresse.egid::TEXT)
        ELSE 'https://www.housing-stat.ch/'
    END AS link_gwr
FROM agi_mopublic_pub.mopublic_gebaeudeadresse adresse
    JOIN agi_mopublic_pub.mopublic_bodenbedeckung bodenbedeckung 
        ON ST_CONTAINS(bodenbedeckung.geometrie , adresse.lage)
WHERE adresse.ist_offizielle_bezeichnung IS TRUE AND bodenbedeckung.art_txt = 'Gebaeude'
