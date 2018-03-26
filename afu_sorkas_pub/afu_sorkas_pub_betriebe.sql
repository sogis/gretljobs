SELECT
    gid AS t_id,
    bemerkung_,
    betreuung_,
    bsid,
    datenerheb,
    erhebungsd,
    geprueft,
    konsultati,
    koordinate,
    koordina_1,
    parzellen_,
    ue,
    zusatz,
    id_untersu,
    id_betrieb,
    id_klassie,
    aktiv,
    text,
    id_konstru,
    id_adresse,
    id_kommuni,
    bezirk,
    the_geom AS geometrie
FROM
    sorkas.betriebe
;
