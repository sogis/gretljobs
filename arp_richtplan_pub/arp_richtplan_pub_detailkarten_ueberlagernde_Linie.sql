/* Detailkarte ueberlagernde Linie
 */
SELECT
    detailkarten_ueberlagernde_linie.t_ili_tid,
    detailkarten_ueberlagernde_linie.objektname,
    detailkarten_ueberlagernde_linie.objekttyp,
    detailkarten_ueberlagernde_linie.abstimmungskategorie,
    detailkarten_ueberlagernde_linie.geometrie
FROM
    arp_richtplan_v1.detailkarten_ueberlagernde_linie
;
