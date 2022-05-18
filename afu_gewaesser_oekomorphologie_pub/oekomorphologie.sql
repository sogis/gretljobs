WITH breitenvariabilitaetspunkte AS (
    SELECT 
        t_id,
        CASE 
            WHEN breitenvariabilitaet = 'nicht_bestimmt'
            THEN -10 
            WHEN breitenvariabilitaet = 'ausgepraegt' 
            THEN 0
            WHEN breitenvariabilitaet = 'eingeschraenkt'
            THEN 2 
            WHEN breitenvariabilitaet = 'keine' 
            THEN 3 
        END AS punkte
    FROM 
        afu_gewaesser_v1.oekomorph_v
),

sohle_breitenvariabilitaet AS (
    SELECT 
        oekomorph.t_id, 
        CASE
	        WHEN sohlenbreite IS NULL 
            THEN NULL 
            ELSE 
                CASE 
                    WHEN breitenvariabilitaet = 'ausgepraegt'
                    THEN sohlenbreite 
                    WHEN breitenvariabilitaet = 'eingeschraenkt'
                    THEN sohlenbreite*1.5 
                    WHEN breitenvariabilitaet = 'keine' 
                    THEN sohlenbreite*2 
                END 
            END AS punkte
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph
),

sohlenverbauungspunkte AS (
    SELECT 
        t_id,
        CASE 
            WHEN sohlenverbauung = 'nicht_bestimmt'
            THEN -10 
            WHEN sohlenverbauung = 'keine'
            THEN 0 
            WHEN sohlenverbauung = 'vereinzelt'
            THEN 1 
            WHEN sohlenverbauung = 'maessig' 
            THEN 2 
            ELSE 
            CASE 
                WHEN sohlmaterial IN ('Natursteine','Holz','Betongittersteine')
                THEN 2 
                ELSE 3 
            END 
        END AS punkte 
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph
), 

eindolungspunkte AS (
    SELECT 
        t_id,
        CASE 
            WHEN eindolung IS TRUE 
            THEN -100 
            ELSE 0 
        END AS punkte
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph
),

boeschungsverbauung_rechts AS (
    SELECT 
        t_id, 
        CASE 
            WHEN boeschungsfussverbaurechts IN ('nicht_bestimmt','unverbaut','punktuell') 
            THEN 0 
            WHEN boeschungsfussverbaurechts = 'maessig' AND materialrechts IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 0.5 
            WHEN boeschungsfussverbaurechts = 'maessig' AND materialrechts NOT IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 1 
            WHEN boeschungsfussverbaurechts = 'groessere' AND materialrechts IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 1.5 
            WHEN boeschungsfussverbaurechts = 'groessere' AND materialrechts NOT IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 2
            WHEN boeschungsfussverbaurechts IN ('ueberwiegend','vollstaendig') AND materialrechts IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 2.5 
            WHEN boeschungsfussverbaurechts IN ('ueberwiegend','vollstaendig') AND materialrechts NOT IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 3
        END AS buk_rechts
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph
),

boeschungsverbauung_links AS (
    SELECT 
        t_id, 
        CASE 
            WHEN boeschungsfussverbaulinks IN ('nicht_bestimmt','unverbaut','punktuell') 
            THEN 0 
            WHEN boeschungsfussverbaulinks = 'maessig' AND materiallinks IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 0.5 
            WHEN boeschungsfussverbaulinks = 'maessig' AND materiallinks NOT IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 1 
            WHEN boeschungsfussverbaulinks = 'groessere' AND materiallinks IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 1.5 
            WHEN boeschungsfussverbaulinks = 'groessere' AND materiallinks NOT IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 2
            WHEN boeschungsfussverbaulinks IN ('ueberwiegend','vollstaendig') AND materiallinks IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 2.5 
            WHEN boeschungsfussverbaulinks IN ('ueberwiegend','vollstaendig') AND materiallinks NOT IN ('Lebendverbau','Betongittersteine','Holz','Naturstein_locker')
            THEN 3
        END AS buk_links
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph
),

boeschungsverbauungspunkte AS (
    SELECT 
        oekomorph.t_id,
        CASE 
            WHEN (boeschungsfussverbaurechts != 'nicht_bestimmt' 
                 AND
                 boeschungsfussverbaulinks != 'nicht_bestimmt')
             THEN 
                 CASE 
                     WHEN ((boeschungsfussverbaurechts != 'unverbaut' AND materialrechts = 'nicht_bestimmt')
                            OR 
                           (boeschungsfussverbaulinks != 'unverbaut' AND materiallinks = 'nicht_bestimmt'))
                     THEN -10 
                     ELSE round((boeschungsverbauung_rechts.buk_rechts + boeschungsverbauung_links.buk_links)/2,0)
                 END 
             ELSE -10 
         END AS punkte
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph, 
        boeschungsverbauung_rechts,
        boeschungsverbauung_links
    WHERE 
        oekomorph.t_id = boeschungsverbauung_rechts.t_id 
        AND 
        oekomorph.t_id = boeschungsverbauung_links.t_id
),

