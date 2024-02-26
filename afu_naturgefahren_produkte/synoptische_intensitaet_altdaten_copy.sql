with
basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
), 

attribute_mapping as (
    SELECT 
	    st_multi(geometrie) as geometrie, --Im neuen Modell sind Multi-Polygone
    	CASE 
		    WHEN int_stufe = 'keine'
			    THEN 'keine_einwirkung'
			WHEN int_stufe = 'vorhanden'
			    THEN 'einwirkung_vorhanden'
		    WHEN int_stufe = 'schwach'
			    THEN 'schwach'
		    WHEN int_stufe = 'mittel'
			    THEN 'mittel'
	        WHEN int_stufe = 'stark'
			    THEN 'hoch'
            ELSE 'MAPPING_ERROR' 
	    END AS int_stufe,
	    CASE
		    WHEN wkp = 'von_0_bis_30_Jahre'
			    THEN 30
		    WHEN wkp = 'von_30_bis_100_Jahre'
			    THEN 100
		    WHEN wkp = 'von_100_bis_300_Jahre'
			    THEN 300
		    WHEN wkp = 'groesser_300_Jahre'
			    THEN 500
		    WHEN wkp IS NULL
	            THEN NULL
		    ELSE -9999
	    END AS wkp,
	CASE
		WHEN teilproz = 'Ufererosion'
			THEN 'w_ufererosion'
		WHEN teilproz = 'Ueberschwemmung'
			THEN 'w_ueberschwemmung'
		WHEN teilproz = 'Uebermurung'
			THEN 'w_uebermurung'
		WHEN teilproz = 'Steinschlag_Blockschlag'
			THEN 's_stein_block_schlag'
		WHEN teilproz = 'spontane_Rutschung'
		    THEN 'r_plo_spontane_rutschung'
		WHEN teilproz = 'permanente_Rutschung'
			THEN 'r_permanente_rutschung'
		WHEN teilproz = 'Hangmure'
			THEN 'r_plo_hangmure'
		WHEN teilproz = 'Felssturz_Bergsturz'
			THEN 's_fels_berg_sturz'
		WHEN teilproz = 'Einsturz_Absenkung'
		    THEN 'einsturz_absenkung'
		ELSE 'MAPPING_ERROR'
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