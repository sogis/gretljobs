SELECT
    geometrie AS apolygon,
    typ AS typ,
    bemerkungen AS bemerkung
FROM
    afu_gewaesserschutz.gsbereiche_gsbereich
WHERE
    typ != 'Zu' AND typ != 'Zo'
;