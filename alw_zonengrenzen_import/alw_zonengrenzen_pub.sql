SELECT
    lz_flaeche.t_id,
    lz_flaeche.flaeche,
    erstellungsdatum,
    katalogtyp.lz_code,
    katalogtyp.typ_de AS typ
FROM
    alw_zonengrenzen.zonengrenzen_lz_flaeche AS lz_flaeche
    LEFT JOIN alw_zonengrenzen.lz_kataloge_lz_katalog_typ AS katalogtyp
        ON lz_flaeche.typ = katalogtyp.t_id
;