beurteilungsuferbreiterechts AS (
    SELECT 
    t_id,
        CASE 
            WHEN (sohlenbreite IS NULL OR breitenvariabilitaet = 'nicht_bestimmt') 
            THEN 'nicht_beurteilt'
            ELSE 
                CASE 
                    WHEN uferbreiterechts = 0 
                    THEN 'kein_uferbereich' 
                    WHEN (breitenvariabilitaet = 'ausgepraegt' 
                          AND 
                          (
                              (sohlenbreite < 2 AND uferbreiterechts >= 5) 
                               OR
                              (2 <= sohlenbreite AND sohlenbreite <= 15 AND uferbreiterechts >= (3/4*sohlenbreite+3.5))
                               OR 
                              (sohlenbreite > 15 AND uferbreiterechts >= 15)
                          )
                         )
                    THEN 'genuegend'
                    WHEN (breitenvariabilitaet = 'eingeschraenkt' 
                          AND 
                          (
                              (sohlenbreite < 4/3 AND uferbreiterechts >= 5) 
                               OR
                              (4/3 <= sohlenbreite AND sohlenbreite <= 10 AND uferbreiterechts >= (5.5/4*sohlenbreite+3.5))
                               OR 
                              (sohlenbreite > 10 AND uferbreiterechts >= 15)
                          )
                         )
                    THEN 'genuegend'
                    WHEN (breitenvariabilitaet = 'keine' 
                          AND 
                          (
                              (sohlenbreite < 1 AND uferbreiterechts >= 5) 
                               OR
                              (1 <= sohlenbreite AND sohlenbreite <= 15/2 AND uferbreiterechts >= (2*sohlenbreite+3.5))
                               OR 
                              (sohlenbreite > 15/2 AND uferbreiterechts >= 15)
                          )
                         )
                    THEN 'genuegend'
                    ELSE 'ungenuegend'
                END 
        END AS beurteilung
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph
),

beurteilungsuferbreitelinks AS (
    SELECT 
    t_id,
        CASE 
            WHEN (sohlenbreite IS NULL OR breitenvariabilitaet = 'nicht_bestimmt') 
            THEN 'nicht_beurteilt'
            ELSE 
                CASE 
                    WHEN uferbreitelinks = 0 
                    THEN 'kein_uferbereich' 
                    WHEN (breitenvariabilitaet = 'ausgepraegt' 
                          AND 
                          (
                              (sohlenbreite < 2 AND uferbreitelinks >= 5) 
                               OR
                              (2 <= sohlenbreite AND sohlenbreite <= 15 AND uferbreitelinks >= (3/4*sohlenbreite+3.5))
                               OR 
                              (sohlenbreite > 15 AND uferbreitelinks >= 15)
                          )
                         )
                    THEN 'genuegend'
                    WHEN (breitenvariabilitaet = 'eingeschraenkt' 
                          AND 
                          (
                              (sohlenbreite < 4/3 AND uferbreitelinks >= 5) 
                               OR
                              (4/3 <= sohlenbreite AND sohlenbreite <= 10 AND uferbreitelinks >= (5.5/4*sohlenbreite+3.5))
                               OR 
                              (sohlenbreite > 10 AND uferbreitelinks >= 15)
                          )
                         )
                    THEN 'genuegend'
                    WHEN (breitenvariabilitaet = 'keine' 
                          AND 
                          (
                              (sohlenbreite < 1 AND uferbreitelinks >= 5) 
                               OR
                              (1 <= sohlenbreite AND sohlenbreite <= 15/2 AND uferbreitelinks >= (2*sohlenbreite+3.5))
                               OR 
                              (sohlenbreite > 15/2 AND uferbreitelinks >= 15)
                          )
                         )
                    THEN 'genuegend'
                    ELSE 'ungenuegend'
                END 
        END AS beurteilung
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph
),

