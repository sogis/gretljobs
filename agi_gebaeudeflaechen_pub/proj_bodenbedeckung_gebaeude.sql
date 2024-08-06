WITH gebaeudename AS (
SELECT 
    objektname.objektname,
    bodenbedeckung.t_id
FROM agi_mopublic_pub.mopublic_objektname_pos AS objektname
    JOIN agi_mopublic_pub.mopublic_bodenbedeckung_proj AS bodenbedeckung
        ON ST_CONTAINS(bodenbedeckung.geometrie , objektname.pos)
WHERE objektname.art_txt = 'Gebaeude' AND objektname.herkunft = 'BB'
)

SELECT
    bodenbedeckung.bfs_nr,
    bodenbedeckung.geometrie,
    bodenbedeckung.egid,
    gebaeudename.objektname AS gebaeudename,
    adresse.strassenname,
    CASE
    	WHEN adresse.ist_offizielle_bezeichnung IS TRUE
    	    THEN adresse.hausnummer
    	ELSE '0'
    END AS hausnummer,
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
        WHEN bodenbedeckung.egid IS NOT NULL
            THEN concat('https://www.housing-stat.ch/de/query/egid.html?egid=',bodenbedeckung.egid::TEXT)
        ELSE 'https://www.housing-stat.ch/'
    END AS link_gwr
FROM agi_mopublic_pub.mopublic_gebaeudeadresse adresse
    JOIN agi_mopublic_pub.mopublic_bodenbedeckung_proj AS bodenbedeckung
        ON ST_CONTAINS(bodenbedeckung.geometrie , adresse.lage)
    LEFT JOIN gebaeudename AS gebaeudename ON gebaeudename.t_id = bodenbedeckung.t_id 
WHERE bodenbedeckung.art_txt = 'Gebaeude'
