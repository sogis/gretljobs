#!/bin/bash

# use like this:
# start-gretl.sh --docker-image sogis/gretl-runtime:latest --job-directory ~/gretljobs/jobname [taskName...] [--option-name...]
# [--option-name...] takes any Gradle option, including project properties
# (e.g. -Pmyprop=myvalue) and system properties (e.g. -Dmyprop=myvalue).
# See https://docs.gradle.org/current/userguide/command_line_interface.html
# or the output of gradle -h for available options.

gradle_options=()

while [ $# -gt 0 ]; do
    if [[ $1 == "--docker-image" ]]; then
        declare docker_image="$2"
        shift
    elif [[ $1 == "--job-directory" ]]; then
        declare job_directory="$2"
        shift
    else
        gradle_options+=($1)
   fi
  shift
done

resource_parameters=(
-PdbUriSogis=\'$DB_URI_SOGIS\' \
-PdbUserSogis=\'$DB_USER_SOGIS\' \
-PdbPwdSogis=\'$DB_PWD_SOGIS\' \
-PdbUriEdit=\'$DB_URI_EDIT\' \
-PdbUserEdit=\'$DB_USER_EDIT\' \
-PdbPwdEdit=\'$DB_PWD_EDIT\' \
-PdbUriPub=\'$DB_URI_PUB\' \
-PdbUserPub=\'$DB_USER_PUB\' \
-PdbPwdPub=\'$DB_PWD_PUB\' \
-PdbUriAltlast4web=\'$DB_URI_ALTLAST4WEB\' \
-PdbUserAltlast4web=\'$DB_USER_ALTLAST4WEB\' \
-PdbPwdAltlast4web=\'$DB_PWD_ALTLAST4WEB\' \
-PaiServer=\'$AI_SERVER\' \
-PaiUser=\'$AI_USER\' \
-PaiPwd=\'$AI_PWD\' \
)

declare gretl_cmd="gretl ${gradle_options[@]} -PgretlShare=/tmp/gretl-share ${resource_parameters[@]}"

echo "======================================================="
echo "Starts the GRETL runtime to execute the given GRETL job"
echo "Docker Image: $docker_image"
echo "job directory: $job_directory"
echo "Gradle options: ${gradle_options[@]}"
# The following line is commented out because it would display database credentials
# echo "gretl_cmd: $gretl_cmd"
echo "======================================================="

# special run configuration for jenkins-slave based image:
# 1. use a shell as entry point
# 2. mount job directory as volume
# 3. run as current user to avoid permission problems on generated .gradle directory
# 4. gretl-runtime image with tag latest
# 5. executed commands seperated by semicolon:
#    a. jenkins jnlp client
#    b. change to project directory
#    c. run gradle with given task and parameter using init script from image

docker run -i --rm \
    --entrypoint="/bin/sh" \
    -v "$job_directory":/home/gradle/project \
    -v /tmp:/tmp/gretl-share \
    --user $UID \
    "$docker_image" "-c" \
        "/usr/local/bin/run-jnlp-client > /dev/null 2>&1;cd /home/gradle/project;$gretl_cmd"
