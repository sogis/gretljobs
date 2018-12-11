#!/bin/bash

# use like this:
# start-gretl.sh --docker_image sogis/gretl-runtime:14 --job_directory /home/gretl --task_name gradleTaskName -Pparam1=1 -Pparam2=2

task_parameter=()

while [ $# -gt 0 ]; do
    if [[ $1 == *"--"* ]]; then
        v="${1/--/}"
        declare $v="$2"
   elif [[ "$1" =~ ^"-P" ]]; then
        task_parameter+=($1)
   fi
  shift
done

db_parameter=(
-PdbUriSogis=$DB_URI_SOGIS \
-PdbUserSogis=$DB_USER_SOGIS \
-PdbPwdSogis=$DB_PWD_SOGIS \
-PdbUriEdit=$DB_URI_EDIT \
-PdbUserEdit=$DB_USER_EDIT \
-PdbPwdEdit=$DB_PWD_EDIT \
-PdbUriPub=$DB_URI_PUB \
-PdbUserPub=$DB_USER_PUB \
-PdbPwdPub=$DB_PWD_PUB \
-PdbUriAltlast4web=$DB_URI_ALTLAST4WEB \
-PdbUserAltlast4web=$DB_USER_ALTLAST4WEB \
-PdbPwdAltlast4web=$DB_PWD_ALTLAST4WEB \
)

declare gretl_cmd="gretl $task_name ${task_parameter[@]} ${db_parameter[@]}"

echo "======================================================="
echo "Starts the GRETL runtime to execute the given GRETL job"
echo "Docker Image: $docker_image"
echo "task name: $task_name"
echo "job directory: $job_directory"
echo "task_parameter: ${task_parameter[@]}"
#echo "gretl_cmd: $gretl_cmd"
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
    --user $UID \
    "$docker_image" "-c" \
        "/usr/local/bin/run-jnlp-client > /dev/null 2>&1;cd /home/gradle/project;$gretl_cmd"
