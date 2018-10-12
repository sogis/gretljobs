def dbUriSogis = ''
def dbCredentialNameSogis = ''
def aiServer = ''
def aiCredentialName = ''
def gretljobsRepo = ''

node("master") {
    dbUriSogis = "${env.DB_URI_SOGIS}"
    dbCredentialNameSogis = "${DB_CREDENTIAL_GRETL}"
    aiServer = "${env.AI_SERVER}"
    aiCredentialName = "${AI_CREDENTIAL}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    git "${gretljobsRepo}"
    dir(env.JOB_BASE_NAME) {
        withCredentials([usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'), usernamePassword(credentialsId: "${aiCredentialName}", usernameVariable: 'aiUser', passwordVariable: 'aiPwd')]) {
            sh "gradle --init-script /home/gradle/init.gradle -PdbUriSogis='${dbUriSogis}' -PdbUserSogis='${dbUserSogis}' -PdbPwdSogis='${dbPwdSogis}' -PaiServer='${aiServer}' -PaiUser='${aiUser}' -PaiPwd='${aiPwd}'"
        }
    }
}
