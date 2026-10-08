UPDATE avt_strassenlaermflaechen_pub_v1.strassenlarmflche_strassenlaermflaeche_nacht
SET
	laermbelastung_txt = 
		CASE
			WHEN laermbelastung = 'groesser_gleich_75_dB'
				THEN '≥ 75 dB(A)'
			WHEN laermbelastung = 'kleiner_50_groesser_gleich_45_dB'
				THEN '45 - 49.9 dB(A)'
			WHEN laermbelastung = 'kleiner_55_groesser_gleich_50_dB'
				THEN '50 - 54.9 dB(A)'
			WHEN laermbelastung = 'kleiner_65_groesser_gleich_60_dB'
				THEN '60 - 64.9 dB(A)'
			WHEN laermbelastung = 'kleiner_75_groesser_gleich_70_dB'
				THEN '70 - 74.9 dB(A)'
			WHEN laermbelastung = 'kleiner_45_groesser_gleich_40_dB'
				THEN '40 - 44.9 dB(A)'
			WHEN laermbelastung = 'kleiner_60_groesser_gleich_55_dB'
				THEN '55 - 59.9 dB(A)'
			WHEN laermbelastung = 'kleiner_70_groesser_gleich_65_dB'
				THEN '65 - 69.9 dB(A)'
			WHEN laermbelastung = 'kleiner_40_dB'
				THEN '< 40 dB(A)'
			ELSE laermbelastung_txt
		END
;

UPDATE avt_strassenlaermflaechen_pub_v1.strassenlarmflche_strassenlaermflaeche_tag
SET
	laermbelastung_txt = 
		CASE
			WHEN laermbelastung = 'groesser_gleich_75_dB'
				THEN '≥ 75 dB(A)'
			WHEN laermbelastung = 'kleiner_50_groesser_gleich_45_dB'
				THEN '45 - 49.9 dB(A)'
			WHEN laermbelastung = 'kleiner_55_groesser_gleich_50_dB'
				THEN '50 - 54.9 dB(A)'
			WHEN laermbelastung = 'kleiner_65_groesser_gleich_60_dB'
				THEN '60 - 64.9 dB(A)'
			WHEN laermbelastung = 'kleiner_75_groesser_gleich_70_dB'
				THEN '70 - 74.9 dB(A)'
			WHEN laermbelastung = 'kleiner_45_groesser_gleich_40_dB'
				THEN '40 - 44.9 dB(A)'
			WHEN laermbelastung = 'kleiner_60_groesser_gleich_55_dB'
				THEN '55 - 59.9 dB(A)'
			WHEN laermbelastung = 'kleiner_70_groesser_gleich_65_dB'
				THEN '65 - 69.9 dB(A)'
			WHEN laermbelastung = 'kleiner_40_dB'
				THEN '< 40 dB(A)'
			ELSE laermbelastung_txt
		END
;









