SELECT 
    brueckenname, 
    eigentuemer, 
    brueckentyp, 
    betriebsstatus, 
    brueckentyp_txt, 
    geometrie, 
    bezeichnung, 
    astatus, 
    aktiv, 
    erfassungsdatum, 
    datenerfasser, 
    begruendung_aus_vsb_entlassen, 
    datum_aus_vsb_entlassen, 
    bemerkung, 
    nutzungseinschraenkung, 
    dokumente, 
    schadstoffe, 
    bfs_gemeindenummern, 
    gemeindenamen, 
    grundbuchnummern, 
    flurnamen, 
    nutzungsverbot, 
    status_txt, 
    begruendung_aus_vsb_entlassen_txt
FROM 
    afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_stahlbruecke
;
