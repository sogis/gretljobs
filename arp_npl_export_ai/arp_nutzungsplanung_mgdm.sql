/*
 * GRUNDNUTZUNG START
 */
WITH typ_kt_grundnutzung AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_typ_kt
    (
      code,
      bezeichnung,
      abkuerzung,
      hauptnutzung_ch
    )
  SELECT
    substring(ilicode FROM 2 FOR 3) AS code, 
    replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
    substring(ilicode FROM 1 FOR 4) AS abkuerzung,
    hn.t_id AS hauptnutzung_ch
  FROM
    arp_npl.nutzungsplanung_np_typ_kanton_grundnutzung AS gn
    LEFT JOIN 
      arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hn
      ON 
        hn.code::text = substring(ilicode FROM 2 FOR 2)
  RETURNING *
),
/*
 * Selektieren und Inserten wird getrennt, damit
 * man nicht den Ursprungs-Primary-Key verliert.
 * Auf diesen wird bei späteren Queries gebraucht.
 */ 
typ_kommunal_grundnutzung AS 
(
  SELECT 
    nextval('arp_npl_mgdm.t_ili2db_seq'::regclass) AS t_id,
    typ.t_id AS nutzungsplanung_typ_grundnutzung_t_id,
    typ.code_kommunal AS code,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.nutzungsziffer,
    typ.nutzungsziffer_art,
    typ.bemerkungen,
    typ_kt_grundnutzung.t_id AS typ_kt
  FROM
    arp_npl.nutzungsplanung_typ_grundnutzung AS typ
    LEFT JOIN
      typ_kt_grundnutzung
      ON
        typ_kt_grundnutzung.code = substring(typ.typ_kt FROM 2 FOR 3)
),
grundnutzung_zonenflaeche AS 
(
  SELECT
    nextval('arp_npl_mgdm.t_ili2db_seq'::regclass) AS t_id,
    grundnutzung.t_id AS nutzungsplanung_grundnutzung_t_id,
    grundnutzung.publiziertab,
    grundnutzung.rechtsstatus,
    grundnutzung.bemerkungen,
    typ_kommunal_grundnutzung.t_id AS typ,
    grundnutzung.geometrie
  FROM
    arp_npl.nutzungsplanung_grundnutzung AS grundnutzung
    LEFT JOIN typ_kommunal_grundnutzung
    ON grundnutzung.typ_grundnutzung = typ_kommunal_grundnutzung.nutzungsplanung_typ_grundnutzung_t_id
),
typ_kommunal_grundnutzung_insert AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_typ
    (
      t_id,
      code,
      bezeichnung,
      abkuerzung,
      verbindlichkeit,
      nutzungsziffer,
      nutzungsziffer_art,
      bemerkungen,
      typ_kt
    )
  SELECT 
    t_id,
    code,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    nutzungsziffer,
    nutzungsziffer_art,
    bemerkungen,
    typ_kt
  FROM
    typ_kommunal_grundnutzung
  RETURNING *
),
grundnutzung_zonenflaeche_insert AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_grundnutzung_zonenflaeche
    (
      t_id,
      publiziertab,
      rechtsstatus,
      bemerkungen,
      typ,
      geometrie
    )
  SELECT
    t_id,
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ,
    geometrie
  FROM
    grundnutzung_zonenflaeche
  RETURNING *
),
/*
 * GRUNDNUTZUNG ENDE
 */
/*
 * ÜBERLAGERND FLÄCHE START
 */
