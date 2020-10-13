--Adresse für das Projekt Zivilschutz; für Frima Om Computer
WITH
adressen AS (
    SELECT
        DISTINCT ON (a.strassenname, a.nummer, a.ortschaft) -- in Tabelle adressen.adressen gibt es doppelte Adresse wegen EO.Flaechenelement
        a.t_id,
        a.strassenname AS lokalisationsname,
        a.nummer,
        a.plz4 AS plz,
        a.ortschaft,
        g.gemeindename AS gemeinde,
        a.egid AS gwr_egid,
        a.edid AS gwr_edid,
        ST_X(a.geometrie) AS koord_ost,
        st_y(a.geometrie) AS koord_nord,
        a.astatus,
        b.geometrie AS gwr_egid_geom,
        a.geometrie AS gwr_edid_geom,
        a.bfsnr
    FROM
        agi_swisstopo_gebaeudeadressen_pub.gebaeudeadressen_adresse AS a
    LEFT JOIN agi_mopublic_pub.mopublic_bodenbedeckung AS b
        ON 
        a.geometrie && b.geometrie
        AND
        st_distance(a.geometrie, b.geometrie) = 0
    LEFT JOIN agi_mopublic_pub.mopublic_gemeindegrenze AS g
        ON a.bfsnr::int = g.bfs_nr
    WHERE
        a.nummer IS NOT NULL -- nur die mit Hausnummern
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
        a.astatus,
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
        a.bfsnr = g.bfs_nr
)
;
