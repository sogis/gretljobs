-- In der Nutzungsplanung werden kantonale und kommunale Nutzungspläne separat (Schemas nutzungsplanung, nutzungsplanung_kanton, statsiche_waldgrenze, gewaesserschutz, naturreservat) erfasst. 
---Das kann zu doppelten Dokumenten führen, die wir im Planregsiter nicht wollen. Deshalb diese Query, welche die Doppelten Einträge löscht. 

DELETE
FROM
arp_nutzungsplanung_planregister_pub_v1.planregister_dokument
WHERE
    t_id IN
(
SELECT 
    b.t_id AS t_id_delete
FROM
    arp_nutzungsplanung_planregister_pub_v1.planregister_dokument a,
    arp_nutzungsplanung_planregister_pub_v1.planregister_dokument b
WHERE
    a.dokument_url = b.dokument_url
    AND
    a.gemeinde = b.gemeinde -- Für die Pläne, die über die Gemeindegrenze gehen. Diese werden pro Gemeinde erfasst. Hier ist es richtig, dass sie doppelt sind.
    AND
    a.offiziellenr = b.offiziellenr --Für die Dokumente die die URL https://planregister-data.so.ch/public/kanton/Dokument-nicht-digital-verfuegbar.pdf haben
    AND
    a.t_id < b.t_id
)