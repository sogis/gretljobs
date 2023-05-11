#!/bin/bash

java -jar ~/tools/ili2pg-4.9.1/ili2pg-4.9.1.jar \
--import \
--dbhost localhost --dbport 54321 --dbdatabase edit --dbusr ddluser --dbpwd ddluser \
--dbschema ada_archaeologie_v1 --models SO_ADA_Archaeologie_20230417 \
--disableValidation \
$(pwd)/.gitignored/export.xtf

