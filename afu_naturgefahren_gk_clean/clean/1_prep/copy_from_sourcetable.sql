INSERT INTO -- Insert aus Quelle in Verarbeitungstabelle
    public.interface_table(
        id,
        geometrie,
        gefahrenstufe
    )
    SELECT
        t_id AS id,
        geometrie,
        gefahrenstufe
    FROM 
        ${sourcetable}
    --LIMIT 1000 -- $td
;