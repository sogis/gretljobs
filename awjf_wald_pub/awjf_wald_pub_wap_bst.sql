SELECT 
    ogc_fid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
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
    CASE 
        WHEN fid_eig=1000
            THEN '1000 - Bundeswald' 
        WHEN fid_eig=2000
            THEN '2000 - Staatswald'
        WHEN fid_eig=3100
            THEN '3100 - Bürgergemeinde'
        WHEN fid_eig=3200
            THEN '3200 - Einwohnergemeinde'
        WHEN fid_eig=3300
            THEN '3300 - Einheitsgemeinde'
        WHEN fid_eig=4000
            THEN '4000 - Öffentlich (gemischt)'
        WHEN fid_eig=5000
            THEN '5000 - Gemischt öffentlich-privat'
        WHEN fid_eig=6000
            THEN '6000 - Privat'
        WHEN fid_eig=7000
            THEN '7000 - Privat (gemischt)'
    END AS fid_eig,
    fid_prod,
    CASE 
        WHEN wpnr=501 
            THEN '501 - Wirtschaftswald' 
        WHEN wpnr=502 
            THEN '502 - Schutzwald' 
        WHEN wpnr=503 
            THEN '503 - Erholungswald' 
        WHEN wpnr=504 
            THEN '504 - Natur und Landschaft'
        WHEN wpnr=505 
            THEN '505 - Schutzwald / Natur und Landschaft' 
        WHEN wpnr=509 
            THEN '509 - Nicht Wald'
    END AS wpnr,
    CASE 
        WHEN wptyp=1 
            THEN '1 - Mit Wald bestockt' 
        WHEN wptyp=2
            THEN '2 - Niederhaltezone'
        WHEN wptyp=3 
            THEN '3 - Waldstrasse'
        WHEN wptyp=4
            THEN '4 - Maschinenweg'
        WHEN wptyp=5
            THEN '5 - Bauten und Anlagen'
        WHEN wptyp=6
            THEN '6 - Rodungsfläche (temporär)'
        WHEN wptyp=7
            THEN '7 - Gewässer'
        WHEN wptyp=8
            THEN '8 - Abbaustelle'
        WHEN wptyp=9
            THEN '9 - Nicht Wald'
    END AS wptyp,
    betriebsteil,
    fid_abt,
    bstnr,
    bsttyp,
    wpinfo,
    bemerkung,
    round(flae_gis::numeric,0) AS flae_gis,
    round(korr_flae::numeric,0) AS korr_flae,
    round(wpflae::numeric,0) AS wpflae,
    zeitstand,
    beschrift,
    x_beschr,
    y_beschr,
    objnummer
FROM 
    awjf.wap_bst
WHERE 
    archive = 0
;
