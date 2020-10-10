INSERT INTO agi_mopublic_pub_export.mopublic_fixpunkt
    (
        geometrie,
        typ_txt,
        nbident,
        nummer,
        hoehe,
        bfs_nr,
        lagegenauigkeit,
        hoehengenauigkeit,
        punktzeichen_txt,
        importdatum,
        nachfuehrung,
        koordinate
    )
    SELECT
        geometrie,
        typ_txt,
        nbident,
        nummer,
        hoehe,
        bfs_nr,
        lagegenauigkeit,
        hoehengenauigkeit,
        punktzeichen_txt,
        importdatum,
        nachfuehrung,
        koordinate
    FROM 
        agi_mopublic_pub.mopublic_fixpunkt
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_fixpunktpos
    (
        pos,
        orientierung,
        hali,
        vali,
        typ_txt,
        nbident,
        nummer,
        hoehe,
        bfs_nr,
        lagegenauigkeit,
        hoehengenauigkeit,
        punktzeichen_txt,
        importdatum,
        nachfuehrung,
        koordinate
    )
    SELECT
        pos,
        orientierung,
        hali,
        vali,
        typ_txt,
        nbident,
        nummer,
        hoehe,
        bfs_nr,
        lagegenauigkeit,
        hoehengenauigkeit,
        punktzeichen_txt,
        importdatum,
        nachfuehrung,
        koordinate
    FROM 
        agi_mopublic_pub.mopublic_fixpunkt
    WHERE
        bfs_nr = ${gem_bfs}
        AND 
        pos IS NOT NULL
;

INSERT INTO agi_mopublic_pub_export.mopublic_bodenbedeckung
    (
        art_txt,
        bfs_nr,
        egid,
        importdatum,
        nachfuehrung,
        geometrie
    )
    SELECT
        art_txt,
        bfs_nr,
        egid,
        importdatum,
        nachfuehrung,
        geometrie
    FROM 
        agi_mopublic_pub.mopublic_bodenbedeckung
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_bodenbedeckungproj
    (
        art_txt,
        bfs_nr,
        egid,
        importdatum,
        nachfuehrung,
        geometrie
    )
    SELECT
        art_txt,
        bfs_nr,
        egid,
        importdatum,
        nachfuehrung,
        geometrie
    FROM 
        agi_mopublic_pub.mopublic_bodenbedeckung_proj 
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_einzelobjektflaeche
    (
        art_txt,
        bfs_nr,
        egid,
        importdatum,
        nachfuehrung,
        geometrie
    )
    SELECT
        art_txt,
        bfs_nr,
        egid,
        importdatum,
        nachfuehrung,
        geometrie
    FROM 
        agi_mopublic_pub.mopublic_einzelobjekt_flaeche 
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_einzelobjektlinie
    (
        art_txt,
        bfs_nr,
        importdatum,
        nachfuehrung,
        geometrie
    )
    SELECT
        art_txt,
        bfs_nr,
        importdatum,
        nachfuehrung,
        geometrie
    FROM 
        agi_mopublic_pub.mopublic_einzelobjekt_linie
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_einzelobjektpunkt
    (
        art_txt,
        bfs_nr,
        symbolorientierung,
        importdatum,
        nachfuehrung,
        geometrie
    )
    SELECT
        art_txt,
        bfs_nr,
        symbolorientierung,        
        importdatum,
        nachfuehrung,
        geometrie
    FROM 
        agi_mopublic_pub.mopublic_einzelobjekt_punkt
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_flurname
    (
        geometrie,
        flurname,
        bfs_nr,
        importdatum,
        nachfuehrung,
        gemeinde
    )
    SELECT
        geometrie,
        flurname,
        bfs_nr,
        importdatum,
        nachfuehrung,
        gemeinde
    FROM 
        agi_mopublic_pub.mopublic_flurname
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_flurnamepos
    (
        pos,
        orientierung,
        hali,
        vali,
        flurname,
        bfs_nr,
        importdatum,
        nachfuehrung,
        gemeinde
    )
    SELECT
        pos,
        orientierung,
        hali,
        vali,
        flurname,
        bfs_nr,
        importdatum,
        nachfuehrung,
        gemeinde
    FROM 
        agi_mopublic_pub.mopublic_flurname
    WHERE
        bfs_nr = ${gem_bfs}
        AND 
        pos IS NOT NULL
;

