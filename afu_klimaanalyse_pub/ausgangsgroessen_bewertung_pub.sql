SELECT
    geometrie,
    nutzung,
    waldflaeche,
    waldflaeche::text AS waldflaeche_txt,
    lufttemperatur_04uhr,
    windgeschwindigkeit,
    pet,
    kaltluftprozess,
    kaltluftprozess_code.dispname AS kaltluftprozess_txt,
    kaltluftentstehungsgebiet,
    kaltluftentstehungsgebiet::text AS kaltluftentstehungsgebiet_txt,
    flaeche,
    einwohnerzahl_gesamt,
    einwohner_unter_6_jahren,
    einwohner_ueber_65_jahre,
    einwohnerdichte,
    bewertung_tag,
    bewertung_code_tag.dispname AS bewertung_tag_txt,
    bewertung_nacht,
    bewertung_code_nacht.dispname AS bewertung_nacht_txt,
    bewertung_tag_pub,
    bewertung_nacht_pub
FROM
    afu_klimaanalyse_v1.ausgangsgroessen_bewertung AS ausgangsgroessen_bewertung
    LEFT JOIN afu_klimaanalyse_v1.ausgangsgroessen_bewertung_kaltluftprozess AS kaltluftprozess_code
      ON kaltluftprozess = kaltluftprozess_code.ilicode
    LEFT JOIN afu_klimaanalyse_v1.bewertung AS bewertung_code_tag
      ON bewertung_tag = bewertung_code_tag.ilicode
    LEFT JOIN afu_klimaanalyse_v1.bewertung AS bewertung_code_nacht
      ON bewertung_nacht = bewertung_code_nacht.ilicode
;
