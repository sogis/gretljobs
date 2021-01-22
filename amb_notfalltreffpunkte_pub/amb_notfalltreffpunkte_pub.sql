SELECT
    a.t_id, 
    a.t_ili_tid, 
    a.bezeichnung,
    a.einzugsgebiet, 
    a.rfs, 
    a.einwohner,
    a.art,
    coalesce(b.strasse,'unbekannt') AS strasse, 
    coalesce(b.hausnummer,'unbekannt') AS hausnummer, 
    coalesce(postleitzahl.plz, 0) AS plz, 
    coalesce(ortschaft.ortschaftsname, 'unbekannt') AS ort, 
    a.url, 
    a.geometrie
FROM 
    amb_notfalltreffpunkte.notfalltreffpnkte_treffpunkt a 
    LEFT JOIN (
        SELECT 
            bodenflaeche.geometrie, 
	        adresse.hausnummer, 
	        strasse.atext AS strasse 
        FROM 
            agi_dm01avso24.bodenbedeckung_boflaeche bodenflaeche 
        LEFT JOIN 
            agi_dm01avso24.gebaeudeadressen_gebaeudeeingang adresse 
	        ON 
	        st_dwithin(adresse.lage,bodenflaeche.geometrie,0)
        LEFT JOIN 
            agi_dm01avso24.gebaeudeadressen_lokalisation lokalisation 
	        ON 
	        lokalisation.t_id = adresse.gebaeudeeingang_von
        LEFT JOIN 
            agi_dm01avso24.gebaeudeadressen_lokalisationsname strasse 
	        ON 
	        strasse.benannte = lokalisation.t_id
        WHERE 
            strasse.atext IS NOT NULL
		    AND 
		    adresse.hausnummer IS NOT NULL
    ) b 
	    ON 
	    st_dwithin(a.geometrie,b.geometrie,0)
	LEFT JOIN 
        agi_plz_ortschaften_pub.plzortschaften_postleitzahl postleitzahl 
	    ON 
	    st_dwithin(a.geometrie,postleitzahl.geometrie,0)
    LEFT JOIN 
        agi_plz_ortschaften_pub.plzortschaften_ortschaft ortschaft 
	    ON 
	    st_dwithin(a.geometrie,ortschaft.geometrie,0)
	;
