SELECT 
    kantonsgrenzsteine.ogc_fid AS t_id, 
    kantonsgrenzsteine.nummer, 
    kantonsgrenzsteine.bfs, 
    kantonsgrenzsteine.bfs_nachbar, 
    kantonsgrenzsteine.vermarkung, 
    kantonsgrenzsteine.schoenerst AS schoener_stein, 
    kantonsgrenzsteine.masse_cm, 
    kantonsgrenzsteine.cm_ueber_boden, 
    kantonsgrenzsteine.jahreszahl, 
    kantonsgrenzsteine.wappen, 
    kantonsgrenzsteine.richtungskerbe, 
    kantonsgrenzsteine.begehung, 
    kantonsgrenzsteine.arbeit_erledigt, 
    kantonsgrenzsteine.nachfuehrung, 
    kantonsgrenzsteine.bemerkungen, 
    kantonsgrenzsteine.wkb_geometry AS geometrie, 
    gemeinden_1.gdename AS gemeinde_so, 
    gemeinden_1.gdektna AS kanton_so, 
    gemeinden_1.gdekt AS krzl_kanton_so, 
    gemeinden_2.gdename AS nachbar_gemeinde, 
    gemeinden_2.gdektna AS nachbar_kanton, 
    gemeinden_2.gdekt AS krzl_nachbar_kanton
FROM 
    agi_inventar_hoheitsgrenzsteine.kantonsgrenzsteine_v kantonsgrenzsteine
    JOIN agi_inventar_hoheitsgrenzsteine.bfs_gemeinden gemeinden_1
        ON kantonsgrenzsteine.bfs = gemeinden_1.gdenr::integer
    JOIN agi_inventar_hoheitsgrenzsteine.bfs_gemeinden gemeinden_2
        ON kantonsgrenzsteine.bfs_nachbar = gemeinden_2.gdenr::integer
;