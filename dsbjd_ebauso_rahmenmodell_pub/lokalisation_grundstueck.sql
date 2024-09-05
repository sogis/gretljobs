DELETE FROM 
    dsbjd_ebauso_rahmenmodell_pub_v1.lokalisation_grundstueck
;

INSERT INTO 
    dsbjd_ebauso_rahmenmodell_pub_v1.lokalisation_grundstueck
    (
        nummer,
        egrid,
        art,
        flaechenmass,
        bfsnr,
        geometrie,
        gemeinde,
        grundbuchkreis,
        amtschreiberei
    )
SELECT 
    nummer,
    egrid,
    art_txt AS art,
    flaechenmass,
    bfs_nr AS bfsnr,
    geometrie,
    gemeinde,
    grundbuch AS grundbuchkreis,
    gb.amtschreiberei 
FROM 
    agi_mopublic_pub.mopublic_grundstueck AS g
    LEFT JOIN agi_av_gb_admin_einteilung_pub.grundbuchkreise_grundbuchkreis AS gb 
    ON g.bfs_nr = gb.bfsnr 
;