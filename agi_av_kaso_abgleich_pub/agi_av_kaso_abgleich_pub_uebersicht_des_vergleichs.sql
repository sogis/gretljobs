SELECT
    t_id,
    geometrie,
    gem_bfs,
    aname AS name,
    anzahl_differenzen
FROM
    agi_av_kaso_abgleich_import.uebersicht_des_vergleichs_staging
;
