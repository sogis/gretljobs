UPDATE
    afu_wasserbewirtschaftung_pub_v2.wassrbwrtschftung_quelle quelle
SET
    zustand_txt = (
        SELECT
            dispname
        FROM
            afu_wasserbewirtschaftung_pub_v2.wassrbwschftung_quelle_zustand
        WHERE
            ilicode = quelle.zustand
    )