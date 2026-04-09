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
)
INSERT INTO afu_bodeneinheiten_v1.kartierperson
(
    t_basket,
    t_datasetname,
    vorname,
    aname
)
SELECT
    basket.t_id,
    dataset.datasetname,
    v.vorname,
    v.aname
FROM dataset
CROSS JOIN basket
CROSS JOIN (
    VALUES
        ('Anina', 'Bürgi'),
        ('Hans', 'Pfister'),
        ('Nicolas', 'Erzer'),
        ('Simon', 'Tutsch'),
        ('Roman', 'Berger'),
        ('Raphael', 'Hürlimann'),
        ('Michael', 'Margreth'),
        ('Ueli', 'Reinmann'),
        ('Markus', 'Vogt'),
        ('Mirjam', 'Lazzini'),
        ('Elisabeth', 'Danner'),
        ('Teresa', 'Steinert'),
        ('Martin', 'Zürrer'),
        ('Anina', 'Schmidhauser'),
        ('Lisa', 'Pirisinu'),
        ('Christine', 'Rupflin'),
        ('Lorenz', 'Ramseier'),
        ('Thomas', 'Gasche'),
        ('Werner', 'Rohr'),
        ('Jiri', 'Videtic'),
        ('Leonie', 'Baumer'),
        ('Stefan', 'Oechslin'),
        ('Stefan', 'Flury'),
        ('Urs', 'Geyer'),
        ('Sandra', 'Köhler'),
        ('Stefan', 'Felder'),
        ('Michael', 'Wernli'),
        ('Andreas', 'Ruef'),
        ('Marco', 'Carizzoni'),
        ('Stefan', 'Vavruch'),
        ('Nathalie', 'Dakhel'),
        ('Oliver', 'Hunziker'),
        ('Albert', 'Pazeller'),
        ('Jiri', 'Presler'),
        ('Christine', 'Eggert'),
        ('Urs', 'Vökt'),
        ('Luis', 'Muheim'),
        ('Geri', 'Kaufmann'),
        ('Marianne', 'Knecht'),
        ('Emanuel', 'Kuster'),
        ('Nathan', 'Pythoud'),
        ('Martina', 'Vögtli'),
        ('Wasja', 'Dollenmeier'),
        ('Julia', 'Siegrist'),
        ('Svatobor', 'Herot'),
        ('Corinne', 'Vez'),
        ('Ueli', 'Busin'),
        ('Esther', 'Bräm'),
        ('Brecht', 'Wasser'),
        ('Markus', 'Günter'),
        ('Markus', 'Rüttimann'),
        ('Marco', 'Pfranger'),
        ('Karin', 'Baumgartner'),
        ('Benjamin', 'Kuster'),
        ('Iwan', 'Vitins'),
        ('Bertram', 'Baumgarten')
) AS v(vorname, aname);