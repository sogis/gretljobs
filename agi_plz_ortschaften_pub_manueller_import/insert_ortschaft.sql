INSERT INTO agi_plz_ortschaften_pub.plzortschaften_ortschaft(ortschaftsname, astatus, geometrie)
(
SELECT 
    plzortschaft_ortschaftsname.atext AS ortschaftsname, 
    plzortschaft_ortschaft.astatus, 
    ST_Multi(ST_Union(plzortschaft_ortschaft.flaeche)) AS geometrie
FROM 
    agi_plz_ortschaften.plzortschaft_ortschaftsname
LEFT JOIN 
    agi_plz_ortschaften.plzortschaft_ortschaft
    ON plzortschaft_ortschaftsname.ortschaftsname_von = plzortschaft_ortschaft.t_id
GROUP BY
    plzortschaft_ortschaftsname.atext,
    plzortschaft_ortschaft.astatus
)
;
