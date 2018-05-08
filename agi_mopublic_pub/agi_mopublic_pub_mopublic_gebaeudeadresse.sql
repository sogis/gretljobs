WITH strassenname AS (
  SELECT 
    lokalisation.tid AS lok_tid,
    lokalisationsname."text" AS strassenname
  FROM
    av_avdpool_ng.gebaeudeadressen_lokalisation AS lokalisation
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisationsname AS lokalisationsname
    ON lokalisationsname.benannte = lokalisation.tid
  WHERE lokalisation.istoffiziellebezeichnung = 0
),
gebaeudeeingang AS (
  SELECT
    gebauedeeingang.gebaeudeeingang_von AS lok_tid,
    gebauedeeingang.hoehenlage,
    gebauedeeingang.lage,
    gebauedeeingang.hausnummer,
    gebauedeeingang.gwr_egid AS egid,
    gebauedeeingang.gwr_edid AS edid,
    gebauedeeingang.status_txt AS status,
    CASE 
      WHEN istoffiziellebezeichnung_txt = 'ja' 
        THEN TRUE
      ELSE FALSE 
    END AS ist_offizielle_bezeichnung,
    name."text" AS gebaeudename, -- always empty?
    gebauedeeingang.gem_bfs AS bfs_nr,
    CASE
      WHEN hausnummer.ori IS NULL 
        THEN (100 - 100) * 0.9
      ELSE (100 - hausnummer.ori) * 0.9 
    END AS orientierung,
    CASE 
      WHEN hausnummer.hali_txt IS NULL 
        THEN 'Center'
      ELSE hausnummer.hali_txt
    END AS hali,
    CASE 
      WHEN hausnummer.vali_txt IS NULL 
        THEN 'Half'
      ELSE hausnummer.vali_txt
    END AS vali,
    gebauedeeingang.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    hausnummer.pos
FROM
    av_avdpool_ng.gebaeudeadressen_gebaeudeeingang AS gebauedeeingang
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_hausnummerpos AS hausnummer
    ON hausnummer.hausnummerpos_von = gebauedeeingang.tid
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_gebnachfuehrung AS nachfuehrung
    ON gebauedeeingang.entstehung = nachfuehrung.tid
    LEFT JOIN av_avdpool_ng.gebaeudeadressen_gebaeudename AS name
    ON name.gebaeudename_von = gebauedeeingang.tid
),
gebaeudeeingang_strassenname AS
(
  SELECT
    strassenname.lok_tid, 
    strassenname.strassenname, 
    gebaeudeeingang.hoehenlage, 
    gebaeudeeingang.lage, 
    gebaeudeeingang.hausnummer, 
    gebaeudeeingang.egid, 
    gebaeudeeingang.edid,
    gebaeudeeingang.status,
    gebaeudeeingang.ist_offizielle_bezeichnung,
    gebaeudeeingang.gebaeudename,
    gebaeudeeingang.bfs_nr, 
    gebaeudeeingang.orientierung,
    gebaeudeeingang.hali,
    gebaeudeeingang.vali,
    gebaeudeeingang.importdatum,
    gebaeudeeingang.nachfuehrung,
    gebaeudeeingang.pos
  FROM
    strassenname
    RIGHT JOIN gebaeudeeingang
    ON strassenname.lok_tid = gebaeudeeingang.lok_tid
),
gebaeudeeingang_strassenname_plz_ortschaft AS 
(
  SELECT
    gebaeudeeingang_strassenname.lok_tid, 
    gebaeudeeingang_strassenname.strassenname, 
    gebaeudeeingang_strassenname.hoehenlage, 
    gebaeudeeingang_strassenname.lage, 
    gebaeudeeingang_strassenname.hausnummer, 
    gebaeudeeingang_strassenname.egid, 
    gebaeudeeingang_strassenname.edid,
    gebaeudeeingang_strassenname.status,
    gebaeudeeingang_strassenname.ist_offizielle_bezeichnung,
    gebaeudeeingang_strassenname.gebaeudename,
    gebaeudeeingang_strassenname.bfs_nr, 
    gebaeudeeingang_strassenname.orientierung,
    gebaeudeeingang_strassenname.hali,
    gebaeudeeingang_strassenname.vali,
    gebaeudeeingang_strassenname.importdatum,
    gebaeudeeingang_strassenname.nachfuehrung,
    gebaeudeeingang_strassenname.pos,
    plz.plz,
    ortschaftsname.atext AS ortschaft
  FROM
    gebaeudeeingang_strassenname
    LEFT JOIN agi_plz_ortschaften.plzortschaft_plz6 AS plz
    ON ST_Intersects(gebaeudeeingang_strassenname.lage, plz.flaeche)
    LEFT JOIN agi_plz_ortschaften.plzortschaft_ortschaft AS ortschaft
    ON ST_Intersects(gebaeudeeingang_strassenname.lage, ortschaft.flaeche)
    LEFT JOIN agi_plz_ortschaften.plzortschaft_ortschaftsname AS ortschaftsname
    ON ortschaftsname.ortschaftsname_von = ortschaft.t_id
    WHERE 
      plz.status = 'real'
      AND
      ortschaft.status = 'real'
      AND 
      strassenname IS NOT NULL
      AND
      hausnummer IS NOT NULL
)
SELECT
  gebaeudeeingang_strassenname_plz_ortschaft.strassenname,
  gebaeudeeingang_strassenname_plz_ortschaft.hausnummer,
  gebaeudeeingang_strassenname_plz_ortschaft.egid,
  gebaeudeeingang_strassenname_plz_ortschaft.edid,
  gebaeudeeingang_strassenname_plz_ortschaft.plz,
  gebaeudeeingang_strassenname_plz_ortschaft.ortschaft,
  gebaeudeeingang_strassenname_plz_ortschaft.status,
  gebaeudeeingang_strassenname_plz_ortschaft.ist_offizielle_bezeichnung,
  gebaeudeeingang_strassenname_plz_ortschaft.hoehenlage,
  gebaeudeeingang_strassenname_plz_ortschaft.gebaeudename,
  gebaeudeeingang_strassenname_plz_ortschaft.bfs_nr,
  gebaeudeeingang_strassenname_plz_ortschaft.orientierung,
  gebaeudeeingang_strassenname_plz_ortschaft.hali,
  gebaeudeeingang_strassenname_plz_ortschaft.vali,
  gebaeudeeingang_strassenname_plz_ortschaft.importdatum,
  gebaeudeeingang_strassenname_plz_ortschaft.nachfuehrung,
  gebaeudeeingang_strassenname_plz_ortschaft.lage,
  gebaeudeeingang_strassenname_plz_ortschaft.pos

FROM
  gebaeudeeingang_strassenname_plz_ortschaft
;