WITH nummerierungsbereich AS
(
  SELECT
    nbgeometrie.gem_bfs,
    nbbereich.kt_txt || nbbereich.nbnummer AS nbident,
    ST_Multi(ST_Union(nbgeometrie.geometrie)) AS geometrie,
    gemeindegrenze.gemeindename
  FROM
    av_avdpool_ng.nummerierungsbereiche_nbgeometrie AS nbgeometrie
    LEFT JOIN av_avdpool_ng.nummerierungsbereiche_nummerierungsbereich AS nbbereich
    ON nbgeometrie.nbgeometrie_von = nbbereich.tid
    LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
    ON nbgeometrie.gem_bfs = gemeindegrenze.bfs_gemeindenummer
  WHERE
    nbbereich.kt_txt =  'SO'
  GROUP BY
    nbgeometrie.gem_bfs,
    nbbereich.kt_txt,
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
  nummerierungsbereich.geometrie AS perimeter,
  amt.amtschreiberei AS amtschreiberei,
  amt.amt AS amt,
  amt.strasse AS strasse,
  amt.hausnummer AS hausnummer,
  amt.plz AS plz,
  amt.ortschaft AS ortschaft,
  amt.telefon AS telefon,
  amt.web AS web,
  amt.email AS email,
  amt.uid AS uid
FROM
  agi_av_gb_administrative_einteilungen.grundbuchkreise_grundbuchkreis AS kreis
  LEFT JOIN agi_av_gb_administrative_einteilungen.grundbuchkreise_grundbuchamt AS amt
  ON kreis.r_grundbuchamt = amt.t_id
  LEFT JOIN nummerierungsbereich
  ON nummerierungsbereich.gem_bfs = kreis.bfsnr AND nummerierungsbereich.nbident = kreis.nbident
;