with documents as (
    select 
        typ as titel,
        offiziellertitel as offizieller_titel, 
        abkuerzung as abkuerzung,
        offiziellenr as offizielle_nr,
        kanton as kanton,
        gemeinde as gemeinde,
        publiziert_ab as publiziert_ab,
        rechtsstatus as rechtsstatus, 
        text_im_web as text_im_web, 
        bemerkungen as bemerkungen,
        datum_archivierung as datum_archivierung,
        erfasser as erfasser,
        datum_erfassung as datum_erfassung,
        typ_dokument.festlegung as waldgrenze_waldgrenze_dokumente
    from 
        awjf_statische_waldgrenze.dokumente_dokument
        left join 
            awjf_statische_waldgrenze.geobasisdaten_typ_dokument typ_dokument 
            on 
            typ_dokument.dokumente = dokumente_dokument.t_id
    order by 
        waldgrenze_waldgrenze_dokumente, typ desc 
), 

documents_json AS (
    SELECT 
        array_to_json(array_agg(row_to_json(documents))) AS dokumente, 
        waldgrenze_waldgrenze_dokumente
    FROM 
        documents
    GROUP BY 
        waldgrenze_waldgrenze_dokumente
)

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
    documents_json.dokumente::jsonb,
    waldgrenze.genehmigt_am as genehmigt_am, 
    waldgrenze.datum_archivierung as datum_archivierung
from 
    awjf_statische_waldgrenze.geobasisdaten_waldgrenze_linie waldgrenze
left join 
    awjf_statische_waldgrenze.geobasisdaten_typ typ 
    on 
    waldgrenze.waldgrenze_typ = typ.t_id 
left join 
    documents_json 
    on 
    documents_json.waldgrenze_waldgrenze_dokumente = typ.t_id