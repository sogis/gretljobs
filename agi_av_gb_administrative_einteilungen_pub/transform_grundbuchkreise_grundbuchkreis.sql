WITH nummerierungsbereich AS
(
  SELECT
    nbgeometrie.t_datasetname,
    nbbereich.kt || nbbereich.nbnummer AS nbident,
    ST_Multi(ST_Union(ST_CurveToLine(nbgeometrie.geometrie, 32, 0, 1))) AS geometrie,
    gemeindegrenze.gemeindename
  FROM
    agi_dm01avso24.nummerierngsbrche_nbgeometrie AS nbgeometrie
    LEFT JOIN agi_dm01avso24.nummerierngsbrche_nummerierungsbereich AS nbbereich
    ON nbgeometrie.nbgeometrie_von = nbbereich.t_id
    LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
    ON nbgeometrie.t_datasetname = gemeindegrenze.bfs_gemeindenummer::text
  WHERE
    nbbereich.kt =  'SO'
  GROUP BY
    nbgeometrie.t_datasetname,
    nbbereich.kt,
    nbbereich.nbnummer,
    gemeindegrenze.gemeindename
)
SELECT
  kreis.aname AS aname,
  kreis.art AS art,
  kreis.nbident AS nbident,
  kreis.grundbuchkreisnummer AS grundbuchkreisnummer,
  kreis.grundbuchkreis_bfsnr AS grundbuchkreis_bfsnr,
  kreis.bfsnr AS bfsnr,
  ST_Multi(ST_Buffer(ST_SnapToGrid(nummerierungsbereich.geometrie, 0.001), 0)) AS perimeter,
  amt.amtschreiberei AS amtschreiberei,
  amt.amt AS amt,
  amt.strasse AS strasse,
  amt.hausnummer AS hausnummer,
  amt.plz AS plz,
  amt.ortschaft AS ortschaft,
  amt.telefon AS telefon,
  amt.web AS web,
  amt.email AS email,
  amt.auid
FROM
  agi_av_gb_admin_einteilung.grundbuchkreise_grundbuchkreis AS kreis
  LEFT JOIN agi_av_gb_admin_einteilung.grundbuchkreise_grundbuchamt AS amt
  ON kreis.r_grundbuchamt = amt.t_id
  LEFT JOIN nummerierungsbereich
  ON nummerierungsbereich.t_datasetname::integer = kreis.bfsnr AND nummerierungsbereich.nbident = kreis.nbident
;
