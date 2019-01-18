def dbUriSogis = ''
def dbCredentialNameSogis = ''
def dbUriPub = ''
def dbCredentialNamePub = ''
def dbUriCapitastra = ''
def dbCredentialNameCapitastra = ''
def gretljobsRepo = ''

node("master") {
    dbUriSogis = "${env.DB_URI_SOGIS}"
    dbCredentialNameSogis = "${DB_CREDENTIAL_GRETL}"
    dbUriPub = "${env.DB_URI_PUB}"
    dbCredentialNamePub = "${DB_CREDENTIAL_GRETL}"
    dbUriCapitastra = "${env.DB_URI_CAPITASTRA}"
    dbCredentialNameCapitastra = "${DB_CREDENTIAL_CAPITASTRA}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    try {
        gitBranch = "${params.BRANCH ?: 'master'}"
        git url: "${gretljobsRepo}", branch: gitBranch
        dir(env.JOB_BASE_NAME) {
            withCredentials([usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'), usernamePassword(credentialsId: "${dbCredentialNamePub}", usernameVariable: 'dbUserPub', passwordVariable: 'dbPwdPub'), usernamePassword(credentialsId: "${dbCredentialNameCapitastra}", usernameVariable: 'dbUserCapitastra', passwordVariable: 'dbPwdCapitastra')]) {
                sh "gradle --init-script /home/gradle/init.gradle \
                -PdbUriSogis='${dbUriSogis}' -PdbUserSogis='${dbUserSogis}' -PdbPwdSogis='${dbPwdSogis}' \
                -PdbUriPub='${dbUriPub}' -PdbUserPub='${dbUserPub}' -PdbPwdPub='${dbPwdPub}' \
                -PdbUriCapitastra='${dbUriCapitastra}' -PdbUserCapitastra='${dbUserCapitastra}' -PdbPwdCapitastra='${dbPwdCapitastra}'"
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

