WITH gefuege AS (
        SELECT
            isbo_prof_horizont.horkey,
            string_agg(concat(code_gefuegeform.strcode, code_gefuegegroesse.strcode), '/') AS gefuege
        FROM 
            isbo_prof_horizont
            LEFT JOIN isbo_prof_gefuege
                ON isbo_prof_horizont.horkey = isbo_prof_gefuege.horkey
            LEFT JOIN isbo_prof_codenumzeichen AS code_gefuegeform
                ON isbo_prof_gefuege.gefuegeform = code_gefuegeform.numcode
            LEFT JOIN isbo_prof_codenumzeichen AS code_gefuegegroesse 
                ON isbo_prof_gefuege.gefuegegroesse = code_gefuegegroesse.numcode
        GROUP BY
            isbo_prof_horizont.horkey
    ),
    farbe_munsell AS (
        SELECT
            isbo_prof_horizont.horkey,
            string_agg(concat(code_fton.strcode, ' ', code_ffarbe.strcode, ' ', code_fhelligk.strcode, '/', code_intensitaet.strcode), '<br>') AS farbe
        FROM
            isbo_prof_horizont
            LEFT JOIN isbo_prof_farbe
                ON isbo_prof_horizont.horkey = isbo_prof_farbe.horkey
            LEFT JOIN isbo_prof_codenumzeichen AS code_fton 
                ON isbo_prof_farbe.ton = code_fton.numcode
            LEFT JOIN isbo_prof_codenumzeichen AS code_ffarbe
                ON isbo_prof_farbe.farbe = code_ffarbe.numcode
            LEFT JOIN isbo_prof_codenumzeichen AS code_fhelligk
                ON isbo_prof_farbe.helligkeit = code_fhelligk.numcode
            LEFT JOIN isbo_prof_codenumzeichen AS code_intensitaet
                ON isbo_prof_farbe.intensitaet = code_intensitaet.numcode
        WHERE 
            code_fton.strcode IS NOT NULL 
        GROUP BY
            isbo_prof_horizont.horkey
    )

SELECT
    isbo_prof_horizont.horkey,
    isbo_prof_profil.profkey,
    isbo_prof_horizont.tiefe,
    gefuege.gefuege,
    isbo_prof_horizont.humusgehalt AS f33,
    isbo_prof_horizont.labhumusgehalt AS f34,
    isbo_prof_horizont.tongehalt AS f35,
    isbo_prof_horizont.labtongehalt AS f36,
    isbo_prof_horizont.schluffgehalt AS f37,
    isbo_prof_horizont.labschluffgehalt AS f38,
    isbo_prof_horizont.sandgehalt AS f39,
    isbo_prof_horizont.labsandgehalt AS f40,
    isbo_prof_horizont.kiesvolprozent AS f41,
    isbo_prof_horizont.steinevolprozent AS f42,
    code_karbonatgehalt.strcode AS f44,
    isbo_prof_horizont.labkarbonatgehalt AS f45,
    isbo_prof_horizont.phbodenreaktion AS f46,
    isbo_prof_horizont.labphbodenreakt AS f47,
    isbo_prof_horizont.kationkapeffektiv,
    isbo_prof_horizont.kationkappotenz,
    code_fton.strcode AS fton,
    code_ffarbe.strcode AS ffarbe,
    code_fhelligk.strcode AS fhelligk,
    code_intensitaet.strcode AS fintensitaet
FROM
    isbo_prof_horizont
    LEFT JOIN isbo_prof_profil
        ON isbo_prof_horizont.profkey = isbo_prof_profil.profkey
    LEFT JOIN isbo_prof_codenumzeichen AS code_karbonatgehalt 
        ON isbo_prof_horizont.karbonatgehalt = code_karbonatgehalt.numcode

    LEFT JOIN gefuege
        ON gefuege.horkey = isbo_prof_horizont.horkey

;
