DROP TABLE IF EXISTS public.verification
;

CREATE TABLE public.verification (
    source_t_id int4 NOT NULL,
    geometrie public.geometry(multipoint, 2056) NOT NULL,
    CONSTRAINT verification_pk PRIMARY KEY (source_t_id)
)
;
CREATE INDEX sidx_verification_geometrie ON public.verification USING gist (geometrie)
;

WITH 

small_center AS (
    SELECT 
        merge_big_id AS big_id,
        ST_PointOnSurface(geom) AS centerpoint
    FROM
        public.poly_cleanup 
    WHERE 
        merge_big_id IS NOT NULL 
)

,big_center_id AS (
    SELECT 
        merge_big_id
    FROM 
        public.poly_cleanup 
    GROUP BY
        merge_big_id
)

,big_center AS (
    SELECT 
        id AS big_id,
        ST_PointOnSurface(geom) AS centerpoint
    FROM
        public.poly_cleanup p
    JOIN
        big_center_id c ON p.id = c.merge_big_id
)

,big_centermarker AS (
    SELECT 
        big_id,        
        (ST_DumpPoints(
            ST_Buffer(
                centerpoint,
                0.25,
                1
            )        
        )).geom AS centerpoint 
    FROM 
        big_center
)

INSERT INTO public.verification(
   source_t_id,
   geometrie
)
SELECT
    big_id AS source_t_id,
    ST_COLLECT(centerpoint) AS geometrie
FROM (
    SELECT big_id, centerpoint FROM small_center
    UNION ALL 
    SELECT big_id, centerpoint FROM big_center
    UNION ALL 
    SELECT big_id, centerpoint FROM big_centermarker
) c
GROUP BY 
    big_id
;