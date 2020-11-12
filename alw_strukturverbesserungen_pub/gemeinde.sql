SELECT std.t_id,SELECT std.t_id,
       std.t_ili_tid,
       std.bfsnr,
       gem.gemeindename,
       gem.geometrie AS gemeinde_geometrie,
       stand.dispname AS stand_gueterregulierung,
       string_agg(dok.titel,', ')::jsonb AS flurreglemente
    FROM alw_strukturverbesserungen.stand_gutrrglrung_stand_gueterregulierung std
    LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gem ON std.bfsnr = gem.bfs_gemeindenummer
    LEFT JOIN alw_strukturverbesserungen.stand stand ON std.stand = stand.ilicode
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_gemeinde_flurreglement flurregl ON std.bfsnr = flurregl.bfsnr
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_gemeinde_flurreglement_dokument ztflurregl ON flurregl.t_id = ztflurregl.gemeinde_flurreglement
    LEFT JOIN alw_strukturverbesserungen.raeumlicheelemnte_dokument dok ON ztflurregl.dokument = dok.t_id
    GROUP BY std.t_id, std.t_ili_tid, std.bfsnr, gem.gemeindename, gem.geometrie, stand.dispname
;