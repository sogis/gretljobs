WITH ueberlagernd_linie AS 
(
    SELECT 
        ueberlagernd_linie.t_id,
        ueberlagernd_linie.t_datasetname,
        ueberlagernd_linie.t_ili_tid,
        ueberlagernd_linie.geometrie,
        typ_ueberlagernd_linie.typ_kt,
        typ_ueberlagernd_linie.code_kommunal,
        typ_ueberlagernd_linie.bezeichnung,
        typ_ueberlagernd_linie.abkuerzung,
        typ_ueberlagernd_linie.verbindlichkeit,
        typ_ueberlagernd_linie.bemerkungen as typ_bemerkungen,
        ueberlagernd_linie.name_nummer,
        ueberlagernd_linie.rechtsstatus,
        ueberlagernd_linie.publiziertab,
        ueberlagernd_linie.bemerkungen,
        ueberlagernd_linie.erfasser,
        ueberlagernd_linie.datum
    FROM 
        arp_npl.nutzungsplanung_ueberlagernd_linie AS ueberlagernd_linie
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_linie AS typ_ueberlagernd_linie
        ON typ_ueberlagernd_linie.t_id = ueberlagernd_linie.typ_ueberlagernd_linie
),
ueberlagernd_linie_dokument AS 
(
    -- Dokument für ueberlagernd_linie 
    SELECT 
        ueberlagernd_linie.t_id AS fl_t_id,
        typ_ueberlagernd_linie.t_id AS typ_t_id,
        dok.t_id,
        dok.dokumentid,
        dok.titel,
        dok.offiziellertitel,
        dok.abkuerzung,
        dok.offiziellenr,
        dok.kanton,
        dok.gemeinde,
        dok.publiziertab,
        dok.rechtsstatus,
        dok.textimweb,
        dok.bemerkungen,
        dok.rechtsvorschrift
    FROM 
        arp_npl.nutzungsplanung_ueberlagernd_linie AS ueberlagernd_linie
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_linie AS typ_ueberlagernd_linie
        ON typ_ueberlagernd_linie.t_id = ueberlagernd_linie.typ_ueberlagernd_linie
        LEFT JOIN arp_npl.rechtsvorschrften_dokument AS dok
        ON  ueberlagernd_linie.dokument = dok.t_id
    WHERE 
        dok.titel IS NOT NULL 

    UNION
  
    -- Dokument für Typ_ueberlagernd_linie 
    SELECT 
        ueberlagernd_linie.t_id AS fl_t_id,
        typ_ueberlagernd_linie.t_id AS typ_t_id,
        dok.t_id,
        dok.dokumentid,
        dok.titel,
        dok.offiziellertitel,
        dok.abkuerzung,
        dok.offiziellenr,
        dok.kanton,
        dok.gemeinde,
        dok.publiziertab,
        dok.rechtsstatus,
        dok.textimweb,
        dok.bemerkungen,
        dok.rechtsvorschrift
    FROM 
        arp_npl.nutzungsplanung_ueberlagernd_linie AS ueberlagernd_linie
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_linie AS typ_ueberlagernd_linie
        ON typ_ueberlagernd_linie.t_id = ueberlagernd_linie.typ_ueberlagernd_linie
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_linie_dokument AS typ_dok
        ON typ_dok.typ_ueberlagernd_linie=typ_ueberlagernd_linie.t_id 
        LEFT JOIN arp_npl.rechtsvorschrften_dokument AS dok
        ON typ_dok.dokument = dok.t_id 
)
SELECT  
    fl.t_datasetname::int4 AS bfs_nr,
    fl.t_ili_tid,
    fl.geometrie,
    fl.typ_kt,
    fl.code_kommunal AS typ_code_kommunal,
    fl.bezeichnung AS typ_bezeichnung,
    fl.abkuerzung AS typ_abkuerzung,
    fl.verbindlichkeit AS typ_verbindlichkeit,
    fl.typ_bemerkungen,
    fl.name_nummer,
    fl.rechtsstatus,
    fl.publiziertab,
    fl.bemerkungen,
    fl.erfasser,
    fl.datum,
    string_agg( DISTINCT dok.dokumentid, ', ') AS dok_id, 
    string_agg( DISTINCT dok.titel, ', ' ) AS dok_titel,
    string_agg( DISTINCT dok.offiziellertitel, ', ') AS dok_offiziellertitel, 
    string_agg( DISTINCT dok.abkuerzung, ', ') AS dok_abkuerzung,
    string_agg( DISTINCT dok.offiziellenr, ', ' ) AS dok_offiziellenr,
    string_agg( DISTINCT dok.kanton, ', ' ) AS dok_kanton,
    string_agg( DISTINCT dok.gemeinde::text, ', ' ) AS dok_gemeinde,
    string_agg( DISTINCT dok.publiziertab::text, ', ' ) AS dok_publiziertab,
    string_agg( DISTINCT dok.rechtsstatus, ', ' ) AS dok_rechtsstatus,
    string_agg( DISTINCT 'https://geoweb.so.ch/zonenplaene/Zonenplaene_pdf/' || dok.textimweb, ', ' ) AS dok_textimweb,
    string_agg( DISTINCT dok.bemerkungen, ', ' ) AS dok_bemerkungen,
    string_agg( DISTINCT dok.rechtsvorschrift::text, ', ') AS dok_rechtsvorschrift
FROM 
    ueberlagernd_linie AS fl
    LEFT JOIN ueberlagernd_linie_dokument AS dok
    ON fl.t_id = dok.fl_t_id
GROUP BY  
    fl.t_datasetname,
    fl.t_ili_tid,
    fl.geometrie,
    fl.typ_kt,
    fl.code_kommunal,
    fl.bezeichnung,
    fl.abkuerzung,
    fl.verbindlichkeit,
    fl.typ_bemerkungen,
    fl.name_nummer,
    fl.rechtsstatus,
    fl.publiziertab,
    fl.bemerkungen,
    fl.erfasser,
    fl.datum;