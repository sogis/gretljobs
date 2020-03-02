SELECT
    data_id AS t_id,
    wkb_geometry AS geometrie,
    bezeichnung,
    vflz_combined_id_kt,
    c_vflz_unterstand || ', ' || c_vflz_bearbstand AS c_vflz_bearbstand,
    c_bere_res_abwbewe,
    c_bere_res_abwbewe_txt,
    c_vflz_unterstand,
    c_vflz_vftyp   
FROM
    sogis_export.altlasten_belastete_standorte_somap
;