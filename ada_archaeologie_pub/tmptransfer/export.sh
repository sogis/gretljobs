java -jar ~/tools/ili2pg-4.9.1/ili2pg-4.9.1.jar \
--export \
--dbhost geodb-i.rootso.org --dbport 5432 --dbdatabase edit --dbusr bjsvwjek --dbpwd $1 \
--dbschema ada_archaeologie_v1 --models SO_ADA_Archaeologie_20230417 \
--disableValidation \
$(pwd)/.gitignored/export.xtf