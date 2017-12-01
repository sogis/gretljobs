SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    kurventyp,
    erfassung,
    erfasser,
    bearbeitun,
    bearbeiter,
    kote
FROM
    public.aww_gstiso
WHERE
    archive = 0
;