SELECT std.t_id,
       std.t_ili_tid,
       std.bfsnr,
       gem.gemeindename,
       --TODO: Modell auf Multipolygon umbauen
       ST_ExteriorRing(gem.geometrie)::geometry(Polygon,2056) AS gemeinde_geometrie,
       stand.dispname AS stand_gueterregulierung,
       (
           WITH docs AS (
            SELECT json_build_object(
                't_id',dok.t_id,
                'titel',dok.titel,
                'typ',dok.typ,
                 'url','https://geo.so.ch/docs/' || replace(dok.dateipfad,'G:/documents/','')
              ) AS jsondok
            FROM
              alw_strukturverbesserungen.raeumlicheelemnte_gemeinde_flurreglement_dokument ztdok
              LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_gemeinde_flurreglement flrrgl ON ztdok.gemeinde_flurreglement = flrrgl.t_id
              LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztdok.dokument = dok.t_id
                WHERE flrrgl.bfsnr = std.bfsnr
            )
            SELECT json_agg(jsondok) FROM docs
        )::jsonb AS flurreglemente
    FROM alw_strukturverbesserungen.stand_gutrrglrung_stand_gueterregulierung std
    LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gem ON std.bfsnr = gem.bfs_gemeindenummer
    LEFT JOIN alw_strukturverbesserungen.stand stand ON std.stand = stand.ilicode
    GROUP BY std.t_id, std.t_ili_tid, std.bfsnr, gem.gemeindename, gem.geometrie, stand.dispname
    ORDER BY std.bfsnr
;
