DROP TABLE IF EXISTS public.verification
;

CREATE TABLE public.verification (
    source_t_id int4 NOT NULL,
    geometrie public.geometry(multipoint, 2056) NOT NULL,
    num_merged_smallpolys int4 NOT NULL,
    CONSTRAINT verification_pk PRIMARY KEY (source_t_id)
)
;
CREATE INDEX sidx_verification_geometrie ON public.verification USING gist (geometrie)
;

WITH 

-- Zentrumspunkt der verschmolzenen Polygone
small_center AS (
    SELECT 
        _root_id_ref as big_id,
        ST_PointOnSurface(geometrie) AS centerpoint
    FROM
        public.poly_cleanup 
    WHERE 
        _is_big IS FALSE AND _parent_id_ref IS NOT NULL
)

-- Zentrumspunkt der empfangenden Grosspolygone
,big_center AS (
    SELECT 
        id AS big_id,
        ST_PointOnSurface(_center_geom) AS centerpoint
    FROM
        public.poly_cleanup p
    WHERE
        _is_big IS TRUE AND _center_geom IS NOT NULL
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
   geometrie,
   num_merged_smallpolys
)
SELECT
    big_id AS source_t_id,
    ST_COLLECT(centerpoint) AS geometrie,
    count(*) - 5 AS num_merged_smallpolys
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