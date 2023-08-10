-- Es gilt, die pks der neu importierten Daten aus dem csv zu ermitteln.
with imported_pks as (
    select 
        pk_ogc_fid 
    FROM 
        afu_isboden.bodeneinheit_t bodeneinheit
    where 
        bodeneinheit.gemnr||' '||bodeneinheit.objnr in (select gemnr||' '||objnr from afu_isboden_csv_import_v1.csv_import_csv_import_t)
)

-- Die Verknüpfungen zwischen den Untertypen und den Bodeneinheiten wird gelöscht (und später wieder eingefügt)
DELETE FROM 
    afu_isboden.zw_bodeneinheit_untertyp
WHERE 
    fk_bodeneinheit in (select pk_ogc_fid from imported_pks)
AND 
    archive = 0
;

--Gleiches wie oben
with imported_pks as (
    select 
        pk_ogc_fid 
    FROM 
        afu_isboden.bodeneinheit_t bodeneinheit
    where 
        bodeneinheit.gemnr||' '||bodeneinheit.objnr in (select gemnr||' '||objnr from afu_isboden_csv_import_v1.csv_import_csv_import_t)
)

-- Die Ausprägungen der jeweiligen zu importirenden Bodeneinheiten werden gelöscht 
DELETE FROM 
    afu_isboden.bodeneinheit_auspraegung_t
WHERE 
    fk_bodeneinheit in (select pk_ogc_fid from imported_pks)
AND 
    archive = 0
;

--Nun werden die Ausprägungen wieder eingefügt. 
INSERT INTO 
    afu_isboden.bodeneinheit_auspraegung_t 
        (
        fk_bodeneinheit,
        is_hauptauspraegung,
        gewichtung_auspraegung,
        fk_wasserhhgr,
        fk_bodentyp,
        fk_begelfor,
        geologie,
        maechtigk_ah,
        humusgeh_ah,
        maechtigk_ahh,
        fk_humusform_wa,
        pflngr,
        bodpktzahl,
        fk_koernkl_ob,
        fk_koernkl_ub,
        ton_ob,
        ton_ub,
        schluff_ob,
        schluff_ub,
        fk_skelett_ob,
        fk_skelett_ub,
        fk_kalkgehalt_ob,
        fk_kalkgehalt_ub,
        karbgrenze,
        ph_ob,
        ph_ub,
        fk_gefuegeform_ob,
        fk_gefuegeform_ub,
        fk_gefueggr_ob,
        fk_gefueggr_ub,
        bemerkungen
        ) 
        (
        select 
            bodeneinheiten_pk,
            is_hauptauspraegung::boolean,
            gewichtung_auspraegung::integer,
            (select pk_wasserhhgr from afu_isboden.wasserhhgr_t where code = wasserhhgr) as fk_wasserhhgr,
            (select pk_bodentyp from afu_isboden.bodentyp_t where code = bodentyp) as fk_bodentyp,
            (select pk_begelfor from afu_isboden.begelfor_t where code = gelform) as fk_begelfor, --Warum heisst gelform plötzlich begelfor??? 
            geologie::varchar,
            maechtigk_ah::integer,
            humusgeh_ah::float8,
            maechtigk_ahh::float8,
            (select pk_humusform_wa from afu_isboden.humusform_wa_t where code = humusform_wa) as fk_humusform_wa,
            pflngr::integer,
            bodpktzahl::integer,
            (select pk_koernkl from afu_isboden.koernkl_t where code = koernkl_ob::integer) as fk_koernkl_ob,
            (select pk_koernkl from afu_isboden.koernkl_t where code = koernkl_ub::integer) as fk_koernkl_ub,
            ton_ob::integer,
            ton_ub::integer,
            schluff_ob::integer,
            schluff_ub::integer,
            (select pk_skelett from afu_isboden.skelett_t skelett where code = skelett_ob::integer and csv_import.is_wald::boolean = skelett.is_wald) as fk_skelett_ob,
            (select pk_skelett from afu_isboden.skelett_t skelett where code = skelett_ub::integer and csv_import.is_wald::boolean = skelett.is_wald) as fk_skelett_ub,
            (select pk_kalkgehalt from afu_isboden.kalkgehalt_t where code = kalkgeh_ob::integer) as fk_kalkgehalt_ob,
            (select pk_kalkgehalt from afu_isboden.kalkgehalt_t where code = kalkgeh_ub::integer) as fk_kalkgehalt_ub,
            karbgrenze::integer,
            ph_ob::float8,
            ph_ub::float8,
            (select pk_gefuegeform from afu_isboden.gefuegeform_t  where code = gefuegeform_ob) as fk_gefuegeform_ob,
            (select pk_gefuegeform from afu_isboden.gefuegeform_t  where code = gefuegeform_ub) as fk_gefuegeform_ub,
            (select pk_gefueggr from afu_isboden.gefueggr_t where code = gefueggr_ob::integer) as fk_gefueggr_ob,
            (select pk_gefueggr from afu_isboden.gefueggr_t where code = gefueggr_ub::integer) as fk_gefueggr_ub,
            bemerkungen::varchar
        from
            afu_isboden_csv_import_v1.csv_import_csv_import_t csv_import
        )
