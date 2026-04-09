TRUNCATE afu_bodeneinheiten_v1.import_table;
TRUNCATE afu_bodeneinheiten_v1.los CASCADE;
DELETE FROM afu_bodeneinheiten_v1.t_ili2db_basket WHERE attachmentkey = 'migration';
DELETE FROM afu_bodeneinheiten_v1.t_ili2db_dataset WHERE datasetname = 'migration';

WITH dataset AS (
    INSERT INTO 
        afu_bodeneinheiten_v1.t_ili2db_dataset (t_id, datasetname)
        SELECT 
            nextval('afu_bodeneinheiten_v1.t_ili2db_seq'::regclass) AS t_id,
            'migration' AS datasetname 
    RETURNING t_id
),
 
basket AS (
    INSERT INTO 
        afu_bodeneinheiten_v1.t_ili2db_basket (t_id, dataset, topic, attachmentkey)
        SELECT 
            nextval('afu_bodeneinheiten_v1.t_ili2db_seq'::regclass) AS t_id,
            dataset.t_id AS dataset, 
            'SO_AFU_Bodeneinheiten_20251210.Bodeneinheit' AS topic, 
            'migration'  AS attachmentkey 
        FROM 
            dataset
        RETURNING t_id 
),

untertyp_pivot AS (
    SELECT
        z.fk_bodeneinheit AS src_ausp_id,
        max(CASE WHEN u.code ~ '^E[0-9]+$' THEN me.tgt_ilicode END) AS untertyp_e,
        max(CASE WHEN u.code ~ '^I[0-9]+$' THEN mi.tgt_ilicode END) AS untertyp_i,
        max(CASE WHEN u.code ~ '^G[0-9]+$' THEN mg.tgt_ilicode END) AS untertyp_g,
        max(CASE WHEN u.code ~ '^R[0-9]+$' THEN mr.tgt_ilicode END) AS untertyp_r,
        string_agg(DISTINCT CASE WHEN mk.tgt_ilicode IS NOT NULL THEN mk.tgt_ilicode END, ', ' ORDER BY CASE WHEN mk.tgt_ilicode IS NOT NULL THEN mk.tgt_ilicode END) AS untertyp_k,
        string_agg(DISTINCT CASE WHEN mp.tgt_ilicode IS NOT NULL THEN mp.tgt_ilicode END, ', ' ORDER BY CASE WHEN mp.tgt_ilicode IS NOT NULL THEN mp.tgt_ilicode END) AS untertyp_p,
        string_agg(DISTINCT CASE WHEN md.tgt_ilicode IS NOT NULL THEN md.tgt_ilicode END, ', ' ORDER BY CASE WHEN md.tgt_ilicode IS NOT NULL THEN md.tgt_ilicode END) AS untertyp_div
    FROM afu_isboden.zw_bodeneinheit_untertyp z
    JOIN afu_isboden.untertyp_t u
      ON u.pk_untertyp = z.fk_untertyp
    LEFT JOIN mig.map_untertyp_e me
      ON me.src_code = u.code
    LEFT JOIN mig.map_untertyp_i mi
      ON mi.src_code = u.code
    LEFT JOIN mig.map_untertyp_g mg
      ON mg.src_code = u.code
    LEFT JOIN mig.map_untertyp_r mr
      ON mr.src_code = u.code
    LEFT JOIN mig.map_untertyp_k mk
      ON mk.src_code = u.code
    LEFT JOIN mig.map_untertyp_p mp
      ON mp.src_code = u.code
    LEFT JOIN mig.map_untertyp_diverse md
      ON md.src_code = u.code
    WHERE coalesce(z.archive, 0) = 0
      AND coalesce(u.archive, 0) = 0
    GROUP BY z.fk_bodeneinheit
)

