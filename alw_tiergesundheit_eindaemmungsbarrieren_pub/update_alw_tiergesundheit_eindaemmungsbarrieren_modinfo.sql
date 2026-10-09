INSERT INTO alw_tiergesundheit_eindaemmungsbarrieren_v1.modinfo (
    t_lastchange,
    t_createdate,
    t_user,
    tiergsndht_mmngsbrrren_modinfo
)
SELECT
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    SESSION_USER,
    h.t_id
FROM alw_tiergesundheit_eindaemmungsbarrieren_v1.tiergesundheit_eindaemmungsbarrieren h
WHERE NOT EXISTS (
    SELECT 1
    FROM alw_tiergesundheit_eindaemmungsbarrieren_v1.modinfo m
    WHERE m.tiergsndht_mmngsbrrren_modinfo = h.t_id
);
