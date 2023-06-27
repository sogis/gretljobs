-- Dataset kantonal
DELETE FROM
    arp_nutzungsplanung_planregister_v1.planregister_dokument
WHERE
    t_datasetname = 'nutzungsplanung_kommunal' || '_' || ${bfsnr_param}
;
;