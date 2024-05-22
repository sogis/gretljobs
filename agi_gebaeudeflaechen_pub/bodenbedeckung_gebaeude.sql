WITH gebaeudename AS (
SELECT 
    objektname.objektname,
    bodenbedeckung.t_id
FROM agi_mopublic_pub.mopublic_objektname_pos AS objektname
    JOIN agi_mopublic_pub.mopublic_bodenbedeckung AS bodenbedeckung
    ON ST_CONTAINS(bodenbedeckung.geometrie , objektname.pos)
WHERE objektname.art_txt = 'Gebaeude' AND objektname.herkunft = 'BB'
)

SELECT
    bodenbedeckung.bfs_nr,
    bodenbedeckung.geometrie,
    gebaeudename.objektname AS gebaeudename,
    adresse.strassenname,
    adresse.hausnummer,
    adresse.egid,
    adresse.edid,
    adresse.plz,
    adresse.ortschaft,
    adresse.astatus,
    adresse.ist_offizielle_bezeichnung,
    adresse.hoehenlage,
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
    JOIN agi_mopublic_pub.mopublic_bodenbedeckung AS bodenbedeckung
    ON ST_CONTAINS(bodenbedeckung.geometrie , adresse.lage)
    LEFT JOIN gebaeudename AS gebaeudename 
    ON gebaeudename.t_id = bodenbedeckung.t_id 
WHERE adresse.ist_offizielle_bezeichnung IS TRUE AND bodenbedeckung.art_txt = 'Gebaeude'
