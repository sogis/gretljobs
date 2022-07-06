/* Gebiete und Vorhaben Freizeit,Sport und Erholung - Detailkarten
 */
SELECT
    detailkarten_ueberlagernde_flaeche.t_ili_tid,
    detailkarten_ueberlagernde_flaeche.objektname,
    detailkarten_ueberlagernde_flaeche.objekttyp,
    detailkarten_ueberlagernde_flaeche.abstimmungskategorie,
    detailkarten_ueberlagernde_flaeche.geometrie,
    string_agg(hoheitsgrenzen_gemeindegrenze.gemeindename, ', ') AS gemeindenamen
FROM
    arp_richtplan_v1.detailkarten_ueberlagernde_flaeche,
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
WHERE
    ST_DWithin(detailkarten_ueberlagernde_flaeche.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie, 0)
    AND
    ST_Intersects(detailkarten_ueberlagernde_flaeche.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie)
    AND
    objekttyp = 'Freizeit_Sport_Erholung'
GROUP BY
    detailkarten_ueberlagernde_flaeche.t_id

UNION ALL

/* Handlungsräume - Raumkonzept
 * naturnahe Landschaftsräume erhalten (naturnaher_Landschaftsraum) - Raumkonzept
 * Vorranggebiet Landwirtschaft erhalten (landwirtschaftliches_Vorranggebiet) - Raumkonzept
 */
SELECT
    t_ili_tid,
    objektname,
    objekttyp,
    abstimmungskategorie,
    ST_SnapToGrid(geometrie, 0.001) AS geometrie,
    NULL AS gemeinden
FROM
    arp_richtplan_v1.detailkarten_ueberlagernde_flaeche
WHERE
    objekttyp != 'Freizeit_Sport_Erholung'
;