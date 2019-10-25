def dbUriPub = ''
def dbCredentialNamePub = ''
def gretljobsRepo = ''

node("master") {
    dbUriPub = "${env.DB_URI_PUB}"
    dbCredentialNamePub = "${DB_CREDENTIAL_GRETL}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    try {
        gitBranch = "${params.BRANCH ?: 'master'}"
        git url: "${gretljobsRepo}", branch: gitBranch
        dir(env.JOB_BASE_NAME) {
            withCredentials([usernamePassword(credentialsId: "${dbCredentialNamePub}", usernameVariable: 'dbUserPub', passwordVariable: 'dbPwdPub')]) {
                sh "gradle --init-script /home/gradle/init.gradle \
                -PdbUriPub='${dbUriPub}' -PdbUserPub='${dbUserPub}' -PdbPwdPub='${dbPwdPub}'"
            }
        }
    }
    catch (e) {
        echo 'Job failed'
        emailext (
                to: '${DEFAULT_RECIPIENTS}',
                recipientProviders: [requestor()],
                subject: "FAILED: Job ${env.JOB_NAME} ${env.BUILD_DISPLAY_NAME}",
                body: "FAILED: Job ${env.JOB_NAME} ${env.BUILD_DISPLAY_NAME}. Check console output at ${env.BUILD_URL}"
        )
        throw e
    }
}

