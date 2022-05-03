WITH eigensch_measure AS (
         SELECT eig.t_id,
             bg.gnrso,
             eig.aname,
             eig.strahler,
             eig.eigentum,
             eig.qualitaet,
             eig.gdenr2,
             eig.gdenr,
             eig.groesse,
             eig.typ,
             st_linelocatepoint(bg.geometrie, st_startpoint(eig.geometrie)) AS m1,
             st_linelocatepoint(bg.geometrie, st_endpoint(eig.geometrie)) AS m2,
             eig.erhebungsdatum,
             bg.geometrie AS geo_base
         FROM 
             afu_gewaesser_v1.gewaessereigenschaften eig
         JOIN 
             afu_gewaesser_v1.gewaesserbasisgeometrie bg 
             ON 
             eig.rgewaesser = bg.t_id
)
 
SELECT 
    st_linesubstring(eigensch_measure.geo_base, LEAST(eigensch_measure.m1, eigensch_measure.m2), GREATEST(eigensch_measure.m1, eigensch_measure.m2))::geometry(LineString,2056) AS geometrie,
    eigensch_measure.gnrso,
    eigensch_measure.typ,
    eigensch_measure.groesse,
    eigensch_measure.aname,
    eigensch_measure.gdenr as gemeindenummeruferrechts,
    eigensch_measure.gdenr2  as gemeindenummeruferlinks,
    eigensch_measure.qualitaet,
    eigensch_measure.eigentum,
    eigensch_measure.strahler,
    eigensch_measure.erhebungsdatum
FROM 
    eigensch_measure
WHERE 
    eigensch_measure.m1 <> eigensch_measure.m2 
    AND 
    (
        eigensch_measure.m1 <> 'NaN'::numeric::double precision 
        OR 
        eigensch_measure.m2 <> 'NaN'::numeric::double precision
    )
;
