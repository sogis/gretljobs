--Adresse für das Projekt Zivilschutz; für Frima Om Computer
WITH
adressen AS (
    SELECT
        DISTINCT ON (a.str_name, a.hausnummer, a.ortschaft) -- in Tabelle adressen.adressen gibt es doppelte Adresse wegen EO.Flaechenelement
        a.ogc_fid,
        a.str_name AS lokalisationsname,
        a.hausnummer,
        a.plz4 As plz,
        a.ortschaft,
        a.gem_name AS gemeinde,
        a.gwr_egid,
        a.gwr_edid,
        a.koord_lv95_x AS koord_ost,
        a.koord_lv95_y  AS koord_nord,
        a.status_txt AS status,
        a.gwr_egid_geom,
        a.gwr_edid_geom,
        a.gem_bfs
    FROM
        adressen.adressen AS a
    WHERE
        a.archive = 0  -- nur die aktuellen
        AND
        a.hausnummer is not null -- nur die mit Hausnummern
),
grundstueck AS (
    SELECT
        ls.nummer AS grundstuecknummer,
        ls.geometrie,
        g.grundbuch AS grundbuchkreis,
        ls.gem_bfs
    FROM
        av_avdpool_ng.v_liegenschaften_liegenschaft AS ls
    LEFT JOIN av_grundbuch.grundbuchkreise AS g
        ON g.nbident = ls.nbident
),
geb_objektnamen AS (
    SELECT
        a.ogc_fid,
        STRING_AGG(o.name, ', ') as objektname -- mehrere Objektnamen pro BB.Gebäude möglich
    FROM adressen AS a,
        av_avdpool_ng.bodenbedeckung_objektname AS o
    LEFT JOIN
        av_avdpool_ng.bodenbedeckung_boflaeche AS b
        ON b.tid = o.objektname_von
    WHERE
        b.art = 0 -- nur die Objektnamen die einem Gebäude zugewiesen sind
        AND
        a.gwr_edid_geom && b.geometrie
        AND
        st_distance(a.gwr_egid_geom, b.geometrie) = 0
    GROUP BY
        a.ogc_fid
)

INSERT INTO amb_zivilschutz_adressen_staging.adressen_zivilschutz
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
        ON a.ogc_fid = o.ogc_fid,
        grundstueck AS g
    WHERE
        a.gwr_edid_geom && g.geometrie
        AND
        st_distance(a.gwr_edid_geom, g.geometrie) = 0
        AND
        a.gem_bfs = g.gem_bfs
)
;
