SELECT 
    t_ili_tid,
    mutationsnummer,
    nbident,
    beschrieb,
    ${bucket}||dateinameplan||'.pdf' AS dateinameplan,
    endetechnbereit,
    meldungen,
    grundbucheintrag,
    perimeter,
    istprojektmutation
FROM 
    agi_gb2av_controlling.controlling_av2gb_mutationen
;
