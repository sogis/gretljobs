UPDATE
    avt_mehrjahresplanung_v2.projekte_projekt pp
SET
    ranfangsbezugspunkt = (
        SELECT
            t_id
        FROM
            avt_mehrjahresplanung_v2.kantonsstrassen_bezugspunkt bp
        WHERE
            split_part(pp.bpanfang, '+', 1) = bp.bezeichnung
        AND
            pp.achsnr = bp.achsenummer
    )
;

UPDATE
    avt_mehrjahresplanung_v2.projekte_projekt pp
SET
    rendbezugspunkt = (
        SELECT
            t_id
        FROM
            avt_mehrjahresplanung_v2.kantonsstrassen_bezugspunkt bp
        WHERE
            split_part(pp.bpende, '+', 1) = bp.bezeichnung
        AND
            pp.achsnr = bp.achsenummer
    )
;