SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    x,
    y,
    ino2_2010,
    CASE
        WHEN ino2_2010 < 3
            THEN '< 3'
        WHEN 
            ino2_2010 >= 3
            AND
            ino2_2010 < 6
            THEN '3 - 6'
        WHEN 
            ino2_2010 >= 6
            AND
            ino2_2010 < 9
            THEN '6 - 9'
        WHEN
            ino2_2010 >= 9
            AND
            ino2_2010 < 12
            THEN '9 - 12'
        WHEN
            ino2_2010 >= 12
            AND
            ino2_2010 < 15
            THEN '12 - 15'
        WHEN
            ino2_2010 >= 15
            AND
            ino2_2010 < 18
            THEN '15 - 18'
        WHEN
            ino2_2010 >= 18
            AND
            ino2_2010 < 21
            THEN '18 - 21'
        WHEN
            ino2_2010 >= 21
            AND
            ino2_2010 < 24
            THEN '21 - 24'
        WHEN
            ino2_2010 >= 24
            AND
            ino2_2010 < 27
            THEN '24 - 27'
        WHEN
            ino2_2010 >= 27
            AND
            ino2_2010 < 30
            THEN '27 - 30'
        WHEN
            ino2_2010 >= 30
            AND
            ino2_2010 < 33
            THEN '30 - 33'
        WHEN
            ino2_2010 >= 33
            AND
            ino2_2010 < 36
            THEN '33 - 36'
        WHEN
            ino2_2010 >= 36
            AND
            ino2_2010 < 39
            THEN '36 - 39'
        WHEN
            ino2_2010 >= 39
            AND
            ino2_2010 < 42
            THEN '39 - 42'
        WHEN
            ino2_2010 >= 42
            AND
            ino2_2010 < 45
            THEN '42 - 45'
        WHEN
            ino2_2010 >= 45
            AND
            ino2_2010 < 48
            THEN '45 - 48'
        WHEN
            ino2_2010 >= 48
            AND
            ino2_2010 < 51
            THEN '48 - 51'
        WHEN
            ino2_2010 >= 51
            AND 
            ino2_2010 < 54
            THEN '51 - 54'
        WHEN 
            ino2_2010 >= 54
            AND
            ino2_2010 < 57
            THEN '54 - 57'
        WHEN ino2_2010 >= 57
            THEN '> 57'
    END AS ino2_2010_range,
    ino2_2020,
    CASE
        WHEN ino2_2020 < 3
            THEN '< 3'
        WHEN 
            ino2_2020 >= 3
            AND
            ino2_2020 < 6
            THEN '3 - 6'
        WHEN 
            ino2_2020 >= 6
            AND
            ino2_2020 < 9
            THEN '6 - 9'
        WHEN
            ino2_2020 >= 9
            AND
            ino2_2020 < 12
            THEN '9 - 12'
        WHEN
            ino2_2020 >= 12
            AND
            ino2_2020 < 15
            THEN '12 - 15'
        WHEN
            ino2_2020 >= 15
            AND
            ino2_2020 < 18
            THEN '15 - 18'
        WHEN
            ino2_2020 >= 18
            AND
            ino2_2020 < 21
            THEN '18 - 21'
        WHEN
            ino2_2020 >= 21
            AND
            ino2_2020 < 24
            THEN '21 - 24'
        WHEN
            ino2_2020 >= 24
            AND
            ino2_2020 < 27
            THEN '24 - 27'
        WHEN
            ino2_2020 >= 27
            AND
            ino2_2020 < 30
            THEN '27 - 30'
        WHEN
            ino2_2020 >= 30
            AND
            ino2_2020 < 33
            THEN '30 - 33'
        WHEN
            ino2_2020 >= 33
            AND
            ino2_2020 < 36
            THEN '33 - 36'
        WHEN
            ino2_2020 >= 36
            AND
            ino2_2020 < 39
            THEN '36 - 39'
        WHEN
            ino2_2020 >= 39
            AND
            ino2_2020 < 42
            THEN '39 - 42'
        WHEN
            ino2_2020 >= 42
            AND
            ino2_2020 < 45
            THEN '42 - 45'
        WHEN
            ino2_2020 >= 45
            AND
            ino2_2020 < 48
            THEN '45 - 48'
        WHEN
            ino2_2020 >= 48
            AND
            ino2_2020 < 51
            THEN '48 - 51'
        WHEN
            ino2_2020 >= 51
            AND 
            ino2_2020 < 54
            THEN '51 - 54'
        WHEN 
            ino2_2020 >= 54
            AND
            ino2_2020 < 57
            THEN '54 - 57'
        WHEN ino2_2020 >= 57
            THEN '> 57'
    END AS ino2_2020_range,
    ipm10_2010,
    CASE
        WHEN ipm10_2010 < 2
            THEN '< 2'
        WHEN
            ipm10_2010 >= 2
            AND
            ipm10_2010 < 4
            THEN '2 - 4'
        WHEN
            ipm10_2010 >= 4
            AND
            ipm10_2010 < 6
            THEN '4 - 6'
        WHEN
            ipm10_2010 >= 6
            AND
            ipm10_2010 < 8
            THEN '6 - 8'
        WHEN
            ipm10_2010 >= 8
            AND
            ipm10_2010 < 10
            THEN '8 - 10'
        WHEN
            ipm10_2010 >= 10
            AND
            ipm10_2010 < 12
            THEN '10 - 12'
        WHEN
            ipm10_2010 >= 12
            AND
            ipm10_2010 < 14
            THEN '12 - 14'
        WHEN
            ipm10_2010 >= 14
            AND
            ipm10_2010 < 16
            THEN '14 - 16'
        WHEN
            ipm10_2010 >= 16
            AND
            ipm10_2010 < 18
            THEN '16 - 18'
        WHEN
            ipm10_2010 >= 18
            AND
            ipm10_2010 < 20
            THEN '18 - 20'
        WHEN
            ipm10_2010 >= 20
            AND
            ipm10_2010 < 22
            THEN '20 - 22'
        WHEN
            ipm10_2010 >= 22
            AND
            ipm10_2010 < 24
            THEN '22 - 24'
        WHEN
            ipm10_2010 >= 24
            AND
            ipm10_2010 < 26
            THEN '24 - 26'
        WHEN
            ipm10_2010 >= 26
            AND
            ipm10_2010 < 28
            THEN '26 - 28'
        WHEN
            ipm10_2010 >= 28
            AND
            ipm10_2010 < 30
            THEN '28 - 30'
        WHEN
            ipm10_2010 >= 30
            AND
            ipm10_2010 < 32
            THEN '30 - 32'
        WHEN
            ipm10_2010 >= 32
            AND
            ipm10_2010 < 34
            THEN '32 - 34'
        WHEN
            ipm10_2010 >= 34
            AND
            ipm10_2010 < 36
            THEN '34 - 36'
        WHEN
            ipm10_2010 >= 36
            AND
            ipm10_2010 < 38
            THEN '36 - 38'
        WHEN ipm10_2010 >= 38
            THEN '> 38'
    END AS ipm10_2010_range,
    ipm10_2020,
    CASE
        WHEN ipm10_2020 < 2
            THEN '< 2'
        WHEN
            ipm10_2020 >= 2
            AND
            ipm10_2020 < 4
            THEN '2 - 4'
        WHEN
            ipm10_2020 >= 4
            AND
            ipm10_2020 < 6
            THEN '4 - 6'
        WHEN
            ipm10_2020 >= 6
            AND
            ipm10_2020 < 8
            THEN '6 - 8'
        WHEN
            ipm10_2020 >= 8
            AND
            ipm10_2020 < 10
            THEN '8 - 10'
        WHEN
            ipm10_2020 >= 10
            AND
            ipm10_2020 < 12
            THEN '10 - 12'
        WHEN
            ipm10_2020 >= 12
            AND
            ipm10_2020 < 14
            THEN '12 - 14'
        WHEN
            ipm10_2020 >= 14
            AND
            ipm10_2020 < 16
            THEN '14 - 16'
        WHEN
            ipm10_2020 >= 16
            AND
            ipm10_2020 < 18
            THEN '16 - 18'
        WHEN
            ipm10_2020 >= 18
            AND
            ipm10_2020 < 20
            THEN '18 - 20'
        WHEN
            ipm10_2020 >= 20
            AND
            ipm10_2020 < 22
            THEN '20 - 22'
        WHEN
            ipm10_2020 >= 22
            AND
            ipm10_2020 < 24
            THEN '22 - 24'
        WHEN
            ipm10_2020 >= 24
            AND
            ipm10_2020 < 26
            THEN '24 - 26'
        WHEN
            ipm10_2020 >= 26
            AND
            ipm10_2020 < 28
            THEN '26 - 28'
        WHEN
            ipm10_2020 >= 28
            AND
            ipm10_2020 < 30
            THEN '28 - 30'
        WHEN
            ipm10_2020 >= 30
            AND
            ipm10_2020 < 32
            THEN '30 - 32'
        WHEN
            ipm10_2020 >= 32
            AND
            ipm10_2020 < 34
            THEN '32 - 34'
        WHEN
            ipm10_2020 >= 34
            AND
            ipm10_2020 < 36
            THEN '34 - 36'
        WHEN
            ipm10_2020 >= 36
            AND
            ipm10_2020 < 38
            THEN '36 - 38'
        WHEN ipm10_2020 >= 38
            THEN '> 38'
    END AS ipm10_2020_range,
    ipm25_2010,
    ipm25_2020
FROM
    immissionskarten_luft.luftbelastung_2010_2020
;