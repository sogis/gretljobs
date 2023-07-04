update 
    afu_isboden_csv_import_v1.csv_import_csv_import_t csv_import
set 
    bodeneinheiten_pk = bodeneinheit.pk_ogc_fid
from 
    afu_isboden.bodeneinheit_t bodeneinheit
where 
    csv_import.gemnr = bodeneinheit.gemnr
    and 
    csv_import.objnr = bodeneinheit.objnr