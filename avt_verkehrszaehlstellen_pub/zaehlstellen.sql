SELECT 
    zaehlobjekt, 
    objekt.dispname  AS zaehlobjekt_txt, 
    zaehlart, 
    art.dispname AS zaehlart_txt, 
    zaehlkadenz, 
    kadenz.dispname  AS zaehlkadenz_txt, 
    zaehlstelle.bezeichnung, 
    json_agg(json_build_object('@type','SO_AVT_Verkehrszaehlstellen_Publikation_20260205.Verkehrszaehlstellen.Dokument','Bezeichnung', dok.bezeichnung, 'Link', link, 'Jahr', jahr)) AS dokumente, 
    geometrie 
FROM 
    avt_verkehrszaehlstellen_v1.verkehrszaehlstelle zaehlstelle
LEFT JOIN 
    avt_verkehrszaehlstellen_v1.verkehrszaehlstelle_zaehlobjekt objekt
    ON 
    zaehlstelle.zaehlobjekt = objekt.ilicode 
LEFT JOIN 
    avt_verkehrszaehlstellen_v1.verkehrszaehlstelle_zaehlart art  
    ON 
    zaehlstelle.zaehlart = art.ilicode 
LEFT JOIN 
    avt_verkehrszaehlstellen_v1.verkehrszaehlstelle_zaehlkadenz kadenz 
    ON 
    zaehlstelle.zaehlkadenz = kadenz.ilicode 
LEFT JOIN 
    avt_verkehrszaehlstellen_v1.dokument dok
    ON 
    dok.zaehlstelle_staedtische_verkehrszaehlung = zaehlstelle.t_id
GROUP BY 
    zaehlobjekt, 
    objekt.dispname,
    zaehlart, 
    art.dispname,
    zaehlkadenz, 
    kadenz.dispname,
    zaehlstelle.bezeichnung, 
    geometrie