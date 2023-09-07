SELECT 
    substring(rrb_nummer FOR 10) AS rrb_nummer, 
    substring(rrb_titel FOR 200) AS titel, 
    rrb_datum AS datum, 
    substring(name_der_datei FOR 40) AS dateiname
FROM 
    rep_view_rrb
;
