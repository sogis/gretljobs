INSERT INTO 
    arp_waldabstandslinien_mgdm.geobasisdaten_typ 
    (
        acode,
        bezeichnung,
        abkuerzung,
        verbindlichkeit
    ) 
SELECT 
    substring(ilicode FROM 2 FOR 3) AS acode, 
    ilicode AS bezeichnung, 
    substring(ilicode FROM 1 FOR 4) AS abkuerzung,
    'Nutzungsplanfestlegung' AS verbindlichkeit
FROM 
    arp_npl.erschlssngsplnung_ep_typ_kanton_erschliessung_linienobjekt 
WHERE
    ilicode = 'E725_Waldabstandslinie'
;

INSERT INTO
    arp_waldabstandslinien_mgdm.geobasisdaten_waldabstand_linie 
    (
        geometrie,
        rechtsstatus,
        publiziertab,
        bemerkungen,
        wal
    )
SELECT 
    linienobjekt.geometrie,
    linienobjekt.rechtsstatus,
    linienobjekt.publiziertab,
    linienobjekt.bemerkungen,
    mgdm_typ.t_id AS wal
FROM 
    arp_npl.erschlssngsplnung_erschliessung_linienobjekt AS linienobjekt
    LEFT JOIN arp_npl.erschlssngsplnung_typ_erschliessung_linienobjekt AS typ 
    ON typ.t_id = linienobjekt.typ_erschliessung_linienobjekt 
    LEFT JOIN arp_waldabstandslinien_mgdm.geobasisdaten_typ AS mgdm_typ
    ON typ.typ_kt = mgdm_typ.bezeichnung 
WHERE
    typ.typ_kt = 'E725_Waldabstandslinie'
;