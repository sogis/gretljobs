WITH vbtmp AS (
    -- Hier wird die Kombination Bezirk mit Vereinbarungsart erzeugt
    SELECT
         vb.t_id,
         substring(bezirksnummer::TEXT,3,2) || '_' ||
         --Vereinbarungsart (abgekürzt)
         CASE
           WHEN vb.vereinbarungsart = 'Wiese' THEN 'Wi'
           WHEN vb.vereinbarungsart = 'Weide_LN' THEN 'WeLN'
           WHEN vb.vereinbarungsart = 'Weide_SOEG' THEN 'WeSöG'
           WHEN vb.vereinbarungsart = 'Hecke' THEN 'He'
           WHEN vb.vereinbarungsart = 'Lebhag' THEN 'Le'
           WHEN vb.vereinbarungsart = 'Hostett' THEN 'Ho'
           WHEN vb.vereinbarungsart = 'OBL' THEN 'OBL'
           WHEN vb.vereinbarungsart = 'WBL_Wiese' THEN 'WBLWi'
           WHEN vb.vereinbarungsart = 'WBL_Weide' THEN 'WBLWe'
           WHEN vb.vereinbarungsart = 'ALR_Buntbrache' THEN 'ALRB'
           WHEN vb.vereinbarungsart = 'ALR_Saum' THEN 'ALRS'
         END AS beznr_vbart          
    FROM
      ${DB_Schema_MJPNL}.mjpnl_vereinbarung vb
      LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_bezirksgrenze bez
        ON ST_Within(ST_PointOnSurface(vb.geometrie),bez.geometrie)
),
--Hier werden die Laufnr pro Kombination Bezirk und VBArt erzeugt und temporär gespeichert
vbnr AS (
    SELECT
       t_id,
       beznr_vbart || '_' || lpad((ROW_NUMBER() OVER (PARTITION BY beznr_vbart ORDER BY t_id))::TEXT,5,'0') AS vbnr
      FROM vbtmp
)
-- das eigentliche Update basierend auf den obigen Temporärdaten mit Zählern
UPDATE
     ${DB_Schema_MJPNL}.mjpnl_vereinbarung vb
  SET
     vereinbarungs_nr = vbnr.vbnr
    FROM vbnr
 WHERE vb.mjpnl_version = 'MJPNL_2020'
   AND vb.vereinbarungs_nr = 'bla'
   AND vb.t_id = vbnr.t_id
;
