WITH
orig_dataset AS (
    SELECT
        t_id  AS dataset  
    FROM 
        afu_naturgefahren_v1.t_ili2db_dataset
    WHERE 
        datasetname = ${kennung}
)

,orig_basket AS (
    SELECT 
        basket.t_id 
    FROM 
        afu_naturgefahren_v1.t_ili2db_basket basket,
        orig_dataset
    WHERE 
        basket.dataset = orig_dataset.dataset
        AND 
        topic like '%Befunde'
)

,basket AS (
    SELECT 
        t_id,
        attachmentkey
    FROM 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)
 
,gemeinden AS (
    SELECT
        gemeindename,
        geometrie, 
        bfs_gemeindenummer
    FROM 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
)

,berichte AS (
    SELECT 
        array_agg(teilauftrag.t_id) AS teilauftrag_tid,
        auftrag.kennung AS auftragskennung,
        auftrag.deklaration AS auftragsdeklaration,
        auftrag.abschlussjahr::text AS jahr,
        string_agg(DISTINCT teilauftrag.hauptprozess, ', ') AS hauptprozess,
        bericht.bericht AS titel, 
        bericht.dateiname AS dateiname,
        'https://geo.so.ch/docs/ch.so.afu.naturgefahren/'||bericht.dateiname AS link
    FROM 
        afu_naturgefahren_v1.auftrag auftrag 
    LEFT JOIN 
        afu_naturgefahren_v1.bericht bericht
        on 
        bericht.auftrag_r = auftrag.t_id 
    LEFT JOIN 
        afu_naturgefahren_v1.teilauftrag teilauftrag 
        on 
        teilauftrag.auftrag_r = auftrag.t_id
    group by 
        auftrag.kennung,
        auftrag.deklaration,
        auftrag.abschlussjahr::text,
        bericht.bericht,
        bericht.dateiname
)

,teilprozesse AS (
    SELECT 
        teilprozess_einsturz.geometrie,
        teilprozess_einsturz.prozessquelle_r AS prozessquelle_id 
    FROM 
        afu_naturgefahren_v1.befundeinsturz teilprozess_einsturz 
    WHERE 
        teilprozess_einsturz.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT 
        teilprozess_absenkung.geometrie,
        teilprozess_absenkung.prozessquelle_r AS prozessquelle_id 
    FROM 
        afu_naturgefahren_v1.befundabsenkung teilprozess_absenkung
    WHERE 
        teilprozess_absenkung.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT 
        teilprozess_bergfelssturz.geometrie,
        teilprozess_bergfelssturz_pq.prozessquelle_r AS prozessquelle_id 
    FROM 
        afu_naturgefahren_v1.befundbergfelssturz teilprozess_bergfelssturz
    LEFT JOIN 
        afu_naturgefahren_v1.pq_jaehrlichkeit_bergfelssturz teilprozess_bergfelssturz_pq 
        on 
        teilprozess_bergfelssturz.pq_jaehrlichkeit_bergfelssturz_r = teilprozess_bergfelssturz_pq.t_id
    WHERE 
        teilprozess_bergfelssturz.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT 
        teilprozess_hangmure.geometrie,
        teilprozess_hangmure_pq.prozessquelle_r AS prozessquelle_id 
    FROM 
        afu_naturgefahren_v1.befundhangmure teilprozess_hangmure
    LEFT JOIN 
        afu_naturgefahren_v1.pq_jaehrlichkeit_hangmure teilprozess_hangmure_pq 
        on 
        teilprozess_hangmure.pq_jaehrlichkeit_hangmure_r = teilprozess_hangmure_pq.t_id
    WHERE 
        teilprozess_hangmure.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT 
        teilprozess_permanentrutschung.geometrie,
        teilprozess_permanentrutschung.prozessquelle_r AS prozessquelle_id 
    FROM 
        afu_naturgefahren_v1.befundpermanenterutschung teilprozess_permanentrutschung
    WHERE 
        teilprozess_permanentrutschung.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT 
        teilprozess_spontanerutschung.geometrie,
        teilprozess_spontanerutschung_pq.prozessquelle_r AS prozessquelle_id 
    FROM 
        afu_naturgefahren_v1.befundspontanerutschung teilprozess_spontanerutschung
    LEFT JOIN 
        afu_naturgefahren_v1.pq_jaehrlichkeit_spontanerutschung teilprozess_spontanerutschung_pq 
        on 
        teilprozess_spontanerutschung.pq_jaehrlichkeit_spontanerutschung_r = teilprozess_spontanerutschung_pq.t_id
    WHERE 
        teilprozess_spontanerutschung.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT 
        teilprozess_steinblockschlag.geometrie,
        teilprozess_steinblockschlag_pq.prozessquelle_r AS prozessquelle_id 
    FROM 
        afu_naturgefahren_v1.befundsteinblockschlag teilprozess_steinblockschlag
    LEFT JOIN 
        afu_naturgefahren_v1.pq_jaehrlichkeit_steinblockschlag teilprozess_steinblockschlag_pq 
        on 
        teilprozess_steinblockschlag.pq_jaehrlichkeit_steinblockschlag_r = teilprozess_steinblockschlag_pq.t_id 
    WHERE 
        teilprozess_steinblockschlag.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT 
        teilprozess_uebermurung.geometrie,
        teilprozess_uebermurung.prozessquelle_r AS prozessquelle_id 
    FROM 
        afu_naturgefahren_v1.befunduebermurung teilprozess_uebermurung
    WHERE 
        teilprozess_uebermurung.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT 
        teilprozess_ueberschwemmungdynamisch.geometrie,
        teilprozess_ueberschwemmungdynamisch.prozessquelle_r AS prozessquelle_id 
    FROM 
        afu_naturgefahren_v1.befundueberschwemmungdynamisch teilprozess_ueberschwemmungdynamisch 
    WHERE 
        teilprozess_ueberschwemmungdynamisch.t_basket in (SELECT t_id FROM orig_basket)
    UNION ALL 
    SELECT 
        teilprozess_ueberschwemmungstatisch.geometrie,
        teilprozess_ueberschwemmungstatisch.prozessquelle_r AS prozessquelle_id 
    FROM 
        afu_naturgefahren_v1.befundueberschwemmungstatisch teilprozess_ueberschwemmungstatisch
    WHERE 
        teilprozess_ueberschwemmungstatisch.t_basket in (SELECT t_id FROM orig_basket)
),

