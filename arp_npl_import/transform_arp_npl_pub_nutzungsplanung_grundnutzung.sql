WITH grundnutzung AS
(
    SELECT 
        grundnutzung.t_id,
        grundnutzung.t_datasetname,
        grundnutzung.t_ili_tid,
        grundnutzung.geometrie,
        typ_grundnutzung.typ_kt,
        typ_grundnutzung.code_kommunal,
        typ_grundnutzung.nutzungsziffer,
        typ_grundnutzung.nutzungsziffer_art,
        typ_grundnutzung.geschosszahl,
        typ_grundnutzung.bezeichnung,
        typ_grundnutzung.abkuerzung,
        typ_grundnutzung.verbindlichkeit,
        typ_grundnutzung.bemerkungen AS typ_bemerkungen,
        grundnutzung.name_nummer,
        grundnutzung.rechtsstatus,
        grundnutzung.publiziertab,
        grundnutzung.bemerkungen,
        grundnutzung.erfasser,
        grundnutzung.datum
    FROM 
        arp_npl.nutzungsplanung_grundnutzung AS grundnutzung
        LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung AS typ_grundnutzung 
        ON typ_grundnutzung.t_id = grundnutzung.typ_grundnutzung
),
grundnutzung_dokument AS 
(
-- Dokument für Grundnutzung  
    SELECT 
        grundnutzung.t_id AS grund_t_id,
        typ_grundnutzung.t_id AS typ_t_id,
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
        arp_npl.nutzungsplanung_grundnutzung AS grundnutzung
        LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung AS typ_grundnutzung 
        ON typ_grundnutzung.t_id = grundnutzung.typ_grundnutzung
        LEFT JOIN arp_npl.rechtsvorschrften_dokument AS dok
        ON  grundnutzung.dokument = dok.t_id
    WHERE 
        dok.titel IS NOT NULL
         
    UNION

-- Dokument für Typ_Grundnutzung  
    SELECT 
        grundnutzung.t_id AS grund_t_id,
        typ_grundnutzung.t_id AS typ_t_id,
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
        arp_npl.nutzungsplanung_grundnutzung AS grundnutzung
        LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung AS typ_grundnutzung 
        ON typ_grundnutzung.t_id = grundnutzung.typ_grundnutzung
        LEFT JOIN arp_npl.nutzungsplanung_typ_grundnutzung_dokument as typ_dok
        ON typ_dok.typ_grundnutzung=typ_grundnutzung.t_id 
        LEFT JOIN arp_npl.rechtsvorschrften_dokument AS dok
        ON  typ_dok.dokument = dok.t_id 
)    
SELECT  
    g.t_datasetname::int4 AS bfs_nr,
    g.t_ili_tid,
    g.geometrie,
    g.typ_kt,
    g.code_kommunal AS typ_code_kommunal,
    g.nutzungsziffer AS typ_nutzungsziffer,
    g.nutzungsziffer_art AS typ_nutzungsziffer_art,
    g.geschosszahl AS typ_geschosszahl,
    g.bezeichnung AS typ_bezeichnung,
    g.abkuerzung AS typ_abkuerzung,
    g.verbindlichkeit AS typ_verbindlichkeit,
    g.typ_bemerkungen,
    g.name_nummer,
    g.rechtsstatus,
    g.publiziertab,
    g.bemerkungen,
    g.erfasser,
    g.datum,
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
    grundnutzung AS g
    LEFT JOIN grundnutzung_dokument AS dok
    ON g.t_id = dok.grund_t_id
GROUP BY  
    g.t_datasetname,
    g.t_ili_tid,
    g.geometrie,
    g.typ_kt,
    g.code_kommunal,
    g.nutzungsziffer,
    g.nutzungsziffer_art,
    g.geschosszahl,
    g.bezeichnung,
    g.abkuerzung,
    g.verbindlichkeit,
    g.typ_bemerkungen,
    g.name_nummer,
    g.rechtsstatus,
    g.publiziertab,
    g.bemerkungen,
    g.erfasser,
    g.datum;