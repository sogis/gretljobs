INSERT INTO alw_tiergesundheit_eindaemmungsbarrieren_v2.modinfo (
    tiergsndht_mmngsbrrren_modinfo
)
SELECT
    h.t_id
FROM alw_tiergesundheit_eindaemmungsbarrieren_pub_v2.tiergesundheit_eindaemmungsbarrieren h
WHERE NOT EXISTS (
    SELECT 1
    FROM alw_tiergesundheit_eindaemmungsbarrieren_pub_v2.modinfo m
    WHERE m.tiergsndht_mmngsbrrren_modinfo = h.t_id
);
