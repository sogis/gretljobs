pipeline {
    agent { label params.nodeLabel ?: 'gretl' }
    options {
        timeout(time: 6, unit: 'HOURS')
    }
    stages {
        stage('Run GRETL job') {
            steps {
                git url: "${env.GIT_REPO_URL}", branch: "${params.BRANCH ?: 'main'}", changelog: false
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
                // If build was started by a user ("UserIdCause"), then set to user that started the build (the "requestor");
                // otherweise set to $DEFAULT_RECIPIENTS
                // Good to know: $DEFAULT_RECIPIENTS is not a variable,
                // but rather a token which will be replaced by the Email Extension plugin
                // Docs: https://plugins.jenkins.io/email-ext/#plugin-content-tokens
                to: "${currentBuild.getBuildCauses()[0]._class == 'hudson.model.Cause$UserIdCause' ? emailextrecipients([requestor()]) : '$DEFAULT_RECIPIENTS'}",
                subject: "GRETL-Job ${JOB_NAME} (${BUILD_DISPLAY_NAME}) ist fehlgeschlagen",
                body: "Die Ausführung des GRETL-Jobs ${JOB_NAME} (${BUILD_DISPLAY_NAME}) war nicht erfolgreich. Details dazu finden Sie in den Log-Meldungen unter ${RUN_DISPLAY_URL}."
            )
        }
    }
}
