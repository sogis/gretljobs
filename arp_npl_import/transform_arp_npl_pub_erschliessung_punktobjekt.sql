
WITH erschliessung_punktobjekt AS 
(
    SELECT 
        erschliessung_punktobjekt.t_id,
        erschliessung_punktobjekt.t_datasetname,
        erschliessung_punktobjekt.t_ili_tid,
        erschliessung_punktobjekt.geometrie,
        typ_erschliessung_punktobjekt.typ_kt,
        typ_erschliessung_punktobjekt.code_kommunal,
        typ_erschliessung_punktobjekt.bezeichnung,
        typ_erschliessung_punktobjekt.abkuerzung,
        typ_erschliessung_punktobjekt.verbindlichkeit,
        typ_erschliessung_punktobjekt.bemerkungen as typ_bemerkungen,
        erschliessung_punktobjekt.name_nummer,
        erschliessung_punktobjekt.rechtsstatus,
        erschliessung_punktobjekt.publiziertab,
        erschliessung_punktobjekt.bemerkungen,
        erschliessung_punktobjekt.erfasser,
        erschliessung_punktobjekt.datum
    FROM 
        arp_npl.erschlssngsplnung_erschliessung_punktobjekt AS erschliessung_punktobjekt
        LEFT JOIN arp_npl.erschlssngsplnung_typ_erschliessung_punktobjekt AS typ_erschliessung_punktobjekt
        ON typ_erschliessung_punktobjekt.t_id = erschliessung_punktobjekt.typ_erschliessung_punktobjekt
),
erschliessung_punktobjekt_dokument AS 
(
    -- Dokument für Typ_erschliessung_punktobjekt 
    SELECT 
        erschliessung_punktobjekt.t_id AS li_t_id,
        typ_erschliessung_punktobjekt.t_id AS typ_t_id,
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
        arp_npl.erschlssngsplnung_erschliessung_punktobjekt AS erschliessung_punktobjekt
        LEFT JOIN arp_npl.erschlssngsplnung_typ_erschliessung_punktobjekt AS typ_erschliessung_punktobjekt
        ON typ_erschliessung_punktobjekt.t_id = erschliessung_punktobjekt.typ_erschliessung_punktobjekt
        LEFT JOIN arp_npl.erschlssngsplnung_typ_erschliessung_punktobjekt_dokument AS typ_dok
        ON typ_dok.typ_erschliessung_punktobjekt=typ_erschliessung_punktobjekt.t_id 
        LEFT JOIN arp_npl.rechtsvorschrften_dokument AS dok
        ON typ_dok.dokument = dok.t_id 
)           
SELECT  
    pk.t_datasetname::int4 AS bfs_nr,
    pk.t_ili_tid,
    pk.geometrie,
    pk.typ_kt,
    pk.code_kommunal AS typ_code_kommunal,
    pk.bezeichnung AS typ_bezeichnung,
    pk.abkuerzung AS typ_abkuerzung,
    pk.verbindlichkeit AS typ_verbindlichkeit,
    pk.typ_bemerkungen,
    pk.name_nummer,
    pk.rechtsstatus,
    pk.publiziertab,
    pk.bemerkungen,
    pk.erfasser,
    pk.datum,
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
    erschliessung_punktobjekt AS pk
    LEFT JOIN erschliessung_punktobjekt_dokument AS dok
    ON pk.t_id = dok.li_t_id
GROUP BY  
    pk.t_datasetname,
    pk.t_ili_tid,
    pk.geometrie,
    pk.typ_kt,
    pk.code_kommunal,
    pk.bezeichnung,
    pk.abkuerzung,
    pk.verbindlichkeit,
    pk.typ_bemerkungen,
    pk.name_nummer,
    pk.rechtsstatus,
    pk.publiziertab,
    pk.bemerkungen,
    pk.erfasser,
    pk.datum;