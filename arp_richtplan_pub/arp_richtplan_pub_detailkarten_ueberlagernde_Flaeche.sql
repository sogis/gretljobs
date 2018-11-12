SELECT
    detailkarten_ueberlagernde_flaeche.t_ili_tid,
    detailkarten_ueberlagernde_flaeche.objektname,
    detailkarten_ueberlagernde_flaeche.objekttyp,
    detailkarten_ueberlagernde_flaeche.abstimmungskategorie,
    detailkarten_ueberlagernde_flaeche.geometrie,
    string_agg(hoheitsgrenzen_gemeindegrenze.gemeindename, ', ') AS gemeinden
FROM
    arp_richtplan.detailkarten_ueberlagernde_flaeche,
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
WHERE
    ST_DWithin(detailkarten_ueberlagernde_flaeche.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    AND
    ST_Intersects(detailkarten_ueberlagernde_flaeche.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie)
    AND
    objekttyp = 'Freizeit_Sport_Erholung'
GROUP BY
    detailkarten_ueberlagernde_flaeche.t_id

UNION

SELECT
    t_ili_tid,
    objektname,
    objekttyp,
    abstimmungskategorie,
    geometrie,
    NULL AS gemeinden
FROM
    arp_richtplan.detailkarten_ueberlagernde_flaeche
WHERE
    objekttyp != 'Freizeit_Sport_Erholung'
;