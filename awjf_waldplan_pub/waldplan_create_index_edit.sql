CREATE INDEX IF NOT EXISTS
    waldplan_waldeigentum_egrid_idx 
    ON 
    awjf_waldplan_v2.waldplan_waldeigentum 
USING btree (egrid)
;

CREATE INDEX IF NOT EXISTS
    waldplan_waldfunktion_geometrie_idx 
    ON 
    awjf_waldplan_v2.waldplan_waldfunktion 
USING gist (geometrie)
;

CREATE INDEX IF NOT EXISTS
    waldplan_waldnutzung_geometrie_idx 
    ON 
    awjf_waldplan_v2.waldplan_waldnutzung
USING gist (geometrie)
;