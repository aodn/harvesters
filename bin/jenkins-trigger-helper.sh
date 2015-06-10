#!/bin/bash

ARTIFACT_DIRECTORY=$1; shift
PROJECTS_DIRECTORY=$1; shift
OUTPUT_DIRECTORY=$1; shift

get_harvester_job_name() {
    local harvester_job_item=`find $1/process -regex '.*_harvester_[0-9]+\.[0-9]+\.item'`
    echo $harvester_job_item | sed -e 's/.*\///g' -e 's/_[0-9]\+\.[0-9]\+.item//g'
}

rebuild_artifact() {
    artifact_path=`ls $ARTIFACT_DIRECTORY/$1*.zip 2> /dev/null` || return 0
    newer_file=`find "$2" -newer "$artifact_path" -print -quit` && [ "$newer_file" != '' ]
}

# Write harvesters to be rebuilt to $OUTPUT_DIRECTORY directory 
rm -rf --preserve-root $OUTPUT_DIRECTORY
mkdir $OUTPUT_DIRECTORY

project_directories=`ls -d -1 $PROJECTS_DIRECTORY/*`

for project_directory in $project_directories; do
    project_name=$(basename $project_directory)
    harvester_job_name=$(get_harvester_job_name $project_directory)

    if rebuild_artifact "$harvester_job_name" "$project_directory" ; then
        echo "Rebuilding $harvester_job_name"
        echo "PROJECT_NAME=$project_name" > "$OUTPUT_DIRECTORY/$harvester_job_name.properties"
        echo "HARVESTER_NAME=$harvester_job_name" >> "$OUTPUT_DIRECTORY/$harvester_job_name.properties"
    fi
done
