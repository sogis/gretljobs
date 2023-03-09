-- Falls Polygonschwerpunkt der Vereinbarung in Polygon von Sömmerungsgebiet
-- liegt muss das Attribut Sömmerungsgebiet auf True gesetzt werden
-- ggfs wird Vereinbarungsart auf Weide_SOEG korrigiert, falls Vereinbarungsart
-- vorher Weide_LN war
WITH lwzon AS (
    SELECT
       zgfl.flaeche AS geometrie,
       typ.typ_de
    FROM
       alw_zonengrenzen.zonengrenzen_lz_flaeche zgfl
       LEFT JOIN alw_zonengrenzen.lz_kataloge_lz_katalog_typ typ
         ON zgfl.typ = typ.t_id
      WHERE typ.typ_de = 'Sömmerungsgebiet'
)
UPDATE
     {DB_Schema_MJPNL}.mjpnl_vereinbarung vb
  SET
     soemmerungsgebiet = True,
     vereinbarungsart = CASE WHEN vereinbarungsart = 'Weide_LN' THEN 'Weide_SOEG' ELSE vereinbarungsart END
  FROM lwzon
    WHERE ST_Within(ST_PointOnSurface(vb.geometrie),lwzon.geometrie)
;
