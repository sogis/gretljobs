SELECT
    geometrie,
    nummer,
    zustand,
    aname,
    bedeutung,
    zielart,
    replace(objektblatt,'G:\documents\ch.so.awjf.wildtierkorridore\', 'https://geo.so.ch/docs/ch.so.awjf.wildtierkorridore/') AS objektblatt
FROM
    awjf_wildtierkorridore_v1.wildtierkorridor
;
