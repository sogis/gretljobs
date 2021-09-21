WITH strassenname AS (
SELECT 
    lokalisation.t_id AS lok_t_id,
    lokalisationsname.atext AS strassenname
FROM
    agi_dm01avso24.gebaeudeadressen_lokalisation AS lokalisation
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisationsname AS lokalisationsname
    ON lokalisationsname.benannte = lokalisation.t_id
WHERE lokalisation.istoffiziellebezeichnung = 'ja'
),
aimport AS
(
    SELECT
        max(importdate) AS importdate, dataset
    FROM
        agi_dm01avso24.t_ili2db_import
    GROUP BY
        dataset 
),
gebaeudeeingang AS (
SELECT
    gebauedeeingang.gebaeudeeingang_von AS lok_t_id,
    gebauedeeingang.hoehenlage,
    gebauedeeingang.lage,
    gebauedeeingang.hausnummer,
    gebauedeeingang.gwr_egid AS egid,
    gebauedeeingang.gwr_edid AS edid,
    gebauedeeingang.astatus AS astatus,
    CASE 
    WHEN istoffiziellebezeichnung = 'ja' 
        THEN TRUE
    ELSE FALSE 
    END AS ist_offizielle_bezeichnung,
    aname.atext AS gebaeudename, -- always empty?
    CAST(gebauedeeingang.t_datasetname AS INT) AS bfs_nr,    
    CASE
    WHEN hausnummer.ori IS NULL 
        THEN (100 - 100) * 0.9
    ELSE (100 - hausnummer.ori) * 0.9 
    END AS orientierung,
    CASE 
    WHEN hausnummer.hali IS NULL 
        THEN 'Center'
    ELSE hausnummer.hali
    END AS hali,
    CASE 
    WHEN hausnummer.vali IS NULL 
        THEN 'Half'
    ELSE hausnummer.vali
    END AS vali,
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    hausnummer.pos
FROM
    agi_dm01avso24.gebaeudeadressen_gebaeudeeingang AS gebauedeeingang
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_hausnummerpos AS hausnummer
    ON hausnummer.hausnummerpos_von = gebauedeeingang.t_id
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_gebnachfuehrung AS nachfuehrung
    ON gebauedeeingang.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_gebaeudename AS aname
    ON aname.gebaeudename_von = gebauedeeingang.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
    ON gebauedeeingang.t_basket = basket.t_id
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    
),
gebaeudeeingang_strassenname AS
(
SELECT
    strassenname.lok_t_id, 
    strassenname.strassenname, 
    gebaeudeeingang.hoehenlage, 
    gebaeudeeingang.lage, 
    gebaeudeeingang.hausnummer, 
    gebaeudeeingang.egid, 
    gebaeudeeingang.edid,
    gebaeudeeingang.astatus,
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
    ON strassenname.lok_t_id = gebaeudeeingang.lok_t_id
),
gebaeudeeingang_strassenname_plz_ortschaft AS 
(
SELECT
    gebaeudeeingang_strassenname.lok_t_id, 
    gebaeudeeingang_strassenname.strassenname, 
    gebaeudeeingang_strassenname.hoehenlage, 
    gebaeudeeingang_strassenname.lage, 
    gebaeudeeingang_strassenname.hausnummer, 
    gebaeudeeingang_strassenname.egid, 
    gebaeudeeingang_strassenname.edid,
    gebaeudeeingang_strassenname.astatus,
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
    ON plz.plz6_von = ortschaft.t_id
    LEFT JOIN agi_plz_ortschaften.plzortschaft_ortschaftsname AS ortschaftsname
    ON ortschaftsname.ortschaftsname_von = ortschaft.t_id
    WHERE 
    plz.astatus != 'vergangen'
    AND
    ortschaft.astatus != 'vergangen'
)
SELECT
gebaeudeeingang_strassenname_plz_ortschaft.strassenname,
gebaeudeeingang_strassenname_plz_ortschaft.hausnummer,
gebaeudeeingang_strassenname_plz_ortschaft.egid,
gebaeudeeingang_strassenname_plz_ortschaft.edid,
gebaeudeeingang_strassenname_plz_ortschaft.plz,
gebaeudeeingang_strassenname_plz_ortschaft.ortschaft,
gebaeudeeingang_strassenname_plz_ortschaft.astatus AS astatus,
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
