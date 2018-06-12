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
    gb_flaeche,
    we_text,
    fid_eigcod,
    CASE 
        WHEN fid_eig=1000
            THEN 'Bundeswald' 
        WHEN fid_eig=2000
            THEN 'Staatswald'
        WHEN fid_eig=3100
            THEN 'Bürgergemeinde'
        WHEN fid_eig=3200
            THEN 'Einwohnergemeinde'
        WHEN fid_eig=3300
            THEN 'Einheitsgemeinde'
        WHEN fid_eig=4000
            THEN 'Öffentlich (gemischt)'
        WHEN fid_eig=5000
            THEN 'Gemischt öffentlich-privat'
        WHEN fid_eig=6000
            THEN 'Privat'
        WHEN fid_eig=7000
            THEN 'Privat (gemischt)'
    END AS fid_eig,
    fid_prod,
    CASE 
        WHEN wpnr=501 
            THEN 'Wirtschaftswald' 
        WHEN wpnr=502 
            THEN 'Schutzwald' 
        WHEN wpnr=503 
            THEN 'Erholungswald' 
        WHEN wpnr=504 
            THEN 'Natur und Landschaft'
        WHEN wpnr=505 
            THEN 'Schutzwald / Natur und Landschaft' 
        WHEN wpnr=509 
            THEN 'Nicht Wald'
    END AS wpnr,
    CASE 
        WHEN wptyp=1 
            THEN 'Mit Wald bestockt' 
        WHEN wptyp=2
            THEN 'Niederhaltezone'
        WHEN wptyp=3 
            THEN 'Waldstrasse'
        WHEN wptyp=4
            THEN 'Maschinenweg'
        WHEN wptyp=5
            THEN 'Bauten und Anlagen'
        WHEN wptyp=6
            THEN 'Rodungsfläche (temporär)'
        WHEN wptyp=7
            THEN 'Gewässer'
        WHEN wptyp=8
            THEN 'Abbaustelle'
        WHEN wptyp=9
            THEN 'Nicht Wald'
    END AS wptyp,
    betriebsteil,
    fid_abt,
    bstnr,
    bsttyp,
    wpinfo,
    bemerkung,
    flae_gis,
    korr_flae,
    wpflae,
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
