-- Basket anlegen

SELECT
    nextval('arp_nutzungsplanung_planregister_pub_v1.t_ili2db_seq'::regclass) AS t_id,
    d.t_id AS dataset,
    'SO_Nutzungsplanung_Planregister_Publikation_20221115.Planregister' AS topic,
    NULL AS t_ili_tid,
    d.datasetname AS attachmentkey,
    NULL AS domains
FROM
        arp_nutzungsplanung_planregister_pub_v1.t_ili2db_dataset AS d
;
