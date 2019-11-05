pipeline {
    agent none
    stages {
        stage ('discover_changed_harvesters') {
            agent any
            steps {
                script {
                    if (env.GIT_PREVIOUS_COMMIT  == null) {
                        sh(returnStdout: true, script: "git fetch --no-tags --progress -- https://github.com/aodn/harvesters.git +refs/heads/master:refs/remotes/origin/master")
                        base = sh(returnStdout: true, script: "git merge-base origin/master HEAD").trim()
                    } else {
                        base = GIT_PREVIOUS_COMMIT
                    }
                    
                    projects = sh(returnStdout: true, script: "git diff --name-only ${base } ${GIT_COMMIT} | awk -F '/' '{print \$2}' | uniq").trim().split()
                    for(project in projects) {
                        echo "Found changes in project ${project}"
                    }
                    
                }
            }
        }
        stage('build') {
            agent any
            steps {
                script {
                    for(project in projects) {
                        projects_directory = "workspace"
                        harvester_job_name = harvesterHelper.getHarvesterJobName("${WORKSPACE}/${projects_directory}/${project}/process/")
                        
                        if (!harvester_job_name) {
                            echo "Skipping $project. No job with '_harvester' suffix found"
                            continue
                        }
                    
                        childJobName = "harvester_${project}_build"
                        try {
                            build job: childJobName, parameters: [
                                string(name: 'GIT_REVISION', value: env.GIT_COMMIT),
                                string(name: 'HARVESTER_NAME', value: harvester_job_name),
                                string(name: 'PROJECT_NAME', value: project)
                            ],
                            wait: false
                        } catch (Exception e) {
                                echo "No build job named ${childJobName} found, skipping"
                        }
                    }
                }
            }
        }
    }
}
