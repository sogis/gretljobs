
-- *************************************************************************** Korrekturen  ************************************************************************************************************ 

-- GTFS Haltestelennamen korrigieren   -  oevkov siehe auch kurzdoku.doc
BEGIN;
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Allerheiligenberg, Restaurant' WHERE stop_name = 'Allerheiligenberg, Rest. Aller';                                                             -- wie BOGG
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Brügglen SO, Ochsenbeinschmiede' WHERE stop_name = 'Brügglen SO,Ochsenbeinschmiede';                                          -- Leerschlag fehlt im GTFS
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Büsserach, Schulhaus' WHERE stop_name = 'Büsserach, Post'; 
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Grenchen, Alterssiedlung' WHERE stop_name = 'Grenchen, Altersiedlung';                                                                           -- korrekt, wie BGU
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Grenchen, Maria-Schürer-Strasse' WHERE stop_name = 'Grenchen, M. Schürer-Strasse';                                                      -- wie BGU
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Hofstetten SO, Witterswilerstr.' WHERE stop_name = 'Hofstetten SO,Witterswilerstr.';                                                         -- Leerschlag fehlt im GTFS
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Kyburg, Bad' WHERE stop_name = 'Kyburg Bad'; 
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Lostorf, Mitte' WHERE stop_name = 'Lostorf, Mahrenstrasse'; 
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Nunningen, Musslistrasse' WHERE stop_name = 'Nunningen, Mussliweg';
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Olten, Hammer' WHERE stop_name = 'Olten, Hammer BOGG';                                                                                              -- wie BOGG
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Schönenwerd SO, Schachenstrasse' WHERE stop_name = 'Schönenwerd SO, Schachenstrass';
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Schönenwerd SO, Schenker Storen' WHERE stop_name = 'Schönenwerd SO,Schenker Storen';                                            -- Leerschlag fehlt im GTFS
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Solothurn, Zuchwilerstrasse/Bahnhof' WHERE stop_name = 'Solothurn, Zuchwilerstr./Bhf'; 
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Starrkirch-Wil, Gemeindezentrum' WHERE stop_name = 'Starrkirch-Wil,Gemeindezentrum';                                               -- Leerschlag fehlt im GTFS
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Trimbach, Zentrum' WHERE stop_name = 'Trimbach, Post';
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Staad (Grenchen), Staadstr. 186' WHERE stop_name = 'Staad (Grenchen), Staadstr.186';                                                    -- Leerschlag fehlt im GTF
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Wangen b. Olten, Bahnhof' WHERE stop_name = 'Wangen bei Olten, Bahnhof';                                                                    -- wie BOGG, fällt weg ab 9.12.2019
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Welschenrohr, Zentrum' WHERE stop_name = 'Welschenrohr, Post'; 
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Welschenrohr, Zelgli' WHERE stop_name = 'Welschenrohr, Rotschihaus'; 
UPDATE avt_oevkov_2019.gtfs_stop SET stop_name = 'Zuchwil, Langfeld' WHERE stop_name = 'Zuchwil, Mc Donald''s';


DELETE FROM avt_oevkov_2019.gtfs_stoptime WHERE stop_id IN (SELECT stop_id FROM avt_oevkov_2019.gtfs_stop WHERE stop_name LIKE '% BSG');
DELETE FROM  avt_oevkov_2019.gtfs_stop WHERE stop_name LIKE '% BSG';


--trip_headsign auch anpassen
UPDATE avt_oevkov_2019.gtfs_trip SET trip_headsign = 'Lostorf, Mitte' WHERE trip_headsign = 'Lostorf, Mahrenstrasse';
UPDATE avt_oevkov_2019.gtfs_trip SET trip_headsign = 'Starrkirch-Wil, Gemeindezentrum'WHERE trip_headsign = 'Starrkirch-Wil,Gemeindezentrum';
UPDATE avt_oevkov_2019.gtfs_trip SET trip_headsign = 'Welschenrohr, Zentrum' WHERE trip_headsign = 'Welschenrohr, Post';
UPDATE avt_oevkov_2019.gtfs_trip SET trip_headsign = 'Zuchwil, Langfeld' WHERE trip_headsign = 'Zuchwil, Mc Donald''s';