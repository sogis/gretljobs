UPDATE 
   awjf_schutzwald_pub_v1.behandelte_flaeche
SET 
    massnahme_txt = (SELECT 
                         dispname 
                     FROM 
                        awjf_schutzwald_pub_v1.behandelte_flaeche_massnahme
                     WHERE 
                         behandelte_flaeche.massnahme = behandelte_flaeche_massnahme.ilicode)
;

UPDATE 
   awjf_schutzwald_pub_v1.behandelte_flaeche
SET 
    astatus_txt = (SELECT 
                         dispname 
                   FROM 
                       awjf_schutzwald_pub_v1.behandelte_flaeche_status
                   WHERE 
                       behandelte_flaeche.astatus = behandelte_flaeche_status.ilicode)
;

UPDATE 
   awjf_schutzwald_pub_v1.dokument
SET 
    nais_code_txt = (SELECT 
                         dispname 
                     FROM 
                        awjf_schutzwald_pub_v1.nais_code
                     WHERE 
                         dokument.nais_code = nais_code.ilicode)
;

UPDATE 
   awjf_schutzwald_pub_v1.schutzwald
SET 
    sturz_txt = (SELECT
                     CASE 
                         WHEN sturz IS TRUE 
                             THEN 'Ja'
                         ELSE 'Nein'
                     END)
;

UPDATE 
   awjf_schutzwald_pub_v1.schutzwald
SET 
    rutsch_txt = (SELECT
                     CASE 
                         WHEN rutsch IS TRUE 
                             THEN 'Ja'
                         ELSE 'Nein'
                     END)
;

UPDATE 
   awjf_schutzwald_pub_v1.schutzwald
SET 
    gerinnerelevante_prozesse_txt = (SELECT
                                         CASE 
                                             WHEN gerinnerelevante_prozesse IS TRUE 
                                                 THEN 'Ja'
                                             ELSE 'Nein'
                                         END)
;

UPDATE 
   awjf_schutzwald_pub_v1.schutzwald
SET 
    lawine_txt = (SELECT
                     CASE 
                         WHEN lawine IS TRUE 
                             THEN 'Ja'
                         ELSE 'Nein'
                     END)
;

UPDATE 
   awjf_schutzwald_pub_v1.schutzwald
SET 
    andere_kt_txt = (SELECT
                         CASE 
                             WHEN andere_kt IS TRUE 
                                 THEN 'Ja'
                             ELSE 'Nein'
                         END)
;

UPDATE 
   awjf_schutzwald_pub_v1.schutzwald
SET 
    objektkategorie_txt = (SELECT 
                               dispname 
                           FROM 
                               awjf_schutzwald_pub_v1.schutzwald_objektkategorie
                           WHERE 
                               schutzwald.objektkategorie = schutzwald_objektkategorie.ilicode)
;

UPDATE 
   awjf_schutzwald_pub_v1.schutzwald
SET 
    hauptgefahrenpotential_txt = (SELECT 
                                      dispname 
                                  FROM 
                                      awjf_schutzwald_pub_v1.schutzwald_hauptgefahrenpotential
                                  WHERE 
                                      schutzwald.hauptgefahrenpotential = schutzwald_hauptgefahrenpotential.ilicode)
;

UPDATE 
   awjf_schutzwald_pub_v1.schutzwald
SET 
    intensitaet_geschaetzt_txt = (SELECT 
                                      dispname 
                                  FROM 
                                      awjf_schutzwald_pub_v1.schutzwald_intensitaet_geschaetzt
                                  WHERE 
                                      schutzwald.intensitaet_geschaetzt = schutzwald_intensitaet_geschaetzt.ilicode)
;

UPDATE 
   awjf_schutzwald_pub_v1.schutzwald_info
SET 
    zieltyp_txt = (SELECT 
                       dispname 
                   FROM 
                       awjf_schutzwald_pub_v1.schutzwald_info_zieltyp
                   WHERE 
                       schutzwald_info.zieltyp = schutzwald_info_zieltyp.ilicode)
;

UPDATE 
   awjf_schutzwald_pub_v1.schutzwald_info
SET 
    nais_code_txt = (SELECT 
                         dispname 
                     FROM 
                        awjf_schutzwald_pub_v1.nais_code
                     WHERE 
                         schutzwald_info.nais_code = nais_code.ilicode)
;
