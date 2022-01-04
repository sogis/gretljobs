select distinct 
    to_date(max(datenstand), 'DD.MM.YYYY') as datenstand, 
    'Amt für Landwirtschaft Kanton Solothurn' as amt
from 
    alw_fruchtfolgeflaechen_v1.fruchtfolgeflaeche
;