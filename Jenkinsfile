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
        stage('trigger_builds') {
            agent any
            steps {
                script {
                    for(project in projects) {
                        childJobName = "harvester_${project}_build"
                        try {
                            build job: childJobName, parameters: [
                                string(name: 'GIT_BRANCH', value: env.GIT_BRANCH),
                                string(name: 'GIT_COMMIT', value: env.GIT_COMMIT),
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
