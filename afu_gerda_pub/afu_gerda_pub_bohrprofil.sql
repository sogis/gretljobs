WITH 
    limitierung_67 AS (
        SELECT 
            isbo_prof_profil.profkey,
            string_agg(code.strcode ,', ' ORDER BY code.strcode ASC) AS code
        FROM 
            isbo_prof_profil
            LEFT JOIN isbo_prof_nutzungsbesch
                ON isbo_prof_nutzungsbesch.profkey = isbo_prof_profil.profkey
            LEFT JOIN isbo_prof_codenumzeichen AS code_eigenschaft
                ON code_eigenschaft.numcode::NUMERIC = isbo_prof_nutzungsbesch.feld
            LEFT JOIN isbo_prof_codenumzeichen AS code
                ON isbo_prof_nutzungsbesch.wert = code.numcode::NUMERIC
        WHERE 
            code_eigenschaft.bezeichnung LIKE 'Limitierende Eigenschaft%'
        
        GROUP BY
            isbo_prof_profil.profkey
    ), 
    untertyp_18 AS (
        SELECT 
            profil.profkey,  
            string_agg(code.strcode, ', ') AS f18, 
            string_agg(code.bezeichnung, ', ') AS untertypen
        FROM 
            isbo_prof_profil profil, 
            isbo_prof_untertyp tbluntertyp, 
            isbo_prof_codenumzeichen code
        WHERE 
            tbluntertyp.profkey = profil.profkey 
            AND 
            tbluntertyp.untertyp = code.numcode::NUMERIC
        GROUP BY
            profil.profkey
    ),
    topografie_bild AS (
        SELECT
            bytea AS daten,
            profkey
        FROM
            isbo_prof_attach
        WHERE
            typ = 1
    ),
    profilskizze_bild AS (
        SELECT
            bytea AS daten,
            profkey
        FROM
            isbo_prof_attach
        WHERE
            typ = 2
    ),
    nutzungsbeschraenkung_68 AS (
        SELECT 
            isbo_prof_profil.profkey,
            string_agg(isbo_prof_codenumzeichen.strcode, ', ' ORDER BY isbo_prof_codenumzeichen.strcode ASC) AS code
        FROM 
            isbo_prof_profil
            LEFT JOIN isbo_prof_nutzungsbesch
                ON isbo_prof_nutzungsbesch.profkey = isbo_prof_profil.profkey
            LEFT JOIN isbo_prof_codenumzeichen
                ON isbo_prof_codenumzeichen.numcode::NUMERIC = isbo_prof_nutzungsbesch.wert
            LEFT JOIN isbo_prof_codenumzeichen AS code_eigenschaft
                ON code_eigenschaft.numcode::NUMERIC = isbo_prof_nutzungsbesch.feld
        WHERE
            code_eigenschaft.bezeichnung = 'Nutzungsbeschränkung'
        GROUP BY
            isbo_prof_profil.profkey
    ), 
    melioration_festgestellt_69 AS (
        SELECT 
            isbo_prof_profil.profkey,
            string_agg(isbo_prof_codenumzeichen.strcode, ', ' ORDER BY isbo_prof_codenumzeichen.strcode ASC) AS code
        FROM 
            isbo_prof_profil
            LEFT JOIN isbo_prof_nutzungsbesch
                ON isbo_prof_nutzungsbesch.profkey = isbo_prof_profil.profkey
            LEFT JOIN isbo_prof_codenumzeichen
                ON isbo_prof_codenumzeichen.numcode::NUMERIC = isbo_prof_nutzungsbesch.wert
            LEFT JOIN isbo_prof_codenumzeichen AS code_eigenschaft
                ON code_eigenschaft.numcode::NUMERIC = isbo_prof_nutzungsbesch.feld
        WHERE
            code_eigenschaft.bezeichnung = 'Melioration festgestellt%'
        GROUP BY
            isbo_prof_profil.profkey
    ),
    melioration_empfohlen_70 AS (
        SELECT 
            isbo_prof_profil.profkey,
            string_agg(isbo_prof_codenumzeichen.strcode, ', ' ORDER BY isbo_prof_codenumzeichen.strcode ASC) AS code
        FROM 
            isbo_prof_profil
            LEFT JOIN isbo_prof_nutzungsbesch
                ON isbo_prof_nutzungsbesch.profkey = isbo_prof_profil.profkey
            LEFT JOIN isbo_prof_codenumzeichen
                ON isbo_prof_codenumzeichen.numcode::NUMERIC = isbo_prof_nutzungsbesch.wert
            LEFT JOIN isbo_prof_codenumzeichen AS code_eigenschaft
                ON code_eigenschaft.numcode::NUMERIC = isbo_prof_nutzungsbesch.feld
        WHERE
            code_eigenschaft.bezeichnung =  'Melioration empfohlen%'
        GROUP BY
            isbo_prof_profil.profkey
    ),
    foto AS (
        SELECT 
            isbo_prof_profil.profkey,
            row_num,
            daten
        FROM 
            isbo_prof_profil
            LEFT JOIN (
                SELECT
                    name, 
                    bytea AS daten,
                    typ,
                    profkey,
                    row_number() OVER (PARTITION BY profkey ORDER BY name asc) row_num
                FROM
                    isbo_prof_attach
                WHERE 
                    typ = 3) AS bild
                ON bild.profkey = isbo_prof_profil.profkey
        WHERE 
            row_num = 1 
            OR 
            row_num IS NULL 
)
    
    

