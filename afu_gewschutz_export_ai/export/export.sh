#!/usr/bin/env bash

#!/bin/bash
#
# Skript führt die notwendigen Schritte aus um den planerischen Gewässerschutz
# von unserer PostGIS-Datenbank auf die Aggregationsinfrastruktur zu pushen.
#
# Parameter beim Aufruf des Skriptes:
# 1: Passwort des dbusers für den ili2pg Export (für die Inserts muss das PW in .pgpass vorhanden sein)
# 2: Passwort für den Push des zips auf die Aggregationsinfrastruktur
#
# Hauptschritte im Skript:
# 1: Datenumbau von der SOGIS-DB mittels Queries in das ili2pg-Schema afu_gewaesserschutz_export
# 2: Export des xtf aus Schema afu_gewaesserschutz_export
# 3: Push des xtf auf die Aggregationsinfrastruktur mittels curl

#if [1]
# then
	# echo 'Skript erwartet Passwort für das Auslesen der Datenbank und für push der Daten auf die Aggregationsinfrastruktur.'
	# exit 1
# fi

# Variablen
# Pfad zum Verzeichnis in dem das Skript liegt
out_dir='./output'

# Verbindungsvariablen zur Datenbank mit Ausgangs- und Umbautabellen
db_host='geodb.verw.rootso.org'
db_port=5432
db_name='sogis'
db_usr='datasync'

# ili2pg Variablen
#idb_jre_path='/home/bjsvwjek/javaora/jre1.8.0_121/bin/java'
idb_path='/home/bjsvwjek/IdeaProjects/_lib/ili2pg361/ili2pg.jar'
idb_dbpass=$1
idb_xtf_name='gewschutz.xtf'

# curl Variablen für HTTP-Post auf Aggregationsinfrastruktur
curl_zip_name='gewschutz.zip'
curl_pass=$2
curl_url='https://geodienste.ch/data_agg/interlis/import'
curl_log_path=$out_dir'/aipush.log'
curl_toml_name='config.toml'


echo '1: xtf mittels ili2pg aus db schema afu_gewaesserschutz_export exportieren'
java -jar $idb_path --export --dbhost $db_host --dbdatabase $db_name --dbschema afu_gewaesserschutz_export \
	--dbusr datasync --dbpwd $idb_dbpass --log $out_dir'/idb_export.log' --models PlanerischerGewaesserschutz_LV95_V1_1 \
	$out_dir'/'$idb_xtf_name

echo '2.1: xtf und toml zippen'
cp $sh_dir'/'$curl_toml_name $out_dir
cd $out_dir
zip $curl_zip_name $idb_xtf_name $curl_toml_name

echo '2.2 zip mittels curl auf die Aggregationsinfrastruktur pushen'
curl -X POST -u geodienste_so:$curl_pass -F topic='planerischer_gewaesserschutz' –F publish='true' -F lv95_file='@'$curl_zip_name $curl_url