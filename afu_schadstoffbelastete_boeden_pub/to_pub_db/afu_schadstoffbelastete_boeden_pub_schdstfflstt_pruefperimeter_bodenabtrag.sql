DELETE FROM afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_pruefperimeter_bodenabtrag;

WITH

pruefperimeter_bodenabtrag AS (
SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'bodenbelastungsgebiet' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_bodenbelastungsgebiet	
WHERE 
	schdstfflstt_bden_bodenbelastungsgebiet.aktiv = TRUE

UNION

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'eisenbahn' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_eisenbahn
WHERE
	aktiv = TRUE 
AND
	astatus = 'Verdachtsflaeche'	
AND 
	 flaechentyp!= 'Tunnelstrecke'
AND
	(flaechentyp!='Verdachtsstreifen_entlang_Gleise' 
OR 
	verdachtsstreifenbreite!='kein_Verdachtsstreifen')
	
UNION

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'flugplatz' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_flugplatz
WHERE
	aktiv = TRUE
	
UNION

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'hopfenbau' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_hopfenbau
WHERE
	aktiv = TRUE
	
UNION

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'rebbau' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_rebbau
WHERE
	aktiv = TRUE
			
UNION

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'schiessanlage' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_schiessanlage
WHERE
	aktiv = TRUE
	
UNION 

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'schrebergarten' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_schrebergarten
WHERE
	aktiv = TRUE			
	
UNION 

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'strasse' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_strasse
WHERE
	aktiv = TRUE 
AND
	astatus = 'Verdachtsflaeche'	
AND
	verdachtsstreifenbreite != 'kein_Verdachtsstreifen'	
	
UNION
	
SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'siedlungsgebiet' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_siedlungsgebiet
WHERE
	aktiv = TRUE
		
UNION 

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'stahlbruecke' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlbruecke
WHERE
	aktiv= TRUE		
	
UNION 

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'stahlmast' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlmast
WHERE
	schdstfflstt_bden_stahlmast.aktiv= TRUE		
	
UNION 	

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'stahlkonstruktion' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_stahlkonstruktion
WHERE
	aktiv= TRUE		
	
UNION

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'geogene_bodenbelastung' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_geogene_bodenbelastung
WHERE
	schdstfflstt_bden_geogene_bodenbelastung.aktiv= TRUE			

UNION 	

	SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'militaerischer_schiessplatz' AS typ
	FROM 
		afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_militaerischer_schiessplatz
	WHERE	
		schdstfflstt_bden_militaerischer_schiessplatz.aktiv= TRUE		
	
UNION 	

SELECT 
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	'gaertnerei' AS typ
FROM 
	afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_gaertnerei
WHERE	
	aktiv= TRUE		
)

INSERT INTO afu_schadstoffbelastete_boeden_pub_v1.schdstfflstt_bden_pruefperimeter_bodenabtrag (
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	typ
)
SELECT
	t_id,
	t_ili_tid,
	geometrie,
	astatus,
	aktiv,
	nutzungseinschraenkung,
	nutzungsverbot,
	typ
FROM
	pruefperimeter_bodenabtrag
;