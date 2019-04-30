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
  WHERE
    ursprung != hinweis

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
)
, 
doc_doc_references_all AS 
(
  SELECT 
    ursprung, 
    hinweis, 
    --array_to_string(parents,';'),
    parents,
    depth
  FROM x 
  WHERE 
    depth = (SELECT max(sq."depth") FROM x sq WHERE sq.ursprung = x.ursprung)
)
,
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
)
,
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
      ('https://geo.so.ch/docs/ch.so.arp.zonenplaene/Zonenplaene_pdf/'||"textimweb")::text AS textimweb_absolut
    FROM
      arp_npl.rechtsvorschrften_dokument
  ) AS t
)
,
-- TODO:
-- Alle Dokumente (die in HinweisWeitereDokumente vorkommen) 
-- als JSON-Objekte (resp. als Text-Repräsentation).
-- Muss noch genauer überlegt werden, wie genau mit JSON hantiert wird.

-- TODO: Brauch ich jetzt diese Tabelle überhaupt noch?
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
)
,
-- TODO: 
-- Erstes SELECT liefert nur die Dokumente, die auch in der hinweisweiteredokumente-Tabelle
-- vorkommen. Daher das Union mit der "linienobjekt_dokument"-Tabelle, um auch wirklich
-- alle Dokumente zu erhalten, die mit einem Typ assoziiert sind.
-- -> Nochmals überlegen, ob man das nicht besser lösen kann.
typ_erschliessung_linienobjekt_dokument_ref AS 
(
  SELECT DISTINCT ON (typ_erschliessung_linienobjekt, dok_referenz)
    *
  FROM
  (
    SELECT DISTINCT
      typ_erschliessung_linienobjekt_dokument.typ_erschliessung_linienobjekt,
      dokument,
      unnest(dok_dok_referenzen) AS dok_referenz
    FROM
      arp_npl.erschlssngsplnung_typ_erschliessung_linienobjekt_dokument AS typ_erschliessung_linienobjekt_dokument
      LEFT JOIN doc_doc_references
      ON typ_erschliessung_linienobjekt_dokument.dokument = doc_doc_references.ursprung
    
    UNION 
    
    SELECT
      typ_erschliessung_linienobjekt,
      dokument,
      dokument AS dok_referenz
    FROM
      arp_npl.erschlssngsplnung_typ_erschliessung_linienobjekt_dokument
  ) AS foo
)
,
-- Dieses Joinen muss folgerichtig mit *allen* Json-Dokumenten geschehen,
-- sonst gibt es NULL bei den Dokumenten, die nicht in hinweisweiteredokumente
-- auftreten.
typ_erschliessung_linienobjekt_json_dokument AS 
(
  SELECT
    *
  FROM
    typ_erschliessung_linienobjekt_dokument_ref
    LEFT JOIN json_documents_all
    ON json_documents_all.t_id = typ_erschliessung_linienobjekt_dokument_ref.dok_referenz
)
,
typ_erschliessung_linienobjekt_json_dokument_agg AS 
(
  SELECT
    typ_erschliessung_linienobjekt_t_id,
    '[' || dokumente::varchar || ']' as dokumente
  FROM
  (
    SELECT
      typ_erschliessung_linienobjekt AS typ_erschliessung_linienobjekt_t_id,
      string_agg(json_dokument, ',') AS dokumente
    FROM
      typ_erschliessung_linienobjekt_json_dokument
    GROUP BY
      typ_erschliessung_linienobjekt
  ) as foo
)
,
erschliessung_linienobjekt_geometrie_typ AS
(
  SELECT 
    f.t_datasetname::int4 AS bfs_nr,
    f.t_ili_tid,
    f.name_nummer,
    f.rechtsstatus,
    f.publiziertab,
    f.bemerkungen,
    f.erfasser,
    f.datum,
    f.geometrie,
    t.t_id AS typ_t_id,
    t.typ_kt AS typ_typ_kt,
    t.code_kommunal AS typ_code_kommunal,
    t.bezeichnung AS typ_bezeichnung,
    t.abkuerzung AS typ_abkuerzung,
    t.verbindlichkeit AS typ_verbindlichkeit,
    t.bemerkungen AS typ_bemerkungen 
  FROM
    arp_npl.erschlssngsplnung_erschliessung_linienobjekt AS f
    LEFT JOIN arp_npl.erschlssngsplnung_typ_erschliessung_linienobjekt AS t
    ON f.typ_erschliessung_linienobjekt = t.t_id
)
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
  d.dokumente AS dok_id
FROM  
  erschliessung_linienobjekt_geometrie_typ AS g 
  LEFT JOIN typ_erschliessung_linienobjekt_json_dokument_agg AS d
  ON g.typ_t_id = d.typ_erschliessung_linienobjekt_t_id;