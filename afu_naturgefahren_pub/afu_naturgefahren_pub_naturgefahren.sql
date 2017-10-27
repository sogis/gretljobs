 WITH query AS (   (   (   (   (   (   (   (
                            SELECT 
                                t.oid,
                                t.wkb_geometry, 
                                t.grid_code
                            FROM 
                                aww_natgef_rutsch_tief t
                            WHERE 
                                t.archive = 0
                                
                            UNION 
                            
                            SELECT 
                                ut.oid,
                                ut.wkb_geometry, 
                                ut.grid_code
                            FROM 
                                aww_natgef_rutsch_untief ut
                            WHERE 
                                ut.archive = 0)
                                
                        UNION 
                        
                        SELECT 
                            b.oid, 
                            b.wkb_geometry, 
                            b.grid_code
                        FROM 
                            aww_natgef_rutsch_bek b
                        WHERE 
                            b.archive = 0)
                            
                    UNION 
                    
                    SELECT 
                        tb.oid, 
                        tb.wkb_geometry, 
                        tb.grid_code
                    FROM 
                        aww_natgef_talbod tb
                    WHERE 
                        tb.archive = 0)
                        
                UNION 
                
                SELECT 
                    u.oid, 
                    u.wkb_geometry,
                    u.grid_code
                FROM 
                    aww_natgef_ubsar u
                WHERE 
                    u.archive = 0)
                    
            UNION 
            
            SELECT 
                m.oid, 
                m.wkb_geometry, 
                m.grid_code
            FROM 
                aww_natgef_murgang m
            WHERE 
                m.archive = 0)
                
        UNION 
        
        SELECT 
            f.oid, 
            f.wkb_geometry, 
            f.grid_code
        FROM 
            aww_natgef_ubflut f
        WHERE f.archive = 0)
        
    UNION 
    
    SELECT 
        bl.oid, 
        bl.wkb_geometry, 
        99 AS grid_code
    FROM 
        aww_natgef_block bl
    WHERE 
        bl.archive = 0)
UNION 

SELECT 
    st.oid, 
    st.wkb_geometry, 
    st.grid_code
FROM 
    aww_natgef_steins st
WHERE 
    st.archive = 0)


SELECT 
	oid AS t_id,
	ST_Multi(wkb_geometry) AS geometrie,
	grid_code
FROM
	query;