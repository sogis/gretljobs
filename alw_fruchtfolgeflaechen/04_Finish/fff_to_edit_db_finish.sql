with remove_duplicate_coordinates as (
    select 
        ST_RemoveRepeatedPoints(geometrie,0.01) AS geometrie, 
        bezeichnung, 
        spezialfall, 
        9999 as bfs_nr,
        to_char(datenstand, 'DD.MM.YYYY') as datenstand, 
        anrechenbar
    from 
        alw_fruchtfolgeflaechen.fff_komplett
),

makevalid as (
    select 
        ST_makevalid(geometrie) AS geometrie, 
        bezeichnung, 
        spezialfall, 
        bfs_nr,
        datenstand, 
        anrechenbar
    from 
        remove_duplicate_coordinates
),

dump as (
    select 
        (st_dump(geometrie)).geom AS geometrie, 
        bezeichnung, 
        spezialfall, 
        bfs_nr,
        datenstand, 
        anrechenbar
    from 
        makevalid
)

select 
    geometrie, 
    bezeichnung, 
    spezialfall, 
    bfs_nr,
    datenstand, 
    anrechenbar, 
    st_area(dump.geometrie)/100 as area_aren,
    (st_area(dump.geometrie)/100)*anrechenbar as area_anrech
from 
    dump
;
