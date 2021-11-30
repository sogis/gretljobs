select 
    typ.bezeichnung as typ_bezeichnung,
    typ.abkuerzung as typ_abkuerzung,
    typ.verbindlichkeit as typ_verbindlichkeit,
    typ.bemerkungen as typ_bemerkungen, 
    typ.art as typ_art,
    waldgrenze.geometrie as geometrie, 
    waldgrenze.nummer as nummer,
    waldgrenze.rechtsstatus as rechtsstatus,
    waldgrenze.publiziert_ab as publiziert_ab,
    waldgrenze.bemerkungen as bemerkungen, 
    waldgrenze.erfasser as erfasser,
    waldgrenze.datum_erfassung as datum_erfassung,
    waldgrenze.genehmigt_am as genehmigt_am, 
    waldgrenze.datum_archivierung as datum_archivierung 
from 
    awjf_statische_waldgrenze.geobasisdaten_waldgrenze_linie waldgrenze
left join 
    awjf_statische_waldgrenze.geobasisdaten_typ typ 
    on 
    waldgrenze.waldgrenze_typ = typ.t_id 