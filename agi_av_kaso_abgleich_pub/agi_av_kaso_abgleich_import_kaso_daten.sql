SELECT 
    geb_gdeid, 
    geb_bfsnr, 
    geb_gemname, 
    gb_nr, 
    gb_flaeche*100 AS gb_flaeche, -- Are zu m² umrechnen
    gb_art, 
    gb_gueltigbis
FROM 
    sogis_av_kaso_abgleich
;