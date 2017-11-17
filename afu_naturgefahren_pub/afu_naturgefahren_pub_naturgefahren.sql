 WITH query AS ((((((((
                            SELECT 
                                tief.oid,
                                tief.wkb_geometry, 
                                tief.grid_code
                            FROM 
                                aww_natgef_rutsch_tief AS tief
                            WHERE 
                                tief.archive = 0
                                
                            UNION 
                            
                            SELECT 
                                untief.oid,
                                untief.wkb_geometry, 
                                untief.grid_code
                            FROM 
                                aww_natgef_rutsch_untief AS untief
                            WHERE 
                                untief.archive = 0)
                                
                        UNION 
                        
                        SELECT 
                            bekannte_rutschung.oid, 
                            bekannte_rutschung.wkb_geometry, 
                            bekannte_rutschung.grid_code
                        FROM 
                            aww_natgef_rutsch_bek AS bekannte_rutschung
                        WHERE 
                            bekannte_rutschung.archive = 0)
                            
                    UNION 
                    
                    SELECT 
                        talboden.oid, 
                        talboden.wkb_geometry, 
                        talboden.grid_code
                    FROM 
                        aww_natgef_talbod AS talboden
                    WHERE 
                        talboden.archive = 0)
                        
                UNION 
                
                SELECT 
                    uebersarung.oid, 
                    uebersarung.wkb_geometry,
                    uebersarung.grid_code
                FROM 
                    aww_natgef_ubsar AS uebersarung
                WHERE 
                    uebersarung.archive = 0)
                    
            UNION 
            
            SELECT 
                murgang.oid, 
                murgang.wkb_geometry, 
                murgang.grid_code
            FROM 
                aww_natgef_murgang AS murgang
            WHERE 
                murgang.archive = 0)
                
        UNION 
        
        SELECT 
            ueberflutung.oid, 
            ueberflutung.wkb_geometry, 
            ueberflutung.grid_code
        FROM 
            aww_natgef_ubflut AS ueberflutung
        WHERE ueberflutung.archive = 0)
        
    UNION 
    
    SELECT 
        block.oid, 
        block.wkb_geometry, 
        99 AS grid_code
    FROM 
        aww_natgef_block AS block
    WHERE 
        block.archive = 0)
UNION 

SELECT 
    stein.oid, 
    stein.wkb_geometry, 
    stein.grid_code
FROM 
    aww_natgef_steins AS stein
WHERE 
    stein.archive = 0)


SELECT 
	oid AS t_id,
	ST_Multi(wkb_geometry) AS geometrie,
	grid_code
FROM
	query
;