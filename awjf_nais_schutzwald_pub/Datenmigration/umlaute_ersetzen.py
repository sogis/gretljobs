#!/usr/bin/env python3
"""PDF-Dateinamen mit deutschen Umlauten bereinigen; Standard ist eine Vorschau."""

import argparse
import csv
from pathlib import Path
import sys
import unicodedata


ZUORDNUNG = str.maketrans({
    "Ä": "AE", "Ö": "OE", "Ü": "UE", "ä": "ae", "ö": "oe", "ü": "ue",
    "ẞ": "SS", "ß": "ss",
})


def neuer_name(name):
    # Auch zerlegte Umlaute (z.B. A + kombinierendes Trema) berücksichtigen.
    return unicodedata.normalize("NFC", name).translate(ZUORDNUNG)


def plan_erstellen(ordner, rekursiv=False):
    dateien = ordner.rglob("*") if rekursiv else ordner.iterdir()
    plan = []
    for quelle in sorted(dateien):
        if quelle.is_symlink() or not quelle.is_file():
            continue
        if quelle.suffix.lower() != ".pdf":
            continue
        ziel = quelle.with_name(neuer_name(quelle.name))
        if ziel != quelle:
            plan.append((quelle, ziel))

    # Auch Kollisionen auf Dateisystemen ohne Unterscheidung der Schreibweise
    # verhindern. Keine Datei wird vor Abschluss dieser Prüfung umbenannt.
    belegt = {}
    for eltern in {quelle.parent for quelle, _ in plan}:
        for pfad in eltern.iterdir():
            belegt[(eltern, pfad.name.casefold())] = pfad
    for quelle, ziel in plan:
        key = (ziel.parent, ziel.name.casefold())
        if key in belegt:
            raise ValueError(f"Namenskollision: {quelle} -> {ziel}; belegt durch {belegt[key]}")
        belegt[key] = quelle
    return plan


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("ordner", type=Path, help="Ordner mit den PDF-Dateien")
    parser.add_argument("--rekursiv", action="store_true", help="Auch Unterordner durchsuchen")
    parser.add_argument("--anwenden", action="store_true", help="Geplante Umbenennungen ausführen")
    parser.add_argument("--protokoll", type=Path, default=Path("umbenennungen.csv"),
                        help="CSV-Protokoll beim Anwenden; muss neu sein (Standard: umbenennungen.csv)")
    args = parser.parse_args()
    ordner = args.ordner.resolve()
    if not ordner.is_dir():
        parser.error(f"Kein Verzeichnis: {ordner}")
    try:
        plan = plan_erstellen(ordner, args.rekursiv)
        for quelle, ziel in plan:
            print(f"{quelle.relative_to(ordner)} -> {ziel.relative_to(ordner)}")
        print(f"{len(plan)} PDF-Datei(en) umzubenennen.")
        if not args.anwenden:
            print("Vorschau: Keine Dateien geändert. Ausführen mit --anwenden.")
            return 0
        if not plan:
            return 0
        # Vor der ersten Umbenennung anlegen; vorhandene Protokolle schützen.
        with args.protokoll.open("x", newline="", encoding="utf-8") as protokoll:
            writer = csv.writer(protokoll)
            writer.writerow(["alter_pfad", "neuer_pfad"])
            protokoll.flush()
            for quelle, ziel in plan:
                if ziel.exists() or ziel.is_symlink():
                    raise ValueError(f"Ziel wurde inzwischen angelegt: {ziel}")
                quelle.rename(ziel)
                writer.writerow([str(quelle), str(ziel)])
                protokoll.flush()
        print(f"Umbenennungen ausgeführt. Protokoll: {args.protokoll.resolve()}")
        return 0
    except (OSError, ValueError) as exc:
        print(f"Abbruch: {exc}", file=sys.stderr)
        print("Falls bereits Dateien umbenannt wurden: CSV-Protokoll beachten.", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
