SELECT
    baustelle.t_id,
    baustelle.t_ili_tid,
    nummer,
    achsnummer,
    beschreibung,
    stassenabschnitt,
    ausnahmetransportroute,
    amtsblatt_nr,
    bp_nr_von,
    bp_nr_bis,
    beginn_monat,
    beginn_jahr,
    ende_monat,
    ende_jahr,
    CASE
        WHEN
            status = 'im_Bau'
            THEN ' im Bau'
        ELSE status
    END AS status,
    verkehrsfuehrung.massnahme AS verkehrsfuehrung,
    kreis||' / '||projektleiter_kuerzel  AS zustaendigkeit,
    documents.dokumente,
    geometrie
FROM
    avt_baustellen.baustellen_baustelle AS baustelle
LEFT JOIN avt_baustellen.baustellen_verkehrsfuehrung AS verkehrsfuehrung
    ON verkehrsfuehrung.t_id = baustelle.verkehrsfuehrung
LEFT JOIN avt_baustellen.baustellen_zustaendigkeit AS zustaendigkeit
    ON zustaendigkeit.t_id = baustelle.zustaendigkeit
LEFT JOIN (
    SELECT 
        array_to_json(array_agg(row_to_json(docs)))::text AS dokumente, 
        baustelle
    FROM 
         (SELECT
              dokumententyp,
              dokumentname,
              baustelle
         FROM
             avt_baustellen.baustellen_dokument
         ) AS docs
     GROUP BY 
         baustelle
) AS documents
    ON baustelle.t_id = documents.baustelle
;