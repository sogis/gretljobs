SELECT
    geometrie AS apolygon,
    typ AS typ,
    bemerkungen AS bemerkung
FROM
    afu_gewaesserschutz_bereiche_v1.gsbereiche_gsbereich
WHERE
    typ != 'Zu' AND typ != 'Zo'
;