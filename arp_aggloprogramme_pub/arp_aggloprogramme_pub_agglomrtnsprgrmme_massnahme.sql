SELECT
    row_number() over() AS t_id,
    aggloprogramm.aname AS aggloprogramm,
    aggloprogramm.generation,
    CASE 
        WHEN generation = 3
            THEN 'in Prüfung'
    END AS status,
    paket.handlungsfeld,
    paket.handlungspaket,
    paket.massnahmepaket AS massnahmenpaket,
    massnahme.prioritaet,
    CASE
        concat(
            ST_GeometryType(punktobjekt.geometrie),
            ST_GeometryType(linienobjekt.geometrie),
            ST_GeometryType(flaechenobjekt.geometrie)
        )
        WHEN 'ST_Point' 
            THEN 'Punkt'
        WHEN 'ST_LineString'
            THEN 'Linie'
        WHEN 'ST_Polygon' 
            THEN 'Polygon'
        WHEN '' 
            THEN 'keine Geometrie'
        ELSE 'andere'
    END AS geometrietyp,
    massnahme.nummer,
    massnahme.beschreibung,
    massnahme.kosten_massnahmenblatt,
    massnahme.kosten_lv,
    massnahme.kostenstand_aktuell,
    massnahme.kostenanteil_bund,
    concat('<a href="', replace(massnahme.massnahmenblatt, '/opt/sogis_pic/daten_aktuell/arp/agglo/Dokumente/', '../docs/ch.so.arp.agglo/'), '" target="_blank">PDF</a>') AS massnahmenblatt,
    massnahme.ansprechperson,
    massnahme.sonstiges,
    massnahme.projektphase,
    massnahme.umsetzungsstand,
    string_agg(DISTINCT federfuehrung.aname, ', ' ORDER BY federfuehrung.aname) AS federfuehrung,
    string_agg(DISTINCT gemeinde.aname || ' ' || gemeinde.kanton, ', 'ORDER BY gemeinde.aname || ' ' || gemeinde.kanton) AS gemeinden,
    CASE
        WHEN
            aggloprogramm.generation = 1 
            AND 
            LEFT(massnahme.prioritaet, 1) = 'A'
            THEN '2011-2014'::CHARACTER VARYING(255)
        WHEN
            (
                aggloprogramm.generation = 1 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'B'
            )
            OR
            (
                aggloprogramm.generation = 2 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'A'
            )
            THEN '2015-2018'::CHARACTER VARYING(255)
        WHEN
            (
                aggloprogramm.generation = 1 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'C'
            )
            OR
            (
                aggloprogramm.generation = 2 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'B'
            )
            OR
            (
                aggloprogramm.generation = 3 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'A'
            )
            THEN '2019-2022'::CHARACTER VARYING(255)
        WHEN
            (
                aggloprogramm.generation = 2 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'C'
            )
            OR
            (
                aggloprogramm.generation = 3 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'B'
            )
            OR
            (
                aggloprogramm.generation = 4 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'A'
            )
            THEN '2023-2026'::CHARACTER VARYING(255)
        WHEN
            (
                aggloprogramm.generation = 3 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'C'
            )
            OR
            (
                aggloprogramm.generation = 4 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'B'
            )
            OR
            (
                aggloprogramm.generation = 5 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'A'
            )
            THEN '2027-2030'::CHARACTER VARYING(255)
        WHEN
            (
                aggloprogramm.generation = 4 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'C'
            )
            OR
            (
                aggloprogramm.generation = 5 
                AND 
                LEFT(massnahme.prioritaet, 1) = 'B'
            )
            THEN '2031-2034'::CHARACTER VARYING(255)
        WHEN
            aggloprogramm.generation = 5 
            AND 
            LEFT(massnahme.prioritaet, 1) = 'C'
            THEN '2035-2038'::CHARACTER VARYING(255)
        ELSE massnahme.prioritaet::CHARACTER VARYING(255)
    END AS baubeginn,
    massnahme.infrastrukturell,
    aggloprogramm.link AS agglomerationsprogramm_link,
    massnahme.letzte_anpassung,
    punktobjekt.geometrie AS punktgeometrie,
    linienobjekt.geometrie AS liniengeometrie,
    flaechenobjekt.geometrie AS flaechengeometrie,
    concat('(', aggloprogramm.aname, ' - ', massnahme.nummer, ') ', massnahme.beschreibung) AS suchattribut
FROM
    arp_aggloprogramme.agglomrtnsprgrmme_massnahme massnahme
    LEFT JOIN arp_aggloprogramme.agglomrtnsprgrmme_agglomerationsprogramm aggloprogramm
        ON massnahme.agglo_programm = aggloprogramm.t_id
    LEFT JOIN arp_aggloprogramme.agglomrtnsprgrmme_paket paket
        ON massnahme.paket = paket.t_id
    LEFT JOIN arp_aggloprogramme.agglomrtnsprgrmme_punktobjekt punktobjekt
        ON massnahme.punkte_geometrie = punktobjekt.t_id
    LEFT JOIN arp_aggloprogramme.agglomrtnsprgrmme_linienobjekt linienobjekt
        ON massnahme.linien_geometrie = linienobjekt.t_id
    LEFT JOIN arp_aggloprogramme.agglomrtnsprgrmme_flaechenobjekt flaechenobjekt
        ON massnahme.flaechen_geometrie = flaechenobjekt.t_id 
    LEFT JOIN arp_aggloprogramme.agglomrtnsprgrmme_federfuehrung_massnahme federfuehrung_massnahme
        ON massnahme.t_id = federfuehrung_massnahme.massnahme
    LEFT JOIN arp_aggloprogramme.agglomrtnsprgrmme_federfuehrung federfuehrung
        ON federfuehrung_massnahme.federfuehrung_name = federfuehrung.t_id
     LEFT JOIN arp_aggloprogramme.agglomrtnsprgrmme_gemeinde_massnahme gemeinde_massnahme
        ON massnahme.t_id = gemeinde_massnahme.massnahme
    LEFT JOIN arp_aggloprogramme.agglomrtnsprgrmme_gemeinde gemeinde
        ON gemeinde_massnahme.gemeinde_name = gemeinde.t_id
GROUP BY
    massnahme.t_id,
    aggloprogramm.t_id,
    paket.t_id,
    punktobjekt.t_id,
    linienobjekt.t_id,
    flaechenobjekt.t_id
;
