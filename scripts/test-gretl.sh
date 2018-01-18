#!/bin/bash

# requires Docker Image uncoyote/gretl-runtime with tag 11 on Docker Hub
# requires a test postgres db to be running on the host with port: 5432

hostIP=`ip route get 8.8.8.8 | awk '{print $NF; exit}'`

job_directory=$(pwd)/../afu_altlasten_pub
task_name=transferAfuAltlasten

task_parameter=(
-PsourceDbUrl="jdbc:postgresql://$hostIP:5432/gretl" \
-PsourceDbUser="ddluser" \
-PsourceDbPass="ddluser" \
-PtargetDbUrl="jdbc:postgresql://$hostIP:5432/gretl" \
-PtargetDbUser="dmluser" \
-PtargetDbPass="dmluser" \
)


# run GRETL job by GRETL runtime
./start-gretl.sh \
  --docker_image uncoyote/gretl-runtime:11 \
  --job_directory $job_directory \
  --task_name $task_name "${task_parameter[@]}"
