CREATE INDEX IF NOT EXISTS
    bodeneinheit_bodpktzahl_idx 
    ON 
    afu_isboden_pub.bodeneinheit 
USING btree (bodpktzahl)
;

CREATE INDEX IF NOT EXISTS
    bodeneinheit_gelform_idx 
    ON 
    afu_isboden_pub.bodeneinheit 
USING btree (gelform)
;

CREATE INDEX IF NOT EXISTS
    bodeneinheit_geometrie_idx 
    ON 
    afu_isboden_pub.bodeneinheit 
USING gist (geometrie)
;

CREATE INDEX IF NOT EXISTS
    bodeneinheit_skelett_ob_idx 
    ON 
    afu_isboden_pub.bodeneinheit 
USING btree (skelett_ob)
;

CREATE INDEX IF NOT EXISTS
    bodeneinheit_wasserhhgr_idx 
    ON 
    afu_isboden_pub.bodeneinheit 
USING btree (wasserhhgr)
;

CREATE INDEX IF NOT EXISTS
    idx_afu_isboden_bodeneinheit_wkb_geometery 
    ON 
    afu_isboden_pub.bodeneinheit 
USING gist (geometrie)
;
