INSERT INTO ${DB_Schema_MJPNL}.auswertung_rrb_neue_vereinbarung
(   t_basket,
    jahr,
    vereinbarungsart,
    gemeinde,
    vereinbarungs_nr,
    vereinbarungs_nr_alt,
    gelan_pid_gelan,
    gelan_person,
    flaeche,
    betrag_total,
    rrb_nr,
    rrb_publiziert_ab
)
SELECT 
    (SELECT t_id FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE topic = 'SO_ARP_MJPNL_20240606.Auswertung' LIMIT 1) as t_basket,
    ${AUSZAHLUNGSJAHR}::integer as jahr,
    vbg.vereinbarungsart as vereinbarungsart,
    array_to_string(vbg.gemeinde, ',') as gemeinde, 
    vbg.vereinbarungs_nr as vereinbarungs_nr,
    vbg.vereinbarungs_nr_alt as vereinbarungs_nr_alt,
    vbg.gelan_pid_gelan as gelan_pid_gelan,
    gp.name_vorname as gelan_person,
	vbg.flaeche as flaeche,
    -- ist nur NULL falls keine beurteilung gemacht
	COALESCE(abr_vbg.gesamtbetrag, 0) as betrag_total,
    vbg.rrb_nr as rrb_nr,
    vbg.rrb_publiziert_ab as rrb_publiziert_ab
FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
JOIN ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person gp
ON gp.pid_gelan = vbg.gelan_pid_gelan 
LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung abr_vbg
ON abr_vbg.vereinbarung = vbg.t_id and abr_vbg.auszahlungsjahr = ${AUSZAHLUNGSJAHR}
-- wir kalkulieren alle "aktuellen", heisst die ohne oder mit diesjährigem publikationsjahr
WHERE vbg.status_vereinbarung = 'aktiv'
AND ( 
    date_part('year', vbg.rrb_publiziert_ab)::integer = ${AUSZAHLUNGSJAHR}
    OR
    vbg.rrb_publiziert_ab IS NULL
)