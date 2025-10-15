SELECT 
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        REPLACE(claimcausation, ', ', '_'),
        'ä','ae'),
        'ö','oe'),
        'ü','ue'),
        'Ä','Ae'),
        'Ö','Oe'),
        'Ü','Ue') 
     AS schadenart,
     claimcausation AS schadenart_txt,
     federalestateid AS EGRID,
     federalbuildingid AS EGID,
     estatenumbernum AS grundstuecknummer,
     landregistersectornodescription AS grundbuchkreis,
     buildingcity AS gemeinde, 
     claimsum AS schadensumme,
     claimincidentdate AS schadendatum,
     buildingstreetname||' '||buildingstreetnumber||', '||buildingpostcode||' '||buildingcity AS beschreibung, 
     buildingassurancenumbercant AS gebaeudenummer,
     REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
         REPLACE(objectclaimstate, ' ', '_'),
         'ä','ae'),
         'ö','oe'),
         'ü','ue'),
         'Ä','Ae'),
         'Ö','Oe'),
         'Ü','Ue')
     AS schadenstatus,
     objectclaimstate AS schadenstatus_txt,
     claimnumber AS schadennummer,
     link_gemdat AS sgv_link, 
     REPLACE(buildinginsurancestate, ' ', '_') AS gebaeudestatus,
     buildinginsurancestate AS gebaeudestatus_txt,
     insurancevalue AS versicherungswert 
FROM 
    sgv_schadenkarte_v1.schadenfall
;