update afu_naturgefahren_staging_v1.fliesstiefen 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.fliesstiefen 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_sturz 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_sturz 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_absenkung_einsturz  
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_absenkung_einsturz 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_murgang 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_murgang 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_permanente_rutschung  
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_permanente_rutschung 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_spontane_rutschung
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_spontane_rutschung
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_hangmure 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_hangmure 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_stein_blockschlag 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_stein_blockschlag 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_fels_bergsturz 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_fels_bergsturz 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_ueberflutung 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_ueberflutung 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.synoptische_intensitaet 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.synoptische_intensitaet 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.synoptisches_gefahrengebiet 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.synoptisches_gefahrengebiet 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.ufererosion 
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.ufererosion 
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.abklaerungsperimeter
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.abklaerungsperimeter
where st_isempty(geometrie) = true
; 

update afu_naturgefahren_staging_v1.erhebungsgebiet
set geometrie = st_reducePrecision(geometrie,0.001)
;

delete from afu_naturgefahren_staging_v1.erhebungsgebiet
where st_isempty(geometrie) = true
; 