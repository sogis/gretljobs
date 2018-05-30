SELECT DISTINCT 
    setsrid(bewirtschafter.wkb_geometry, 2056) AS geometrie,
    bewirtschafter.name, 
    bewirtschafter.vorname, 
    bewirtschafter.bauherr, 
    CASE
        WHEN bewirtschafter.nachfuehrung IS NOT NULL 
            THEN adresse.str_name
        ELSE bewirtschafter.strasse
    END AS strasse, 
    CASE
        WHEN bewirtschafter.nachfuehrung IS NOT NULL 
            THEN adresse.hausnummer
        ELSE bewirtschafter.nr
    END AS nr, 
    CASE
        WHEN bewirtschafter.nachfuehrung IS NOT NULL 
            THEN adresse.plz4::integer
        ELSE bewirtschafter.plz
    END AS plz, 
    CASE
        WHEN bewirtschafter.nachfuehrung IS NOT NULL 
            THEN adresse.gem_name
        ELSE bewirtschafter.gemeinde
    END AS gemeinde, 
    bewirtschafter.ogc_fid AS t_id, 
    bewirtschafter.nachfuehrung, 
    CASE
        WHEN sgv.bewirtschafter_id IS NOT NULL 
            THEN '1'::text
        ELSE '0'::text
    END AS sgv, 
    CASE
        WHEN alw.bewirtschafter_id IS NOT NULL 
            THEN '1'::text
        ELSE '0'::text
    END AS alw, 
    CASE
        WHEN afu.bewirtschafter_id IS NOT NULL 
            THEN '1'::text
        ELSE '0'::text
    END AS afu, 
    CASE
        WHEN lmk.bewirtschafter_id IS NOT NULL 
            THEN '1'::text
        ELSE '0'::text
    END AS lmk
FROM 
    wasserversorgung.bewirtschafter bewirtschafter
    LEFT JOIN wasserversorgung.sgv sgv 
        ON bewirtschafter.ogc_fid = sgv.bewirtschafter_id
    LEFT JOIN wasserversorgung.alw alw
        ON bewirtschafter.ogc_fid = alw.bewirtschafter_id
    LEFT JOIN wasserversorgung.afu afu 
        ON bewirtschafter.ogc_fid = afu.bewirtschafter_id
    LEFT JOIN wasserversorgung.lmk lmk 
        ON bewirtschafter.ogc_fid = lmk.bewirtschafter_id
    LEFT JOIN adressen.adressen adresse 
        ON bewirtschafter.nachfuehrung = adresse.gwr_egid
;