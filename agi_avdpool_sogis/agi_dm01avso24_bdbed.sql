SELECT
    boflaeche.geometrie AS wkb_geometry,
    CASE
        WHEN boflaeche.art = 'Gebaeude'
            THEN 0
        WHEN boflaeche.art = 'befestigt.Strasse_Weg'
            THEN 1
        WHEN boflaeche.art = 'befestigt.Trottoir'
            THEN 3
        WHEN boflaeche.art = 'befestigt.Verkehrsinsel'
            THEN 4
        WHEN boflaeche.art = 'befestigt.Bahn'
            THEN 5
        WHEN boflaeche.art = 'befestigt.Flugplatz'
            THEN 6
        WHEN boflaeche.art = 'befestigt.Wasserbecken'
            THEN 7
        WHEN boflaeche.art = 'befestigt.uebrige_befestigte.Sportanlage_befestigt'
            THEN 8
        WHEN boflaeche.art = 'befestigt.uebrige_befestigte.Lagerplatz'
            THEN 9
        WHEN boflaeche.art = 'befestigt.uebrige_befestigte.Boeschungsbauwerk'
            THEN 10
        WHEN boflaeche.art = 'befestigt.uebrige_befestigte.Gebaeudeerschliessung'
            THEN 11
        WHEN boflaeche.art = 'befestigt.uebrige_befestigte.Parkplatz'
            THEN 12
        WHEN boflaeche.art = 'befestigt.uebrige_befestigte.uebrige_befestigte'
            THEN 13
        WHEN boflaeche.art = 'humusiert.Acker_Wiese_Weide.Acker_Wiese'
            THEN 14
        WHEN boflaeche.art = 'humusiert.Acker_Wiese_Weide.Weide'
            THEN 15
        WHEN boflaeche.art = 'humusiert.Intensivkultur.Reben'
            THEN 16
        WHEN boflaeche.art = 'humusiert.Intensivkultur.uebrige_Intensivkultur.Obstkultur'
            THEN 17
        WHEN boflaeche.art = 'humusiert.Intensivkultur.uebrige_Intensivkultur.uebrige_Intensivkultur'
            THEN 18
        WHEN boflaeche.art = 'humusiert.Gartenanlage.Gartenanlage'
            THEN 19
        WHEN boflaeche.art = 'humusiert.Gartenanlage.Parkanlage_humusiert'
            THEN 20
        WHEN boflaeche.art = 'humusiert.Gartenanlage.Sportanlage_humusiert'
            THEN 21
        WHEN boflaeche.art = 'humusiert.Gartenanlage.Friedhof'
            THEN 22
        WHEN boflaeche.art = 'humusiert.Hoch_Flachmoor'
            THEN 23
        WHEN boflaeche.art = 'humusiert.uebrige_humusierte'
            THEN 24
        WHEN boflaeche.art = 'Gewaesser.stehendes'
            THEN 25
        WHEN boflaeche.art = 'Gewaesser.fliessendes'
            THEN 26
        WHEN boflaeche.art = 'Gewaesser.Schilfguertel'
            THEN 27
        WHEN boflaeche.art = 'bestockt.geschlossener_Wald'
            THEN 28
        WHEN boflaeche.art = 'bestockt.Wytweide.Wytweide_dicht'
            THEN 39
        WHEN boflaeche.art = 'bestockt.Wytweide.Wytweide_offen'
            THEN 40
        WHEN boflaeche.art = 'bestockt.uebrige_bestockte.Parkanlage_bestockt'
            THEN 29
        WHEN boflaeche.art = 'bestockt.uebrige_bestockte.Hecke'
            THEN 30
        WHEN boflaeche.art = 'bestockt.uebrige_bestockte.uebrige_bestockte'
            THEN 31
        WHEN boflaeche.art = 'vegetationslos.Fels'
            THEN 32
        WHEN boflaeche.art = 'vegetationslos.Gletscher_Firn'
            THEN 41
        WHEN boflaeche.art = 'vegetationslos.Geroell_Sand'
            THEN 33
        WHEN boflaeche.art = 'vegetationslos.Abbau_Deponie.Steinbruch'
            THEN 34
        WHEN boflaeche.art = 'vegetationslos.Abbau_Deponie.Kiesgrube'
            THEN 35
        WHEN boflaeche.art = 'vegetationslos.Abbau_Deponie.Deponie'
            THEN 36
        WHEN boflaeche.art = 'vegetationslos.Abbau_Deponie.uebriger_Abbau'
            THEN 37
        WHEN boflaeche.art = 'vegetationslos.uebrige_vegetationslose'
            THEN 38
    END AS art,
    CAST(boflaeche.t_datasetname AS INT) AS gem_bfs,
    aimport.importdate AS new_date,    
    CAST('9999-01-01' AS timestamp) AS archive_date,
    0 AS archive,
    0 AS los
FROM
    agi_dm01avso24.bodenbedeckung_boflaeche AS boflaeche
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON boflaeche.t_basket = basket.t_id
    LEFT JOIN 
    (
        SELECT
            max(importdate) AS importdate,
            dataset
        FROM
            agi_dm01avso24.t_ili2db_import
        GROUP BY
            dataset 
    ) AS  aimport
        ON basket.dataset = aimport.dataset
;