;

--Hier werden die Bodeneinheiten und Ausprägungen miteinander verbunden: 
--ACHTUNG: Deummerweise heisst der pk der Ausprägungen auch "pk_bodeneinheit". Ich benennen ihn hier aber um zu pk(oder fk) auspraegung. 
with auspraegungen as (
    select 
        fk_bodeneinheit as pk_bodeneinheit,
        pk_bodeneinheit as pk_auspraegung, --falls Haut und Nebenausprägungen (evtl. nicht mehr relevant) 
        csv_import.gewichtung_auspraegung
    from 
        afu_isboden.bodeneinheit_auspraegung_t auspraegung
    inner join 
        afu_isboden_csv_import_v1.csv_import_csv_import_t csv_import 
        on 
        auspraegung.fk_bodeneinheit = csv_import.bodeneinheiten_pk 
        and 
        auspraegung.gewichtung_auspraegung = csv_import.gewichtung_auspraegung::afu_isboden.d_gt_0_le_100
        and 
        auspraegung.is_hauptauspraegung = csv_import.is_hauptauspraegung::boolean
    where 
        fk_bodeneinheit in (select bodeneinheiten_pk from afu_isboden_csv_import_v1.csv_import_csv_import_t)
    --group by 
    --    csv_import.gewichtung_auspraegung,
    --    fk_bodeneinheit
), 

--Macht für jeden Untertyp einer Bodeneinheit eine neue Zeile. Erleichtert später den Import und macht eine for-schlaufe überflüssig
untertypen as (
    select 
        csv_import.bodeneinheiten_pk, 
        auspraegung.pk_bodeneinheit as fk_auspraegung,
        csv_import.is_hauptauspraegung,
        csv_import.gewichtung_auspraegung,
        trim((regexp_split_to_table(CONCAT(
            coalesce(untertyp_e, ''),
            coalesce(',' ||untertyp_k, ''),
            coalesce(',' ||untertyp_i, ''),
            coalesce(',' ||untertyp_g, ''),
            coalesce(',' ||untertyp_r, ''),
            coalesce(',' ||untertyp_p, ''),
            coalesce(',' ||untertyp_div, '')
        )::text,','))) as untertypen
    from 
        afu_isboden_csv_import_v1.csv_import_csv_import_t csv_import
    left join 
        afu_isboden.bodeneinheit_auspraegung_t auspraegung 
        on 
        csv_import.bodeneinheiten_pk = auspraegung.fk_bodeneinheit
        and 
        csv_import.is_hauptauspraegung::boolean = auspraegung.is_hauptauspraegung 
        and 
        csv_import.gewichtung_auspraegung::afu_isboden.d_gt_0_le_100 = auspraegung.gewichtung_auspraegung 
),

untertypen_mit_auspraegungen_und_untertypen as (
    select 
        untertypen.bodeneinheiten_pk, 
        auspraegungen.pk_auspraegung,
        untertypen.untertypen, 
        untertyp_t.pk_untertyp as pk_untertyp 
    from 
        untertypen untertypen
    left join 
        auspraegungen auspraegungen
        on 
        auspraegungen.pk_bodeneinheit = untertypen.bodeneinheiten_pk
        AND 
        auspraegungen.pk_auspraegung = untertypen.fk_auspraegung
    left join 
        afu_isboden.untertyp_t untertyp_t 
        on 
        untertypen.untertypen = untertyp_t.code 
)


insert into afu_isboden.zw_bodeneinheit_untertyp 
(
    fk_bodeneinheit, 
    fk_untertyp
)
(
    select 
        pk_auspraegung as fk_bodeneinheit, 
        pk_untertyp as fk_untertyp 
    from
        untertypen_mit_auspraegungen_und_untertypen
)
;

--update to recalculate kuerzel
-- Das folgende Update löst über einen Update_trigger (update_kuerzel_bodeneinheit_t) die Funktion afu_isboden.update_kuerzel_trigger_function() aus.
UPDATE 
    afu_isboden.bodeneinheit_auspraegung_t 
    SET 
    fk_bodeneinheit = fk_bodeneinheit
WHERE 
    fk_bodeneinheit in (select bodeneinheiten_pk from afu_isboden_csv_import_v1.csv_import_csv_import_t)
;