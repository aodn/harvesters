#!/bin/bash

get_harvester_job_name() {
    local harvester_job_item=`find $1/process -regex '.*_harvester_[0-9]+\.[0-9]+\.item'`
    echo $harvester_job_item | sed -e 's/.*\///g' -e 's/_[0-9]\+\.[0-9]\+.item//g'
}

rebuild_artifact() {
    local artifacts_directory="$1"; shift
    local project_directory="$1"; shift
    local harvester_name="$1"; shift
    [ x"$harvester_name" = x ] && return 1

    local artifact_path
    artifact_path=`ls $artifacts_directory/$harvester_name*.zip 2> /dev/null` || return 0

    local -i newer_files=`find "$project_directory" -newer "$artifact_path" -print -quit | wc -l`
    [ $newer_files -gt 0 ]
}

# prints usage and exit
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Triggers talend harvester rebuilds on jenkins"
    echo "
Options:
  -a, --artifacts            Directory with .zip artifacts (usually \`target\`).
  -p, --projects             Projects directory (usually \`workspace\`).
  -o, --output               Output directory for .properties files.
  -r, --rebuild              Force rebuild of all harvesters."
    exit 3
}

main() {
    # parse options with getopt
    local tmp_getops
    tmp_getops=`getopt -o ha:p:o:r --long help,artifacts:,projects:,output:,rebuild -- "$@"`
    [ $? != 0 ] && usage

    eval set -- "$tmp_getops"
    local artifacts_directory projects_directory output_directory
    local -i rebuild_all=0

    # parse the options
    while true ; do
        case "$1" in
            -h|--help) usage;;
            -a|--artifacts) artifacts_directory=$2; shift 2;;
            -p|--projects) projects_directory=$2; shift 2;;
            -o|--output) output_directory=$2; shift 2;;
            -r|--rebuild) rebuild_all=1; shift 1;;
            --) shift; break;;
            *) usage;;
        esac
    done

    [ ! -d "$projects_directory" ] && usage

    if [ $rebuild_all -eq 1 ]; then
        echo "REBUILDING ALL HARVESTERS!!!"
    fi

    # Write harvesters to be rebuilt to $output_directory directory
    rm -rf --preserve-root $output_directory
    mkdir $output_directory

    project_directories=`ls -d -1 $projects_directory/*`

    for project_directory in $project_directories; do
        local project_name=$(basename $project_directory)
        local harvester_job_name=$(get_harvester_job_name $project_directory)

        if [ x"$harvester_job_name" != x ]; then
            if [ $rebuild_all -eq 1 ] || rebuild_artifact "$artifacts_directory" "$project_directory" "$harvester_job_name"; then
                echo "Rebuilding $harvester_job_name"
                echo "PROJECT_NAME=$project_name" > "$output_directory/$harvester_job_name.properties"
                echo "HARVESTER_NAME=$harvester_job_name" >> "$output_directory/$harvester_job_name.properties"
            fi
        else
            echo "Skipping $project_directory"
        fi
    done
}

main "$@"
