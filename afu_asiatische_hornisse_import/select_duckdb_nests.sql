select
	nid_id              as import_nest_id,
    statut              as import_status,
    null::date          as import_datum_behandlung,         -- noch nicht verfügbar
	wkt                 as geometrie,
    materialentityid    as import_materialentity_id,
    date_decouverte     as import_datum_sichtung,
    location            as import_ort,
    canton              as import_kanton,
    lv95_east_x         as import_x_koordinate,
    lv95_north_y        as import_y_koordinate,
    null::text          as import_kontakt_name,             -- noch nicht verfügbar
    null::text          as import_kontakt_mail,             -- noch nicht verfügbar
    null::text          as import_kontakt_tel,              -- noch nicht verfügbar
    remarques           as import_bemerkung,
    url                 as import_url,
    image               as import_foto_url
from nests;