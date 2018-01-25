SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    uuid,
    datum_aend,
    datum_erst,
    erstell_j,
    erstell_m,
    revision_j,
    revision_m,
    grund_aend,
    herkunft,
    herkunft_j,
    herkunft_m,
    objektart,
    revision_q,
    enabled,
    kunstbaute,
    anschlussg,
    achse_dkm,
    museumsbah,
    auf_strass,
    eroeffnung,
    stufe,
    ausser_bet,
    zahnradbah,
    standseilb,
    betriebsba,
    oev_name_u,
    "name",
    anzahl_spu,
    verkehrsmi
FROM
    swisstlm3d.eisenbahn
WHERE
    archive = 0
;