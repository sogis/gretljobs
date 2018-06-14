SELECT
    "BFS_Nr" AS bfs_nr,
    TO_NUMBER("Kreis_Nr") AS kreis_nr,
    "Gemeindename" AS gemeindename,
    "Grundstueckart" AS grundstueckart,
    "Grundstueck_Nr" AS grundstueck_nr,
    "Grundstueck_Nr_Zusatz" AS grundstueck_zusatz,
    "Grundstueck_Nr_3" AS grundstueck_nr_3,
    "Fuehrungsart" AS fuehrungsart,
    "Flaeche" AS flaeche,
    "EGRID" AS egrid
FROM
    capi_p.V_AIO_GrundstueckeMitFlaeche
;
