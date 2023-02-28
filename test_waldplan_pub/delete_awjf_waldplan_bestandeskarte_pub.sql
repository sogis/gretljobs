DELETE FROM
    awjf_waldplan_bestandeskarte_pub_v1.waldplan_bestandeskarte
WHERE
        waldplan_bestandeskarte.gem_bfs <> ${bfsNummerUeberarbeitung}
;
