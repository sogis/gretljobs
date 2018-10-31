def dbUriSogis = ''
def dbCredentialNameSogis = ''
def dbUriNplso = ''
def dbCredentialNameNplso = ''
def gretljobsRepo = ''

node("master") {
    dbUriSogis = "${env.DB_URI_SOGIS}"
    dbCredentialNameSogis = "${DB_CREDENTIAL_GRETL}"
    dbUriNplso = "${env.DB_URI_NPLSO}"
    dbCredentialNameNplso = "${DB_CREDENTIAL_GRETL}"
    gretljobsRepo = "${env.GRETL_JOB_REPO_URL}"
}

node ("gretl") {
    git "${gretljobsRepo}"
    dir(env.JOB_BASE_NAME) {
        withCredentials([usernamePassword(credentialsId: "${dbCredentialNameSogis}", usernameVariable: 'dbUserSogis', passwordVariable: 'dbPwdSogis'), usernamePassword(credentialsId: "${dbCredentialNameNplso}", usernameVariable: 'dbUserNplso', passwordVariable: 'dbPwdNplso')]) {
            sh "gradle --init-script /home/gradle/init.gradle \
                -PdbUriSogis='${dbUriSogis}' -PdbUserSogis='${dbUserSogis}' -PdbPwdSogis='${dbPwdSogis}' \
                -PdbUriNplso='${dbUriNplso}' -PdbUserNplso='${dbUserNplso}' -PdbPwdNplso='${dbPwdNplso}'"
        }
    }
}

