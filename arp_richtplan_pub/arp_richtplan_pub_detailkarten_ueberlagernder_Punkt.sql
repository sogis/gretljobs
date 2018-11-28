/*Zentrumsstruktur - Raumkonzept */
SELECT
    detailkarten_ueberlagernder_punkt.t_ili_tid,
    detailkarten_ueberlagernder_punkt.objekttyp,
    detailkarten_ueberlagernder_punkt.status,
    detailkarten_ueberlagernder_punkt.geometrie,
    hoheitsgrenzen_gemeindegrenze.gemeindename AS gemeindename
FROM
    arp_richtplan.detailkarten_ueberlagernder_punkt,
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
WHERE
    ST_DWithin(detailkarten_ueberlagernder_punkt.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    AND
    ST_Within(detailkarten_ueberlagernder_punkt.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie)
    AND
    objekttyp != 'Freizeitnutzung'

UNION ALL

/*Freizeitnutzungen konzentrieren - Raumkonzept*/
SELECT
    t_ili_tid,
    objekttyp,
    status,
    geometrie,
    NULL AS gemeindename
FROM
    arp_richtplan.detailkarten_ueberlagernder_punkt
WHERE
    objekttyp = 'Freizeitnutzung'
;