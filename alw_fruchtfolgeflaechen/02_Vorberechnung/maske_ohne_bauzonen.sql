DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_maske_ohne_bauzonen
;

WITH bauzonen AS (
    SELECT 
        ST_union(geometrie) AS geometrie
    FROM 
        arp_npl_pub.nutzungsplanung_grundnutzung
    WHERE 
        typ_kt NOT IN ('N160_Gruen_und_Freihaltezone_innerhalb_Bauzone',
                       'N210_Landwirtschaftszone',
                       'N220_Spezielle_Landwirtschaftszone',
                       'N230_Rebbauzone',
                       'N290_weitere_Landwirtschaftszonen',
                       'N311_Waldrandschutzzone',
                       'N319_weitere_Schutzzonen_fuer_Lebensraeume_und_Landschaften',
                       'N329_weitere_Zonen_fuer_Gewaesser_und_ihre_Ufer',
                       'N390_weitere_Schutzzonen_ausserhalb_Bauzonen',
                       'N430_Reservezone_Wohnzone_Mischzone_Kernzone_Zentrumszone',
                       'N431_Reservezone_Arbeiten',
                       'N432_Reservezone_OeBA',
                       'N439_Reservezone',
                       'N490_Golfzone',
                       'N491_Abbauzone',
                       'N492_Deponiezone'
                      )
)

SELECT 
    ST_difference(ohne_schafstoffbelastete_boeden.geometrie,bauzonen.geometrie) AS geometrie 
INTO 
    alw_fruchtfolgeflaechen.fff_maske_ohne_bauzonen 
FROM 
    alw_fruchtfolgeflaechen.fff_maske_ohne_schadstoffbelastete_boeden ohne_schafstoffbelastete_boeden,
    bauzonen
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_bauzonen_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_bauzonen
USING GIST(geometrie)
;
