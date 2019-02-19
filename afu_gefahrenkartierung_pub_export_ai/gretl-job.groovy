def dbUriSogis = ''
def dbCredentialNameSogis = ''
def aiServer = ''
def aiCredentialName = ''
def gretljobsRepo = ''

node("master") {
    dbUriPub = "${env.DB_URI_PUB}"
    dbCredentialNamePub = "${DB_CREDENTIAL_GRETL}"
    dbUriEdit = "${env.DB_URI_EDIT}"
    dbCredentialNameEdit = "${DB_CREDENTIAL_GRETL}"
    aiServer = "${env.AI_SERVER}"
    aiCredentialName = "${AI_CREDENTIAL}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    try {
        gitBranch = "${params.BRANCH ?: 'master'}"
        git url: "${gretljobsRepo}", branch: gitBranch
        dir(env.JOB_BASE_NAME) {
            withCredentials([usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'), usernamePassword(credentialsId: "${aiCredentialName}", usernameVariable: 'aiUser', passwordVariable: 'aiPwd')]) {
                sh "gradle --init-script /home/gradle/init.gradle \
                -PdbUriPub='${dbUriPub}' -PdbUserPub='${dbUserPub}' -PdbPwdPub='${dbPwdPub}' \
                -PdbUriEdit='${dbUriEdit}' -PdbUserEdit='${dbUserEdit}' -PdbPwdEdit='${dbPwdEdit}' \
                -PaiServer='${aiServer}' -PaiUser='${aiUser}' -PaiPwd='${aiPwd}'"
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
