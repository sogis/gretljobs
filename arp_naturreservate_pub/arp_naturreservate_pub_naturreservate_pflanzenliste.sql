SELECT
    wissenschaftlicher_name,
    deutscher_name,
    geschuetzt,
    erhebungsjahr,
    erhebungsprojekt,
    rote_liste,
    reservate_teilgebiet.aname AS teilgebietsname,
    reservate_reservat.nummer AS reservatsnummer,
    reservate_teilgebiet.t_id AS teilgebietsnummer
FROM
    arp_naturreservate.reservate_teilgebiet_pflanze
    LEFT JOIN arp_naturreservate.reservate_teilgebiet 
        ON reservate_teilgebiet.t_id = reservate_teilgebiet_pflanze.teilgebiet
    LEFT JOIN arp_naturreservate.reservate_pflanze
        ON reservate_pflanze.t_id = reservate_teilgebiet_pflanze.pflanze
    LEFT JOIN arp_naturreservate.reservate_reservat
        ON reservate_reservat.t_id = reservate_teilgebiet.reservat
;