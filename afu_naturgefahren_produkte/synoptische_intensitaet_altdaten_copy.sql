WITH
basket AS (
     SELECT 
         t_id 
     FROM 
         afu_naturgefahren_staging_v1.t_ili2db_basket
)

,attribute_mapping AS (
    SELECT 
        st_multi(geometrie) as geometrie, --Im neuen Modell sind Multi-Polygone
    	CASE 
            WHEN int_stufe = 'vorhanden'
            THEN 'einwirkung_vorhanden'
            WHEN int_stufe = 'schwach'
       	    THEN 'schwach'
            WHEN int_stufe = 'mittel'
            THEN 'mittel'
            WHEN int_stufe = 'stark'
            THEN 'stark'
            when int_stufe = 'keine'
            then 'keine_einwirkung'
        END AS int_stufe,
	CASE
            WHEN wkp = 'von_0_bis_30_Jahre'
            THEN 30
            WHEN wkp = 'von_30_bis_100_Jahre'
            THEN 100
            WHEN wkp = 'von_100_bis_300_Jahre'
            THEN 300
            WHEN wkp = 'groesser_300_Jahre'
            THEN -1 --Restgefährdung
            WHEN wkp IS NULL
            THEN null
            WHEN int_stufe = 'vorhanden' --Restgefährdung
            then -1
	END AS wkp,
	CASE
            WHEN teilproz = 'Ufererosion'
            THEN 'ufererosion'
            WHEN teilproz = 'Ueberschwemmung'
            THEN 'ueberschwemmung'
            WHEN teilproz = 'Uebermurung'
            THEN 'uebermurung'
            WHEN teilproz = 'Steinschlag_Blockschlag'
            THEN 'stein_blockschlag'
            WHEN teilproz = 'spontane_Rutschung'
            THEN 'spontane_rutschung'
            WHEN teilproz = 'permanente_Rutschung'
            THEN 'permanente_rutschung'
            WHEN teilproz = 'Hangmure'
            THEN 'hangmure'
            WHEN teilproz = 'Felssturz_Bergsturz'
            THEN 'fels_bergsturz'
            WHEN teilproz = 'Einsturz_Absenkung'
            THEN 'einsturz_absenk+ung'
	END AS teilproz
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_ik_synoptisch_mgdm
    
)

INSERT INTO afu_naturgefahren_staging_v1.synoptische_intensitaet (
    t_basket,
    teilprozess, 
    jaehrlichkeit, 
    intensitaet, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)
 select
    basket.t_id as t_basket, 
    syn.teilproz as teilprozess,
    syn.wkp::integer as jaehrlichkeit,
    syn.int_stufe as intensitaet,
    syn.geometrie, 
    'Altdaten' as datenherkunft,
    null as auftrag_neudaten
from 
    attribute_mapping syn,
    basket basket
;