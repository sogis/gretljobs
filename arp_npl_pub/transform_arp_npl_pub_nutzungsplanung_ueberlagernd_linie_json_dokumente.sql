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
  AND
    x.ursprung != t1.hinweis
)
, 
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
  (
    row_to_json
    ((
        SELECT
            docs
        FROM 
        (
            SELECT
                dokumentid AS "Dokument_ID", 
                titel AS "Titel", 
                offiziellertitel AS "Offizieller_Titel", 
                abkuerzung AS "Abkuerzung",
                offiziellenr AS "Offizielle_Nr", 
                kanton AS "Kanton", 
                gemeinde AS "Gemeinde", 
                publiziertab AS "publiziert_ab", 
                rechtsstatus AS "Rechtsstatus",
                ('https://geo.so.ch/docs/ch.so.arp.zonenplaene/Zonenplaene_pdf/'||"textimweb")::text AS "Text_im_Web",
                bemerkungen AS "Bemerkungen", 
                rechtsvorschrift AS "Rechtsvorschrift", 
                'SO_Nutzungsplanung_Publikation_20190909.Nutzungsplanung.Dokument' AS "@type"
        ) docs
    ))
  )::text AS json_dokument,
  t_id
  FROM
      arp_npl.rechtsvorschrften_dokument
 ) 
,
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
)
,
typ_ueberlagernd_linie_dokument_ref AS 
(
  SELECT DISTINCT ON (typ_ueberlagernd_linie, dok_referenz)
    *
  FROM
  (
    SELECT DISTINCT
      typ_ueberlagernd_linie_dokument.typ_ueberlagernd_linie,
      dokument,
      unnest(dok_dok_referenzen) AS dok_referenz
    FROM
      arp_npl.nutzungsplanung_typ_ueberlagernd_linie_dokument AS typ_ueberlagernd_linie_dokument
      LEFT JOIN doc_doc_references
      ON typ_ueberlagernd_linie_dokument.dokument = doc_doc_references.ursprung
   
    UNION 
    
    SELECT
      typ_ueberlagernd_linie,
      dokument,
      dokument AS dok_referenz
    FROM
      arp_npl.nutzungsplanung_typ_ueberlagernd_linie_dokument
  ) AS foo
)
,
typ_ueberlagernd_linie_json_dokument AS 
(
  SELECT
    *
  FROM
    typ_ueberlagernd_linie_dokument_ref
    LEFT JOIN json_documents_all
    ON json_documents_all.t_id = typ_ueberlagernd_linie_dokument_ref.dok_referenz
)
,
typ_ueberlagernd_linie_json_dokument_agg AS 
(
  SELECT
    typ_ueberlagernd_linie_t_id,
    '[' || dokumente::varchar || ']' as dokumente
  FROM
  (
    SELECT
      typ_ueberlagernd_linie AS typ_ueberlagernd_linie_t_id,
      string_agg(json_dokument, ',') AS dokumente
    FROM
      typ_ueberlagernd_linie_json_dokument
    GROUP BY
      typ_ueberlagernd_linie
  ) as foo
)
,
ueberlagernd_linie_geometrie_typ AS
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
    t.t_id AS typ_t_id,
    t.typ_kt AS typ_typ_kt,
    t.code_kommunal AS typ_code_kommunal,
    t.bezeichnung AS typ_bezeichnung,
    t.abkuerzung AS typ_abkuerzung,
    t.verbindlichkeit AS typ_verbindlichkeit,
    t.bemerkungen AS typ_bemerkungen 
  FROM
    arp_npl.nutzungsplanung_ueberlagernd_linie AS l
    LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_linie AS t
    ON l.typ_ueberlagernd_linie = t.t_id
)
-- Es muss noch die m?glichen zusätzlichen Dokumente (Geometrie -> Dokument)
-- hinzugefügt werden. Plural, da auch Kaskade wieder möglich.
SELECT
  --g.t_id,
  g.t_ili_tid,
  g.typ_bezeichnung,
  g.typ_abkuerzung,
  g.typ_verbindlichkeit,
  g.typ_bemerkungen,
  g.typ_typ_kt AS typ_kt,
  g.typ_code_kommunal::int4 AS typ_code_kommunal,
  g.geometrie,
  g.name_nummer,
  g.rechtsstatus,
  g.publiziertab AS publiziert_ab,
  g.bemerkungen,
  g.erfasser,
  g.datum AS datum_erfassung,
  d.dokumente::jsonb AS dokumente,
  g.bfs_nr
FROM  
  ueberlagernd_linie_geometrie_typ AS g 
  LEFT JOIN typ_ueberlagernd_linie_json_dokument_agg AS d
  ON g.typ_t_id = d.typ_ueberlagernd_linie_t_id
  ;
