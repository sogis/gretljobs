delete from afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung
;

with 
basket as (
     select 
         t_id,
         attachmentkey 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
), 

-- zuerst müssen Überlappungen der Teilprozesse "spontane Rutschung" und "Hangmuren" miteinander verschnitten werden. 
-- Grund: Beide haben den Charakterisierungs-Buchstaben H. Es darf in einer Fläche aber kein H1 und H2 (als Beispiel) geben. 
-- Deshalb werden die Polygone gemäss ihrer Charakterisierung (= Priorisierung) miteinander verschnitten. 
 
teilprozesse_spont_rutsch_und_hangmuren as (
    select 
	    gefahrenstufe,
	    charakterisierung, 
	    (ST_Dump(geometrie)).geom as geometrie
	from 
	    afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_spontane_rutschung 
	where 
	    datenherkunft = 'Neudaten'
    union all 
    select 
	    gefahrenstufe,
	    charakterisierung, 
	    (ST_Dump(geometrie)).geom as geometrie
	from 
	    afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_hangmure 
	where 
	    datenherkunft = 'Neudaten'
),

-- Der erste Verschnitt erfolgt gemäss den Gefahrenstufen. Dies ist wichtig, weil bei diesen Prozessen ein H2 "mittel" 
-- und ein H4 "gering" sein kann (geteilte Kästchen).

teilprozesse_spont_rutsch_und_hangmuren_prio as (
    SELECT 
	    gefahrenstufe, 
		charakterisierung, 
		geometrie,
		CASE 
		    WHEN gefahrenstufe = 'restgefaehrdung' THEN 0 
		    WHEN gefahrenstufe = 'gering' THEN 1 
		    WHEN gefahrenstufe = 'mittel' THEN 2 
		    WHEN gefahrenstufe = 'erheblich' THEN 3
		END as prio  
	FROM 
        teilprozesse_spont_rutsch_und_hangmuren
),

teilprozesse_spont_rutsch_und_hangmuren_prio_clip as (
    SELECT 
	    a.gefahrenstufe, 
		a.charakterisierung, 
		ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
    FROM  
        teilprozesse_spont_rutsch_und_hangmuren_prio AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozesse_spont_rutsch_und_hangmuren_prio AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio < b.prio              
    ) AS blade		
),

-- Dann werden die Gebiete noch gemäss ihrer Charakteristik verschnitten, damit sichergestellt ist, dass wirklich nur noch 
-- eine H - Fläche übrig ist (bei anderen Hauptprozessen ist dies nicht nötig, weil unterschiedliche Buchstaben)

teilprozesse_spont_rutsch_und_hangmuren_2_prio as (
    SELECT 
	    gefahrenstufe, 
		charakterisierung, 
		geometrie,
		substring(charakterisierung from 2 for 1) as prio 
	FROM 
        teilprozesse_spont_rutsch_und_hangmuren_prio_clip
),

teilprozesse_spont_rutsch_und_hangmuren_2_prio_clip as (
    SELECT 
	    a.gefahrenstufe, 
		a.charakterisierung, 
		ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
    FROM  
        teilprozesse_spont_rutsch_und_hangmuren_2_prio AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozesse_spont_rutsch_und_hangmuren_2_prio AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio < b.prio              
    ) AS blade		
),

hauptprozess_rutschung as ( 
    SELECT
        gefahrenstufe, 
	    charakterisierung, 
	    (st_dump(geometrie)).geom as geometrie	
	FROM 
	    afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_permanente_rutschung
	where 
	    datenherkunft = 'Neudaten'
    union all 
    select 
	    gefahrenstufe,
	    charakterisierung, 
	    (ST_Dump(geometrie)).geom as geometrie
	from 
	    teilprozesse_spont_rutsch_und_hangmuren_2_prio_clip
),

hauptprozess_rutschung_clean as (
    SELECT 
	    gefahrenstufe, 
		charakterisierung, 
		geometrie 
	FROM 
	    hauptprozess_rutschung 
	WHERE 
        st_area(geometrie) > 0.001
),

hauptprozess_rutschung_clean_prio as (
    SELECT 
	    gefahrenstufe, 
		charakterisierung, 
		geometrie,
		CASE 
		    WHEN gefahrenstufe = 'restgefaehrdung' THEN 0 
		    WHEN gefahrenstufe = 'gering' THEN 1 
		    WHEN gefahrenstufe = 'mittel' THEN 2 
		    WHEN gefahrenstufe = 'erheblich' THEN 3
		END as prio 
	FROM 
        hauptprozess_rutschung_clean
),

hauptprozess_rutschung_clean_prio_clip as (
    SELECT 
	    a.gefahrenstufe, 
		a.charakterisierung, 
		ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie
    FROM  
        hauptprozess_rutschung_clean_prio AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            hauptprozess_rutschung_clean_prio AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio < b.prio              
    ) AS blade		
),

hauptprozess_rutschung_boundary as (
  select 
    st_union(st_boundary(geometrie)) as geometrie
  from
    hauptprozess_rutschung_clean_prio_clip
),

hauptprozess_rutschung_split_poly AS (
  SELECT 
    (st_dump(st_polygonize(geometrie))).geom AS geometrie
  FROM
    hauptprozess_rutschung_boundary
),

hauptprozess_rutschung_split_poly_points AS (
  SELECT 
    ROW_NUMBER() OVER() AS id,
    geometrie AS poly,
    st_pointonsurface(geometrie) AS point
  FROM
    hauptprozess_rutschung_split_poly
),
	
hauptprozess_rutschung_point_on_polygons as (
    SELECT 
        s.id,
        p.gefahrenstufe,
        string_agg(p.charakterisierung,', ') AS charakterisierung
    FROM
        hauptprozess_rutschung_split_poly_points s
    JOIN
        hauptprozess_rutschung_clean_prio_clip p ON st_within(s.point, p.geometrie)
    GROUP BY 
        s.id,
        p.gefahrenstufe
),

hauptprozess_rutschung_charakterisierung_agg as (
    select 
        polygone.gefahrenstufe,
        polygone.charakterisierung,
	    point.poly as geometrie
    FROM 
	    hauptprozess_rutschung_split_poly_points point 
    LEFT JOIN 
	    hauptprozess_rutschung_point_on_polygons polygone 
        ON 
	    polygone.id = point.id
),

-- Flächen mit gleicher Gefahrenstufe und gleicher Charakterisierung können zusammengefasst werden
hauptprozess_rutschung_union as (
    select 
        gefahrenstufe,
        charakterisierung,
        st_union(geometrie) as geometrie
    from 
        hauptprozess_rutschung_charakterisierung_agg
    group by 
        gefahrenstufe,
        charakterisierung 
)

--Die Flächen müssen wieder getrennt werden.
,hauptprozess_rutschung_dump as (
    select 
        gefahrenstufe,
        charakterisierung,
        (st_dump(geometrie)).geom as geometrie
    from 
        hauptprozess_rutschung_union
)

INSERT INTO afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung (
    t_basket, 
    hauptprozess, 
    gefahrenstufe, 
    charakterisierung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

select 
    basket.t_id as t_basket,
    'rutschung' as hauptprozess,
    gefahrenstufe,
    charakterisierung,
    st_multi(geometrie) as geometrie,
    'Neudaten' as datenherkunft, 
    basket.attachmentkey as auftrag_neudaten   
from 
    basket,
    hauptprozess_rutschung_dump
WHERE 
    st_area(geometrie) > 0.001 
    and 
    charakterisierung is not null 
;




