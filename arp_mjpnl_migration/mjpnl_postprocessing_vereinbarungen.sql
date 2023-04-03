--neue Vereinbarungs-Nummern setzen
--zusammengesetzter Wert aus bezirknr_vereinbarungsart_zaehler-pro-vbgart-bezirk
--wobei bei den Bezirksnr nur die letzten 2 Stellen berücksichtigt werden
--und bei der Vereinbarungsart eine Abkürzung verwendet wird (siehe CASE Statement unten)
UPDATE
   arp_mjpnl_v1.mjpnl_vereinbarung AS vbg
     SET vereinbarungs_nr=(
       WITH bezvbart AS (
            SELECT
                 --BezirksNr (letzte 2 Ziffern)
                 substring(bezirksnummer::TEXT,3,2) || '_' ||
                 --Vereinbarungsart (abgekürzt)
                 CASE
                   WHEN vbg.vereinbarungsart = 'Wiese' THEN 'Wi'
                   WHEN vbg.vereinbarungsart = 'Weide_LN' THEN 'WeLN'
                   WHEN vbg.vereinbarungsart = 'Weide_SOEG' THEN 'WeSöG'
                   WHEN vbg.vereinbarungsart = 'Hecke' THEN 'He'
                   WHEN vbg.vereinbarungsart = 'Lebhag' THEN 'Le'
                   WHEN vbg.vereinbarungsart = 'Hostet' THEN 'Ho'
                   WHEN vbg.vereinbarungsart = 'OBL' THEN 'OBL'
                   WHEN vbg.vereinbarungsart = 'WBL_Wiese' THEN 'WBLWi'
                   WHEN vbg.vereinbarungsart = 'WBL_Weide' THEN 'WBLWe'
                   WHEN vbg.vereinbarungsart = 'ALR_Buntbrache' THEN 'ALRB'
                   WHEN vbg.vereinbarungsart = 'ALR_Saum' THEN 'ALRS'
                 END AS beznr_vbart          
            FROM
                 agi_hoheitsgrenzen_pub.hoheitsgrenzen_bezirksgrenze bez
            WHERE
                ST_Within(ST_PointOnSurface(vbg.geometrie),bez.geometrie)
       )
       SELECT
         --BezirksNr (letzte 2 Ziffern)
         bez.beznr_vbart || '_' ||
         (SELECT
            lpad((COALESCE(MAX((SELECT (string_to_array(vereinbarungs_nr,'_'))[3])::int4),0) + 1)::TEXT,5,'0') AS maxval
            FROM
                arp_mjpnl_v1.mjpnl_vereinbarung
            WHERE
                starts_with(vereinbarungs_nr,bez.beznr_vbart)
        )
       FROM
         bezvbart bez
     ) 
WHERE
  vbg.mjpnl_version = 'MJPNL_2020'
 --AND vbg.vereinbarungs_nr = 'bla'
  
