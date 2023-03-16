SELECT
    ST_RemoveRepeatedPoints(waldplan_bestandeskarte.geometrie, 0.02) AS geometrie,
    id_wp,
    fid_amtei,
    fid_fk,
    fid_fr,
    wirt_zone,
    gem_bfs,
    fid_we,
    round(gb_flaeche,0) AS gb_flaeche,
    we_text,
    fid_eigcod,
    fid_eig,
    fid_prod,
    wpnr,
    wptyp,
    betriebsteil,
    fid_abt,
    bstnr,
    bsttyp,
    wpinfo,
    bemerkung,
    round(flae_gis::numeric,0) AS flae_gis,
    zeitstand,
    beschrift,
    x_beschr,
    y_beschr,
    objnummer,
    weidewald,
    gb_gem_bfs,
    astatus,
    'Olten' AS gemeindename,
    CASE 
        WHEN fid_eig = 1000
            THEN '1000 - Bundeswald' 
        WHEN fid_eig = 2000
            THEN '2000 - Staatswald'
        WHEN fid_eig = 3100
            THEN '3100 - Bürgergemeinde'
        WHEN fid_eig = 3200
            THEN '3200 - Einwohnergemeinde'
        WHEN fid_eig = 3300
            THEN '3300 - Einheitsgemeinde'
        WHEN fid_eig = 4000
            THEN '4000 - Öffentlich (gemischt)'
        WHEN fid_eig = 5000
            THEN '5000 - Gemischt öffentlich privat'
        WHEN fid_eig = 6000
            THEN '6000 - Privat'
        WHEN fid_eig = 7000
            THEN '7000 - Privat (gemischt)'
    END AS fid_eig_text,
    CASE 
        WHEN wpnr = 501 
            THEN '501 - Wirtschaftswald' 
        WHEN wpnr = 502 
            THEN '502 - Schutzwald' 
        WHEN wpnr = 503 
            THEN '503 - Erholungswald' 
        WHEN wpnr = 504 
            THEN '504 - Natur und Landschaft'
        WHEN wpnr = 505 
            THEN '505 - Schutzwald / Natur und Landschaft' 
        WHEN wpnr = 509 
            THEN '509 - Nicht Wald'
    END AS wpnr_text,
    CASE 
        WHEN wptyp = 1 
            THEN '1 - Mit Wald bestockt' 
        WHEN wptyp = 2
            THEN '2 - Niederhaltezone'
        WHEN wptyp = 3 
            THEN '3 - Waldstrasse'
        WHEN wptyp = 4
            THEN '4 - Maschinenweg'
        WHEN wptyp = 5
            THEN '5 - Bauten und Anlagen'
        WHEN wptyp = 6
            THEN '6 - Rodungsfläche (temporär)'
        WHEN wptyp = 7
            THEN '7 - Gewässer'
        WHEN wptyp = 8
            THEN '8 - Abbaustelle'
        WHEN wptyp = 9
            THEN '9 - Nicht Wald'
    END AS wptyp_text,
    CASE
        WHEN betriebsteil = 1
            THEN concat_ws(' - ', betriebsteil, 'Talwald')
        WHEN betriebsteil = 2
            THEN concat_ws(' - ', betriebsteil, 'Bergwald')
        WHEN betriebsteil = 3
            THEN concat_ws(' - ', betriebsteil, 'Vorberg')
        WHEN betriebsteil = 4
            THEN concat_ws(' - ', betriebsteil, 'Sonnseite')
        WHEN betriebsteil = 5
            THEN concat_ws(' - ', betriebsteil, 'Schattseite')
        WHEN betriebsteil = 6
            THEN concat_ws(' - ', betriebsteil, 'Lebern-Klus')
        WHEN betriebsteil = 7
            THEN concat_ws(' - ', betriebsteil, 'Aebisholz')
        WHEN betriebsteil = 8
            THEN concat_ws(' - ', betriebsteil, 'Jurawald')
        WHEN  betriebsteil = 9
            THEN concat_ws(' - ', betriebsteil, 'Bornwald')
    END AS betriebsteil_text,
    CASE
        WHEN
            bsttyp >= 10
            AND
            bsttyp <= 14
                THEN 'Jungwuchs/Dickung (10-14)'
        WHEN
            bsttyp >= 21
            AND
            bsttyp <= 24
                THEN 'Stangenholz (21-24)'
        WHEN
            bsttyp >= 31
            AND
            bsttyp <= 34
                THEN 'Schwaches Baumholz (31-34)'
        WHEN
            bsttyp >= 41
            AND
            bsttyp <= 44
                THEN 'Mittleres Baumholz (41-44)'
        WHEN
            bsttyp >= 51
            AND
            bsttyp <= 54
                THEN 'Starkes Baumholz (51-54)'
        WHEN
            bsttyp >= 61
            AND
            bsttyp <= 64
                THEN 'St. Baumholz aufgelockert (61-64)'
        WHEN 
            bsttyp >= 70
            AND
            bsttyp <= 74
                THEN 'Übriger Wald ausser Bewirtschaftung (70-74)'
        WHEN bsttyp = 75
            THEN 'Altholzinsel (75)'
        WHEN bsttyp = 76
            THEN 'Andere Förderfläche (76)'
        WHEN bsttyp = 77
            THEN 'Waldrand (77)'
        WHEN bsttyp = 79
            THEN 'Waldreservat mit Vereinbarung (79)'
        WHEN
            bsttyp >= 81
            AND
            bsttyp <= 84
                THEN 'Dauerwald / Plenterwald (81-84)'
        WHEN
            bsttyp >= 210
            AND
            bsttyp <= 214
                THEN 'Mittelwald (210-214)'
        WHEN
            bsttyp >= 200
            AND
            bsttyp <= 204
                THEN 'Niederwald (200-204)'
    END AS bsttyp_text
FROM
    awjf_waldplan_bestandeskarte_v1.waldplan_bestandeskarte

WHERE
    (
        astatus = 'abgeschlossen'
    OR
        id_wp > 0
    )
-- ${bfsnr_param}
;