SELECT DISTINCT
    isbo_prof_profil.profkey,
    isbo_prof_profil.gdenummer AS gemeindenummer_alt,
    isbo_prof_profil.profilnummer,
    hoheitsgrenzen_gemeindegrenze.gemeindename,
    hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer,
    kva_av_flurn.name AS flurname,
    sogis_lk25.blatt_nr,
    isbo_prof_profil.datschluessel AS f1,
    code.strcode AS f3,
    code_pedologe.strcode AS f4,
    isbo_prof_profil.datum AS f5,
    isbo_prof_profil.xkoordinate AS f13,
    isbo_prof_profil.ykoordinate AS f14,
    isbo_prof_profil.erstaufn_bemerkung,
    isbo_prof_profil.profilbez_prov,
    round(elevation(ST_X(isbo_prof_profil.wkb_geometry), ST_Y(isbo_prof_profil.wkb_geometry))) AS f58,
    code_exposition.strcode AS f59,
    code_exposition.bezeichnung AS exposition,
    code_klimaeignzone.bezeichnung AS f60,
    code_vegetation.strcode AS f61,
    code_ausgangsmaterial.strcode AS f62,
    code_ausgangsmaterial.bezeichnung AS ausgangsmaterial,
    code_ausgangsmaterial_2.strcode AS code_ausgangsmaterial_2,
    code_lanschelement.strcode AS f64,
    code_kleinrelief.strcode AS f65,
    isbo_prof_profil.bodenprofilwert AS f74,
    code_nutzungseignung.strcode AS f75,
    code_eignungsklasse.strcode AS f76,
    code_krumenzustand.strcode AS f66,
    code_duengerfest.strcode AS f71,
    code_duengerfluesssig.strcode AS f72,
    code_bodentyp.strcode AS f16,
    code_bodentyp.bezeichnung AS bodentyp,
    code_skelettoberbod.strcode AS f19,
    code_skelettoberbod.bezeichnung AS skelettoberbod,
    code_skelettunterbod.strcode AS f20,
    skelettunterbod,
    code_feinerdeoberbod.strcode AS f21,
    code_feinerdeoberbod.bezeichnung AS feinerdeoberbod,
    code_feinerdeunterbod.strcode AS f22,
    code_feinerdeunterbod.bezeichnung AS feinerdeunterbod,
    code_wasserhaushalt.strcode AS f23,
    code_wasserhaushalt.bezeichnung AS wasserhh,
    isbo_prof_profil.pngruendigkcm,
    code_pngruendigkeit.strcode AS f24,
    code_pngruendigkeit.bezeichnung AS pflanzengruendigk,
    isbo_prof_profil.neigung AS f25,
    code_gelaendeform.strcode AS f26,
    code_gelaendeform.bezeichnung AS gelaendefrm,
    isbo_prof_profil.bemerkung,
    code_humusform.strcode AS f100,
    code_prodfaehigkeitstufe.strcode AS f110,
    isbo_prof_profil.prodfaehigkeitpkt AS f111,
    isbo_prof_profil.wkb_geometry AS geometrie,
    ST_X(isbo_prof_profil.wkb_geometry) AS e,
    ST_Y(isbo_prof_profil.wkb_geometry) AS n,
    limitierung_67.code AS limitierung,
    untertyp_18.f18,
    untertyp_18.untertypen,
    topografie_bild.daten AS topografie,
    profilskizze_bild.daten AS profilskizze_bild,
    nutzungsbeschraenkung_68.code AS nutzungsbeschraenkung,
    melioration_festgestellt_69.code AS melioration_festgestellt,
    melioration_empfohlen_70.code AS melioration_empfohlen,
    foto.daten AS foto
