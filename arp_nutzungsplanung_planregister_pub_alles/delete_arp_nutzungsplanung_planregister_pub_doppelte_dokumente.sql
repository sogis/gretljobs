-- In der Nutzungsplanung müssen komunale Dokumente in mehreren Gemeidnen erfasst werden, 
-- wenn die Nutzungsplanung über die Gemeindegrenze geht. Das kann zu doppelten Dokumenten 
-- führen die wir im Planregsiter nicht wollen. Deshalb diese Query, welche die Doppelten Einträge löscht.

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
	a.gemeinde = b.gemeinde
    AND
    a.t_id < b.t_id
)