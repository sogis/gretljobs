SELECT 
    ogc_fid AS t_id,
    ST_Force_2D(wkb_geometry) AS geometrie,
    abschnitt_id,
    gnrso,
    abschnittnr,
    von,
    bis,
    gsbreite,
    eindol,
    CASE
        WHEN eindol = 0
            THEN 'nein'
        WHEN eindol = 1
            THEN 'ja'
    END AS eindol_txt,
    vnatabst,
    CASE
        WHEN vnatabst = 0
            THEN 'nein'
        WHEN vnatabst = 1
            THEN 'ja'
    END AS vnatabst_txt,
    bvar,
    CASE
        WHEN bvar = 0
            THEN 'nicht beurteilt'
        WHEN bvar = 1
            THEN 'ausgeprägt'
        WHEN bvar = 2
            THEN 'eingeschränkt'
        WHEN bvar = 3
            THEN 'keine'
    END AS bvar_txt,
    tvar,
    CASE 
        WHEN tvar = 0
            THEN 'nicht beurteilt'
        WHEN tvar = 1
            THEN 'ausgeprägt'
        WHEN tvar = 2
            THEN 'eingeschränkt'
        WHEN tvar = 3
            THEN 'keine'
    END AS tvar_txt,
    sohlver,
    CASE
        WHEN sohlver = 0
            THEN 'nicht beurteilt'
        WHEN sohlver = 1
            THEN 'keine'
        WHEN sohlver = 2
            THEN 'vereinzelt (<10%)'
        WHEN sohlver = 3
            THEN 'mässig (10-30%)'
        WHEN sohlver = 4
            THEN 'grössere (30-60%)'
        WHEN sohlver = 5
            THEN 'überwiegend (>60%)'
        WHEN sohlver = 6
            THEN 'vollständig'
    END AS sohlver_txt,
    sohlmat,
    CASE
        WHEN sohlmat = 0
            THEN 'nicht beurteilt'
        WHEN sohlmat = 1
            THEN 'Natursteine'
        WHEN sohlmat = 2
            THEN 'Holz'
        WHEN sohlmat = 3
            THEN 'Betongittersteine'
        WHEN sohlmat = 4
            THEN 'undurchlässig'
        WHEN sohlmat = 5
            THEN 'andere (dicht)'
        WHEN sohlmat = 6
            THEN 'Beton, Zement'
        WHEN sohlmat = 7
            THEN 'Pflästerung'
    END AS sohlmat_txt,
    lbukver,
    CASE
        WHEN lbukver = 0
            THEN 'nicht beurteilt'
        WHEN lbukver = 1
            THEN 'keine'
        WHEN lbukver = 2
            THEN 'vereinzelt (<10%)'
        WHEN lbukver = 3
            THEN 'mässig (10-30%)'
        WHEN lbukver = 4
            THEN 'grössere (30-60%)'
        WHEN lbukver = 5
            THEN 'überwiegend (>60%)'
        WHEN lbukver = 6
            THEN 'vollständig'
    END AS lbukver_txt,
    rbukver,
    CASE
        WHEN rbukver = 0
            THEN 'nicht beurteilt'
        WHEN rbukver = 1
            THEN 'keine'
        WHEN rbukver = 2
            THEN 'vereinzelt (<10%)'
        WHEN rbukver = 3
            THEN 'mässig (10-30%)'
        WHEN rbukver = 4
            THEN 'grössere (30-60%)'
        WHEN rbukver = 5
            THEN 'überwiegend (>60%)'
        WHEN rbukver = 6
            THEN 'vollständig'
    END AS rbukver_txt,
    lbukmat,
    CASE
        WHEN lbukmat = 0
            THEN 'nicht beurteilt'
        WHEN lbukmat = 1
            THEN 'Lebendverbau'
        WHEN lbukmat = 2
            THEN 'Natursteine locker'
        WHEN lbukmat = 3
            THEN 'Holz (undurchlässig)'
        WHEN lbukmat = 4
            THEN 'Betongittersteine'
        WHEN lbukmat = 5
            THEN 'Natursteine (dicht)'
        WHEN lbukmat = 6
            THEN 'Mauer'
        WHEN lbukmat = 7
            THEN 'andere (dicht)'
    END AS lbukmat_txt,
    rbukmat,
    CASE
        WHEN rbukmat = 0
            THEN 'nicht beurteilt'
        WHEN rbukmat = 1
            THEN 'Lebendverbau'
        WHEN rbukmat = 2
            THEN 'Natursteine locker'
        WHEN rbukmat = 3
            THEN 'Holz (undurchlässig)'
        WHEN rbukmat = 4
            THEN 'Betongittersteine'
        WHEN rbukmat = 5
            THEN 'Natursteine (dicht)'
        WHEN rbukmat = 6
            THEN 'Mauer'
        WHEN rbukmat = 7
            THEN 'andere (dicht)'
    END AS rbukmat_txt,
    lufbebre,
    rufbebre,
    luferber,
    CASE
        WHEN luferber = 0
            THEN 'nicht beurteilt'
        WHEN luferber = 1
            THEN 'genügend'
        WHEN luferber = 2
            THEN 'ungenügend'
        WHEN luferber = 3
            THEN 'kein Uferbereich'
    END AS luferber_txt,
    ruferber,
    CASE
        WHEN ruferber = 0
            THEN 'nicht beurteilt'
        WHEN ruferber = 1
            THEN 'genügend'
        WHEN ruferber = 2
            THEN 'ungenügend'
        WHEN ruferber = 3
            THEN 'kein Uferbereich'
    END AS ruferber_txt,
    lufbebew,
    CASE
        WHEN lufbebew = 0
            THEN 'nicht beurteilt'
        WHEN lufbebew = 1
            THEN 'gewässergerecht'
        WHEN lufbebew = 2
            THEN 'gewässerfremd'
        WHEN lufbebew = 3
            THEN 'künstlich'
    END AS lufbebew_txt,
    rufbebew,
    CASE
        WHEN rufbebew = 0
            THEN 'nicht beurteilt'
        WHEN rufbebew = 1
            THEN 'gewässergerecht'
        WHEN rufbebew = 2
            THEN 'gewässerfremd'
        WHEN rufbebew = 3
            THEN 'künstlich'
    END AS rufbebew_txt,
    bewalgen,
    CASE
        WHEN bewalgen = 0
            THEN 'nicht beurteilt'
        WHEN bewalgen = 1
            THEN 'kein/gering'
        WHEN bewalgen = 2
            THEN 'mässig/stark'
        WHEN bewalgen = 3
            THEN 'übermässig/wuchernd'
    END AS bewalgen_txt,
    bewmakro,
    CASE
        WHEN bewmakro = 0
            THEN 'nicht beurteilt'
        WHEN bewmakro = 1
            THEN 'kein/gering'
        WHEN bewmakro = 2
            THEN 'mässig/stark'
        WHEN bewmakro = 3
            THEN 'übermässig/wuchernd'
    END AS bewmakro_txt,
    totholz,
    CASE 
        WHEN totholz = 0
            THEN 'nicht beurteilt'
        WHEN totholz = 1
            THEN 'Ansammlungen'
        WHEN totholz = 2
            THEN 'mässig'
        WHEN totholz = 3
            THEN 'vereinzelt/kein'
    END AS totholz_txt,
    klasse,
    CASE
        WHEN klasse = 0
            THEN 'nicht klassiert'
        WHEN klasse = 1
            THEN 'natürlich/naturnah'
        WHEN klasse = 2
            THEN 'wenig beeinträchtigt'
        WHEN klasse = 3
            THEN 'stark beeinträchtigt'
        WHEN klasse = 4
            THEN 'naturfremd/künstlich'
        WHEN klasse = 5
            THEN 'eingedolt'
    END AS klasse_txt,
    winkelend,
    ueberveg,
    CASE
        WHEN ueberveg = 1
            THEN '>30% der Uferlänge(l&r)'
        WHEN ueberveg = 2
            THEN '5-30% der Uferlänge(l&r)'
        WHEN ueberveg = 3
            THEN 'bis 5% der Uferlänge(l&r)'
        WHEN ueberveg = 4
            THEN '0% der Uferlänge(l&r)'
    END AS ueberveg_txt,
    kgdom,
    CASE 
        WHEN kgdom = 0
            THEN 'nicht beurteilt'
        WHEN kgdom = 1
            THEN 'Sand/Schlick/Schlamm'
        WHEN kgdom = 2
            THEN 'erbsen- bis baumnussgross'
        WHEN kgdom = 3
            THEN 'baumnuss- bis faustgross'
        WHEN kgdom = 4
            THEN 'faust- bis kopfgross'
        WHEN kgdom = 5
            THEN '> kopfgross'
        WHEN kgdom = 6
            THEN 'anstehender Fels'
    END AS kgdom_txt,
    umfeldli,
    CASE
        WHEN umfeldli = 0
            THEN 'nicht beurteilt'
        WHEN umfeldli = 1
            THEN 'Wald'
        WHEN umfeldli = 2
            THEN 'Dauergrünland/Weide'
        WHEN umfeldli = 3
            THEN 'Ackerland/Kunstwiese'
        WHEN umfeldli = 4
            THEN 'befestigte Flur- und Wanderwege'
        WHEN umfeldli = 5
            THEN 'Siedlung/Infrastruktur'
        WHEN umfeldli = 6
            THEN 'andere'
    END AS umfeldli_txt,
    umfeldre,
        CASE
        WHEN umfeldre = 0
            THEN 'nicht beurteilt'
        WHEN umfeldre = 1
            THEN 'Wald'
        WHEN umfeldre = 2
            THEN 'Dauergrünland/Weide'
        WHEN umfeldre = 3
            THEN 'Ackerland/Kunstwiese'
        WHEN umfeldre = 4
            THEN 'befestigte Flur- und Wanderwege'
        WHEN umfeldre = 5
            THEN 'Siedlung/Infrastruktur'
        WHEN umfeldre = 6
            THEN 'andere'
    END AS umfeldre_txt,
    minuferber,
    raumbedarf,
    erhebungsdatum
FROM 
    gewisso.oeko_abschnitte
WHERE 
    archive = 0
;