#!/bin/bash

get_harvester_job_name() {
    local harvester_job_item=`find $1/process -regex '.*_harvester_[0-9]+\.[0-9]+\.item'`
    echo $harvester_job_item | sed -e 's/.*\///g' -e 's/_[0-9]\+\.[0-9]\+.item//g'
}

rebuild_artifact() {
    local artifact_directory="$1"; shift
    local project_directory="$1"; shift
    local harvester_name="$1"; shift
    [ x"$harvester_name" = x ] && return 1

    local artifact_path
    artifact_path=`ls $artifact_directory/$harvester_name*.zip 2> /dev/null` || return 0

    local -i newer_files=`find "$project_directory" -newer "$artifact_path" -print -quit | wc -l`
    [ $newer_files -gt 0 ]
}

main() {
    local artifact_directory="$1"; shift
    local projects_directory="$1"; shift
    local output_directory="$1"; shift

    # Write harvesters to be rebuilt to $output_directory directory
    rm -rf --preserve-root $output_directory
    mkdir $output_directory

    project_directories=`ls -d -1 $projects_directory/*`

    for project_directory in $project_directories; do
        local project_name=$(basename $project_directory)
        local harvester_job_name=$(get_harvester_job_name $project_directory)

        if rebuild_artifact "$artifact_directory" "$project_directory" "$harvester_job_name"; then
            echo "Rebuilding $harvester_job_name"
            echo "PROJECT_NAME=$project_name" > "$output_directory/$harvester_job_name.properties"
            echo "HARVESTER_NAME=$harvester_job_name" >> "$output_directory/$harvester_job_name.properties"
        fi
    done
}

main "$@"