typ_kt_ueberlagernd_flaeche AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_typ_kt
    (
      code,
      bezeichnung,
      abkuerzung,
      hauptnutzung_ch
    )
  SELECT
    substring(ilicode FROM 2 FOR 3) AS code, 
    replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
    substring(ilicode FROM 1 FOR 4) AS abkuerzung,
    hn.t_id AS hauptnutzung_ch
  FROM
    arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_flaeche AS fl
    LEFT JOIN 
      arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hn
      ON 
        hn.code::text = substring(ilicode FROM 2 FOR 2)
  WHERE 
    substring(ilicode FROM 2 FOR 3) 
    NOT IN 
    (
      '593', 
      '594', 
      '595', 
      '596', 
      '680', 
      '680', 
      '680', 
      '681', 
      '682', 
      '683', 
      '684', 
      '685', 
      '686'
    )
  /* 800er-Werte für Flächen müssen dem MGDM-Wert 69 zugewiesen werden. */
  AND 
    substring(ilicode FROM 2 FOR 3)::int < 800
  
  UNION 
  
  SELECT
    substring(ilicode FROM 2 FOR 3) AS code, 
    replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
    substring(ilicode FROM 1 FOR 4) AS abkuerzung,
    hn.t_id AS hauptnutzung_ch
  FROM
    arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_flaeche AS fl
    LEFT JOIN 
    (
      SELECT 
        t_id
      FROM
        arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch
      WHERE
        code = 69
    ) AS hn
    ON 
      1=1
  WHERE 
    substring(ilicode FROM 2 FOR 3)::int >= 800     
  RETURNING *
),
typ_kommunal_ueberlagernd_flaeche AS 
(
  SELECT 
    nextval('arp_npl_mgdm.t_ili2db_seq'::regclass) AS t_id,
    typ.t_id AS nutzungsplanung_typ_ueberlagernd_flaeche_t_id,
    typ.code_kommunal AS code,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt_ueberlagernd_flaeche.t_id AS typ_kt
  FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_flaeche AS typ
    JOIN
      typ_kt_ueberlagernd_flaeche
      ON
        typ_kt_ueberlagernd_flaeche.code = substring(typ.typ_kt FROM 2 FOR 3)
),
ueberlagernde_festlegung AS 
(
  SELECT
    nextval('arp_npl_mgdm.t_ili2db_seq'::regclass) AS t_id,
    flaeche.t_id AS nutzungsplanung_ueberlagernd_flaeche_t_id,
    flaeche.publiziertab,
    flaeche.rechtsstatus,
    flaeche.bemerkungen,
    typ_kommunal_ueberlagernd_flaeche.t_id AS typ,
    flaeche.geometrie
  FROM
    arp_npl.nutzungsplanung_ueberlagernd_flaeche AS flaeche
    -- Weil wir einige Typen nicht transferieren, dürfen wir nicht LEFT JOIN verwenden.
    JOIN typ_kommunal_ueberlagernd_flaeche
    ON flaeche.typ_ueberlagernd_flaeche = typ_kommunal_ueberlagernd_flaeche.nutzungsplanung_typ_ueberlagernd_flaeche_t_id
),
typ_kommunal_ueberlagernd_flaeche_insert AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_typ
    (
      t_id,
      code,
      bezeichnung,
      abkuerzung,
      verbindlichkeit,
      nutzungsziffer,
      nutzungsziffer_art,
      bemerkungen,
      typ_kt
    )
  SELECT 
    t_id,
    code,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    NULL::float AS nutzungsziffer,
    NULL::text AS nutzungsziffer_art,
    bemerkungen,
    typ_kt
  FROM
    typ_kommunal_ueberlagernd_flaeche
  RETURNING *
),
ueberlagernde_festlegung_insert AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_ueberlagernde_festlegung
    (
      t_id,
      publiziertab,
      rechtsstatus,
      bemerkungen,
      typ,
      geometrie
    )
  SELECT
    t_id,
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ,
    geometrie
  FROM
    ueberlagernde_festlegung
  RETURNING *
),
/*
 * ÜBERLAGERND FLÄCHE ENDE
 */
/*
 * ÜBERLAGERND LINIE START
 */
typ_kt_ueberlagernd_linie AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_typ_kt
    (
      code,
      bezeichnung,
      abkuerzung,
      hauptnutzung_ch
    )
  SELECT
    substring(ilicode FROM 2 FOR 3) AS code, 
    replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
    substring(ilicode FROM 1 FOR 4) AS abkuerzung,
    hn.t_id AS hauptnutzung_ch
  FROM
    arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_linie AS li
    LEFT JOIN 
      arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hn
      ON 
        hn.code::text = substring(ilicode FROM 2 FOR 2)
  WHERE 
    substring(ilicode FROM 2 FOR 3) 
    NOT IN 
    (
      '792', 
      '793'
    )
  RETURNING *
),
typ_kommunal_ueberlagernd_linie AS 
(
  SELECT 
    nextval('arp_npl_mgdm.t_ili2db_seq'::regclass) AS t_id,
    typ.t_id AS nutzungsplanung_typ_ueberlagernd_linie_t_id,
    typ.code_kommunal AS code,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt_ueberlagernd_linie.t_id AS typ_kt
  FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_linie AS typ
    JOIN
      typ_kt_ueberlagernd_linie
      ON
        typ_kt_ueberlagernd_linie.code = substring(typ.typ_kt FROM 2 FOR 3)
),
linienbezogene_festlegung AS 
(
  SELECT
    nextval('arp_npl_mgdm.t_ili2db_seq'::regclass) AS t_id,
    linie.t_id AS nutzungsplanung_ueberlagernd_linie_t_id,
    linie.publiziertab,
    linie.rechtsstatus,
    linie.bemerkungen,
    typ_kommunal_ueberlagernd_linie.t_id AS typ,
    linie.geometrie
  FROM
    arp_npl.nutzungsplanung_ueberlagernd_linie AS linie
    JOIN typ_kommunal_ueberlagernd_linie
    ON linie.typ_ueberlagernd_linie = typ_kommunal_ueberlagernd_linie.nutzungsplanung_typ_ueberlagernd_linie_t_id
),
typ_kommunal_ueberlagernd_linie_insert AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_typ
    (
      t_id,
      code,
      bezeichnung,
      abkuerzung,
      verbindlichkeit,
      nutzungsziffer,
      nutzungsziffer_art,
      bemerkungen,
      typ_kt
    )
  SELECT 
    t_id,
    code,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    NULL::float AS nutzungsziffer,
    NULL::text AS nutzungsziffer_art,
    bemerkungen,
    typ_kt
  FROM
    typ_kommunal_ueberlagernd_linie
  RETURNING *
),
linienbezogene_festlegung_insert AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_linienbezogene_festlegung
    (
      t_id,
      publiziertab,
      rechtsstatus,
      bemerkungen,
      typ,
      geometrie
    )
  SELECT
    t_id,
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ,
    geometrie
  FROM
    linienbezogene_festlegung
  RETURNING *
),
/*
 * ÜBERLAGERND LINIE ENDE
 */