INSERT INTO agi_mopublic_pub_export.mopublic_gebaeudeadresse
    (
        lage,
        strassenname,
        hausnummer,
        egid,
        edid,
        plz,
        ortschaft,
        astatus,
        ist_offizielle_bezeichnung,
        hoehenlage,
        gebaeudename,
        bfs_nr,
        importdatum,
        nachfuehrung
    )
    SELECT
        lage,
        strassenname,
        hausnummer,
        egid,
        edid,
        plz,
        ortschaft,
        astatus,
        ist_offizielle_bezeichnung,
        hoehenlage,
        gebaeudename,
        bfs_nr,
        importdatum,
        nachfuehrung
    FROM 
        agi_mopublic_pub.mopublic_gebaeudeadresse
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_gebaeudeadressepos
    (
        pos,
        orientierung,
        hali,
        vali,
        strassenname,
        hausnummer,
        egid,
        edid,
        plz,
        ortschaft,
        astatus,
        ist_offizielle_bezeichnung,
        hoehenlage,
        gebaeudename,
        bfs_nr,
        importdatum,
        nachfuehrung
    )
    SELECT
        pos,
        orientierung,
        hali,
        vali,
        strassenname,
        hausnummer,
        egid,
        edid,
        plz,
        ortschaft,
        astatus,
        ist_offizielle_bezeichnung,
        hoehenlage,
        gebaeudename,
        bfs_nr,
        importdatum,
        nachfuehrung
    FROM 
        agi_mopublic_pub.mopublic_gebaeudeadresse
    WHERE
        bfs_nr = ${gem_bfs}
        AND 
        pos IS NOT NULL
;

INSERT INTO agi_mopublic_pub_export.mopublic_gelaendename
    (
        gelaendename,
        bfs_nr,
        pos,
        orientierung,
        hali,
        vali,
        importdatum,
        nachfuehrung,
        gemeinde
    )
    SELECT
        gelaendename,
        bfs_nr,
        pos,
        orientierung,
        hali,
        vali,
        importdatum,
        nachfuehrung,
        gemeinde
    FROM 
        agi_mopublic_pub.mopublic_gelaendename
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_gemeindegrenze
    (
        gemeindename,
        geometrie,
        bfs_nr,
        importdatum,
        nachfuehrung
    )
    SELECT
        gemeindename,
        geometrie,
        bfs_nr,
        importdatum,
        nachfuehrung
    FROM 
        agi_mopublic_pub.mopublic_gemeindegrenze
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_gemeindegrenzeproj
    (
        gemeindename,
        geometrie,
        bfs_nr,
        importdatum,
        nachfuehrung
    )
    SELECT
        gemeindename,
        geometrie,
        bfs_nr,
        importdatum,
        nachfuehrung
    FROM 
        agi_mopublic_pub.mopublic_gemeindegrenze_proj
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_grenzpunkt
    (
        geometrie,
        lagegenauigkeit,
        lagezuverlaessigkeit,
        punktzeichen_txt,
        symbolorientierung,
        bfs_nr,
        importdatum,
        nachfuehrung,
        gueltigkeit
    )
    SELECT
        geometrie,
        lagegenauigkeit,
        lagezuverlaessigkeit,
        punktzeichen_txt,
        symbolorientierung,
        bfs_nr,
        importdatum,
        nachfuehrung,
        gueltigkeit
    FROM 
        agi_mopublic_pub.mopublic_grenzpunkt
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_grundstueck
    (
        geometrie,
        nbident,
        nummer,
        art_txt,
        flaechenmass,
        egrid,
        bfs_nr,
        importdatum,
        nachfuehrung,
        grundbuch,
        gemeinde
    )
    SELECT
        geometrie,
        nbident,
        nummer,
        art_txt,
        flaechenmass,
        egrid,
        bfs_nr,
        importdatum,
        nachfuehrung,
        grundbuch,
        gemeinde
    FROM 
        agi_mopublic_pub.mopublic_grundstueck
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_grundstueckpos
    (
        pos,
        orientierung,
        hali,
        vali,
        nbident,
        nummer,
        art_txt,
        flaechenmass,
        egrid,
        bfs_nr,
        importdatum,
        nachfuehrung,
        grundbuch,
        gemeinde
    )
    SELECT
        pos,
        orientierung,
        hali,
        vali,
        nbident,
        nummer,
        art_txt,
        flaechenmass,
        egrid,
        bfs_nr,
        importdatum,
        nachfuehrung,
        grundbuch,
        gemeinde
    FROM 
        agi_mopublic_pub.mopublic_grundstueck
    WHERE
        bfs_nr = ${gem_bfs}
        AND 
        pos IS NOT NULL
;

INSERT INTO agi_mopublic_pub_export.mopublic_grundstueckproj 
    (
        geometrie,
        nbident,
        nummer,
        art_txt,
        flaechenmass,
        egrid,
        bfs_nr,
        importdatum,
        nachfuehrung,
        grundbuch,
        gemeinde
    )
    SELECT
        geometrie,
        nbident,
        nummer,
        art_txt,
        flaechenmass,
        egrid,
        bfs_nr,
        importdatum,
        nachfuehrung,
        grundbuch,
        gemeinde
    FROM 
        agi_mopublic_pub.mopublic_grundstueck_proj 
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_grundstueckprojpos
    (
        pos,
        orientierung,
        hali,
        vali,
        nbident,
        nummer,
        art_txt,
        flaechenmass,
        egrid,
        bfs_nr,
        importdatum,
        nachfuehrung,
        grundbuch,
        gemeinde
    )
    SELECT
        pos,
        orientierung,
        hali,
        vali,
        nbident,
        nummer,
        art_txt,
        flaechenmass,
        egrid,
        bfs_nr,
        importdatum,
        nachfuehrung,
        grundbuch,
        gemeinde
    FROM 
        agi_mopublic_pub.mopublic_grundstueck_proj 
    WHERE
        bfs_nr = ${gem_bfs}
        AND 
        pos IS NOT NULL
