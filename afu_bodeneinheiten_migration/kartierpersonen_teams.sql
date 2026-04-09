WITH dataset AS (
    SELECT
        t_id,
        datasetname
    FROM
        afu_bodeneinheiten_v1.t_ili2db_dataset
    WHERE
        datasetname = 'migration'
),
basket AS (
    SELECT
        t_id
    FROM
        afu_bodeneinheiten_v1.t_ili2db_basket
    WHERE
        attachmentkey = 'migration'
),
mapping AS (
    SELECT *
    FROM (
        VALUES
            ('Brecht', 'Wasser', 'BW'),
            ('Brecht', 'Wasser', 'BW/GK'),
            ('Geri', 'Kaufmann', 'BW/GK'),
            ('Elisabeth', 'Danner', 'ED'),
            ('Hans', 'Pfister', 'HP'),
            ('Albert', 'Pazeller', 'Pa/AR/MK'),
            ('Andreas', 'Ruef', 'Pa/AR/MK'),
            ('Marianne', 'Knecht', 'Pa/AR/MK'),
            ('Werner', 'Rohr', 'Ro'),
            ('Svatobor', 'Herot', 'SH'),
            ('Martin', 'Zürrer', 'zü'),
            ('Thomas', 'Gasche', 'ga'),
            ('Markus', 'Vogt', 'MV'),
            ('Markus', 'Rüttimann', 'rü/ug'),
            ('Urs', 'Geyer', 'rü/ug'),
            ('Stefan', 'Vavruch', 'VAV/PRE'),
            ('Jiri', 'Presler', 'VAV/PRE'),
            ('Jiri', 'Videtic', 'VIDE'),
            ('Jiri', 'Presler', 'PRE'),
            ('Jiri', 'Presler', 'PRE/VOG'),
            ('Markus', 'Vogt', 'PRE/VOG'),
            ('Andreas', 'Ruef', 'AR/MK/UB/KB'),
            ('Marianne', 'Knecht', 'AR/MK/UB/KB'),
            ('Ueli', 'Busin', 'AR/MK/UB/KB'),
            ('Karin', 'Baumgartner', 'AR/MK/UB/KB'),
            ('Markus', 'Günter', 'GUN'),
            ('Thomas', 'Gasche', 'ga/as'),
            ('Anina', 'Schmidhauser', 'ga/as'),
            ('Anina', 'Schmidhauser', 'as'),
            ('Andreas', 'Ruef', 'AR/UB/MW'),
            ('Ueli', 'Busin', 'AR/UB/MW'),
            ('Michael', 'Wernli', 'AR/UB/MW'),
            ('Thomas', 'Gasche', 'ga/as/mw'),
            ('Anina', 'Schmidhauser', 'ga/as/mw'),
            ('Michael', 'Wernli', 'ga/as/mw'),
            ('Marianne', 'Knecht', 'MK/KB/MM'),
            ('Karin', 'Baumgartner', 'MK/KB/MM'),
            ('Michael', 'Margreth', 'MK/KB/MM'),
            ('Werner', 'Rohr', 'Ro/Tu'),
            ('Simon', 'Tutsch', 'Ro/Tu'),
            ('Werner', 'Rohr', 'Ro/EK'),
            ('Emanuel', 'Kuster', 'Ro/EK'),
            ('Marianne', 'Knecht', 'MK'),
            ('Karin', 'Baumgartner', 'KB'),
            ('Werner', 'Rohr', 'Ro/Tu/sfe'),
            ('Simon', 'Tutsch', 'Ro/Tu/sfe'),
            ('Stefan', 'Felder', 'Ro/Tu/sfe'),
            ('Ueli', 'Reinmann', 'UR'),
            ('Thomas', 'Gasche', 'ga/mw/mm/as'),
            ('Michael', 'Wernli', 'ga/mw/mm/as'),
            ('Michael', 'Margreth', 'ga/mw/mm/as'),
            ('Anina', 'Schmidhauser', 'ga/mw/mm/as'),
            ('Brecht', 'Wasser', 'BW/ED/GK'),
            ('Elisabeth', 'Danner', 'BW/ED/GK'),
            ('Geri', 'Kaufmann', 'BW/ED/GK'),
            ('Albert', 'Pazeller', 'Pa/Ro'),
            ('Werner', 'Rohr', 'Pa/Ro'),
            ('Hans', 'Pfister', 'HP/UV'),
            ('Urs', 'Vökt', 'HP/UV'),
            ('Jiri', 'Presler', 'PRE/GUN'),
            ('Markus', 'Günter', 'PRE/GUN'),
            ('Jiri', 'Presler', 'PRE/MV/CAR'),
            ('Markus', 'Vogt', 'PRE/MV/CAR'),
            ('Marco', 'Carizzoni', 'PRE/MV/CAR'),
            ('Jiri', 'Presler', 'PRE/MV/VAR/GUN/ga'),
            ('Markus', 'Vogt', 'PRE/MV/VAR/GUN/ga'),
            ('Stefan', 'Vavruch', 'PRE/MV/VAR/GUN/ga'),
            ('Markus', 'Günter', 'PRE/MV/VAR/GUN/ga'),
            ('Thomas', 'Gasche', 'PRE/MV/VAR/GUN/ga'),
            ('Werner', 'Rohr', 'Ro/Pa'),
            ('Albert', 'Pazeller', 'Ro/Pa'),
            ('Werner', 'Rohr', 'Ro/Pa/Tu'),
            ('Albert', 'Pazeller', 'Ro/Pa/Tu'),
            ('Simon', 'Tutsch', 'Ro/Pa/Tu'),
            ('Andreas', 'Ruef', 'AR/MK/UB/KB/MM'),
            ('Marianne', 'Knecht', 'AR/MK/UB/KB/MM'),
            ('Ueli', 'Busin', 'AR/MK/UB/KB/MM'),
            ('Karin', 'Baumgartner', 'AR/MK/UB/KB/MM'),
            ('Michael', 'Margreth', 'AR/MK/UB/KB/MM'),
            ('Markus', 'Rüttimann', 'rü/uv/ug'),
            ('Urs', 'Vökt', 'rü/uv/ug'),
            ('Urs', 'Geyer', 'rü/uv/ug'),
            ('Markus', 'Vogt', 'MV/Bau'),
            ('Urs', 'Vökt', 'UV/MW/MM'),
            ('Michael', 'Wernli', 'UV/MW/MM'),
            ('Michael', 'Margreth', 'UV/MW/MM'),
            ('Thomas', 'Gasche', 'ga/ra'),
            ('Lorenz', 'Ramseier', 'ga/ra'),
            ('Christine', 'Rupflin', 'ru/zü'),
            ('Martin', 'Zürrer', 'ru/zü'),
            ('Raphael', 'Hürlimann', 'hü/zü'),
            ('Martin', 'Zürrer', 'hü/zü'),
            ('Esther', 'Bräm', 'brä'),
            ('Stefan', 'Felder', 'sfe/Zü'),
            ('Martin', 'Zürrer', 'sfe/Zü'),
            ('Michael', 'Margreth', 'MM'),
            ('Michael', 'Wernli', 'MW'),
            ('Lorenz', 'Ramseier', 'ra'),
            ('Nathalie', 'Dakhel', 'Dn/Vf'),
            ('Corinne', 'Vez', 'Dn/Vf'),
            ('Michael', 'Margreth', 'MM/JS'),
            ('Julia', 'Siegrist', 'MM/JS'),
            ('Marianne', 'Knecht', 'MK/TS'),
            ('Teresa', 'Steinert', 'MK/TS'),
            ('Mirjam', 'Lazzini', 'ML'),
            ('Julia', 'Siegrist', 'JS'),
            ('Thomas', 'Gasche', 'ga / laz'),
            ('Mirjam', 'Lazzini', 'ga / laz'),
            ('Stefan', 'Felder', 'sfe'),
            ('Stefan', 'Flury', 'sfl'),
            ('Martina', 'Vögtli', 'vö'),
            ('Christine', 'Eggert', 'eg'),
            ('Anina', 'Bürgi', 'bü'),
            ('Oliver', 'Hunziker', 'ho'),
            ('Raphael', 'Hürlimann', 'hü'),
            ('Sandra', 'Köhler', 'kö'),
            ('Teresa', 'Steinert', 'TS'),
            ('Benjamin', 'Kuster', 'bk'),
            ('Wasja', 'Dollenmeier', 'WD'),
            ('Iwan', 'Vitins', 'IV'),
            ('Bertram', 'Baumgarten', 'bb/ga'),
            ('Thomas', 'Gasche', 'bb/ga'),
            ('Lisa', 'Pirisinu', 'pi'),
            ('Leonie', 'Baumer', 'ba'),
            ('Bertram', 'Baumgarten', 'bb'),
            ('Roman', 'Berger', 'bego'),
            ('Elisabeth', 'Danner', 'ed/sfl'),
            ('Stefan', 'Flury', 'ed/sfl'),
            ('Nicolas', 'Erzer', 'ne'),
            ('Nicolas', 'Erzer', 'ne/slf'),
            ('Stefan', 'Flury', 'ne/slf'),
            ('Nicolas', 'Erzer', 'ne/lm'),
            ('Luis', 'Muheim', 'ne/lm'),
            ('Stefan', 'Flury', 'slf/lr'),
            ('Lorenz', 'Ramseier', 'slf/lr'),
            ('Stefan', 'Flury', 'slf/ne'),
            ('Nicolas', 'Erzer', 'slf/ne'),
            ('Stefan', 'Flury', 'slf/lm'),
            ('Luis', 'Muheim', 'slf/lm'),
            ('Luis', 'Muheim', 'lm/ne'),
            ('Nicolas', 'Erzer', 'lm/ne'),
            ('Stefan', 'Oechslin', 'oe'),
            ('Marco', 'Pfranger', 'pf'),
            ('Nathan', 'Pythoud', 'np')
    ) AS v(vorname, aname, teamkuerzel)
)
INSERT INTO afu_bodeneinheiten_v1.kartierpersonteam
(
    t_basket,
    t_datasetname,
    kartierperson_r,
    kartierteam_r
)
SELECT
    basket.t_id,
    dataset.datasetname,
    kp.t_id,
    kt.t_id
FROM mapping m
CROSS JOIN dataset
CROSS JOIN basket
JOIN afu_bodeneinheiten_v1.kartierperson kp
    ON kp.t_datasetname = dataset.datasetname
   AND kp.vorname = m.vorname
   AND kp.aname = m.aname
JOIN afu_bodeneinheiten_v1.kartierteam kt
    ON kt.t_datasetname = dataset.datasetname
   AND kt.teamkuerzel = m.teamkuerzel;