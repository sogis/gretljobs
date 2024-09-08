WITH clipped_raster AS 
(
    SELECT 
    	ST_Union(ST_Clip(rast, ST_MakeEnvelope(2615194, 1256247, 2615897, 1256800, 2056))) as rast_subset
    FROM 
    	public.lidar_2023_dsm 
    WHERE 
    	ST_Intersects(rast, ST_MakeEnvelope(2615194, 1256247, 2615897, 1256800, 2056))
)
SELECT 
	ST_AsGDALRaster(rast_subset, 'GTiff')::bytea
FROM 
	clipped_raster;
;