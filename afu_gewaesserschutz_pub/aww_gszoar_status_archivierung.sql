UPDATE afu_gewaesserschutz_sogis.aww_gszoar 
    SET 
        archive = 1, 
        archive_date = current_date 
WHERE  archive = 0;
