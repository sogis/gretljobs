WITH evaluation_exposure_limit_value AS
(
    SELECT
        t_id,
        CASE
            WHEN min_exposure_limit = 1 THEN 'Alarmwert überschritten'
            WHEN min_exposure_limit = 2 THEN 'Immissionsgrenzwert überschritten, Alarmwert eingehalten'
            WHEN min_exposure_limit = 3 THEN 'Planungswert überschritten, Immissionsgrenzwert eingehalten'
            WHEN min_exposure_limit = 4 THEN 'Planungswert überschritten, Immissionsgrenzwert eingehalten'
            WHEN min_exposure_limit = 5 THEN 'Planungswert eingehalten'
            WHEN min_exposure_limit = 6 THEN 'Unbekannte Lärm-Empfindlichkeitsstufe'
            ELSE 'Should not reach here'
         END AS beurteilung
    FROM
    (
        SELECT 
            pointofdetermination.t_id,
            LEAST(
                CAST(SUBSTRING(exposure_limit_value_catalogue_d.acode, 4, 1) AS INTEGER),
                CAST(SUBSTRING(exposure_limit_value_catalogue_n.acode, 4, 1) AS INTEGER)
            ) AS min_exposure_limit
        FROM
            avt_strassenlaerm_v1.immission_strasse_pointofdetermination AS pointofdetermination
            LEFT JOIN avt_strassenlaerm_v1.codelisten_exposure_limit_value_catalogue AS exposure_limit_value_catalogue_d
            ON pointofdetermination.exposure_limit_value_d = exposure_limit_value_catalogue_d.t_id
            LEFT JOIN avt_strassenlaerm_v1.codelisten_exposure_limit_value_catalogue AS exposure_limit_value_catalogue_n
            ON pointofdetermination.exposure_limit_value_n = exposure_limit_value_catalogue_n.t_id    
    ) AS foo
)
SELECT 
    pointofdetermination.lr_day AS immissionspegel_tag,
    pointofdetermination.lr_night AS immissionspegel_nacht,
    dispersion_calculation.refyear_register AS referenzjahr,
    pointofdetermination.grenzwert_tag AS immissionsgrenzwert_tag,
    pointofdetermination.grenzwert_nacht AS immissionsgrenzwert_nacht,
    evaluation_exposure_limit_value.beurteilung AS beurteilung,
    pointofdetermination_catalogue.adefinition_de AS typ_ermittlungspunkt,
    operation_status_catalogue.adefinition_de AS betriebsstatus,
    pointofdetermination.address_pod AS adresse,
    -- gemeinde
    -- parzellennummer
    pointofdetermination.empfindlichkeitsstufe AS empfindlichkeitsstufe,
    pointofdetermination.inklusive_nationalstrasse AS nationalstrasse_beruecksichtigt,
    pointofdetermination.geometry_pod AS geometrie
FROM
    avt_strassenlaerm_v1.immission_strasse_pointofdetermination AS pointofdetermination
    LEFT JOIN avt_strassenlaerm_v1.immission_strasse_dispersion_calculation AS dispersion_calculation
    ON pointofdetermination.dispersion_calculation = dispersion_calculation.t_id
    LEFT JOIN avt_strassenlaerm_v1.codelisten_pointofdetermination_catalogue AS pointofdetermination_catalogue
    ON pointofdetermination.pointofdetermination_t = pointofdetermination_catalogue.t_id
    LEFT JOIN avt_strassenlaerm_v1.codelisten_operation_status_catalogue AS operation_status_catalogue
    ON pointofdetermination.operation_status = operation_status_catalogue.t_id 
    LEFT JOIN evaluation_exposure_limit_value
    ON pointofdetermination.t_id = evaluation_exposure_limit_value.t_id
;
