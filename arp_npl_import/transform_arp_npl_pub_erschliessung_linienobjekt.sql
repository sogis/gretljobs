WITH erschliessung_linienobjekt AS 
(
    SELECT 
        erschliessung_linienobjekt.t_id,
        erschliessung_linienobjekt.t_datasetname,
        erschliessung_linienobjekt.t_ili_tid,
        erschliessung_linienobjekt.geometrie,
        typ_erschliessung_linienobjekt.typ_kt,
        typ_erschliessung_linienobjekt.code_kommunal,
        typ_erschliessung_linienobjekt.bezeichnung,
        typ_erschliessung_linienobjekt.abkuerzung,
        typ_erschliessung_linienobjekt.verbindlichkeit,
        typ_erschliessung_linienobjekt.bemerkungen as typ_bemerkungen,
        erschliessung_linienobjekt.name_nummer,
        erschliessung_linienobjekt.rechtsstatus,
        erschliessung_linienobjekt.publiziertab,
        erschliessung_linienobjekt.bemerkungen,
        erschliessung_linienobjekt.erfasser,
        erschliessung_linienobjekt.datum
    FROM 
        arp_npl.erschlssngsplnung_erschliessung_linienobjekt AS erschliessung_linienobjekt
        LEFT JOIN arp_npl.erschlssngsplnung_typ_erschliessung_linienobjekt AS typ_erschliessung_linienobjekt
        ON typ_erschliessung_linienobjekt.t_id = erschliessung_linienobjekt.typ_erschliessung_linienobjekt   
),
erschliessung_linienobjekt_dokument AS 
(
    -- Dokument für Typ_erschliessung_linienobjekt 
    SELECT 
        erschliessung_linienobjekt.t_id AS li_t_id,
        typ_erschliessung_linienobjekt.t_id AS typ_t_id,
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
        arp_npl.erschlssngsplnung_erschliessung_linienobjekt AS erschliessung_linienobjekt
        LEFT JOIN arp_npl.erschlssngsplnung_typ_erschliessung_linienobjekt AS typ_erschliessung_linienobjekt
        ON typ_erschliessung_linienobjekt.t_id = erschliessung_linienobjekt.typ_erschliessung_linienobjekt
        LEFT JOIN arp_npl.erschlssngsplnung_typ_erschliessung_linienobjekt_dokument AS typ_dok
        ON typ_dok.typ_erschliessung_linienobjekt=typ_erschliessung_linienobjekt.t_id 
        LEFT JOIN arp_npl.rechtsvorschrften_dokument AS dok
        ON typ_dok.dokument = dok.t_id 
)          
SELECT  
    li.t_datasetname::int4 AS bfs_nr,
    li.t_ili_tid,
    li.geometrie,
    li.typ_kt,
    li.code_kommunal AS typ_code_kommunal,
    li.bezeichnung AS typ_bezeichnung,
    li.abkuerzung AS typ_abkuerzung,
    li.verbindlichkeit AS typ_verbindlichkeit,
    li.typ_bemerkungen,
    li.name_nummer,
    li.rechtsstatus,
    li.publiziertab,
    li.bemerkungen,
    li.erfasser,
    li.datum,
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
    erschliessung_linienobjekt AS li
    LEFT JOIN erschliessung_linienobjekt_dokument AS dok
    ON li.t_id = dok.li_t_id
GROUP BY  
    li.t_datasetname,
    li.t_ili_tid,
    li.geometrie,
    li.typ_kt,
    li.code_kommunal,
    li.bezeichnung,
    li.abkuerzung,
    li.verbindlichkeit,
    li.typ_bemerkungen,
    li.name_nummer,
    li.rechtsstatus,
    li.publiziertab,
    li.bemerkungen,
    li.erfasser,
    li.datum;