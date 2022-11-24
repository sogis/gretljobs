SELECT
   sekt.wkb_geometry AS geometrie, 
   CASE WHEN sekt.r_lr_prozent = 10 THEN 'r_lr_1' WHEN sekt.r_lr_prozent = 100 THEN 'r_lr_90' END AS letalitaetsradius_art,
   --the radius is not present in the sektor table, we derive it from the Letalflaechen
   round(MIN(lf.r_p_lr)::numeric,2) AS letalitaetsradius,
   CASE WHEN sekt.typ = 'vz' THEN 'Wohnbevoelkerung' WHEN sekt.typ = 'bz' THEN 'Arbeitsbevoelkerung' WHEN sekt.typ = 'vzbz' THEN 'WohnUndArbeitsbevoelkerung' END AS bevoelkerung_typ,
   NULL AS bevoelkerung_anzahl,
   sekt.risiko AS risikozahl,
   sekt.n_tote AS anzahl_tote,
   sekt.szenario_id::text AS bemerkung,
   --later we need to revise the szenario_id based on the new szenario import (new id)
   --99999 is just a place-holder pointing to a dummy record
   99999 AS id_szenario
FROM
 qrcat.betbev_sektoren sekt
 LEFT JOIN qrcat.betbev_ot_letalflaechen_pt lf
    ON sekt.szenario_id = lf.szenario_id AND sekt.r_lr_prozent = lf.r_lr_prozent AND sekt.typ = lf.typ
  -- only select records where we find a correspondence to a Szenario
  -- and where a geometry is present
  WHERE
     sekt.szenario_id IN (SELECT szenario_id FROM qrcat."tbl_RCAT_SZENARIO" WHERE id_assoziation IS NOT NULL AND id_assoziation NOT IN (325329,325132,423613))
     AND sekt.wkb_geometry IS NOT NULL
   GROUP BY sekt.wkb_geometry, sekt.r_lr_prozent, sekt.typ, sekt.risiko, sekt.n_tote, sekt.szenario_id 
;
