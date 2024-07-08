INSERT INTO ${DB_Schema_MJPNL}.rrb_neue_vereinbarung,
    t_basket,
    jahr,
    vereinbarungsart,
    gemeinde,
    vereinbarungs_nr,
    vereinbarungs_nr_alt
    gelan_pid_gelan,
    gelan_person,
    flaeche,
    betrag_total
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
	abr_vbg.gesamtbetrag as betrag_total
FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
JOIN ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person gp
ON gp.pid_gelan = vbg.gelan_pid_gelan 
LEFT JOIN ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_vereinbarung abr_vbg
ON abr_vbg.vereinbarung = vbg.t_id 
-- das ist vermutlich falsch und wird noch besprochen
WHERE vbg.rrb_nr = ${AUSZAHLUNGSJAHR}::varchar and vbg.status_vereinbarung = 'aktiv'