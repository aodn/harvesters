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
                        echo project
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
                        harvester_job_name=sh(returnStdout: true, script: 
                        "find $projects_directory/$project/process -regex '.*_harvester_[0-9]+\\.[0-9]+\\.item' | sed -e 's/.*\\///g' -e 's/_[0-9]\\+\\.[0-9]\\+\\.item//g' | head -n 1").trim()
                            
                        echo(harvester_job_name)
                        if (!harvester_job_name) {
                            echo "Skipping $project. No job with '_harvester' suffix found"
                            continue
                        }
                    
                        childJobName = "harvester_${project}_build"
                        try {
                            build job: childJobName, parameters: [
                                string(name: 'BRANCH_NAME', value: env.BRANCH_NAME),
                                string(name: 'TALEND_JOB_NAME', value: harvester_job_name)
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