;

INSERT INTO agi_mopublic_pub_export.mopublic_hoheitsgrenzpunkt 
    (
        geometrie,
        nummer,
        punktzeichen_txt,
        schoener_stein,
        lagegenauigkeit,
        lagezuverlaessigkeit,
        bfs_nr,
        importdatum,
        nachfuehrung
    )
    SELECT
        geometrie,
        nummer,
        punktzeichen_txt,
        schoener_stein,
        lagegenauigkeit,
        lagezuverlaessigkeit,
        bfs_nr,
        importdatum,
        nachfuehrung
    FROM 
        agi_mopublic_pub.mopublic_hoheitsgrenzpunkt 
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_hoheitsgrenzpunktpos 
    (
        pos,
        symbolorientierung,
        hali,
        vali,
        nummer,
        punktzeichen_txt,
        schoener_stein,
        lagegenauigkeit,
        lagezuverlaessigkeit,
        bfs_nr,
        importdatum,
        nachfuehrung
    )
    SELECT
        pos,
        symbolorientierung,
        hali,
        vali,
        nummer,
        punktzeichen_txt,
        schoener_stein,
        lagegenauigkeit,
        lagezuverlaessigkeit,
        bfs_nr,
        importdatum,
        nachfuehrung
    FROM 
        agi_mopublic_pub.mopublic_hoheitsgrenzpunkt 
    WHERE
        bfs_nr = ${gem_bfs}
        AND pos IS NOT NULL
;

INSERT INTO agi_mopublic_pub_export.mopublic_objektnamepos 
    (
        objektname,
        pos,
        orientierung,
        hali,
        vali,
        art_txt,
        herkunft,
        bfs_nr,
        importdatum,
        nachfuehrung,
        astatus
    )
    SELECT
        objektname,
        pos,
        orientierung,
        hali,
        vali,
        art_txt,
        herkunft,
        bfs_nr,
        importdatum,
        nachfuehrung,
        astatus
    FROM 
        agi_mopublic_pub.mopublic_objektname_pos 
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_ortsname 
    (
        geometrie,
        ortsname,
        bfs_nr,
        importdatum,
        nachfuehrung
    )
    SELECT
        geometrie,
        ortsname,
        bfs_nr,
        importdatum,
        nachfuehrung
    FROM 
        agi_mopublic_pub.mopublic_ortsname 
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_ortsnamepos 
    (
        pos,
        orientierung,
        hali,
        vali,
        ortsname,
        bfs_nr,
        importdatum,
        nachfuehrung
    )
    SELECT
        pos,
        orientierung,
        hali,
        vali,
        ortsname,
        bfs_nr,
        importdatum,
        nachfuehrung
    FROM 
        agi_mopublic_pub.mopublic_ortsname 
    WHERE
        bfs_nr = ${gem_bfs}
        AND 
        pos IS NOT NULL
;

INSERT INTO agi_mopublic_pub_export.mopublic_rohrleitung 
    (
        geometrie,
        art_txt,
        betreiber,
        bfs_nr,
        importdatum,
        nachfuehrung
    )
    SELECT
        geometrie,
        art_txt,
        betreiber,
        bfs_nr,
        importdatum,
        nachfuehrung
    FROM 
        agi_mopublic_pub.mopublic_rohrleitung 
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_strassenachse 
    (
        geometrie,
        strassenname,
        ordnung,
        bfs_nr,
        importdatum,
        nachfuehrung
    )
    SELECT
        geometrie,
        strassenname,
        ordnung,
        bfs_nr,
        importdatum,
        nachfuehrung
    FROM 
        agi_mopublic_pub.mopublic_strassenachse 
    WHERE
        bfs_nr = ${gem_bfs}
;

INSERT INTO agi_mopublic_pub_export.mopublic_strassennamepos 
    (
        strassenname,
        pos,
        orientierung,
        hali,
        vali,
        bfs_nr,
        importdatum,
        nachfuehrung
    )
    SELECT
        strassenname,
        pos,
        orientierung,
        hali,
        vali,
        bfs_nr,
        importdatum,
        nachfuehrung
    FROM 
        agi_mopublic_pub.mopublic_strassenname_pos 
    WHERE
        bfs_nr = ${gem_bfs}
;
