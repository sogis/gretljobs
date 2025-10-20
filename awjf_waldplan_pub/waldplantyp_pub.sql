SELECT
	nutzungskategorie,
	typ_nk.dispname AS yp_nknutzungskategorie_txt,
	geometrie,
	bemerkung
FROM 
	awjf_waldplan_v2.waldplan_waldplantyp AS wt
LEFT JOIN awjf_waldplan_v2.walplan_nutzungskategorie AS typ_nk --Klassenname wird noch angepasst im Modell, daher auch hier noch anpassen.
	ON wt.nutzungskategorie = typ_nk.ilicode