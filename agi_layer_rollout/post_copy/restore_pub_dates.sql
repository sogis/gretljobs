WITH 

themepub_ident AS (
	SELECT
		concat_ws(
			':',
			t.identifier,
			COALESCE(tp.class_suffix_override, 'VOID')
		) AS fullident,
		tp.id
	FROM
		simi.simitheme_theme_publication tp 
	JOIN
		simi.simitheme_theme t ON tp.theme_id = t.id 
),

helper_idents AS (
	SELECT 
		concat_ws(
			':',
			h.theme_identifier,
			COALESCE(h.tpub_class_suffix_override , 'VOID')
		) AS tp_fullident,
		concat_ws(':', h.subarea_coverage_ident, subarea_identifier) AS area_fullident,
		h.id
	FROM 
		simi.simitheme_published_sub_area_helper h
),

area_ident AS ( -- 
	SELECT 
		concat_ws(':', a.coverage_ident , a.identifier) AS fullident,
		a.id
	FROM 
		simi.simitheme_sub_area a
),

leftjoin AS (
	SELECT
		(tp.id IS NULL) AS tp_broken,
		h.tp_fullident,
		(a.id IS NULL) AS area_broken,
		h.area_fullident,
		h.id AS helper_id,
		tp.id AS tp_id,
		a.id AS area_id
	FROM
		helper_idents h
	LEFT JOIN 
		themepub_ident tp ON h.tp_fullident = tp.fullident
	LEFT JOIN 
		area_ident a ON h.area_fullident = a.fullident
)

--SELECT * FROM leftjoin; -- Zwecks finden, welche fk-beziehung (a_id, tp_id) gebrochen ist.

INSERT INTO 
  simi.simitheme_published_sub_area(
    sub_area_id,
    theme_publication_id,
    published,
    prev_published,
    id,
    update_ts,
    updated_by,
    create_ts,
    created_by,
    "version"
  )
SELECT 
  COALESCE(l.area_id, '9207a87f-3694-4622-baf4-b084c7256a28'::uuid) AS sub_area_id, --COALESCE notwendig, da sub_area_id im moment noch NULL sein kann.
  l.tp_id AS theme_publication_id,  
  h.published,
  h.prev_published,
  h.id,
  h.update_ts,
  h.updated_by,
  h.create_ts,
  h.created_by,
  h."version"
FROM
  simi.simitheme_published_sub_area_helper h
JOIN
  leftjoin l ON h.id = l.helper_id 
-- WHERE l.a_id IS NOT NULL AND l.tp_id IS NOT NULL -- Where aktivieren, um alle helper-eintraege mit intakten links zurückzuschreiben
;