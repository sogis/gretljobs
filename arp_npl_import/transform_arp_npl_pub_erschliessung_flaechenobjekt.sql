WITH erschliessung_flaechenobjekt AS 
(
    SELECT 
        erschliessung_flaechenobjekt.t_id,
        erschliessung_flaechenobjekt.t_datasetname,
        erschliessung_flaechenobjekt.t_ili_tid,
        erschliessung_flaechenobjekt.geometrie,
        typ_erschliessung_flaechenobjekt.typ_kt,
        typ_erschliessung_flaechenobjekt.code_kommunal,
        typ_erschliessung_flaechenobjekt.bezeichnung,
        typ_erschliessung_flaechenobjekt.abkuerzung,
        typ_erschliessung_flaechenobjekt.verbindlichkeit,
        typ_erschliessung_flaechenobjekt.bemerkungen as typ_bemerkungen,
        erschliessung_flaechenobjekt.name_nummer,
        erschliessung_flaechenobjekt.rechtsstatus,
        erschliessung_flaechenobjekt.publiziertab,
        erschliessung_flaechenobjekt.bemerkungen,
        erschliessung_flaechenobjekt.erfasser,
        erschliessung_flaechenobjekt.datum
    FROM 
        arp_npl.erschlssngsplnung_erschliessung_flaechenobjekt AS erschliessung_flaechenobjekt
        LEFT JOIN arp_npl.erschlssngsplnung_typ_erschliessung_flaechenobjekt AS typ_erschliessung_flaechenobjekt
        ON typ_erschliessung_flaechenobjekt.t_id = erschliessung_flaechenobjekt.typ_erschliessung_flaechenobjekt  
),
erschliessung_flaechenobjekt_dokument AS 
(
    -- Dokument für Typ_erschliessung_flaechenobjekt 
    SELECT 
        erschliessung_flaechenobjekt.t_id AS fl_t_id,
        typ_erschliessung_flaechenobjekt.t_id AS typ_t_id,
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
        arp_npl.erschlssngsplnung_erschliessung_flaechenobjekt AS erschliessung_flaechenobjekt
        LEFT JOIN arp_npl.erschlssngsplnung_typ_erschliessung_flaechenobjekt AS typ_erschliessung_flaechenobjekt
        ON typ_erschliessung_flaechenobjekt.t_id = erschliessung_flaechenobjekt.typ_erschliessung_flaechenobjekt
        LEFT JOIN arp_npl.erschlssngsplnung_typ_erschliessung_flaechenobjekt_dokument AS typ_dok
        ON typ_dok.typ_erschliessung_flaechenobjekt=typ_erschliessung_flaechenobjekt.t_id 
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
    erschliessung_flaechenobjekt AS fl
    LEFT JOIN erschliessung_flaechenobjekt_dokument AS dok
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