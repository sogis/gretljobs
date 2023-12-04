with dokumente as (
    select 
        t_id,
        json_build_object(
        'Titel', titel,  
        'Abkuerzung', abkuerzung, 
        'OffizielleNr', offiziellenr,
        'TextImWeb', textimweb,
        'Rechtsstatus', rechtsstatus,
        'publiziertAb', publiziertab,
        'publiziertBis', publiziertbis, 
        '@type','SO_ARP_Waldreservate_Publikation_20231201.Dokumente.Dokument'
        ) as dokument 
    from 
        arp_waldreservate_v1.dokumente_dokument 
) 
,
dokumente_agg as (
    select 
        reservat.festlegung, 
        json_agg(dokumente.dokument) as dokument 
    from 
        arp_waldreservate_v1.geobasisdaten_waldreservat_dokument reservat 
    left join 
        dokumente 
        on 
        reservat.dokumente = dokumente.t_id 
    group by 
        reservat.festlegung
)

select 
    reservat.objnummer as objnummer, 
    teilobjekt.teilobj_nr as teilobj_nr, 
    reservat.aname as aname, 
    reservat.obj_gesflaeche as obj_gesflaeche,
    reservat.obj_gisflaeche as obj_gisflaeche,
    reservat.rechtsstatus as rechtsstatus, 
    teilobjekt.mcpfe_code as mcpfe_code, 
    teilobjekt.obj_gisteilobjekt as obj_gisteilobjekt,
    teilobjekt.geo_obj as geo_obj, 
    reservat.publiziertab as publiziertab, 
    reservat.publiziertbis as publiziertbis, 
    dokumente_agg.dokument as dokumente
from 
    arp_waldreservate_v1.geobasisdaten_waldreservat_teilobjekt teilobjekt  
right join 
    arp_waldreservate_v1.geobasisdaten_waldreservat reservat 
    on 
    reservat.t_id = teilobjekt.wr 
full join 
    dokumente_agg 
    on 
    dokumente_agg.festlegung = reservat.t_id 
    