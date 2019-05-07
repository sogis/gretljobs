WITH documents AS (
    SELECT 
        array_to_json(
            array_agg(
                json_build_object(
                    'bezeichnung',bezeichnung,
                    'link', link,
                    'jahr', jahr
                )
            )
        )::text AS dokumente, 
        verkehrszaehlstelle
    FROM 
        avt_verkehrszaehlstellen.verkehrszhlstllen_dokument
    GROUP BY 
        verkehrszaehlstelle
), 
gemeinde AS (
    SELECT 
        hoheitsgrenzen_gemeindegrenze.gemeindename,
        verkehrszhlstllen_verkehrszaehlstelle.t_id
    FROM
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze,
        avt_verkehrszaehlstellen.verkehrszhlstllen_verkehrszaehlstelle
    WHERE
        ST_Within(verkehrszhlstllen_verkehrszaehlstelle.geometrie, hoheitsgrenzen_gemeindegrenze.geometrie) = TRUE
)

SELECT
    t_ili_tid,
    bezeichnung,
    zaehlart,
    gemeinde.gemeindename AS gemeinde,
    coalesce(documents.dokumente,'keine') AS dokumente,
    geometrie
FROM
    avt_verkehrszaehlstellen.verkehrszhlstllen_verkehrszaehlstelle
    LEFT JOIN gemeinde
        ON gemeinde.t_id = verkehrszhlstllen_verkehrszaehlstelle.t_id
    LEFT JOIN documents
        ON documents.verkehrszaehlstelle = verkehrszhlstllen_verkehrszaehlstelle.t_id
WHERE char_length(dokumente) < 500
;