uferbewertung_rechts AS (
    SELECT 
        oekomorph.t_id,
        CASE 
            WHEN (beurteilungsuferbreiterechts.beurteilung = 'kein_uferbereich' OR uferbeschaffenheitrechts = 'kuenstlich')
            THEN 3 
            ELSE 
                CASE 
                    WHEN (beurteilungsuferbreiterechts.beurteilung = 'genuegend' AND uferbeschaffenheitrechts = 'gewaessergerecht') 
                    THEN 0
                    WHEN (beurteilungsuferbreiterechts.beurteilung = 'genuegend' AND uferbeschaffenheitrechts != 'gewaessergerecht')
                    THEN 1.5 
                    WHEN (beurteilungsuferbreiterechts.beurteilung != 'genuegend' AND uferbeschaffenheitrechts = 'gewaessergerecht')
                    THEN 2 
                    WHEN (beurteilungsuferbreiterechts.beurteilung != 'genuegend' AND uferbeschaffenheitrechts != 'gewaessergerecht')
                    THEN 3
                END 
        END AS bewertung
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph,
        beurteilungsuferbreiterechts
    WHERE 
        oekomorph.t_id = beurteilungsuferbreiterechts.t_id 
),
        
uferbewertung_links AS (
    SELECT 
        oekomorph.t_id,
        CASE 
            WHEN (beurteilungsuferbreitelinks.beurteilung = 'kein_uferbereich' OR uferbeschaffenheitlinks = 'kuenstlich')
            THEN 3 
            ELSE 
                CASE 
                    WHEN (beurteilungsuferbreitelinks.beurteilung = 'genuegend' AND uferbeschaffenheitlinks = 'gewaessergerecht') 
                    THEN 0
                    WHEN (beurteilungsuferbreitelinks.beurteilung = 'genuegend' AND uferbeschaffenheitlinks != 'gewaessergerecht')
                    THEN 1.5 
                    WHEN (beurteilungsuferbreitelinks.beurteilung != 'genuegend' AND uferbeschaffenheitlinks = 'gewaessergerecht')
                    THEN 2 
                    WHEN (beurteilungsuferbreitelinks.beurteilung != 'genuegend' AND uferbeschaffenheitlinks != 'gewaessergerecht')
                    THEN 3
                END 
        END AS bewertung
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph,
        beurteilungsuferbreitelinks
    WHERE 
        oekomorph.t_id = beurteilungsuferbreitelinks.t_id 
),

uferpunkte AS (
SELECT
    oekomorph.t_id, 
    CASE 
        WHEN (beurteilungsuferbreiterechts.beurteilung = 'nicht_beurteilt' OR beurteilungsuferbreitelinks.beurteilung = 'nicht_beurteilt')
        THEN -10 
        ELSE round((uferbewertung_links.bewertung + uferbewertung_rechts.bewertung)/2,0)
    END AS punkte
FROM 
    afu_gewaesser_v1.oekomorph_v oekomorph, 
    uferbewertung_links,
    uferbewertung_rechts, 
    beurteilungsuferbreitelinks, 
    beurteilungsuferbreiterechts
WHERE 
    oekomorph.t_id = uferbewertung_links.t_id 
    AND 
    oekomorph.t_id = uferbewertung_rechts.t_id
    AND 
    oekomorph.t_id = beurteilungsuferbreitelinks.t_id 
    AND 
    oekomorph.t_id = beurteilungsuferbreiterechts.t_id 
),

raumbedarf AS ( 
    
    SELECT 
        oekomorph.t_id, 
        CASE
	        WHEN sohle_breitenvariabilitaet.punkte < 2 
            THEN 11
            WHEN (sohle_breitenvariabilitaet.punkte >= 2 AND sohle_breitenvariabilitaet.punkte <= 15)
            THEN 2.5*sohle_breitenvariabilitaet.punkte+7
            WHEN sohle_breitenvariabilitaet.punkte > 15
            THEN 45
        END AS raumbedarf
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph, 
        sohle_breitenvariabilitaet
    WHERE 
        oekomorph.t_id = sohle_breitenvariabilitaet.t_id
), 

minimaler_uferbereich AS ( 
    SELECT 
        oekomorph.t_id, 
        CASE
	        WHEN sohle_breitenvariabilitaet.punkte < 2 
            THEN round((11 - sohle_breitenvariabilitaet.punkte)/2,0)
            WHEN (sohle_breitenvariabilitaet.punkte >= 2 AND sohle_breitenvariabilitaet.punkte <= 15)
            THEN round(((2.5*sohle_breitenvariabilitaet.punkte+7 - sohle_breitenvariabilitaet.punkte)/2),0)
            WHEN sohle_breitenvariabilitaet.punkte > 15
            THEN 15
        END AS breite
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph, 
        sohle_breitenvariabilitaet
    WHERE 
        oekomorph.t_id = sohle_breitenvariabilitaet.t_id
), 

