--Adresse für das Projekt Zivilschutz; für Frima Om Computer
WITH
adressen AS (
    SELECT
        DISTINCT ON (a.strassenname, a.hausnummer, a.ortschaft) -- in Tabelle adressen.adressen gibt es doppelte Adresse wegen EO.Flaechenelement
        a.t_id,
        a.strassenname AS lokalisationsname,
        a.hausnummer,
        a.plz AS plz,
        a.ortschaft,
        g.gemeindename AS gemeinde,
        a.egid AS gwr_egid,
        a.edid AS gwr_edid,
        ST_X(a.lage) AS koord_ost,
        st_y(a.lage) AS koord_nord,
        a.astatus AS status,
        b.geometrie AS gwr_egid_geom,
        a.lage AS gwr_edid_geom,
        a.bfs_nr
    FROM
        agi_mopublic_pub.mopublic_gebaeudeadresse AS a
    LEFT JOIN agi_mopublic_pub.mopublic_bodenbedeckung AS b
        ON 
        a.lage && b.geometrie
        AND
        st_distance(a.lage, b.geometrie) = 0
    LEFT JOIN agi_mopublic_pub.mopublic_gemeindegrenze AS g
        ON a.bfs_nr = g.bfs_nr
    WHERE
        a.hausnummer IS NOT NULL -- nur die mit Hausnummern
    AND
        b.art_txt = 'Gebaeude'
),
grundstueck AS (
    SELECT
        ls.nummer AS grundstuecknummer,
        ls.geometrie,
        g.aname AS grundbuchkreis,
        ls.bfs_nr
    FROM
        agi_mopublic_pub.mopublic_grundstueck AS ls
    LEFT JOIN agi_av_gb_admin_einteilung_pub.grundbuchkreise_grundbuchkreis AS g
        ON g.nbident = ls.nbident
),
geb_objektnamen AS (
    SELECT
        a.t_id,
        STRING_AGG(o.objektname, ', ') AS objektname -- mehrere Objektnamen pro BB.Gebäude möglich
    FROM adressen AS a
    JOIN
        agi_mopublic_pub.mopublic_objektname_pos AS o 
        ON 
        o.pos && a.gwr_egid_geom
        AND
        st_distance(o.pos, a.gwr_egid_geom) = 0
    GROUP BY
        a.t_id
)

INSERT INTO amb_zivilschutz_adressen_staging_pub.adressen_zivilschutz
(
    SELECT
    a.lokalisationsname,
    a.hausnummer,
        a.plz,
        a.ortschaft,
        a.gemeinde,
        a.gwr_egid,
        a.gwr_edid,
        a.koord_ost,
        a.koord_nord,
        a.status,
        o.objektname,
        g.grundstuecknummer,
        g.grundbuchkreis
    FROM
        adressen AS a
        LEFT JOIN
        geb_objektnamen AS o
        ON a.t_id = o.t_id,
        grundstueck AS g
    WHERE
        a.gwr_edid_geom && g.geometrie
        AND
        st_distance(a.gwr_edid_geom, g.geometrie) = 0
        AND
        a.bfs_nr = g.bfs_nr
)
;