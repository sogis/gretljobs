SELECT
    geometrie,
    nutzung,
    waldflaeche,
    lufttemperatur_04uhr,
    windgeschwindigkeit,
    pet,
    kaltluftprozess,
    --kaltluftprozess_code.dispname AS kaltluftprozess_txt,
    kaltluftentstehungsgebiet,
    flaeche,
    einwohnerzahl_gesamt,
    einwohner_unter_6_jahren,
    einwohner_ueber_65_jahre,
    einwohnerdichte,
    bewertung_tag,
    bewertung_nacht
FROM
    afu_klimaanalyse_v1.ausgangsgroessen_bewertung AS bewertung
    --LEFT JOIN afu_klimaanalyse_v1.ausgangsgroessen_bewertung_kaltluftprozess AS kaltluftprozess_code
    --ON kaltluftprozess = kaltluftprozess_code.ilicode
;
