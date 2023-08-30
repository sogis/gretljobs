WITH bodenfaktorg_lookup AS (
    SELECT
        *
    FROM (
        VALUES
            -- Werte und deren Reihenfolge entsprechen dem Datenmodell
            -- DM01AVSO24LV95. Im Sinne der Vollständigkeit sind alle
            -- Bodenbedeckungsarten übernommen worden, auch die, die im Kanton
            -- keine Verwendung finden.
            ( 1 , 'Gebaeude', 0.1 ),        
            ( 2 , 'befestigt.Strasse_Weg', 0 ),        
            ( 3 , 'befestigt.Trottoir', 0 ),        
            ( 4 , 'befestigt.Verkehrsinsel', 0.1 ),        
            ( 5 , 'befestigt.Bahn', 1 ),        
            ( 6 , 'befestigt.Flugplatz', 0 ),        
            ( 7 , 'befestigt.Wasserbecken', 0 ),        
            ( 8 , 'befestigt.uebrige_befestigte.Sportanlage_befestigt', 0 ),             -- Mehranforderung
            ( 9 , 'befestigt.uebrige_befestigte.Lagerplatz', 0 ),                        -- Mehranforderung
            ( 10, 'befestigt.uebrige_befestigte.Boeschungsbauwerk', 0 ),                 -- Mehranforderung
            ( 11, 'befestigt.uebrige_befestigte.Gebaeudeerschliessung', 0 ),             -- Mehranforderung
            ( 12, 'befestigt.uebrige_befestigte.Parkplatz', 0 ),                         -- Mehranforderung
            ( 13, 'befestigt.uebrige_befestigte.uebrige_befestigte', 0 ),
            ( 14, 'humusiert.Acker_Wiese_Weide.Acker_Wiese', 1 ),                        -- Mehranforderung
            ( 15, 'humusiert.Acker_Wiese_Weide.Weide', 1 ),                              -- Mehranforderung
            ( 16, 'humusiert.Intensivkultur.Reben', 1 ),        
            ( 17, 'humusiert.Intensivkultur.uebrige_Intensivkultur.Obstkultur', 1 ),     -- Mehranforderung
            ( 18, 'humusiert.Intensivkultur.uebrige_Intensivkultur.uebrige_Intensivkultur', 1 ),        
            ( 19, 'humusiert.Gartenanlage.Gartenanlage', 1 ),        
            ( 20, 'humusiert.Gartenanlage.Parkanlage_humusiert', 1 ),                    -- Mehranforderung
            ( 21, 'humusiert.Gartenanlage.Sportanlage_humusiert', 1 ),                   -- Mehranforderung
            ( 22, 'humusiert.Gartenanlage.Friedhof', 1 ),                                -- Mehranforderung
            ( 23, 'humusiert.Hoch_Flachmoor', 1 ),        
            ( 24, 'humusiert.uebrige_humusierte', 1 ),        
            ( 25, 'Gewaesser.stehendes', 0 ),        
            ( 26, 'Gewaesser.fliessendes', 0 ),        
            ( 27, 'Gewaesser.Schilfguertel', 1 ),        
            ( 28, 'bestockt.geschlossener_Wald', 1 ),        
            ( 29, 'bestockt.Wytweide.Wytweide_dicht', 1 ),                               -- keine Vorkommnisse
            ( 30, 'bestockt.Wytweide.Wytweide_offen', 1 ),                               -- keine Vorkommnisse
            ( 31, 'bestockt.uebrige_bestockte.Parkanlage_bestockt', 1 ),                 -- Mehranforderung
            ( 32, 'bestockt.uebrige_bestockte.Hecke', 1 ),                               -- Mehranforderung
            ( 33, 'bestockt.uebrige_bestockte.uebrige_bestockte', 1 ),        
            ( 34, 'vegetationslos.Fels', 0 ),        
            ( 35, 'vegetationslos.Gletscher_Firn', 0.3 ),                                -- keine Vorkommnisse
            ( 36, 'vegetationslos.Geroell_Sand', 0.3 ),        
            ( 37, 'vegetationslos.Abbau_Deponie.Steinbruch', 0.3 ),                      -- Mehranforderung
            ( 38, 'vegetationslos.Abbau_Deponie.Kiesgrube', 0.3 ),                       -- Mehranforderung
            ( 39, 'vegetationslos.Abbau_Deponie.Deponie', 0.3 ),
            ( 40, 'vegetationslos.Abbau_Deponie.uebriger_Abbau', 0.3 ),        
            ( 41, 'vegetationslos.uebrige_vegetationslose', 0.3 )        
    )
    AS t (id, code, val)
)
INSERT INTO avt_bodenabsorption.bodenfaktor (t_basket, t_datasetname, bodenfaktorg, bfsnr, geometrie)
(
    SELECT
        abb.t_id as t_basket,
        abd.datasetname as t_datasetname,
        bfl.val AS bodenfaktorg,
        abd.datasetname::integer as bfsnr,
        bb.geometrie
    FROM
        agi_dm01avso24.bodenbedeckung_boflaeche bb
    LEFT JOIN bodenfaktorg_lookup bfl
        ON bb.art = bfl.code
    FULL OUTER JOIN avt_bodenabsorption.t_ili2db_dataset abd
        ON abd.datasetname = bb.t_datasetname
    FULL OUTER JOIN avt_bodenabsorption.t_ili2db_basket abb
        ON abb.dataset = abd.t_id
);

