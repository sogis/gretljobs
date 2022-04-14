pipeline {
    agent { label params.nodeLabel ?: 'gretl' }
    options {
        timeout(time: 6, unit: 'HOURS')
    }
    stages {
        stage('Run GRETL-Job') {
            options {
                retry(2)
            }
            steps {
                git url: "${env.GIT_REPO_URL}", branch: "${params.BRANCH ?: 'master'}", changelog: false
                container('gretl') {
                    dir(env.JOB_BASE_NAME) {
                        sh 'gretl'
                    }
                }
            }
        }
    }
    post {
        unsuccessful {
            emailext (
                to: '${DEFAULT_RECIPIENTS}',
                recipientProviders: [requestor()],
                subject: "GRETL-Job ${JOB_NAME} (${BUILD_DISPLAY_NAME}) ist fehlgeschlagen",
                body: "Die Ausführung des GRETL-Jobs ${JOB_NAME} (${BUILD_DISPLAY_NAME}) war nicht erfolgreich. Details dazu finden Sie in den Log-Meldungen unter ${RUN_DISPLAY_URL}."
            )
        }
    }
}
