DROP TABLE IF EXISTS public.gk_mocklayer;

CREATE TABLE public.gk_mocklayer (
    t_id int4 NOT NULL,
    geometrie public.geometry(multipolygon, 2056) NOT NULL,
    gefahrenstufe varchar(255) NOT NULL,
    CONSTRAINT gk_mocklayer_pk PRIMARY KEY (t_id)
);