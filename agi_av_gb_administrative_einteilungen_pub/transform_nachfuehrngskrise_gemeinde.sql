SELECT
  gemeindegrenze.gemeindename AS gemeindename,
  gemeinde.bfsnr AS bfsnr,
  gemeindegrenze.geometrie AS perimeter,
  geometer.aname AS nfg_name,
  geometer.vorname AS nfg_vorname,
  geometer.titel AS nfg_titel,
  standort.firma AS firma,
  standort.firma_zusatz AS firma_zusatz,
  standort.strasse AS strasse,
  standort.hausnummer AS hausnummer,
  standort.plz AS plz,
  standort.ortschaft AS ortschaft,
  standort.telefon AS telefon,
  standort.web AS web,
  standort.email AS email,
  standort.uid AS uid
FROM
  agi_av_gb_administrative_einteilungen.nachfuehrngskrise_gemeinde AS gemeinde
  LEFT JOIN agi_av_gb_administrative_einteilungen.nachfuehrngskrise_nachfuehrungsgeometer AS geometer
  ON gemeinde.r_geometer = geometer.t_id
  LEFT JOIN agi_av_gb_administrative_einteilungen.nachfuehrngskrise_standort AS standort
  ON gemeinde.r_standort = standort.t_id
  LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
  ON gemeinde.bfsnr = gemeindegrenze.bfs_gemeindenummer
;
