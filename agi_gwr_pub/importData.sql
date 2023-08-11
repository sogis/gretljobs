SELECT
   EGID AS egid,
   GKODE AS easting,
   GKODN AS northing,
   GSTAT AS gebaeudestatus,
   GBAUP AS bauperiode,
   GENH1 AS energie_waermequelle_heizung
FROM 
    building
;