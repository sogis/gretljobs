SELECT 
    g.typ,
    g.gesetzeskonform,
    g.rechtskraftdatum,
    g.dokumente,
    g.apolygon,
    g.rechtsstatus,
    g.bemerkung
FROM
    afu_gewaesserschutz_staging_v2.gewaesserschutz_schutzzone g