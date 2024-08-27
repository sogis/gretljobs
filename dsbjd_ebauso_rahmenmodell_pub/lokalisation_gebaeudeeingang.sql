DELETE FROM 
    dsbjd_ebauso_rahmenmodell_pub_v1.lokalisation_gebaeudeeingang
;

INSERT INTO
    dsbjd_ebauso_rahmenmodell_pub_v1.lokalisation_gebaeudeeingang
    (
        strassenname,
        hausnummer,
        plz,
        ortschaft,
        egid,
        edid,
        lage
    )
SELECT 
    strassenname,
    hausnummer,
    plz,
    ortschaft,
    egid,
    edid,
    lage
FROM 
    agi_mopublic_pub.mopublic_gebaeudeadresse 
WHERE 
    ist_offizielle_bezeichnung IS TRUE
;