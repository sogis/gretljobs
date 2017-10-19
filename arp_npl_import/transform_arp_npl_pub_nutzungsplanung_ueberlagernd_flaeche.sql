WITH ueberlagernd_flaeche AS 
( 
    SELECT 
        ueberlagernd_flaeche.t_id,
        ueberlagernd_flaeche.t_datasetname,
        ueberlagernd_flaeche.t_ili_tid,
        ueberlagernd_flaeche.geometrie,
        typ_ueberlagernd_flaeche.typ_kt,
        typ_ueberlagernd_flaeche.code_kommunal,
        typ_ueberlagernd_flaeche.bezeichnung,
        typ_ueberlagernd_flaeche.abkuerzung,
        typ_ueberlagernd_flaeche.verbindlichkeit,
        typ_ueberlagernd_flaeche.bemerkungen AS typ_bemerkungen,
        ueberlagernd_flaeche.name_nummer,
        ueberlagernd_flaeche.rechtsstatus,
        ueberlagernd_flaeche.publiziertab,
        ueberlagernd_flaeche.bemerkungen,
        ueberlagernd_flaeche.erfasser,
        ueberlagernd_flaeche.datum,
        plan.plandokumentid,
        plan.titel AS plan_titel,
        plan.offiziellertitel AS plan_offiziellertitel,
        plan.offiziellenr AS plan_offiziellenr,
        plan.kanton AS plan_kanton,
        plan.gemeinde AS plan_gemeinde,
        plan.publiziertab AS plan_publiziertab,
        plan.rechtsstatus AS plan_rechtsstatus,
        plan.planimweb,
        plan.bemerkungen AS plan_bemerkung
    FROM 
        arp_npl.nutzungsplanung_ueberlagernd_flaeche AS ueberlagernd_flaeche
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche AS typ_ueberlagernd_flaeche
        ON typ_ueberlagernd_flaeche.t_id = ueberlagernd_flaeche.typ_ueberlagernd_flaeche
        LEFT JOIN arp_npl.rechtsvorschrften_plandokument AS plan
        ON plan.t_id =ueberlagernd_flaeche.plandokument
),
ueberlagernd_flaeche_dokument AS (
    -- Dokument für ueberlagernd_flaeche 
    SELECT 
        ueberlagernd_flaeche.t_id AS fl_t_id,
        typ_ueberlagernd_flaeche.t_id AS typ_t_id,
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
        arp_npl.nutzungsplanung_ueberlagernd_flaeche AS ueberlagernd_flaeche
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche AS typ_ueberlagernd_flaeche
        ON typ_ueberlagernd_flaeche.t_id = ueberlagernd_flaeche.typ_ueberlagernd_flaeche
        LEFT JOIN arp_npl.rechtsvorschrften_dokument AS dok
        ON ueberlagernd_flaeche.dokument = dok.t_id
    WHERE 
        dok.titel IS NOT NULL
 
    UNION
      
    -- Dokument für Typ_ueberlagernd_flaeche 
    SELECT 
        ueberlagernd_flaeche.t_id AS fl_t_id,
        typ_ueberlagernd_flaeche.t_id AS typ_t_id,
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
        arp_npl.nutzungsplanung_ueberlagernd_flaeche AS ueberlagernd_flaeche
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche AS typ_ueberlagernd_flaeche
        ON typ_ueberlagernd_flaeche.t_id = ueberlagernd_flaeche.typ_ueberlagernd_flaeche
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche_dokument AS typ_dok
        ON typ_dok.typ_ueberlagernd_flaeche=typ_ueberlagernd_flaeche.t_id 
        LEFT JOIN arp_npl.rechtsvorschrften_dokument AS dok
        ON typ_dok.dokument = dok.t_id 
)
SELECT  
    fl.t_datasetname::int4 as bfs_nr,
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
    string_agg( DISTINCT dok.rechtsvorschrift::text, ', ') AS dok_rechtsvorschrift,
    fl.plandokumentid AS plan_plandokumentid,
    fl.plan_titel,
    fl.plan_offiziellertitel,
    fl.plan_offiziellenr,
    fl.plan_kanton,
    fl.plan_gemeinde,
    fl.plan_publiziertab,
    fl.plan_rechtsstatus,
    'https://geoweb.so.ch/zonenplaene/Zonenplaene_pdf/' || fl.planimweb AS plan_planimweb,
    fl.plan_bemerkung AS plan_bemerkungen
FROM 
    ueberlagernd_flaeche AS fl
    LEFT JOIN ueberlagernd_flaeche_dokument AS dok
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
    fl.datum,
    fl.plandokumentid,
    fl.plan_titel,
    fl.plan_offiziellertitel,
    fl.plan_offiziellenr,
    fl.plan_kanton,
    fl.plan_gemeinde,
    fl.plan_publiziertab,
    fl.plan_rechtsstatus,
    fl.planimweb,
    fl.plan_bemerkung;