FROM
    isbo_prof_profil
    LEFT JOIN isbo_prof_codenumzeichen AS code 
        ON isbo_prof_profil.profilart = code.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_pedologe
        ON code_pedologe.numcode = isbo_prof_profil.pedologe
    LEFT JOIN isbo_prof_codenumzeichen AS code_exposition 
        ON isbo_prof_profil.exposition = code_exposition.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_lanschelement 
        ON isbo_prof_profil.landschelement = code_lanschelement.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_vegetation 
        ON isbo_prof_profil.vegetation = code_vegetation.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_ausgangsmaterial 
        ON isbo_prof_profil.ausgangsmaterial = code_ausgangsmaterial.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_kleinrelief 
        ON isbo_prof_profil.kleinrelief = code_kleinrelief.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_eignungsklasse 
        ON isbo_prof_profil.eignungsklasse = code_eignungsklasse.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_krumenzustand 
        ON isbo_prof_profil.krumenzustand = code_krumenzustand.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_klimaeignzone 
        ON isbo_prof_profil.klimaeignzone = code_klimaeignzone.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_ausgangsmaterial_2 
        ON isbo_prof_profil.ausgangsmaterial_2 = code_ausgangsmaterial_2.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_nutzungseignung 
        ON isbo_prof_profil.nutzungseignung = code_nutzungseignung.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_duengerfest 
        ON isbo_prof_profil.duengerfest = code_duengerfest.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_duengerfluesssig 
        ON isbo_prof_profil.duengerfluessig = code_duengerfluesssig.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_bodentyp
        ON code_bodentyp.numcode = isbo_prof_profil.bodentyp
    LEFT JOIN isbo_prof_codenumzeichen AS code_skelettoberbod 
        ON isbo_prof_profil.skelettoberbod = code_skelettoberbod.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_skelettunterbod 
        ON isbo_prof_profil.skelettunterbod = code_skelettunterbod.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_feinerdeoberbod 
        ON isbo_prof_profil.feinerdeoberbod = code_feinerdeoberbod.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_feinerdeunterbod 
        ON isbo_prof_profil.feinerdeunterbod = code_feinerdeunterbod.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_wasserhaushalt 
        ON isbo_prof_profil.wasserhaushalt = code_wasserhaushalt.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_pngruendigkeit 
        ON isbo_prof_profil.pngruendigkeit = code_pngruendigkeit.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_gelaendeform 
        ON isbo_prof_profil.gelaendeform = code_gelaendeform.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_humusform 
        ON isbo_prof_profil.humusform = code_humusform.numcode
    LEFT JOIN isbo_prof_codenumzeichen AS code_prodfaehigkeitstufe 
        ON isbo_prof_profil.prodfaehigkeitstufe = code_prodfaehigkeitstufe.numcode
    LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
        ON ST_DWithin(isbo_prof_profil.wkb_geometry, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    LEFT JOIN kva_av_flurn
        ON ST_DWithin(isbo_prof_profil.wkb_geometry,kva_av_flurn.wkb_geometry, 0)
    LEFT JOIN sogis_lk25
        ON ST_DWithin(isbo_prof_profil.wkb_geometry,sogis_lk25.wkb_geometry, 0)
    LEFT JOIN limitierung_67
        ON limitierung_67.profkey = isbo_prof_profil.profkey
    LEFT JOIN untertyp_18
        ON untertyp_18.profkey = isbo_prof_profil.profkey
    LEFT JOIN topografie_bild
        ON topografie_bild.profkey = isbo_prof_profil.profkey
    LEFT JOIN profilskizze_bild
        ON profilskizze_bild.profkey = isbo_prof_profil.profkey
    LEFT JOIN nutzungsbeschraenkung_68
        ON nutzungsbeschraenkung_68.profkey = isbo_prof_profil.profkey
    LEFT JOIN melioration_festgestellt_69
        ON melioration_festgestellt_69.profkey = isbo_prof_profil.profkey
    LEFT JOIN melioration_empfohlen_70
        ON melioration_empfohlen_70.profkey = isbo_prof_profil.profkey
    LEFT JOIN foto
        ON foto.profkey = isbo_prof_profil.profkey