CREATE INDEX IF NOT EXISTS
    waldplan_waldplan_grundstueck_egrid_idx 
    ON 
    awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck
USING btree (egrid)
;

CREATE INDEX IF NOT EXISTS
    waldplan_waldplan_grundstueck_geometrie_idx 
    ON 
    awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck
USING gist (geometrie)
;

CREATE INDEX IF NOT EXISTS
    waldplan_waldfunktion_geometrie_idx 
    ON 
    awjf_waldplan_pub_v2.waldplan_waldfunktion 
USING gist (geometrie)
;

CREATE INDEX IF NOT EXISTS
    waldplan_waldnutzung_geometrie_idx 
    ON 
    awjf_waldplan_pub_v2.waldplan_waldnutzung
USING gist (geometrie)
;