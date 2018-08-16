SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    id,
    gueteklasse,
    'https://geo.so.ch/docs/ch.so.arp.oev_gueteklasse/OeV_Gueteklassen_Erlaeuterung.pdf' AS erlaeuterung_dok
FROM
    oev_guete.oevgueteklassen
WHERE 
    archive = 0
;