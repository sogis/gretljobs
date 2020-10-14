SELECT
    reservate_pflanze.wissenschaftlicher_name,
    reservate_pflanze.deutscher_name,
    reservate_pflanze.geschuetzt,
    reservate_pflanze.rote_liste,
    reservate_erhebung.jahr,
    reservate_erhebung.projekt,
    reservate_teilgebiet.teilgebietsname AS teilgebietsname,
    reservate_reservat.nummer AS reservatsnummer,
    reservate_teilgebiet.t_id AS teilgebietsnummer
FROM
    arp_naturreservate.reservate_pflanze_erhebung
    LEFT JOIN arp_naturreservate.reservate_pflanze
        ON reservate_pflanze.t_id = reservate_pflanze_erhebung.pflanze
    LEFT JOIN arp_naturreservate.reservate_erhebung
        ON reservate_erhebung.t_id = reservate_pflanze_erhebung.erhebung
    LEFT JOIN arp_naturreservate.reservate_teilgebiet_erhebung
        ON  reservate_erhebung.t_id = reservate_teilgebiet_erhebung.erhebung
    LEFT JOIN arp_naturreservate.reservate_teilgebiet
        ON  reservate_teilgebiet.t_id = reservate_teilgebiet_erhebung.teilgebiet
    LEFT JOIN arp_naturreservate.reservate_reservat
        ON reservate_reservat.t_id = reservate_teilgebiet.reservat
