SELECT 
    geometrie,
    gnrso,
    typ,
    groesse,
    aname,
    gdenr as gemeindenummeruferrechts,
    gdenr2  as gemeindenummeruferlinks,
    qualitaet,
    eigentum,
    strahler,
    erhebungsdatum
FROM 
    afu_gewaesser_v1.gewaessereigenschaft_v
;
