--Pflanzenliste
DELETE FROM
    arp_naturreservate_staging_v1.naturreservate_pflanzenliste
;

--Reservat
DELETE FROM
    arp_naturreservate_staging_v1.naturreservate_reservat
;

--Teilgebiet
DELETE FROM
    arp_naturreservate_staging_v1.naturreservate_teilgebiet
;

-- Basket / Dataset 
DELETE FROM
    arp_naturreservate_staging_v1.t_ili2db_basket
;

DELETE FROM
    arp_naturreservate_staging_v1.t_ili2db_dataset
;