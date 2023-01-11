SELECT
    waldplan_bestandeskarte.geometrie,
    id_wp,
    fid_amtei,
    fid_fk,
    fid_fr,
    wirt_zone,
    gem_bfs,
    fid_we,
    gb_flaeche,
    we_text,
    fid_eigcod,
    fid_eig,
    fid_prod,
    wpnr,
    wptyp,
    betriebsteil,
    fid_abt,
    bstnr,
    bsttyp,
    wpinfo,
    bemerkung,
    flae_gis,
    zeitstand,
    beschrift,
    x_beschr,
    y_beschr,
    objnummer,
    weidewald,
    gb_gem_bfs,
    astatus,
    hoheitsgrenzen_gemeindegrenze.gemeindename
FROM
    awjf_waldplan_bestandeskarte_v1.waldplan_bestandeskarte
    LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
        ON hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer = waldplan_bestandeskarte.gem_bfs
WHERE
    astatus = 'abgeschlossen'
OR
    id_wp > 0
;
