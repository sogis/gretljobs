SELECT
    bp.bezeichnun AS bezeichnung,
    bp.achsenumme AS achsenummer,
    bp.geometrie
FROM
    avt_kantonsstrassen_pub.bezugspunkt bp
;