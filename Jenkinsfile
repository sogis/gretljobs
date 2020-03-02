def gretljobsRepo = ''

node('master') {
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node (params.nodeLabel ?: 'gretl') {
    try {
        gitBranch = "${params.BRANCH ?: 'master'}"
        git url: "${gretljobsRepo}", branch: gitBranch, changelog: false
        dir(env.JOB_BASE_NAME) {
            sh "gradle -Dorg.gradle.jvmargs=-Xmx2G --init-script /home/gradle/init.gradle"
        }
    }
    catch (e) {
        echo 'Job failed'
        emailext (
                to: '${DEFAULT_RECIPIENTS}',
                recipientProviders: [requestor()],
                subject: "GRETL-Job ${env.JOB_NAME} (${env.BUILD_DISPLAY_NAME}) ist fehlgeschlagen",
                body: "Der GRETL-Job ${env.JOB_NAME} (${env.BUILD_DISPLAY_NAME}) war leider nicht erfolgreich. Details dazu finden Sie in den Log-Meldungen unter ${env.BUILD_URL}."
        )
        throw e
    }
}
