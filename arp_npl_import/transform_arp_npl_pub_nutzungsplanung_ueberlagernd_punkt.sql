WITH ueberlagernd_punkt AS 
(
    SELECT 
        ueberlagernd_punkt.t_id,
        ueberlagernd_punkt.t_datasetname,
        ueberlagernd_punkt.t_ili_tid,
        ueberlagernd_punkt.geometrie,
        typ_ueberlagernd_punkt.typ_kt,
        typ_ueberlagernd_punkt.code_kommunal,
        typ_ueberlagernd_punkt.bezeichnung,
        typ_ueberlagernd_punkt.abkuerzung,
        typ_ueberlagernd_punkt.verbindlichkeit,
        typ_ueberlagernd_punkt.bemerkungen as typ_bemerkungen,
        ueberlagernd_punkt.name_nummer,
        ueberlagernd_punkt.rechtsstatus,
        ueberlagernd_punkt.publiziertab,
        ueberlagernd_punkt.bemerkungen,
        ueberlagernd_punkt.erfasser,
        ueberlagernd_punkt.datum
    FROM 
        arp_npl.nutzungsplanung_ueberlagernd_punkt AS ueberlagernd_punkt
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_punkt AS typ_ueberlagernd_punkt
        ON typ_ueberlagernd_punkt.t_id = ueberlagernd_punkt.typ_ueberlagernd_punkt
),
ueberlagernd_punkt_dokument AS 
(
    -- Dokument für ueberlagernd_punkt 
    SELECT 
        ueberlagernd_punkt.t_id AS fl_t_id,
        typ_ueberlagernd_punkt.t_id AS typ_t_id,
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
        arp_npl.nutzungsplanung_ueberlagernd_punkt AS ueberlagernd_punkt
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_punkt AS typ_ueberlagernd_punkt
        ON typ_ueberlagernd_punkt.t_id = ueberlagernd_punkt.typ_ueberlagernd_punkt
        LEFT JOIN arp_npl.rechtsvorschrften_dokument AS dok
        ON  ueberlagernd_punkt.dokument = dok.t_id
    WHERE 
        dok.titel IS NOT NULL

    UNION
 
    -- Dokument für Typ_ueberlagernd_punkt 
    SELECT 
        ueberlagernd_punkt.t_id AS fl_t_id,
        typ_ueberlagernd_punkt.t_id AS typ_t_id,
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
        arp_npl.nutzungsplanung_ueberlagernd_punkt AS ueberlagernd_punkt
        LEFT JOIN arp_npl.nutzungsplanung_typ_ueberlagernd_punkt AS typ_ueberlagernd_punkt
        ON typ_ueberlagernd_punkt.t_id = ueberlagernd_punkt.typ_ueberlagernd_punkt
        LEFT JOIN 
        arp_npl.nutzungsplanung_typ_ueberlagernd_punkt_dokument AS typ_dok
        ON typ_dok.typ_ueberlagernd_punkt=typ_ueberlagernd_punkt.t_id 
        LEFT JOIN arp_npl.rechtsvorschrften_dokument AS dok
        ON  typ_dok.dokument = dok.t_id 
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
    string_agg( DISTINCT dok.textimweb, ', ' ) AS dok_textimweb,
    string_agg( DISTINCT dok.bemerkungen, ', ' ) AS dok_bemerkungen,
    string_agg( DISTINCT dok.rechtsvorschrift::text, ', ') AS dok_rechtsvorschrift
FROM 
    ueberlagernd_punkt AS fl
    LEFT JOIN ueberlagernd_punkt_dokument AS dok
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