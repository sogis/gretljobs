WITH
lines AS (
  SELECT 
    ST_Union(st_boundary(geometrie)) AS geometrie
  FROM
    afu_naturgefahren_staging_v1.abklaerungsperimeter
)

,splited AS (
  SELECT 
    (ST_Dump(ST_Polygonize(geometrie))).geom AS geometrie
  FROM
    lines
)

,withpoint AS (
    SELECT
        ROW_NUMBER() OVER() AS id, 
        geometrie AS poly,
        ST_PointOnSurface(geometrie) AS point
    FROM 
        splited
    WHERE 
        ST_Area(geometrie) > 1
)

,erhebungsgebiet_mapped AS (
    SELECT 
        geometrie,
        concat('_',t_ili_tid,'.so.ch')::text AS t_ili_tid,
        erhebungsstand,
        teilprozess
    FROM 
        afu_naturgefahren_staging_v1.abklaerungsperimeter
)

,attribute_agg AS (
    SELECT 
        id, 
        point,
        poly,
        string_agg(distinct absenkung.erhebungsstand,', ') AS status_absenkung, 
        string_agg(distinct einsturz.erhebungsstand,', ') AS status_einsturz,
        string_agg(distinct perm_rutschung.erhebungsstand,', ') AS status_permanente_rutschung,
        string_agg(distinct hangmure.erhebungsstand,', ') AS status_hangmure,
        string_agg(distinct spont_rutschung.erhebungsstand,', ') AS status_spontane_rutschung,
        string_agg(distinct fels_bergsturz.erhebungsstand,', ') AS status_fels_berg_sturz,
        string_agg(distinct stein_blockschlag.erhebungsstand,', ') AS status_stein_block_schlag,
        string_agg(distinct murgang.erhebungsstand,', ') AS status_uebermurung,
        string_agg(distinct ueberschwemmung.erhebungsstand,', ') AS status_ueberschwemmung,
        string_agg(distinct ufererosion.erhebungsstand,', ') AS status_ufererosion
    FROM 
        withpoint point
    LEFT JOIN
        (SELECT geometrie, erhebungsstand FROM erhebungsgebiet_mapped WHERE teilprozess = 'absenkung') absenkung 
        ON 
        st_dwithin(absenkung.geometrie, point.point, 0)
    LEFT JOIN
        (SELECT geometrie, erhebungsstand FROM erhebungsgebiet_mapped WHERE teilprozess = 'einsturz') einsturz 
        ON 
        st_dwithin(einsturz.geometrie, point.point, 0)     
    LEFT JOIN
        (SELECT geometrie, erhebungsstand FROM erhebungsgebiet_mapped WHERE teilprozess = 'permanente_rutschung') perm_rutschung 
        ON 
        st_dwithin(perm_rutschung.geometrie, point.point, 0)  
    LEFT JOIN
        (SELECT geometrie, erhebungsstand FROM erhebungsgebiet_mapped WHERE teilprozess = 'hangmure') hangmure 
        ON 
        st_dwithin(hangmure.geometrie, point.point, 0)  
    LEFT JOIN
        (SELECT geometrie, erhebungsstand FROM erhebungsgebiet_mapped WHERE teilprozess = 'spontane_rutschung') spont_rutschung 
        ON 
        st_dwithin(spont_rutschung.geometrie, point.point, 0)   
    LEFT JOIN
        (SELECT geometrie, erhebungsstand FROM erhebungsgebiet_mapped WHERE teilprozess = 'fels_bergsturz') fels_bergsturz 
        ON 
        st_dwithin(fels_bergsturz.geometrie, point.point, 0) 
    LEFT JOIN
        (SELECT geometrie, erhebungsstand FROM erhebungsgebiet_mapped WHERE teilprozess = 'stein_blockschlag') stein_blockschlag 
        ON 
        st_dwithin(stein_blockschlag.geometrie, point.point, 0) 
    LEFT JOIN
        (SELECT geometrie, erhebungsstand FROM erhebungsgebiet_mapped WHERE teilprozess = 'uebermurung') murgang 
        ON 
        st_dwithin(murgang.geometrie, point.point, 0) 
    LEFT JOIN
        (SELECT geometrie, erhebungsstand FROM erhebungsgebiet_mapped WHERE teilprozess = 'ueberschwemmung') ueberschwemmung 
        ON 
        st_dwithin(ueberschwemmung.geometrie, point.point, 0) 
    LEFT JOIN
        (SELECT geometrie, erhebungsstand FROM erhebungsgebiet_mapped WHERE teilprozess = 'ufererosion') ufererosion 
        ON 
        st_dwithin(ufererosion.geometrie, point.point, 0) 
    GROUP BY 
        id, point,poly
),

basket AS (
     SELECT 
         t_id,
         attachmentkey
     FROM 
         afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO 
    afu_naturgefahren_staging_v1.erhebungsgebiet (
        t_basket,
        flaeche, 
        datenherr, 
        status_ueberschwemmung, 
        status_uebermurung, 
        status_ufererosion, 
        status_permanente_rutschung, 
        status_spontane_rutschung, 
        status_hangmure, 
        status_stein_block_schlag, 
        status_fels_berg_sturz, 
        status_einsturz, 
        status_absenkung, 
        kommentar
)
SELECT 
    basket.t_id AS t_basket,
    poly AS flaeche,
    'SO' AS datenherr,
    coalesce(status_ueberschwemmung, 'nicht_beurteilt') AS fl_state_flooding,
    coalesce(status_uebermurung, 'nicht_beurteilt') AS df_state_debris_flow,
    coalesce(status_ufererosion, 'nicht_beurteilt') AS be_state_bank_erosion,
    coalesce(status_permanente_rutschung, 'nicht_beurteilt') AS pl_state_permanent_landslide,
    coalesce(status_spontane_rutschung, 'nicht_beurteilt') AS sl_state_spontaneous_landslide,
    coalesce(status_hangmure, 'nicht_beurteilt') AS hd_state_hillslope_debris_flow,
    coalesce(status_stein_block_schlag, 'nicht_beurteilt') AS rf_state_rock_fall,
    coalesce(status_fels_berg_sturz, 'nicht_beurteilt') AS rs_state_rock_slide_rock_aval,
    coalesce(status_einsturz, 'nicht_beurteilt') AS sh_state_sinkhole,
    coalesce(status_absenkung,'nicht_beurteilt') AS su_state_subsidence,
    NULL AS kommentar
FROM 
    attribute_agg
    ,basket
;

UPDATE afu_naturgefahren_staging_v1.erhebungsgebiet 
SET flaeche = ST_ReducePrecision(flaeche,0.001)
;

DELETE FROM afu_naturgefahren_staging_v1.erhebungsgebiet 
WHERE ST_Isempty(flaeche) = true
; 