dokumente_union AS (
SELECT distinct 
    basket.t_id AS t_basket, 
    gemeinden.bfs_gemeindenummer AS gemeinde_bfsnr, 
    gemeinden.gemeindename AS gemeinde_name,
    jsonb_build_object('@type', 'SO_AFU_Naturgefahren_Publikation_20240704.Naturgefahren.Dokument',
                      'Titel', berichte.titel, 
                      'Dateiname', berichte.dateiname, 
                      'Link', berichte.link, 
                      'Hauptprozesse', berichte.hauptprozess, 
                      'Jahr', berichte.jahr
                      ) AS dokumente,
    gemeinden.geometrie,
    berichte.jahr::text AS jahr
FROM 
    basket,
    teilprozesse befund
LEFT JOIN 
    afu_naturgefahren_v1.prozessquelle prozessquelle 
    on 
    befund.prozessquelle_id = prozessquelle.t_id
LEFT JOIN 
    berichte 
    on 
    prozessquelle.teilauftrag_r = ANY(berichte.teilauftrag_tid)
LEFT JOIN 
    gemeinden 
    on 
    st_dwithin(befund.geometrie,gemeinden.geometrie,0)
    
UNION ALL 

SELECT DISTINCT 
    basket.t_id AS t_basket,
    alte_dokumente.gemeinde_bfsnr,
    alte_dokumente.gemeinde_name,
    alte_dokumente.dokument AS dokumente,
    alte_dokumente.geometrie,
    alte_dokumente.dokument ->> 'Jahr' AS jahr
FROM 
    basket,
    afu_naturgefahren_alte_dokumente_v1.alte_dokumente alte_dokumente
)

INSERT INTO afu_naturgefahren_staging_v1.dokumente_pro_gemeinde (
    t_basket, 
    gemeinde_bfsnr, 
    gemeinde_name, 
    dokumente, 
    geometrie
)

SELECT 
    t_basket,
    gemeinde_bfsnr, 
    gemeinde_name,
    json_agg(dokumente order by jahr)::jsonb ||      
    jsonb_build_object('@type', 'SO_AFU_Naturgefahren_Publikation_20240704.Naturgefahren.Dokument',
                      'Titel', 'Lesehilfe', 
                      'Dateiname', 'B_Lesehilfe_Gefahrenkarte_PLANAT_120309.pdf', 
                      'Link', 'https://geo.so.ch/docs/ch.so.afu.naturgefahren/B_Lesehilfe_Gefahrenkarte_PLANAT_120309.pdf', 
                      'Hauptprozesse', '-', 
                      'Jahr', '-'
                      )
                      AS dokumente,
    geometrie
FROM 
    dokumente_union
GROUP by 
    t_basket,
    gemeinde_bfsnr,
    gemeinde_name,
    geometrie 
;