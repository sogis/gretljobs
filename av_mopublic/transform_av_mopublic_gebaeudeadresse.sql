/*
 * PLZ/Ortschaft wird noch nicht berücksichtigt.
 * Datenablage/-organisation in sogis-DB ist noch
 * unbefriedigend und alt.
 */

/*
 * PLZ/Ortschaft wird noch nicht berücksichtigt.
 * Datenablage/-organisation in sogis-DB ist noch
 * unbefriedigend und alt.
 */

WITH strassenname AS (
    SELECT 
        lok.tid AS lok_tid,
        lokname."text" AS strassenname
    FROM
        av_avdpool_ng.gebaeudeadressen_lokalisation AS lok
        LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisationsname AS lokname
        ON lokname.benannte = lok.tid   
),
gebaeudeeingang AS (
    SELECT
        g.gebaeudeeingang_von AS lok_tid,
        g.hoehenlage,
        g.lage,
        g.hausnummer,
        g.gwr_egid AS egid,
        g.gwr_edid AS edid,
        g.status_txt AS status,
        CASE 
            WHEN istoffiziellebezeichnung_txt = 'ja' THEN TRUE
            ELSE FALSE 
        END AS ist_offizielle_bezeichnung,
        n."text" AS gebaeudename, -- always empty?
        g.gem_bfs AS bfs_nr,
        CASE
            WHEN h.ori IS NULL THEN (100 - 100) * 0.9
            ELSE (100 - h.ori) * 0.9 
        END AS orientierung,
        CASE 
            WHEN h.hali_txt IS NULL THEN 'Center'
            ELSE h.hali_txt
        END AS hali,
        CASE 
            WHEN h.vali_txt IS NULL THEN 'Half'
            ELSE h.vali_txt
        END AS vali,
        g.lieferdatum AS importdatum,
        to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
        h.pos
    FROM
        av_avdpool_ng.gebaeudeadressen_gebaeudeeingang AS g
        LEFT JOIN av_avdpool_ng.gebaeudeadressen_hausnummerpos AS h
        ON h.hausnummerpos_von = g.tid
        LEFT JOIN av_avdpool_ng.gebaeudeadressen_gebnachfuehrung AS nf
        ON g.entstehung = nf.tid
        LEFT JOIN av_avdpool_ng.gebaeudeadressen_gebaeudename AS n 
        ON n.gebaeudename_von = g.tid
),
gebaeudeeingang_strassenname AS
(
    SELECT
        s.lok_tid, 
        s.strassenname, 
        g.hoehenlage, 
        g.lage, 
        g.hausnummer, 
        g.egid, 
        g.edid,
        g.status,
        g.ist_offizielle_bezeichnung,
        g.gebaeudename,
        g.bfs_nr, 
        g.orientierung,
        g.hali,
        g.vali,
        g.importdatum,
        g.nachfuehrung,
        g.pos
    FROM
        strassenname AS s
        RIGHT JOIN gebaeudeeingang AS g
        ON s.lok_tid = g.lok_tid
)
SELECT 
    s.strassenname,
    s.hausnummer,
    s.egid,
    s.edid,
    -1 AS plz,
    'fubar' AS ortschaft,
    s.status,
    s.ist_offizielle_bezeichnung,
    s.hoehenlage,
    s.gebaeudename,
    s.bfs_nr,
    s.orientierung,
    s.hali,
    s.vali,
    s.importdatum,
    s.nachfuehrung,
    s.lage,
    s.pos
FROM
    gebaeudeeingang_strassenname AS s;