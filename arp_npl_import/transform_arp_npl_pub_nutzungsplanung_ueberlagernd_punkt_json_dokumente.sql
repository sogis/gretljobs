-- Recursive CTE must start with 'WITH'
WITH RECURSIVE x(ursprung, hinweis, parents, last_ursprung, depth) AS 
(
  SELECT 
    ursprung, 
    hinweis, 
    ARRAY[ursprung] AS parents, 
    ursprung AS last_ursprung, 
    0 AS "depth" 
  FROM 
    arp_npl.rechtsvorschrften_hinweisweiteredokumente
  
  UNION ALL
  
  SELECT 
    x.ursprung, 
    x.hinweis, 
    parents||t1.hinweis, 
    t1.hinweis AS last_ursprung, 
    x."depth" + 1
  FROM 
    x 
    INNER JOIN arp_npl.rechtsvorschrften_hinweisweiteredokumente t1 
    ON (last_ursprung = t1.ursprung)
  WHERE 
    t1.hinweis IS NOT NULL
), 
doc_doc_references_all AS 
(
  SELECT 
    ursprung, 
    hinweis, 
    parents,
    depth
  FROM x 
  WHERE 
    depth = (SELECT max(sq."depth") FROM x sq WHERE sq.ursprung = x.ursprung)
),
-- Rekursion liefert alle Möglichkeiten, dh. zum Beispiel
-- auch [3,4]. Wir sind aber nur längster Variante einer 
-- Kasksade interessiert: [1,2,3,4,5].
doc_doc_references AS 
(
  SELECT 
    ursprung,
    a_parents AS dok_dok_referenzen
  FROM
  (
    SELECT DISTINCT ON (a_parents)
      a.ursprung,
      a.parents AS a_parents,
      b.parents AS b_parents
    FROM
      doc_doc_references_all AS a
      LEFT JOIN doc_doc_references_all AS b
      ON a.parents <@ b.parents AND a.parents != b.parents
  ) AS foo
  WHERE b_parents IS NULL
),
-- Alle Dokumente in JSON-Text codiert.
json_documents_all AS 
(
  SELECT
    t_id, 
    row_to_json(t)::text AS json_dokument -- Text-Repräsentation des JSON-Objektes. 
  FROM
  (
    SELECT
      *,
      ('https://geoweb.so.ch/zonenplaene/Zonenplaene_pdf/'||"textimweb")::text AS textimweb_absolut
    FROM
      arp_npl.rechtsvorschrften_dokument
  ) AS t
),
-- Alle Dokumente (die in HinweisWeitereDokumente vorkommen) 
-- als JSON-Objekte (resp. als Text-Repräsentation).
-- Muss noch genauer überlegt werden, wie genau mit JSON hantiert wird.
json_documents_doc_doc_reference AS 
(
  SELECT
    t_id, 
    json_dokument
  FROM
  -- Alle t_id der Dokumente, die in der HinweisWeitereDokumente-Tabelle vorhanden sind.
  -- UNION macht gleich das DISTINCT.
  (
    SELECT
      ursprung AS dokument_t_id
    FROM 
      arp_npl.rechtsvorschrften_hinweisweiteredokumente
    
    UNION 
    
    SELECT
      hinweis AS dokument_t_id
    FROM 
      arp_npl.rechtsvorschrften_hinweisweiteredokumente
  ) AS foo
  LEFT JOIN json_documents_all AS bar
  ON foo.dokument_t_id = bar.t_id
),
typ_ueberlagernd_punkt_dokument_ref AS 
(
  SELECT DISTINCT
    typ_ueberlagernd_punkt_dokument.typ_ueberlagernd_punkt,
    dokument,
    unnest(dok_dok_referenzen) AS dok_referenz
  FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_punkt_dokument AS typ_ueberlagernd_punkt_dokument
    LEFT JOIN doc_doc_references
    ON typ_ueberlagernd_punkt_dokument.dokument = doc_doc_references.ursprung
    
  UNION 
  
  SELECT
    typ_ueberlagernd_punkt,
    dokument,
    dokument AS dok_referenz
  FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_punkt_dokument    
),
typ_ueberlagernd_punkt_json_dokument AS 
(
  SELECT
    *
  FROM
    typ_ueberlagernd_punkt_dokument_ref
    LEFT JOIN json_documents_all
    ON json_documents_all.t_id = typ_ueberlagernd_punkt_dokument_ref.dok_referenz
),
typ_ueberlagernd_punkt_json_dokument_agg AS 
(
  SELECT
    typ_ueberlagernd_punkt AS typ_ueberlagernd_punkt_t_id,
    string_agg(json_dokument, ';') AS dokumente
  FROM
    typ_ueberlagernd_punkt_json_dokument
  GROUP BY
    typ_ueberlagernd_punkt
),
ueberlagernd_punkt_geometrie_typ AS
(
  SELECT
    l.t_id,
    l.t_datasetname::int4 AS bfs_nr,
    l.t_ili_tid,
    l.name_nummer,
    l.rechtsstatus,
    l.publiziertab,
    l.bemerkungen,
    l.erfasser,
    l.datum,
    l.geometrie,
    l.dokument,
    t.t_id AS typ_t_id,
    t.typ_kt AS typ_typ_kt,
    t.code_kommunal AS typ_code_kommunal,
    t.bezeichnung AS typ_bezeichnung,
    t.abkuerzung AS typ_abkuerzung,
    t.verbindlichkeit AS typ_verbindlichkeit,
    t.bemerkungen AS typ_bemerkungen 
  FROM
    arp_npl.nutzungsplanung_ueberlagernd_punkt AS l
    LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_punkt AS t
    ON l.typ_ueberlagernd_punkt = t.t_id
),
-- Alle Dokumente (inkl. Kaskade), die direkt von der Geometrie
-- auf ein Dokument zeigen.
additional_documents_from_geometry AS 
(
  SELECT
    foo.t_id,
    string_agg(json_dokument, ';') AS json_dokument
  FROM
  (
  SELECT 
    ueberlagernd_punkt.t_id,
    ueberlagernd_punkt.t_ili_tid,
    ueberlagernd_punkt.dokument,
    unnest(dok_dok_referenzen) AS dok_referenz
  FROM
    arp_npl.nutzungsplanung_ueberlagernd_punkt AS ueberlagernd_punkt
    LEFT JOIN doc_doc_references
    ON ueberlagernd_punkt.dokument = doc_doc_references.ursprung
  ) AS foo
  LEFT JOIN json_documents_all
  ON json_documents_all.t_id = foo.dok_referenz
  GROUP BY foo.t_id
)
-- Es muss noch die möglichen zusätzlichen Dokumente (Geometrie -> Dokument)
-- hinzugefügt werden. Plural, da auch Kaskade wieder möglich.
SELECT
  g.bfs_nr,
  g.t_ili_tid,
  g.name_nummer,
  g.rechtsstatus,
  g.publiziertab,
  g.bemerkungen,
  g.erfasser,
  g.datum,
  g.geometrie,
  g.typ_typ_kt AS typ_kt,
  g.typ_code_kommunal,
  g.typ_bezeichnung,
  g.typ_abkuerzung,
  g.typ_verbindlichkeit,
  g.typ_bemerkungen,
  CASE 
    WHEN j.json_dokument IS NOT NULL THEN COALESCE(d.dokumente||';','')||j.json_dokument
    ELSE d.dokumente 
  END AS dok_id
FROM  
  ueberlagernd_punkt_geometrie_typ AS g 
  LEFT JOIN typ_ueberlagernd_punkt_json_dokument_agg AS d
  ON g.typ_t_id = d.typ_ueberlagernd_punkt_t_id
  LEFT JOIN additional_documents_from_geometry AS j
  ON j.t_id = g.t_id;