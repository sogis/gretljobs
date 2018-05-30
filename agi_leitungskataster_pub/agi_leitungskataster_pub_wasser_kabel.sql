SELECT
    pk_id AS t_id,
    ogc_fid,
    tid,
    name_nummer,
    geometrie,
    funktion,
    funktion_txt,
    kabelart,
    kabelart_txt,
    lagebestimmung,
    lagebestimmung_txt,
    status,
    status_txt,
    einbaujahr,
    ueberdeckung,
    zustand,
    eigentuemer,
    bemerkung,
    letzte_aenderung,
    gem_bfs,
    los,
    lieferdatum
FROM
    gemgis.t_sia405_wasser_wi_kabel
;