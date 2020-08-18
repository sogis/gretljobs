SELECT
    massnahme.t_id,
    aggloprogramm.aname AS Agglomerationsprogramm,
    aggloprogramm.generation,
    aggloprogramm.agglo_nu AS agglomerationsprogramm_nr,
    aggloprogramm.url AS agglomerationsprogramm_url,
    paket.handlungsfeld,
    paket.handlungspaket_kuerzel || ' - ' || paket.handlungspaket AS handlungspaket,
    paket.massnahmekategorie,
    paket.unterkategorie,
    massnahme.measure_nu AS massnahmennummer,
    massnahme.beschreibung,
    massnahme.kosten_massnahmenblatt,
    massnahme.kosten_lv AS kosten_leistungsvereinbarung,
    massnahme.kostenstand_aktuell,
    massnahme.kostenanteil_bund,
    massnahme.kostenanteil_lv_mp,
    replace(massnahme.massnahmenblatt, 'G:\documents\ch.so.arp.agglo\', 'https://geo.so.ch/docs/ch.so.arp.agglo/') AS massnahmenblatt,
    massnahme.prioritaet,
    prioritaet.description AS prioritaet_text,
    regexp_replace(massnahme.ansprechperson, E'[\\n\\r]+', ' ', 'g' ) AS ansprechperson,
    massnahme.acomment AS Kommentar,
    massnahme.projektphase,
    projektphase.description AS projektphase_text,
    massnahme.umsetzungsstand,
    umsetzungsstand.description AS umsetzungsstand_text,
    string_agg(DISTINCT federfuehrung.aname, ', ' ORDER BY federfuehrung.aname) AS federfuehrung,
    string_agg(DISTINCT gemeinde.aname || ' ' || gemeinde.kanton, ', 'ORDER BY gemeinde.aname || ' ' || gemeinde.kanton) AS gemeinden,
    massnahme.infrastrukturell,
    massnahme.letzte_anpassung,
    massnahme.are_code,
    massnahme.finanzvereinbarung,
    massnahme.fv_nummer AS finanzierungsvereinbarungsnr,
    massnahme.baubeginn_geplant_lv,
    punktobjekt.geometrie AS punktgeometrie
FROM
    arp_agglomerationsprogramme.agglomrtnsprgrmme_massnahme massnahme
    LEFT JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_agglomerationsprogramm aggloprogramm
        ON massnahme.agglo_programm = aggloprogramm.t_id
    LEFT JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_paket paket
        ON massnahme.paket = paket.t_id
    RIGHT JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_agglo_point punktobjekt
        ON massnahme.punkte_geometrie = punktobjekt.t_id 
    LEFT JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_federfuehrung_massnahme federfuehrung_massnahme
        ON massnahme.t_id = federfuehrung_massnahme.massnahme
    LEFT JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_federfuehrung federfuehrung
        ON federfuehrung_massnahme.federfuehrung_name = federfuehrung.t_id
    LEFT JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_gemeinde_massnahme gemeinde_massnahme
        ON massnahme.t_id = gemeinde_massnahme.massnahme
    LEFT JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_gemeinde gemeinde
        ON gemeinde_massnahme.gemeinde_name = gemeinde.t_id
    LEFT JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_projektphase projektphase 
	ON projektphase.ilicode = massnahme.projektphase
    LEFT JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_prioritaet prioritaet 
        ON prioritaet.ilicode = massnahme.prioritaet 
    LEFT JOIN arp_agglomerationsprogramme.agglomrtnsprgrmme_umsetzungsstand umsetzungsstand 
	ON umsetzungsstand.ilicode = massnahme.umsetzungsstand 	

GROUP BY
    massnahme.t_id,
    aggloprogramm.t_id,
    paket.t_id,
    punktobjekt.t_id,
    umsetzungsstand.itfcode,
    prioritaet.itfcode,
    projektphase.itfcode
;