INSERT INTO afu_bodeneinheiten_v1.import_table (
    t_basket,
    t_datasetname,
    gemnr,
    objnr,
    wasserhhgr,
    bodentyp,
    gelform,
    geologie,
    untertyp_e,
    untertyp_k,
    untertyp_i,
    untertyp_g,
    untertyp_r,
    untertyp_p,
    untertyp_div,
    skelett_ob,
    skelett_ub,
    koernkl_ob,
    koernkl_ub,
    ton_ob,
    ton_ub,
    schluff_ob,
    schluff_ub,
    karbgrenze,
    kalkgeh_ob,
    kalkgeh_ub,
    ph_ob,
    ph_ub,
    maechtigk_ah,
    humusgeh_ah,
    humusform_wa,
    maechtigk_ahh,
    gefuegeform_ob,
    gefueggr_ob,
    gefuegeform_ub,
    gefueggr_ub,
    pflngr,
    bodpktzahl,
    bemerkungen,
    los,
    kartierjahr,
    kartierteam,
    kartierquartal,
    ist_wald,
    gewichtung_auspraegung,
    ist_hauptauspraegung,
    ohne_oberboden,
    ohne_unterboden,
    import_fehler
) 
SELECT
    basket.t_id AS t_basket,
    dataset.t_id AS t_datasetname,
    be.gemnr::int,
    be.objnr::int,
    mwh.tgt_ilicode,
    mbt.tgt_ilicode,
    mgf.tgt_ilicode,
    a.geologie,
    up.untertyp_e,
    up.untertyp_k,
    up.untertyp_i,
    up.untertyp_g,
    up.untertyp_r,
    up.untertyp_p,
    up.untertyp_div,
    askob.code AS skelett_oberboden,
    askub.code AS skelett_unterboden,
    akoob.code AS koernungsklasse_unterboden,
    akoub.code AS koernungsklasse_oberboden,
    a.ton_ob,
    a.ton_ub,
    a.schluff_ob,
    a.schluff_ub,
    a.karbgrenze,
    akgob.code AS kalkgehalt_oberboden,
    akgub.code AS kalkgehalt_unterboden,
    CASE WHEN a.ph_ob IS NOT NULL THEN round(a.ph_ob::numeric, 1)::int END AS ph_ob,
    CASE WHEN a.ph_ub IS NOT NULL THEN round(a.ph_ub::numeric, 1)::int END AS ph_up,
    a.maechtigk_ah,
    a.humusgeh_ah::numeric(4,1),
    mhw.tgt_ilicode,
    a.maechtigk_ahh::numeric(3,1),
    mgfo.tgt_ilicode AS gefuegeform,
    aggo.code AS gefuegegroesse_oberboden,
    mgfu.tgt_ilicode AS gefuegeform,
    aggu.code AS gefuegegroesse,
    a.pflngr,
    a.bodpktzahl,
    a.bemerkungen,
    left(be.los, 20),
    coalesce(be.kartierjahr, extract(year from current_date)::int),
    coalesce(kv.kuerzel, 'UNBEKANNT'),
    be.kartierquartal,
    be.is_wald,
    a.gewichtung_auspraegung::numeric(4,1),
    a.is_hauptauspraegung,
    CASE WHEN (
          a.ton_ob IS NULL
          AND a.schluff_ob IS NULL
          AND a.fk_koernkl_ob IS NULL
          AND a.fk_kalkgehalt_ob IS NULL
          AND a.ph_ob IS NULL
          AND a.fk_gefuegeform_ob IS NULL
          AND a.fk_gefueggr_ob IS NULL
          AND a.fk_skelett_ob IS NULL
        ) THEN TRUE
        ELSE FALSE 
      END AS ohne_oberboden,
    CASE WHEN (
          a.ton_ub IS NULL
          AND a.schluff_ub IS NULL
          AND a.fk_koernkl_ub IS NULL
          AND a.fk_kalkgehalt_ub IS NULL
          AND a.ph_ub IS NULL
          AND a.fk_gefuegeform_ub IS NULL
          AND a.fk_gefueggr_ub IS NULL
          AND a.fk_skelett_ub IS NULL
      ) THEN TRUE 
      ELSE FALSE  
    END AS ohne_unterboden,
    NULL::varchar(500) AS import_fehler
FROM 
    dataset, 
    basket, 
    afu_isboden.bodeneinheit_t be
JOIN afu_isboden.bodeneinheit_auspraegung_t a
  ON a.fk_bodeneinheit = be.pk_ogc_fid
LEFT JOIN untertyp_pivot up
  ON up.src_ausp_id = a.pk_bodeneinheit
LEFT JOIN afu_isboden.wasserhhgr_t swh
  ON swh.pk_wasserhhgr = a.fk_wasserhhgr
LEFT JOIN mig.map_wasserhaushaltcode mwh
  ON mwh.src_code = swh.code
LEFT JOIN afu_isboden.bodentyp_t sbt
  ON sbt.pk_bodentyp = a.fk_bodentyp
LEFT JOIN mig.map_bodentypcode mbt
  ON mbt.src_code = sbt.code
LEFT JOIN afu_isboden.begelfor_t sgf
  ON sgf.pk_begelfor = a.fk_begelfor
LEFT JOIN mig.map_gelaendeform mgf
  ON mgf.src_code = sgf.code
LEFT JOIN afu_isboden.skelett_t askob
  ON askob.pk_skelett = a.fk_skelett_ob
LEFT JOIN afu_isboden.skelett_t askub
  ON askub.pk_skelett = a.fk_skelett_ub
LEFT JOIN afu_isboden.koernkl_t akoob
  ON akoob.pk_koernkl = a.fk_koernkl_ob
LEFT JOIN afu_isboden.koernkl_t akoub
  ON akoub.pk_koernkl = a.fk_koernkl_ub
LEFT JOIN afu_isboden.kalkgehalt_t akgob
  ON akgob.pk_kalkgehalt = a.fk_kalkgehalt_ob
LEFT JOIN afu_isboden.kalkgehalt_t akgub
  ON akgub.pk_kalkgehalt = a.fk_kalkgehalt_ub
LEFT JOIN afu_isboden.humusform_wa_t shw
  ON shw.pk_humusform_wa = a.fk_humusform_wa
LEFT JOIN mig.map_humusform_wald mhw
  ON mhw.src_code = shw.code
LEFT JOIN afu_isboden.gefuegeform_t sgfo
  ON sgfo.pk_gefuegeform = a.fk_gefuegeform_ob
LEFT JOIN mig.map_gefuegeform mgfo
  ON mgfo.src_code = sgfo.code
LEFT JOIN afu_isboden.gefueggr_t aggo
  ON aggo.pk_gefueggr = a.fk_gefueggr_ob
LEFT JOIN afu_isboden.gefuegeform_t sgfu
  ON sgfu.pk_gefuegeform = a.fk_gefuegeform_ub
LEFT JOIN mig.map_gefuegeform mgfu
  ON mgfu.src_code = sgfu.code
LEFT JOIN afu_isboden.gefueggr_t aggu
  ON aggu.pk_gefueggr = a.fk_gefueggr_ub
LEFT JOIN afu_isboden.kartiererin_v_sc kv
  ON kv.pk_kartiererin = be.fk_kartierer
WHERE coalesce(be.archive, 0) = 0 
;
