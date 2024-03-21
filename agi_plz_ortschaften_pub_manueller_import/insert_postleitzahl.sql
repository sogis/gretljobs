INSERT INTO agi_plz_ortschaften_pub.plzortschaften_postleitzahl(plz, zusatzziffern, astatus, geometrie)
SELECT 
    plzortschaft_plz6.plz, 
    plzortschaft_plz6.zusatzziffern,
    plzortschaft_plz6.astatus,
    ST_Multi(ST_Union(plzortschaft_plz6.flaeche)) AS geometrie
FROM 
    agi_plz_ortschaften.plzortschaft_plz6
GROUP BY 
    plz, 
    zusatzziffern, 
    astatus
;
