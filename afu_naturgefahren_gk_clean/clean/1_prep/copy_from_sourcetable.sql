DELETE FROM public.poly_cleanup
;

INSERT INTO -- Insert aus Quelle in Verarbeitungstabelle
    public.poly_cleanup(
        id,
        gefahrenstufe,
        geometrie
    )
    SELECT
        t_id AS id,
        gefahrenstufe,
        geometrie
    FROM 
        ${sourcetable}
    --LIMIT 1000 -- $td
;