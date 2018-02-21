/*
 * PLZ/Ortschaft wird noch nicht berücksichtigt.
 * Datenablage/-organisation in sogis-DB ist noch
 * unbefriedigend und alt.
 */

WITH strassenname AS (
    SELECT 
        lokalisation.tid AS lok_tid,
        lokalisationsname."text" AS strassenname
    FROM
        av_avdpool_ng.gebaeudeadressen_lokalisation AS lokalisation
        LEFT JOIN av_avdpool_ng.gebaeudeadressen_lokalisationsname AS lokalisationsname
            ON lokalisationsname.benannte = lokalisation.tid   
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
)
SELECT 
    strassenname.strassenname,
    strassenname.hausnummer,
    strassenname.egid,
    strassenname.edid,
    9999 AS plz,
    'Entenhausen' AS ortschaft,
    strassenname.status,
    strassenname.ist_offizielle_bezeichnung,
    strassenname.hoehenlage,
    strassenname.gebaeudename,
    strassenname.bfs_nr,
    strassenname.orientierung,
    strassenname.hali,
    strassenname.vali,
    strassenname.importdatum,
    strassenname.nachfuehrung,
    strassenname.lage,
    strassenname.pos
FROM
    gebaeudeeingang_strassenname AS strassenname
;