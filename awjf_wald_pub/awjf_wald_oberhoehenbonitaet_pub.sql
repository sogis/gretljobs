SELECT
    oberhoehenbonitaets_code,
    oberhoehenbonitaets_code.dispname AS oberhoehenbonitaets_code_txt,
    geometrie
FROM
    awjf_wald_oberhoehenbonitaet_v1.oberhoehenbonitaet
    LEFT JOIN awjf_wald_oberhoehenbonitaet_v1.oberhoehenbonitaet_oberhoehenbonitaets_code AS oberhoehenbonitaets_code
    ON oberhoehenbonitaets_code = oberhoehenbonitaets_code.ilicode
;
