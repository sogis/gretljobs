-- Erstellen einer Trigger-Funktion die bei Änderung in vereinbarung von gelan_pid_gelan den alten Bewirtschafter in eine Historisierungstabelle schreibt

CREATE OR REPLACE FUNCTION ${DB_Schema_MJPNL}.historisiere_bewirtschafter() RETURNS trigger AS $$
BEGIN
    -- Bei der Migration ist gelan_pid_gelan zwischenzeitlich 9999999 - dies soll nicht berücksichtigt werden
    IF NEW.gelan_pid_gelan != OLD.gelan_pid_gelan AND OLD.gelan_pid_gelan != 9999999 THEN
        INSERT INTO ${DB_Schema_MJPNL}.mjpnl_vereinbarung_bewirtschafter_historie(t_basket, vereinbarungs_nr, gelan_pid_gelan, jahr_bewirtschafterwechsel, aenderungsdatum, vereinbarung)
        VALUES (NEW.t_basket, NEW.vereinbarungs_nr, OLD.gelan_pid_gelan, date_part('year',now())::int4, now(), NEW.t_id);
    END IF;
    RETURN NEW;
END; $$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS historisiere_bewirtschafter_after_update ON ${DB_Schema_MJPNL}.vereinbarung;
CREATE TRIGGER historisiere_bewirtschafter_after_update
AFTER UPDATE OF gelan_pid_gelan ON ${DB_Schema_MJPNL}.vereinbarung
FOR EACH ROW
EXECUTE FUNCTION ${DB_Schema_MJPNL}.historisiere_bewirtschafter(); 
