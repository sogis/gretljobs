/*
 * Beanspruchungsflächen und Kompensationsflächen werden
 * in eine gemeinsame Struktur überführt.
 */
WITH alle_flaechen AS (
    SELECT
        bf.t_id                                      AS quelle_id,
        bf.projekt_r,
        'Beanspruchung'::varchar                     AS flaeche_art,
        bf.bezeichnung								 AS flaeche_bezeichnung,
        bf.sobau_nummer                              AS flaeche_sobau_nummer,
        bf.genehmigungsdatum 						 AS flaeche_genehmigungsdatum,
        bf.flaeche_manuell                           AS flaeche_anrechenbar,
        round(ST_Area(bf.geometrie))::integer        AS flaeche_berechnet,
        bf.beanspruchungsflaeche_bemerkungen         AS flaeche_bemerkungen,
        NULL 										 AS abnahme_kompensation, 
        NULL										 AS abnahme_kompensation_datum,
        NULL										 AS abnahme_Folgebewirtschaftung,
        NULL										 AS abnahme_folgebewirtschaftung_datum,
        bf.geometrie,
        'https://geo.so.ch/map/?l=ch.so.arp.fruchtfolgeflaechen_kompensation&bl=hintergrundkarte_sw&t=default&c='||st_x(st_centroid(bf.geometrie))||'%2C'||st_y(st_centroid(bf.geometrie))||'&s=3780&hc=1'          AS link
    FROM
        arp_fruchtfolgeflaechen_kompensation_v1.kompensation_beanspruchungsflaeche bf

    UNION ALL

    SELECT
        kf.t_id                                      AS quelle_id,
        kf.projekt_r,
        kf.kompensationsmassnahme::varchar           AS flaeche_art,
        kf.bezeichnung								 AS flaeche_bezeichnung,
        kf.sobau_nummer 						     AS flaeche_sobau_nummer,
        kf.genehmigungsdatum 						 AS flaeche_genehmigungsdatum,
        kf.flaeche_manuell                           AS flaeche_anrechenbar,
        round(ST_Area(kf.geometrie))::integer        AS flaeche_berechnet,
        kf.kompensation_bemerkungen                  AS flaeche_bemerkungen,
        kf.abnahme_kompensation 					 AS abnahme_kompensation, 
        kf.abnahme_kompensation_datum 				 AS abnahme_kompensation_datum,
        kf.abnahme_folgebewirtschaftung     		 AS abnahme_Folgebewirtschaftung,
        kf.abnahme_folgebewirtschaftung_datum    	 AS abnahme_folgebewirtschaftung_datum,
        kf.geometrie,
        'https://geo.so.ch/map/?l=ch.so.arp.fruchtfolgeflaechen_kompensation&bl=hintergrundkarte_sw&t=default&c='||st_x(st_centroid(kf.geometrie))||'%2C'||st_y(st_centroid(kf.geometrie))||'&s=3780&hc=1'           AS link
    FROM
        arp_fruchtfolgeflaechen_kompensation_v1.kompensation_kompensationsflaeche kf
)

SELECT
    f.flaeche_art,
    p.projektname                                    AS projekt_projektname,
    g.kontaktperson                                  AS firma_kontaktperson,
    g.firma                                          AS firma_name,
    g.auid                                           AS firma_uid,
    g.adresse                                        AS firma_adresse,
    g.telefon                                        AS firma_telefon,
    g.mail                                           AS firma_mail,
    p.eingangsdatum                                  AS projekt_eingangsdatum,
    p.projektstatus                                  AS projekt_status,
    p.projekt_bemerkungen,
    f.flaeche_bezeichnung,
    f.flaeche_anrechenbar,
    f.flaeche_berechnet,
    f.flaeche_sobau_nummer,
    f.flaeche_genehmigungsdatum,
    f.flaeche_bemerkungen,
    f.abnahme_kompensation, 
    f.abnahme_kompensation_datum, 
    f.abnahme_folgebewirtschaftung, 
    f.abnahme_folgebewirtschaftung_datum,
    f.geometrie,
    COALESCE(
        (
            SELECT jsonb_agg(
                jsonb_build_object(
                    '@type', 'SO_ARP_FFF_Kompensation_Publikation_20260624.Kompensation.Teilflaechen',
                    'Flaechenart',          andere.flaeche_art,
                    'Bezeichnung',          andere.flaeche_bezeichnung,
                    'Flaeche_anrechenbar',  andere.flaeche_anrechenbar,
                    'Link',                 andere.link
                )
                ORDER BY
                    andere.flaeche_art,
                    andere.flaeche_bezeichnung,
                    andere.quelle_id
            )
            FROM 
                alle_flaechen andere
            WHERE
                andere.projekt_r = f.projekt_r
                AND 
                andere.quelle_id <> f.quelle_id
        ),
        '[]'::jsonb
    ) AS projektflaechen

FROM
    alle_flaechen f
JOIN 
    arp_fruchtfolgeflaechen_kompensation_v1.kompensation_projekt p
    ON 
    p.t_id = f.projekt_r
JOIN 
    arp_fruchtfolgeflaechen_kompensation_v1.kompensation_gesuchsteller g
    ON 
    g.t_id = p.gesuchsteller_r
;

