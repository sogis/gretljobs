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
_sh_file=$(readlink -f "$0")
sh_dir=$(dirname "$_sh_file")
out_dir=$(dirname "$_sh_file")'/output'

# Verbindungsvariablen zur Datenbank mit Ausgangs- und Umbautabellen
db_host='192.168.56.2'
db_port=5432
db_name='sogis'
db_usr='godfather'

# ili2pg Variablen
idb_jre_path='/home/bjsvwjek/javaora/jre1.8.0_121/bin/java'
idb_path='/home/bjsvwjek/eclipse_ws/lib/ili2pg361/ili2pg.jar'
idb_dbpass=$1
idb_xtf_name='gewschutz.xtf'

# curl Variablen für HTTP-Post auf Aggregationsinfrastruktur
curl_zip_name='gewschutz.zip'
curl_pass=$2
curl_url='https://integration.geodienste.ch/data_agg/interlis/import'
curl_log_path=$out_dir'/aipush.log'
curl_toml_name='config.toml'


echo '1.1: Datenumbau zurücksetzen'
psql -h $db_host -p $db_port -d $db_name -U $db_usr --no-password -c 'truncate table afu_gewaesserschutz_export.gsbereich;'
psql -h $db_host -p $db_port -d $db_name -U $db_usr --no-password -c 'truncate table afu_gewaesserschutz_export.gwsareal;'
psql -h $db_host -p $db_port -d $db_name -U $db_usr --no-password -c 'truncate table afu_gewaesserschutz_export.gwszone;'
psql -h $db_host -p $db_port -d $db_name -U $db_usr --no-password -c 'truncate table afu_gewaesserschutz_export.status;'
rm $out_dir'/'$idb_xtf_name

echo '1.2: Datenumbau gsbereich befuellen'
psql -h $db_host -p $db_port -d $db_name -U $db_usr --no-password -f $sh_dir'/gsbereich_insert.sql'

echo '1.3: Datenumbau gwsareal befuellen'
psql -h $db_host -p $db_port -d $db_name -U $db_usr --no-password -f $sh_dir'/gsareal_insert.sql'

echo '1.3: Datenumbau gwszone befuellen'
psql -h $db_host -p $db_port -d $db_name -U $db_usr --no-password -f $sh_dir'/insert_gwszone.sql'

echo '2: xtf mittels ili2pg aus db schema afu_gewaesserschutz_export exportieren'
$idb_jre_path -jar $idb_path --export --dbhost $db_host --dbdatabase $db_name --dbschema afu_gewaesserschutz_export \
	--dbusr godfather --dbpwd $idb_dbpass --log $out_dir'/idb_export.log' --models PlanerischerGewaesserschutz_LV95_V1_1 \
	$out_dir'/'$idb_xtf_name >/dev/null 2>/dev/null
	
echo '3.1: xtf und toml zippen'
cp $sh_dir'/'$curl_toml_name $out_dir
cd $out_dir
zip $curl_zip_name $idb_xtf_name $curl_toml_name

echo '3.2 zip mittels curl auf die Aggregationsinfrastruktur pushen'
curl -X POST -u geodienste_so:$curl_pass -F topic='planerischer_gewaesserschutz' –F publish='true' -F lv95_file='@'$curl_zip_name $curl_url > $curl_log_path







