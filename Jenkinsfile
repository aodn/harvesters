properties([
    parameters([
        booleanParam(defaultValue: false, name: 'BUILD_ALL_HARVESTERS', description: 'if true, trigger a build of all harvesters.'),
    ])
])

node {
    stage('scm') {
        scmVars = checkout([$class: 'GitSCM',
            branches: [[ name: env.BRANCH_NAME ]],
            doGenerateSubmoduleConfigurations: false,
            extensions: [
                [
                    $class: 'CloneOption',
                    reference: '/var/lib/jenkins/reference_repos/aodn/harvesters.git',
                    shallow: true,
                    noTags: true,
                    honorRefspec: true
                ],
                [
                    $class: 'CheckoutOption',
                    timeout: 30
                ]
            ],
            userRemoteConfigs: [
                [
                    url: 'https://github.com/aodn/harvesters.git',
                    credentialsId: env.GIT_CREDENTIALS_ID,
                ]
            ]
        ])
    }
    stage ('detect_changes') {
        if (params.BUILD_ALL_HARVESTERS == true) {
            projects = sh(returnStdout: true, script: "ls -1 workspace/").trim().split()
        } else {
            if (scmVars.GIT_PREVIOUS_COMMIT == null) {
                // if the previous commit cannot be determined, compare this commit to the master branch to detect changes
                sh(returnStdout: true, script: "git fetch --no-tags --depth 1 origin master")
                base = sh(returnStdout: true, script: "git merge-base master HEAD").trim()
            } else {
                base = scmVars.GIT_PREVIOUS_COMMIT
            }
            projects = sh(returnStdout: true, script: "git diff --name-only ${base} ${scmVars.GIT_COMMIT} | awk -F'/' '{ a[\$2]++ } END { for (b in a) { if (b) print b; } }'").trim().split()
            echo "Found changes in projects ${projects}"
        }
    }
    stage('trigger_builds') {
        for(project in projects) {
            childJobName = "harvester_${project}_build"
            try {
                build job: childJobName, parameters: [
                    string(name: 'GIT_BRANCH', value: env.BRANCH_NAME),
                    string(name: 'GIT_COMMIT', value: scmVars.GIT_COMMIT)
                ],
                wait: false
            } catch (Exception e) {
                    echo "No build job named ${childJobName} found, skipping"
            }
        }
    }
}
