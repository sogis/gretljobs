import csv
import time
from pathlib import Path
from urllib.error import HTTPError
from urllib.parse import quote
from urllib.request import Request, urlopen

ordner = Path(__file__).resolve().parent

with (ordner / "links.csv").open(
    encoding="utf-8-sig", newline=""
) as eingabe:
    # Erkennt Komma, Semikolon oder Tab als Trennzeichen.
    probe = eingabe.read(8192)
    eingabe.seek(0)
    formatierung = csv.Sniffer().sniff(probe, delimiters=",;\t")
    links = list(csv.DictReader(eingabe, dialect=formatierung))

if not links or not {"dokument", "url"}.issubset(links[0]):
    raise SystemExit(
        "Die CSV muss die Spaltenüberschriften dokument und url enthalten."
    )

with (ordner / "ergebnis.csv").open(
    "w", encoding="utf-8-sig", newline=""
) as ausgabe:
    spalten = [
        "t_id", "dokument", "url", "http_status",
        "endgueltige_url", "inhaltstyp", "ergebnis"
    ]
    schreiber = csv.DictWriter(
        ausgabe, fieldnames=spalten, delimiter=";"
    )
    schreiber.writeheader()

    for nummer, link in enumerate(links, start=1):
        url = link["url"].strip()
        ergebnis = {
            "t_id": link["t_id"],
            "dokument": link["dokument"],
            "url": url,
        }

        try:
            # Kodiert unter anderem Leerzeichen und Umlaute in der URL.
            abruf_url = quote(url, safe=":/%?=&#+;,@!$'()*[]~")
            anfrage = Request(
                abruf_url,
                headers={"User-Agent": "Schutzwald-Linkpruefung/1.0"},
            )

            with urlopen(anfrage, timeout=20) as antwort:
                # Nur den Anfang lesen, nicht das ganze Dokument.
                anfang = antwort.read(1024)
                inhaltstyp = antwort.headers.get_content_type()

                ergebnis.update({
                    "http_status": antwort.status,
                    "endgueltige_url": antwort.geturl(),
                    "inhaltstyp": inhaltstyp,
                })

                if anfang.startswith(b"%PDF-"):
                    ergebnis["ergebnis"] = "Erreichbar, PDF erkannt"
                elif inhaltstyp == "text/html":
                    ergebnis["ergebnis"] = (
                        "Pruefen: HTML-Seite statt Dokument"
                    )
                else:
                    ergebnis["ergebnis"] = (
                        "Erreichbar, Dateiformat manuell pruefen"
                    )

        except HTTPError as fehler:
            ergebnis["http_status"] = fehler.code
            ergebnis["endgueltige_url"] = fehler.geturl()
            if fehler.code in (404, 410):
                ergebnis["ergebnis"] = "Dokument nicht gefunden"
            else:
                ergebnis["ergebnis"] = f"HTTP-Fehler: {fehler.reason}"
            fehler.close()

        except Exception as fehler:
            ergebnis["ergebnis"] = f"Abruffehler: {fehler}"

        schreiber.writerow(ergebnis)
        ausgabe.flush()
        print(
            f"{nummer}/{len(links)}: "
            f"{link['dokument']} — {ergebnis['ergebnis']}",
            flush=True,
        )
        time.sleep(0.2)

print("Fertig. Die Ergebnisse stehen in ergebnis.csv.")