/*
 * ÜBERLAGERND PUNKT START
 */
typ_kt_ueberlagernd_punkt AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_typ_kt
    (
      code,
      bezeichnung,
      abkuerzung,
      hauptnutzung_ch
    )
  SELECT
    substring(ilicode FROM 2 FOR 3) AS code, 
    replace(substring(ilicode FROM 6), '_', ' ') AS bezeichnung, 
    substring(ilicode FROM 1 FOR 4) AS abkuerzung,
    hn.t_id AS hauptnutzung_ch
  FROM
    arp_npl.nutzungsplanung_np_typ_kanton_ueberlagernd_punkt AS pn
    LEFT JOIN 
      arp_npl_mgdm.hauptnutzung_ch_hauptnutzung_ch AS hn
      ON 
        hn.code::text = substring(ilicode FROM 2 FOR 2)
  RETURNING *
),
typ_kommunal_ueberlagernd_punkt AS 
(
  SELECT 
    nextval('arp_npl_mgdm.t_ili2db_seq'::regclass) AS t_id,
    typ.t_id AS nutzungsplanung_typ_ueberlagernd_punkt_t_id,
    typ.code_kommunal AS code,
    typ.bezeichnung,
    typ.abkuerzung,
    typ.verbindlichkeit,
    typ.bemerkungen,
    typ_kt_ueberlagernd_punkt.t_id AS typ_kt
  FROM
    arp_npl.nutzungsplanung_typ_ueberlagernd_punkt AS typ
    JOIN
      typ_kt_ueberlagernd_punkt
      ON
        typ_kt_ueberlagernd_punkt.code = substring(typ.typ_kt FROM 2 FOR 3)
),
objektbezogene_festlegung AS 
(
  SELECT
    nextval('arp_npl_mgdm.t_ili2db_seq'::regclass) AS t_id,
    punkt.t_id AS nutzungsplanung_ueberlagernd_punkt_t_id,
    punkt.publiziertab,
    punkt.rechtsstatus,
    punkt.bemerkungen,
    typ_kommunal_ueberlagernd_punkt.t_id AS typ,
    punkt.geometrie
  FROM
    arp_npl.nutzungsplanung_ueberlagernd_punkt AS punkt
    JOIN typ_kommunal_ueberlagernd_punkt
    ON punkt.typ_ueberlagernd_punkt = typ_kommunal_ueberlagernd_punkt.nutzungsplanung_typ_ueberlagernd_punkt_t_id
),
typ_kommunal_ueberlagernd_punkt_insert AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_typ
    (
      t_id,
      code,
      bezeichnung,
      abkuerzung,
      verbindlichkeit,
      nutzungsziffer,
      nutzungsziffer_art,
      bemerkungen,
      typ_kt
    )
  SELECT 
    t_id,
    code,
    bezeichnung,
    abkuerzung,
    verbindlichkeit,
    NULL::float AS nutzungsziffer,
    NULL::text AS nutzungsziffer_art,
    bemerkungen,
    typ_kt
  FROM
    typ_kommunal_ueberlagernd_punkt
  RETURNING *
),
objektbezogene_festlegung_insert AS
(
  INSERT INTO arp_npl_mgdm.geobasisdaten_objektbezogene_festlegung
    (
      t_id,
      publiziertab,
      rechtsstatus,
      bemerkungen,
      typ,
      geometrie
    )
  SELECT
    t_id,
    publiziertab,
    rechtsstatus,
    bemerkungen,
    typ,
    geometrie
  FROM
    objektbezogene_festlegung
  RETURNING *
)
/*
 * ÜBERLAGERND PUNKT ENDE
 */
SELECT 1 AS foo;
