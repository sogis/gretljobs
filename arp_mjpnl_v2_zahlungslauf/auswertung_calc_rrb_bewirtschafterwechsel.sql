INSERT INTO ${DB_Schema_MJPNL}.auswertung_rrb_bewirtschafterwechsel
(   t_basket,
    jahr,
    gemeinde,
    vereinbarungs_nr,
    vereinbarungs_nr_alt,
    gelan_pid_gelan,
    gelan_person
)
SELECT 
    (SELECT t_id FROM ${DB_Schema_MJPNL}.t_ili2db_basket WHERE topic = 'SO_ARP_MJPNL_20240606.Auswertung' LIMIT 1) as t_basket,
    ${AUSZAHLUNGSJAHR}::integer as jahr,
    array_to_string(vbg.gemeinde, ',') as gemeinde, 
    vbg.vereinbarungs_nr as vereinbarungs_nr,
    vbg.vereinbarungs_nr_alt as vereinbarungs_nr_alt,
    vbg.gelan_pid_gelan as gelan_pid_gelan,
    gp.name_vorname as gelan_person
FROM ${DB_Schema_MJPNL}.mjpnl_vereinbarung vbg
JOIN ${DB_Schema_MJPNL}.mjpnl_vereinbarung_bewirtschafter_historie vbg_hist
ON vbg_hist.vereinbarung = vbg.t_id
JOIN ${DB_Schema_MJPNL}.betrbsdttrktrdten_gelan_person gp
ON gp.pid_gelan = vbg.gelan_pid_gelan 
WHERE vbg_hist.jahr_bewirtschafterwechsel = ${AUSZAHLUNGSJAHR}::integer;