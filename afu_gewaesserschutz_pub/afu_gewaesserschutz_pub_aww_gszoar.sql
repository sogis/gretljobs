select ogc_fid,st_multi(wkb_geometry) as wkb_geometry,zone,rrbnr,rrb_date
from aww_gszoar
where archive = 0;
