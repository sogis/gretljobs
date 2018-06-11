 WITH query AS ((((((((
                            SELECT 
                                tief.oid,
                                tief.wkb_geometry, 
                                tief.grid_code,
                                CASE
                                    WHEN grid_code = 8
                                        THEN 'geringe Festigkeit / höhere Rutschneigung'
                                    WHEN grid_code = 9
                                        THEN 'mässige Festigkeit / geringere Rutschneigung'
                                END AS  grid_code_text
                            FROM 
                                aww_natgef_rutsch_tief AS tief
                            WHERE 
                                tief.archive = 0
                                
                            UNION 
                            
                            SELECT 
                                untief.oid,
                                untief.wkb_geometry, 
                                untief.grid_code,
                                CASE
                                    WHEN grid_code = 33
                                        THEN 'Schutzgüter betroffen'
                            END AS grid_code_text
                            FROM 
                                aww_natgef_rutsch_untief AS untief
                            WHERE 
                                untief.archive = 0)
                                
                        UNION 
                        
                        SELECT 
                            bekannte_rutschung.oid, 
                            bekannte_rutschung.wkb_geometry, 
                            bekannte_rutschung.grid_code,
                            CASE
                                WHEN grid_code = 10
                                    THEN 'aus diversen Quellen bekannte aktive oder nichtaktive Rutschgebiete'
                        END AS grid_code_text
                        FROM 
                            aww_natgef_rutsch_bek AS bekannte_rutschung
                        WHERE 
                            bekannte_rutschung.archive = 0)
                            
                    UNION 
                    
                    SELECT 
                        talboden.oid, 
                        talboden.wkb_geometry, 
                        talboden.grid_code,
                        CASE
                            WHEN grid_code = 5
                                THEN 'sehr flache Talböden ausserhalb der modellierten Überflutungsbereiche: Überflutung kann nicht ausgeschlossen werden'
                        END AS grid_code_text
                    FROM 
                        aww_natgef_talbod AS talboden
                    WHERE 
                        talboden.archive = 0)
                        
                UNION 
                
                SELECT 
                    uebersarung.oid, 
                    uebersarung.wkb_geometry,
                    uebersarung.grid_code,
                    CASE
                        WHEN grid_code = 3
                            THEN 'Übersarung /Schwemmkegel'
                    END AS grid_code_text
                FROM 
                    aww_natgef_ubsar AS uebersarung
                WHERE 
                    uebersarung.archive = 0)
                    
            UNION 
            
            SELECT 
                murgang.oid, 
                murgang.wkb_geometry, 
                murgang.grid_code,
                CASE
                    WHEN grid_code = 1
                        THEN 'Übrige Murganggebiete'
                    WHEN grid_code = 2
                        THEN 'Schutzgüter betroffen'
                END AS grid_code_text
            FROM 
                aww_natgef_murgang AS murgang
            WHERE 
                murgang.archive = 0)
                
        UNION 
        
        SELECT 
            ueberflutung.oid, 
            ueberflutung.wkb_geometry, 
            ueberflutung.grid_code,
            CASE
                WHEN grid_code = 4
                    THEN 'Überflutungsgebiete'
            END AS grid_code_text
        FROM 
            aww_natgef_ubflut AS ueberflutung
        WHERE ueberflutung.archive = 0)
        
    UNION 
    
    SELECT 
        block.oid, 
        block.wkb_geometry, 
        99 AS grid_code,
        'bekannte Ereignisse ausserhalb des modellierten Steinschlaggebietes' AS grid_code_text
    FROM 
        aww_natgef_block AS block
    WHERE 
        block.archive = 0)
UNION 

SELECT 
    stein.oid, 
    stein.wkb_geometry, 
    stein.grid_code,
    CASE
        WHEN grid_code = 6
            THEN 'übrige Steinschlaggebiete'
        WHEN grid_code = 7
            THEN 'Schutzgüter betroffen'
    END AS grid_code_text
FROM 
    aww_natgef_steins AS stein
WHERE 
    stein.archive = 0)


SELECT 
    oid AS t_id,
    ST_Multi(wkb_geometry) AS geometrie,
    grid_code,
    grid_code_text
FROM
    query
;