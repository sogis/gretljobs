drop view if exists alw_fruchtfolgeflaechen_v1.fff_gemeinde_statistik_v;

CREATE VIEW alw_fruchtfolgeflaechen_v1.fff_gemeinde_statistik_v AS
select 
    bfs_nr, 
    sum(area_aren) as flaeche, 
    sum(area_anrech) as flaeche_anrechenbar 
from 
    alw_fruchtfolgeflaechen_v1.fruchtfolgeflaeche
GROUP by
    bfs_nr
;