def dbUriSogis = ''
def dbCredentialNameSogis = ''
def dbUriEdit = ''
def dbCredentialNameEdit = ''
def dbUriPub = ''
def dbCredentialNamePub = ''
def aiServer = ''
def aiCredentialName = ''
def gretljobsRepo = ''

node("master") {
    dbUriSogis = "${env.DB_URI_SOGIS}"
    dbCredentialNameSogis = "${DB_CREDENTIAL_GRETL}"
    dbUriEdit = "${env.DB_URI_EDIT}"
    dbCredentialNameEdit = "${DB_CREDENTIAL_GRETL}"
    dbUriPub = "${env.DB_URI_PUB}"
    dbCredentialNamePub = "${DB_CREDENTIAL_GRETL}"
    aiServer = "${env.AI_SERVER}"
    aiCredentialName = "${AI_CREDENTIAL}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    try {
        gitBranch = "${params.BRANCH ?: 'master'}"
        git url: "${gretljobsRepo}", branch: gitBranch
        dir(env.JOB_BASE_NAME) {
            credentials = [
                usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'),
                usernamePassword(credentialsId: "${dbCredentialNameEdit}", usernameVariable: 'dbUserEdit', passwordVariable: 'dbPwdEdit'),
                usernamePassword(credentialsId: "${dbCredentialNamePub}", usernameVariable: 'dbUserPub', passwordVariable: 'dbPwdPub'),
                usernamePassword(credentialsId: "${aiCredentialName}", usernameVariable: 'aiUser', passwordVariable: 'aiPwd')
            ]
            withCredentials(credentials) {
                sh "gradle --init-script /home/gradle/init.gradle \
                -PdbUriSogis='${dbUriSogis}' -PdbUserSogis='${dbUserSogis}' -PdbPwdSogis='${dbPwdSogis}' \
                -PdbUriEdit='${dbUriEdit}' -PdbUserEdit='${dbUserEdit}' -PdbPwdEdit='${dbPwdEdit}' \
                -PdbUriPub='${dbUriPub}' -PdbUserPub='${dbUserPub}' -PdbPwdPub='${dbPwdPub}' \
                -PaiServer='${aiServer}' -PaiUser='${aiUser}' -PaiPwd='${aiPwd}'"
            }
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
