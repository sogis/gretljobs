SELECT
    geometrie,
    maechtigkeit_m,
    maechtigkeit.dispname AS maechtigkeit_m_txt
FROM
    afu_grundwassergeometrie_v1.grundwasser_mittelstand AS grundwasser
    LEFT JOIN afu_grundwassergeometrie_v1.grundwasser_maechtigkeit_m AS maechtigkeit
    ON grundwasser.maechtigkeit_m = maechtigkeit.ilicode
;
