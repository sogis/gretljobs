// Start with a scripted pipeline part
node('master') {
    stage('Prepare') {
        gretlJobRepoUrl = env.GRETL_JOB_REPO_URL
    }
}

// Declarative pipeline starts here
pipeline {
    agent { label params.nodeLabel ?: 'gretl' }
    stages {
        stage('Run GRETL-Job') {
            steps {
                git url: gretlJobRepoUrl, branch: "${params.BRANCH ?: 'master'}", changelog: false
                dir(env.JOB_BASE_NAME) {
                    sh 'gretl -Dorg.gradle.jvmargs=-Xmx2G'
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
