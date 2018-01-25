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
    gew_name_u,
    "name",
    kantgewnr,
    gew_lauf_u,
    gewiss_nr,
    lauf_nr,
    linst,
    gwl_nr
FROM
    swisstlm3d.stehendes_gewaesser
WHERE
    archive = 0
;