oekomorphpunkte AS (
    SELECT 
        oekomorph.t_id, 
        (eindolungspunkte.punkte + breitenvariabilitaetspunkte.punkte + sohlenverbauungspunkte.punkte + boeschungsverbauungspunkte.punkte + uferpunkte.punkte) AS punkte
    FROM 
        afu_gewaesser_v1.oekomorph_v oekomorph, 
        eindolungspunkte, 
        breitenvariabilitaetspunkte, 
        sohlenverbauungspunkte, 
        boeschungsverbauungspunkte, 
        uferpunkte
    WHERE 
        eindolungspunkte.t_id = oekomorph.t_id 
        AND 
        breitenvariabilitaetspunkte.t_id = oekomorph.t_id
        AND 
        sohlenverbauungspunkte.t_id = oekomorph.t_id
        AND 
        boeschungsverbauungspunkte.t_id = oekomorph.t_id
        AND 
        uferpunkte.t_id = oekomorph.t_id
),

oekomorphologie AS (
    SELECT 
        t_id,
        CASE 
            WHEN punkte <= -100
            THEN 'eingedolt' 
            WHEN (punkte > -100 AND punkte < 0) 
            THEN 'nicht_bestimmt' 
            WHEN (punkte >= 0 AND punkte <= 1)
            THEN 'natuerlich_naturnah' 
            WHEN (punkte > 1 AND punkte <= 5)
            THEN 'wenig_beeintraechtigt'
            WHEN (punkte > 5 AND punkte <= 9)
            THEN 'stark_beeintraechtigt'
            WHEN (punkte > 9 AND punkte <= 12)
            THEN 'naturfremd_kuenstlich'
        END AS klasse
    FROM 
        oekomorphpunkte
)

SELECT 
    attr.sohlenbreite,
    attr.eindolung,
    '' AS eindolung_txt,
    attr.breitenvariabilitaet,
    '' AS breitenvariabilitaet_txt,
    attr.tiefenvariabilitaet,
    '' AS tiefenvariabilitaet_txt,
    attr.sohlenverbauung,
    '' AS sohlenverbauung_txt,
    attr.sohlmaterial,
    '' AS sohlmaterial_txt,
    attr.boeschungsfussverbaulinks,
    '' AS boeschungsfussverbaulinks_txt,
    attr.boeschungsfussverbaurechts,
    '' AS boeschungsfussverbaurechts_txt,
    attr.materiallinks,
    '' AS materiallinks_txt,
    attr.materialrechts,
    '' AS materialrechts_txt,
    attr.uferbreitelinks,
    attr.uferbreiterechts, 
    attr.uferbeschaffenheitlinks,
    '' AS uferbeschaffenheitlinks_txt,
    attr.uferbeschaffenheitrechts,
    '' AS uferbeschaffenheitrechts_txt,
    attr.algenbewuchs,
    '' AS algenbewuchs_txt,
    attr.makrophytenbewuchs,
    '' AS makrophytenbewuchs_txt,
    attr.totholz,
    '' AS totholz_txt,
    attr.ueberhvegetation,
    '' AS ueberhvegetation_txt,
    attr.domkorngroesse,
    '' AS domkorngroesse_txt,
    attr.nutzungumlandlinks,
    '' AS nutzungumlandlinks_txt,
    attr.nutzungumlandrechts,
    '' AS nutzungumlandrechts_txt,
    attr.vielenatabstuerze,
    '' AS vielenatabstuerze_txt,
    oekomorphologie.klasse AS klasse, 
    '' AS klasse_txt,
    beurteilungsuferbreitelinks.beurteilung AS beurteilungsuferbreitelinks, 
    '' AS beurteilungsuferbreitelinks_txt,
    beurteilungsuferbreiterechts.beurteilung AS beurteilungsuferbreiterechts, 
    '' AS beurteilungsuferbreiterechts_txt,
    minimaler_uferbereich.breite AS minimaleruferbereich, 
    raumbedarf.raumbedarf, 
    attr.erhebungsdatum, 
    attr.geometrie AS geometrie
FROM 
    afu_gewaesser_v1.oekomorph_v attr 
JOIN 
    raumbedarf raumbedarf  
    ON 
    raumbedarf.t_id = attr.t_id
JOIN 
    beurteilungsuferbreiterechts
    ON 
    beurteilungsuferbreiterechts.t_id = attr.t_id 
JOIN 
    beurteilungsuferbreitelinks 
    ON 
    beurteilungsuferbreitelinks.t_id = attr.t_id
JOIN 
    minimaler_uferbereich
    ON 
    minimaler_uferbereich.t_id = attr.t_id
JOIN 
    oekomorphologie
    ON 
    oekomorphologie.t_id = attr.t_id
;

