SELECT
  kreis.aname AS aname,
  kreis.art AS art,
  kreis.nbident AS nbident,
  kreis.grundbuchkreisnummer AS grundbuchkreisnummer,
  kreis.grundbuchkreis_bfsnr AS grundbuchkreis_bfsnr,
  kreis.bfsnr AS bfsnr,
  kreis.perimeter,
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
  agi_av_gb_administrative_einteilungen_v2.grundbuchkreise_grundbuchkreis AS kreis
  LEFT JOIN agi_av_gb_administrative_einteilungen_v2.grundbuchkreise_grundbuchamt AS amt
  ON kreis.r_grundbuchamt = amt.t_id
;