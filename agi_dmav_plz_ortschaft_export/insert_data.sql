
-- Die TID werden einfach rüberkopiert. Das funktioniert
-- weil wir keine neuen Daten / neue Records erzeugen.
WITH basket AS 
(
    SELECT 
        t_id AS basket_t_id
    FROM 
        agi_dmav_plz_ortschaften_export_v1.t_ili2db_basket
)
,
gemeinde AS 
(
    SELECT
        bfs_gemeindenummer AS bfsnr,
        geometrie
    FROM 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze 
    WHERE 
        bfs_gemeindenummer = ${bfsnr}
) 
-- Weil beide Klassen eine Geometrie haben, kann es mit beiden
-- Geometrie zu Overlaps führen und wegen der Beziehung zwischen
-- beiden Klassen muss ich jeweils auch beide Klassen miteinbeziehen.
-- Im Anschluss wird gemerged und allensfalls doppelte Einträge
-- ignoriert.
,
plz_ortschaft_top_down AS 
(
    SELECT 
        --ST_Area(ST_CollectionExtract(ST_Intersection(gemeinde.geometrie, ortschaft.ageometry), 3)),
        --ST_MaximumInscribedCircle(ST_CollectionExtract(ST_Intersection(gemeinde.geometrie, ortschaft.ageometry), 3)),
        ortschaft.t_id AS o_t_id,
        basket.basket_t_id,
        ortschaft.ageometry AS ortschaft_geometrie,
        ortschaft.localityname AS amtlicherortschaftsname,
        plz.t_id AS p_t_id,
        plz.ageometry AS plz_geometrie,
        plz.zip4 AS plz4,
        plz.additionalnumber AS zusatzziffer
    
    FROM 
        agi_plz_ortschaften_v1.officlndxflclties_locality AS ortschaft
        LEFT JOIN gemeinde 
        ON ST_Intersects(gemeinde.geometrie, ortschaft.ageometry)
        LEFT JOIN agi_plz_ortschaften_v1.officlndxflclties_zip AS plz 
        ON plz.locality = ortschaft.t_id 
        LEFT JOIN basket
        ON 1=1
    WHERE 
        bfsnr = ${bfsnr}
    AND 
        -- Zukünftig mit ST_MaximumInscribedCircle 
        ST_Area(ST_CollectionExtract(ST_Intersection(gemeinde.geometrie, ortschaft.ageometry), 3)) > 1
)
,
plz_ortschaft_bottom_up AS 
(
    SELECT 
        --ST_Area(ST_CollectionExtract(ST_Intersection(gemeinde.geometrie, ortschaft.ageometry), 3)),
        --ST_MaximumInscribedCircle(ST_CollectionExtract(ST_Intersection(gemeinde.geometrie, ortschaft.ageometry), 3)),
        ortschaft.t_id AS o_t_id,
        basket.basket_t_id,
        ortschaft.ageometry AS ortschaft_geometrie,
        ortschaft.localityname AS amtlicherortschaftsname,
        plz.t_id AS p_t_id,
        plz.ageometry AS plz_geometrie,
        plz.zip4 AS plz4,
        plz.additionalnumber AS zusatzziffer
    
    FROM 
        agi_plz_ortschaften_v1.officlndxflclties_zip AS plz
        LEFT JOIN gemeinde 
        ON ST_Intersects(gemeinde.geometrie, plz.ageometry)
        LEFT JOIN agi_plz_ortschaften_v1.officlndxflclties_locality AS ortschaft 
        ON plz.locality = ortschaft.t_id 
        LEFT JOIN basket
        ON 1=1
    WHERE 
        bfsnr = ${bfsnr}
    AND 
        -- Zukünftig mit ST_MaximumInscribedCircle 
        ST_Area(ST_CollectionExtract(ST_Intersection(gemeinde.geometrie, ortschaft.ageometry), 3)) > 1
)
,
plz_ortschaft_merge AS 
(
    SELECT 
        o_t_id,
        basket_t_id,
        ortschaft_geometrie,
        amtlicherortschaftsname,
        p_t_id, 
        plz_geometrie,
        plz4,
        zusatzziffer
    FROM 
        plz_ortschaft_top_down
    UNION 
    SELECT 
        o_t_id,
        basket_t_id,
        ortschaft_geometrie,
        amtlicherortschaftsname,
        p_t_id, 
        plz_geometrie,
        plz4,
        zusatzziffer
    FROM 
        plz_ortschaft_bottom_up
)
,
-- Ortschaften können mehrmals vorkommen, da das Merge-Resultat 
-- denormalisiert ist und eine Ortschaft mehrere PLZ haben kann.
ortschaft_insert AS 
(
    INSERT INTO
        agi_dmav_plz_ortschaften_export_v1.plz_ortschaft_ortschaft 
    (
        t_id,
        t_basket,
        geometrie,
        amtlicherortschaftsname
    )
    SELECT DISTINCT ON (o_t_id)
        o_t_id,
        basket_t_id,
        ortschaft_geometrie,
        amtlicherortschaftsname
    FROM 
        plz_ortschaft_merge
)
-- PLZ kommen im Merge-Resultate nur einmal vor und es muss
-- nicht distinct werden.
INSERT INTO
    agi_dmav_plz_ortschaften_export_v1.plz_ortschaft_plz 
    (
        t_id,
        t_basket,
        geometrie,
        plz4,
        zusatzziffer,
        ortschaft
    )
    SELECT 
        p_t_id, 
        basket_t_id,
        plz_geometrie,
        plz4,
        CAST(zusatzziffer AS int),
        o_t_id
    FROM 
        plz_ortschaft_merge
;
