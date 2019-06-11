INSERT INTO agi_plz_ortschaften_pub.plzortschaften_postleitzahl(plz, zusatzziffern, status, geometrie)
SELECT 
    plzortschaft_plz6.plz, 
    plzortschaft_plz6.zusatzziffern,
    plzortschaft_plz6.status,
    ST_Multi(ST_Union(plzortschaft_plz6.flaeche)) AS geometrie
FROM 
    agi_plz_ortschaften.plzortschaft_plz6
GROUP BY 
    plz, 
    zusatzziffern, 
    status
;
